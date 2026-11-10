"""Adaptive discovery expansion: extracts emerging concepts and queues bounded new search queries."""

from __future__ import annotations

import re
from collections import Counter
from typing import Dict, List

from ..db import RadarDatabase


STOPWORDS = {
    "github", "hacker-news", "discussion", "article", "video", "youtube", "blog",
    "feed", "devto", "lobsters", "reddit", "research-paper", "open-source", "show-hn",
    "open-model", "huggingface", "demo", "ai", "ml", "tech", "news", "release",
}


def run_adaptive_discovery(db: RadarDatabase, max_new_queries: int = 4) -> List[Dict[str, str]]:
    """Learns emerging keywords from high-scoring or saved items and schedules bounded follow-up queries."""
    added: List[Dict[str, str]] = []
    with db.connect() as conn:
        top_rows = conn.execute(
            """
            SELECT d.id, d.primary_category
            FROM discoveries d
            LEFT JOIN user_bookmarks b ON b.discovery_id = d.id
            WHERE d.final_rank_score > 0
            ORDER BY (CASE WHEN b.discovery_id IS NOT NULL THEN 200 ELSE 0 END) + d.final_rank_score DESC
            LIMIT 25
            """
        ).fetchall()

        tag_counts: Counter = Counter()
        tag_cat: Dict[str, str] = {}
        for tr in top_rows:
            tags = conn.execute(
                "SELECT tag FROM discovery_tags WHERE discovery_id = ?", (tr["id"],)
            ).fetchall()
            for t in tags:
                tag = str(t["tag"]).strip().lower()
                if len(tag) < 3 or tag in STOPWORDS or not re.match(r"^[a-z0-9\-_+]+$", tag):
                    continue
                tag_counts[tag] += 1
                tag_cat.setdefault(tag, tr["primary_category"])

        existing_cnt_row = conn.execute(
            "SELECT COUNT(*) AS c FROM discovery_queries WHERE origin = 'adaptive' AND is_active = 1"
        ).fetchone()
        active_adaptive = int(existing_cnt_row["c"]) if existing_cnt_row else 0

    # Cap total active adaptive queries to avoid runaway query explosion
    remaining_slots = max(0, 24 - active_adaptive)
    to_add = min(max_new_queries, remaining_slots)
    if to_add <= 0:
        return added

    for tag, count in tag_counts.most_common(12):
        if len(added) >= to_add:
            break
        if count < 2:
            continue
        cat = tag_cat.get(tag, "B")
        gh_q = f"topic:{tag} stars:>25"
        db.enqueue_discovery_query(
            connector="github",
            query_text=gh_q,
            category_code=cat,
            origin="adaptive",
            priority=0.65,
            cooldown_hours=18,
        )
        added.append({"connector": "github", "query": gh_q, "category": cat})

        if len(added) < to_add:
            yt_q = f"{tag} developer engineering walkthrough"
            db.enqueue_discovery_query(
                connector="youtube",
                query_text=yt_q,
                category_code=cat,
                origin="adaptive",
                priority=0.55,
                cooldown_hours=24,
            )
            added.append({"connector": "youtube", "query": yt_q, "category": cat})

    return added

