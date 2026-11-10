"""Multi-source Trend Detection Engine grounded strictly in recorded database evidence."""

from __future__ import annotations

import uuid
from collections import defaultdict
from datetime import datetime, timedelta, timezone
from typing import Dict, List, Set

from ..config import TOPIC_CATEGORIES
from ..db import RadarDatabase, utc_now_iso


GENERIC_TREND_TAGS = {
    "github", "hacker-news", "discussion", "article", "video", "youtube", "blog",
    "feed", "devto", "lobsters", "reddit", "research-paper", "show-hn", "open-model",
    "huggingface", "huggingface-space", "demo", "arxiv",
}


def detect_and_store_trends(db: RadarDatabase) -> List[Dict]:
    """Evaluates multi-source corroboration & observation velocity into trend_candidates + trend_evidence."""
    now = datetime.now(timezone.utc)
    now_iso = now.replace(microsecond=0).isoformat()
    recent_cutoff = (now - timedelta(hours=72)).isoformat()
    baseline_cutoff = (now - timedelta(days=10)).isoformat()

    tag_to_items: Dict[str, List[Dict]] = defaultdict(list)

    with db.connect() as conn:
        rows = conn.execute(
            """
            SELECT d.id, d.title, d.primary_category, d.source_name, d.discovered_at,
                   d.published_at, d.metric_delta_value, d.primary_metric_value
            FROM discoveries d
            WHERE d.discovered_at >= ?
            """,
            (baseline_cutoff,),
        ).fetchall()

        for r in rows:
            item = dict(r)
            connectors = [
                sr["connector"]
                for sr in conn.execute(
                    "SELECT DISTINCT connector FROM discovery_sources WHERE discovery_id = ?",
                    (item["id"],),
                ).fetchall()
            ]
            item["connectors"] = connectors
            tags = [
                tr["tag"]
                for tr in conn.execute(
                    "SELECT tag FROM discovery_tags WHERE discovery_id = ?",
                    (item["id"],),
                ).fetchall()
            ]
            for tag in tags:
                if tag in GENERIC_TREND_TAGS or len(tag) < 2:
                    continue
                tag_to_items[tag].append(item)

        detected: List[Dict] = []
        # Clear stale trend evidence before rebuilding truthful snapshot for current window
        conn.execute("DELETE FROM trend_evidence")
        conn.execute("DELETE FROM trend_candidates")

        for topic_key, items in tag_to_items.items():
            # Deduplicate items by discovery_id
            by_id = {it["id"]: it for it in items}
            unique_items = list(by_id.values())
            if len(unique_items) < 2:
                continue

            connectors_seen: Set[str] = set()
            recent_count = 0
            older_count = 0
            positive_deltas = 0
            cat_counts: Dict[str, int] = defaultdict(int)

            for it in unique_items:
                connectors_seen.update(it["connectors"])
                cat_counts[it["primary_category"]] += 1
                ts = it.get("published_at") or it["discovered_at"]
                if ts >= recent_cutoff:
                    recent_count += 1
                else:
                    older_count += 1
                if (it.get("metric_delta_value") or 0) > 0:
                    positive_deltas += 1

            diversity = len(connectors_seen)
            mentions = len(unique_items)
            primary_cat = max(cat_counts.items(), key=lambda kv: kv[1])[0]

            # Honest classification: never claim 'emerging'/'growing' without cross-source or delta evidence
            if diversity < 2 and positive_deltas == 0:
                status = "insufficient_evidence"
                explanation = (
                    f"Single-source cluster ({next(iter(connectors_seen), 'unknown')}, "
                    f"{mentions} mentions). Needs cross-source corroboration before calling a trend."
                )
            elif recent_count >= 2 and older_count == 0 and diversity >= 2:
                status = "emerging"
                explanation = (
                    f"Appearing recently across {diversity} independent connectors "
                    f"({', '.join(sorted(connectors_seen))}) with {mentions} total mentions."
                )
            elif recent_count >= older_count and diversity >= 2:
                status = "growing"
                explanation = (
                    f"Sustained or accelerating mentions across {diversity} connectors "
                    f"({mentions} items, {positive_deltas} positive observation deltas)."
                )
            elif older_count > recent_count and mentions >= 3:
                status = "cooling"
                explanation = (
                    f"Earlier spike ({older_count} older items vs {recent_count} recent items) across "
                    f"{diversity} source types."
                )
            else:
                status = "established"
                explanation = f"Steady topic across {diversity} sources with {mentions} active items."

            trend_score = round(diversity * 25.0 + mentions * 12.0 + positive_deltas * 15.0 + recent_count * 6.0, 2)
            trend_id = str(uuid.uuid4())
            label = topic_key.replace("-", " ").title()

            conn.execute(
                """
                INSERT INTO trend_candidates (
                    id, topic_key, label, primary_category, status, trend_score,
                    source_diversity_count, mention_count, window_start, window_end,
                    explanation, updated_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    trend_id,
                    topic_key,
                    label,
                    primary_cat,
                    status,
                    trend_score,
                    diversity,
                    mentions,
                    baseline_cutoff,
                    now_iso,
                    explanation,
                    now_iso,
                ),
            )

            for it in unique_items[:6]:
                conn.execute(
                    """
                    INSERT INTO trend_evidence (
                        id, trend_id, discovery_id, source_name, evidence_summary, metric_delta, observed_at
                    ) VALUES (?, ?, ?, ?, ?, ?, ?)
                    """,
                    (
                        str(uuid.uuid4()),
                        trend_id,
                        it["id"],
                        it["source_name"],
                        it["title"][:220],
                        it.get("metric_delta_value"),
                        it["discovered_at"],
                    ),
                )

            detected.append(
                {
                    "id": trend_id,
                    "topic_key": topic_key,
                    "label": label,
                    "primary_category": primary_cat,
                    "status": status,
                    "trend_score": trend_score,
                    "source_diversity_count": diversity,
                    "mention_count": mentions,
                    "explanation": explanation,
                }
            )

    detected.sort(key=lambda d: -d["trend_score"])
    return detected[:25]

