"""YouTube Data API v3 search + zero-quota Atom channel RSS monitor with dynamic creator discovery."""

from __future__ import annotations

import urllib.parse
import xml.etree.ElementTree as ET
from typing import Dict, List, Optional

from ..config import SEED_YOUTUBE_CHANNELS, YOUTUBE_SEARCH_QUERIES
from ..db import RadarDatabase
from .base import RawDiscovery, clean_html_text, safe_fetch_json, safe_fetch_text


YT_ATOM_NS = {
    "atom": "http://www.w3.org/2005/Atom",
    "yt": "http://www.youtube.com/xml/schemas/2015",
    "media": "http://search.yahoo.com/mrss/",
}


def fetch_youtube_rss_channel(
    channel_id: str,
    channel_name: str,
    default_category: str = "E",
    per_channel: int = 4,
    timeout: int = 12,
) -> List[RawDiscovery]:
    feed_url = f"https://www.youtube.com/feeds/videos.xml?channel_id={urllib.parse.quote(channel_id)}"
    try:
        xml_text = safe_fetch_text(feed_url, timeout=timeout)
        root = ET.fromstring(xml_text)
    except Exception:
        return []

    results: List[RawDiscovery] = []
    entries = root.findall("atom:entry", YT_ATOM_NS)
    for entry in entries[:per_channel]:
        vid_el = entry.find("yt:videoId", YT_ATOM_NS)
        title_el = entry.find("atom:title", YT_ATOM_NS)
        pub_el = entry.find("atom:published", YT_ATOM_NS)
        author_el = entry.find("atom:author/atom:name", YT_ATOM_NS)
        desc_el = entry.find("media:group/media:description", YT_ATOM_NS)

        video_id = vid_el.text.strip() if vid_el is not None and vid_el.text else ""
        title = title_el.text.strip() if title_el is not None and title_el.text else ""
        if not video_id or not title:
            continue

        video_url = f"https://www.youtube.com/watch?v={video_id}"
        creator = (author_el.text.strip() if author_el is not None and author_el.text else channel_name)
        desc = clean_html_text(desc_el.text if desc_el is not None else "", max_len=900)
        stats_el = entry.find("media:group/media:community/media:statistics", YT_ATOM_NS)
        views = None
        if stats_el is not None and stats_el.attrib.get("views"):
            try:
                views = int(stats_el.attrib["views"])
            except ValueError:
                views = None

        results.append(
            RawDiscovery(
                canonical_url=video_url,
                title=title,
                discovery_type="video",
                connector="youtube_rss",
                source_name=f"YouTube · {creator}",
                source_url=feed_url,
                default_categories=list(dict.fromkeys([default_category, "E"])),
                external_id=video_id,
                author_or_org=creator,
                published_at=pub_el.text.strip() if pub_el is not None and pub_el.text else None,
                raw_summary=desc or f"New technical video from {creator}.",
                tags=["youtube", "video", creator.lower().replace(" ", "-")],
                views_count=views,
                primary_metric_label="Views" if views is not None else None,
                primary_metric_value=float(views) if views is not None else None,
                extra={"channel_id": channel_id, "video_id": video_id},
            )
        )
    return results


def fetch_youtube_discoveries(
    db: RadarDatabase,
    youtube_api_key: str = "",
    extra_queries: Optional[List[Dict[str, str]]] = None,
    enable_api_search: bool = True,
    max_search_queries: int = 2,
    timeout: int = 12,
) -> List[RawDiscovery]:
    # Ensure seed creators exist in tracked_creators
    for ch in SEED_YOUTUBE_CHANNELS:
        db.upsert_tracked_creator(
            platform="youtube",
            channel_id=ch["channel_id"],
            name=ch["name"],
            feed_url=f"https://www.youtube.com/feeds/videos.xml?channel_id={ch['channel_id']}",
            primary_category=ch["category"],
            discovered_from="seed",
        )

    results: List[RawDiscovery] = []
    seen_urls = set()

    # 1. Quota-free RSS sweep for tracked channels (followed first)
    tracked = db.get_tracked_creators(limit=12)
    for ch in tracked:
        if ch.get("platform") != "youtube":
            continue
        items = fetch_youtube_rss_channel(
            channel_id=ch["channel_id"],
            channel_name=ch["name"],
            default_category=ch.get("primary_category") or "E",
            per_channel=3,
            timeout=timeout,
        )
        for item in items:
            if item.canonical_url not in seen_urls:
                seen_urls.add(item.canonical_url)
                results.append(item)

    # 2. Controlled YouTube Data API v3 search to discover unfamiliar creators & topics
    if youtube_api_key and enable_api_search:
        search_pool = list(extra_queries or []) + YOUTUBE_SEARCH_QUERIES[:2]
        discovered_video_ids: List[str] = []
        pending_items: Dict[str, RawDiscovery] = {}

        for entry in search_pool[:max_search_queries]:
            q = entry.get("q") or entry.get("query_text", "")
            cat = entry.get("category") or entry.get("category_code", "E")
            if not q:
                continue
            url = (
                "https://www.googleapis.com/youtube/v3/search"
                f"?part=snippet&type=video&order=date&maxResults=5"
                f"&q={urllib.parse.quote(q)}&key={urllib.parse.quote(youtube_api_key)}"
            )
            try:
                payload = safe_fetch_json(url, timeout=timeout)
            except Exception:
                continue

            for item in payload.get("items", []):
                video_id = (item.get("id") or {}).get("videoId")
                snippet = item.get("snippet") or {}
                if not video_id or not snippet.get("title"):
                    continue
                vid_url = f"https://www.youtube.com/watch?v={video_id}"
                if vid_url in seen_urls:
                    continue
                seen_urls.add(vid_url)

                channel_id = snippet.get("channelId")
                channel_title = snippet.get("channelTitle") or "Tech Creator"
                if channel_id:
                    db.upsert_tracked_creator(
                        platform="youtube",
                        channel_id=channel_id,
                        name=channel_title,
                        feed_url=f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}",
                        primary_category=cat,
                        discovered_from=f"yt_search:{q[:40]}",
                    )

                raw = RawDiscovery(
                    canonical_url=vid_url,
                    title=str(snippet["title"]).strip(),
                    discovery_type="video",
                    connector="youtube_api",
                    source_name=f"YouTube · {channel_title}",
                    source_url=vid_url,
                    default_categories=list(dict.fromkeys([cat, "E"])),
                    external_id=video_id,
                    author_or_org=channel_title,
                    published_at=snippet.get("publishedAt"),
                    raw_summary=clean_html_text(snippet.get("description"), max_len=900),
                    tags=["youtube", "video", channel_title.lower().replace(" ", "-")],
                    extra={"channel_id": channel_id, "video_id": video_id},
                )
                discovered_video_ids.append(video_id)
                pending_items[video_id] = raw

        # Enrich discovered search videos with real statistics (1 quota unit per batch!)
        if discovered_video_ids:
            ids_param = ",".join(discovered_video_ids[:25])
            stats_url = (
                "https://www.googleapis.com/youtube/v3/videos"
                f"?part=statistics&id={urllib.parse.quote(ids_param)}&key={urllib.parse.quote(youtube_api_key)}"
            )
            try:
                stats_payload = safe_fetch_json(stats_url, timeout=timeout)
                for st_item in stats_payload.get("items", []):
                    vid = st_item.get("id")
                    stats = st_item.get("statistics") or {}
                    raw = pending_items.get(vid)
                    if not raw:
                        continue
                    views = int(stats["viewCount"]) if "viewCount" in stats else None
                    likes = int(stats["likeCount"]) if "likeCount" in stats else None
                    raw.views_count = views
                    raw.likes_count = likes
                    raw.primary_metric_label = "Views" if views is not None else None
                    raw.primary_metric_value = float(views) if views is not None else None
                    raw.secondary_metric_label = "Likes" if likes is not None else None
                    raw.secondary_metric_value = float(likes) if likes is not None else None
            except Exception:
                pass

        results.extend(pending_items.values())

    return results

