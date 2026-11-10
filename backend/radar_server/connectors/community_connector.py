"""Developer Community REST connectors (DEV.to & Lobsters)."""

from __future__ import annotations

from typing import List

from .base import RawDiscovery, normalize_timestamp, safe_fetch_json


def fetch_community_discoveries(
    dev_limit: int = 10,
    lobsters_limit: int = 10,
    timeout: int = 12,
) -> List[RawDiscovery]:
    results: List[RawDiscovery] = []

    # DEV Community top articles
    try:
        dev_items = safe_fetch_json(
            f"https://dev.to/api/articles?top=3&per_page={dev_limit}",
            timeout=timeout,
        ) or []
    except Exception:
        dev_items = []

    for art in dev_items:
        url = art.get("canonical_url") or art.get("url")
        title = art.get("title")
        if not url or not title:
            continue
        reactions = art.get("positive_reactions_count")
        comments = art.get("comments_count")
        tags = [str(t).lower() for t in (art.get("tag_list") or [])[:8]]
        author = ((art.get("user") or {}).get("name") or (art.get("user") or {}).get("username"))
        results.append(
            RawDiscovery(
                canonical_url=str(url).strip(),
                title=str(title).strip(),
                discovery_type="article",
                connector="community",
                source_name="DEV Community",
                source_url=str(art.get("url") or url).strip(),
                default_categories=["C", "F"],
                external_id=f"dev:{art.get('id')}",
                author_or_org=author,
                published_at=normalize_timestamp(art.get("published_timestamp")),
                raw_summary=str(art.get("description") or "").strip() or "Developer article on DEV Community.",
                tags=list(dict.fromkeys(["devto", *tags])),
                reported_score=float(reactions) if reactions is not None else None,
                reported_comments=float(comments) if comments is not None else None,
                primary_metric_label="Reactions" if reactions is not None else None,
                primary_metric_value=float(reactions) if reactions is not None else None,
                secondary_metric_label="Comments" if comments is not None else None,
                secondary_metric_value=float(comments) if comments is not None else None,
            )
        )

    # Lobsters hottest technical stories
    try:
        lob_items = safe_fetch_json("https://lobste.rs/hottest.json", timeout=timeout) or []
    except Exception:
        lob_items = []

    for post in lob_items[:lobsters_limit]:
        url = post.get("url") or post.get("short_id_url")
        title = post.get("title")
        if not url or not title:
            continue
        score = post.get("score")
        comments = post.get("comment_count")
        tags = [str(t).lower() for t in (post.get("tags") or [])[:8]]
        results.append(
            RawDiscovery(
                canonical_url=str(url).strip(),
                title=str(title).strip(),
                discovery_type="community",
                connector="community",
                source_name="Lobsters",
                source_url=str(post.get("comments_url") or url).strip(),
                default_categories=["C", "F"],
                external_id=f"lob:{post.get('short_id')}",
                author_or_org=post.get("submitter_user"),
                published_at=normalize_timestamp(post.get("created_at")),
                raw_summary=str(post.get("description") or "").strip()
                or f"Technical discussion on Lobsters ({', '.join(tags)}).",
                tags=list(dict.fromkeys(["lobsters", *tags])),
                reported_score=float(score) if score is not None else None,
                reported_comments=float(comments) if comments is not None else None,
                primary_metric_label="Score" if score is not None else None,
                primary_metric_value=float(score) if score is not None else None,
                secondary_metric_label="Comments" if comments is not None else None,
                secondary_metric_value=float(comments) if comments is not None else None,
            )
        )

    return results

