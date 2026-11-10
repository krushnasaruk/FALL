"""Universal RSS 2.0 / Atom connector for engineering blogs, Reddit .rss, Product Hunt, and newsrooms."""

from __future__ import annotations

import xml.etree.ElementTree as ET
from typing import List, Optional

from ..config import RSS_FEEDS, RssFeedSource
from .base import RawDiscovery, clean_html_text, normalize_timestamp, safe_fetch_text


ATOM_NS = {"atom": "http://www.w3.org/2005/Atom"}


def parse_feed_xml(feed: RssFeedSource, xml_text: str, max_items: int = 5) -> List[RawDiscovery]:
    try:
        root = ET.fromstring(xml_text)
    except ET.ParseError:
        return []

    tag_lower = root.tag.lower()
    results: List[RawDiscovery] = []

    if tag_lower.endswith("feed"):
        entries = root.findall("atom:entry", ATOM_NS) or root.findall("entry")
        for entry in entries[:max_items]:
            title_el = entry.find("atom:title", ATOM_NS)
            if title_el is None:
                title_el = entry.find("title")
            link_url = ""
            for link_el in entry.findall("atom:link", ATOM_NS) or entry.findall("link"):
                rel = link_el.attrib.get("rel", "alternate")
                href = link_el.attrib.get("href", "").strip()
                if href and (rel == "alternate" or not link_url):
                    link_url = href
            pub_el = (
                entry.find("atom:published", ATOM_NS)
                or entry.find("atom:updated", ATOM_NS)
                or entry.find("updated")
            )
            summary_el = (
                entry.find("atom:summary", ATOM_NS)
                or entry.find("atom:content", ATOM_NS)
                or entry.find("content")
            )
            author_el = entry.find("atom:author/atom:name", ATOM_NS) or entry.find("author/name")

            title = clean_html_text(title_el.text if title_el is not None else "", max_len=240)
            if not title or not link_url:
                continue
            disc_type = "product" if "producthunt" in feed.url else ("community" if "reddit.com" in feed.url else "article")
            results.append(
                RawDiscovery(
                    canonical_url=link_url,
                    title=title,
                    discovery_type=disc_type,
                    connector="rss",
                    source_name=feed.title,
                    source_url=feed.url,
                    default_categories=list(feed.default_categories),
                    author_or_org=(author_el.text.strip() if author_el is not None and author_el.text else feed.title),
                    published_at=normalize_timestamp(pub_el.text if pub_el is not None else None),
                    raw_summary=clean_html_text(summary_el.text if summary_el is not None else "", max_len=1000)
                    or f"Published via {feed.title}.",
                    tags=[feed.id.replace("_", "-"), "reddit" if "reddit.com" in feed.url else "blog"],
                )
            )
        return results

    # RSS 2.0 (<rss><channel><item>...)
    channel = root.find("channel")
    items = channel.findall("item") if channel is not None else root.findall(".//item")
    for item in items[:max_items]:
        title_el = item.find("title")
        link_el = item.find("link")
        pub_el = item.find("pubDate")
        desc_el = item.find("description")
        creator_el = item.find("{http://purl.org/dc/elements/1.1/}creator") or item.find("author")

        title = clean_html_text(title_el.text if title_el is not None else "", max_len=240)
        link_url = link_el.text.strip() if link_el is not None and link_el.text else ""
        if not title or not link_url:
            continue
        disc_type = "product" if "producthunt" in feed.url else ("community" if "reddit.com" in feed.url else "article")
        results.append(
            RawDiscovery(
                canonical_url=link_url,
                title=title,
                discovery_type=disc_type,
                connector="rss",
                source_name=feed.title,
                source_url=feed.url,
                default_categories=list(feed.default_categories),
                author_or_org=(creator_el.text.strip() if creator_el is not None and creator_el.text else feed.title),
                published_at=normalize_timestamp(pub_el.text if pub_el is not None else None),
                raw_summary=clean_html_text(desc_el.text if desc_el is not None else "", max_len=1000)
                or f"Published via {feed.title}.",
                tags=[feed.id.replace("_", "-"), "feed"],
            )
        )
    return results


def fetch_rss_discoveries(
    feeds: Optional[List[RssFeedSource]] = None,
    per_feed: int = 4,
    timeout: int = 12,
) -> List[RawDiscovery]:
    target_feeds = feeds or RSS_FEEDS
    results: List[RawDiscovery] = []
    for feed in target_feeds:
        try:
            xml_text = safe_fetch_text(feed.url, timeout=timeout, retries=1)
        except Exception:
            continue
        results.extend(parse_feed_xml(feed, xml_text, max_items=per_feed))
    return results

