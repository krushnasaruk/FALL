"""GitHub REST API connector for discovering emerging repos & recording real star/fork snapshots."""

from __future__ import annotations

import urllib.parse
from datetime import datetime, timedelta, timezone
from typing import Dict, List, Optional

from ..config import GITHUB_SEED_QUERIES
from .base import RawDiscovery, safe_fetch_json


def _build_recent_created_query(days_back: int = 14, min_stars: int = 20) -> str:
    cutoff = (datetime.now(timezone.utc) - timedelta(days=days_back)).strftime("%Y-%m-%d")
    return f"created:>{cutoff} stars:>={min_stars}"


def fetch_github_discoveries(
    github_token: str = "",
    extra_queries: Optional[List[Dict[str, str]]] = None,
    per_query: int = 8,
    timeout: int = 15,
) -> List[RawDiscovery]:
    headers: Dict[str, str] = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    if github_token:
        headers["Authorization"] = f"Bearer {github_token}"

    queries: List[Dict[str, str]] = [
        {"q": _build_recent_created_query(days_back=14, min_stars=35), "category": "B"},
        *GITHUB_SEED_QUERIES[:6],
    ]
    if extra_queries:
        queries.extend(extra_queries[:3])

    results: List[RawDiscovery] = []
    seen_urls = set()

    for entry in queries:
        q = entry["q"]
        cat = entry.get("category", "B")
        encoded_q = urllib.parse.quote(q)
        url = (
            f"https://api.github.com/search/repositories"
            f"?q={encoded_q}&sort=stars&order=desc&per_page={per_query}"
        )
        try:
            payload = safe_fetch_json(url, headers=headers, timeout=timeout)
        except Exception:
            continue

        for item in payload.get("items", []):
            html_url = item.get("html_url")
            full_name = item.get("full_name")
            if not html_url or not full_name or html_url in seen_urls:
                continue
            seen_urls.add(html_url)

            stars = item.get("stargazers_count")
            forks = item.get("forks_count")
            lang = item.get("language")
            topics = [str(t).lower() for t in (item.get("topics") or []) if t]
            if lang:
                topics.append(str(lang).lower())

            owner_login = (item.get("owner") or {}).get("login")
            license_name = (item.get("license") or {}).get("spdx_id")
            results.append(
                RawDiscovery(
                    canonical_url=html_url,
                    title=full_name,
                    discovery_type="repo",
                    connector="github",
                    source_name="GitHub Search",
                    source_url=html_url,
                    default_categories=list(dict.fromkeys([cat, "B"])),
                    external_id=str(item.get("id") or full_name),
                    author_or_org=owner_login,
                    published_at=item.get("pushed_at") or item.get("created_at"),
                    raw_summary=item.get("description") or f"Open-source repository by {owner_login or 'community'}.",
                    tags=list(dict.fromkeys(topics[:10])),
                    reported_score=float(stars) if stars is not None else None,
                    stars_count=int(stars) if stars is not None else None,
                    forks_count=int(forks) if forks is not None else None,
                    primary_metric_label="Stars" if stars is not None else None,
                    primary_metric_value=float(stars) if stars is not None else None,
                    secondary_metric_label="Forks" if forks is not None else None,
                    secondary_metric_value=float(forks) if forks is not None else None,
                    extra={
                        "language": lang,
                        "license": license_name,
                        "homepage": item.get("homepage"),
                        "open_issues": item.get("open_issues_count"),
                        "topics": item.get("topics") or [],
                        "created_at": item.get("created_at"),
                    },
                )
            )
    return results

