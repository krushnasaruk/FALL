"""Hacker News Firebase connector for Top, Best, and Show HN stories."""

from __future__ import annotations

from datetime import datetime, timezone
from typing import List

from .base import RawDiscovery, clean_html_text, safe_fetch_json


HN_BASE = "https://hacker-news.firebaseio.com/v0"


def fetch_hackernews_discoveries(
    limit_per_feed: int = 12,
    timeout: int = 12,
) -> List[RawDiscovery]:
    feeds = [
        ("topstories", "HN Top", ["F"]),
        ("showstories", "Show HN", ["D", "F", "B"]),
        ("beststories", "HN Best", ["F", "C"]),
    ]

    candidate_ids: List[tuple[int, str, List[str]]] = []
    seen_ids = set()

    for endpoint, label, cats in feeds:
        try:
            ids = safe_fetch_json(f"{HN_BASE}/{endpoint}.json", timeout=timeout) or []
        except Exception:
            continue
        for item_id in ids[:limit_per_feed]:
            if item_id in seen_ids:
                continue
            seen_ids.add(item_id)
            candidate_ids.append((int(item_id), label, cats))

    results: List[RawDiscovery] = []
    for item_id, label, cats in candidate_ids[:30]:
        try:
            item = safe_fetch_json(f"{HN_BASE}/item/{item_id}.json", timeout=timeout, retries=1)
        except Exception:
            continue
        if not item or item.get("deleted") or item.get("dead") or not item.get("title"):
            continue
        title = str(item["title"]).strip()
        hn_url = f"https://news.ycombinator.com/item?id={item_id}"
        target_url = str(item.get("url") or hn_url).strip()

        ts = item.get("time")
        published_iso = (
            datetime.fromtimestamp(int(ts), tz=timezone.utc).replace(microsecond=0).isoformat()
            if ts
            else None
        )
        score = item.get("score")
        comments = item.get("descendants")
        raw_text = clean_html_text(item.get("text"))
        summary = raw_text or f"Discussed on {label} ({title})."

        is_github = "github.com/" in target_url.lower()
        disc_type = "repo" if is_github else ("product" if label == "Show HN" else "community")

        results.append(
            RawDiscovery(
                canonical_url=target_url,
                title=title,
                discovery_type=disc_type,
                connector="hackernews",
                source_name=label,
                source_url=hn_url,
                default_categories=cats,
                external_id=str(item_id),
                author_or_org=item.get("by"),
                published_at=published_iso,
                raw_summary=summary,
                tags=["hacker-news", "show-hn" if label == "Show HN" else "discussion"],
                reported_score=float(score) if score is not None else None,
                reported_comments=float(comments) if comments is not None else None,
                primary_metric_label="HN Points" if score is not None else None,
                primary_metric_value=float(score) if score is not None else None,
                secondary_metric_label="Comments" if comments is not None else None,
                secondary_metric_value=float(comments) if comments is not None else None,
                extra={"hn_discussion_url": hn_url},
            )
        )
    return results

