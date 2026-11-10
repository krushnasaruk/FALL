"""Transparent multi-signal Radar ranking engine with configurable 70/30 interest-vs-discovery diversity."""

from __future__ import annotations

import json
import math
from datetime import datetime, timezone
from typing import Any, Dict, List, Set

from ..config import PRIORITY_WEIGHTS
from ..db import RadarDatabase


def _freshness_score(iso_ts: Optional[str]) -> float:
    if not iso_ts:
        return 0.35
    try:
        dt = datetime.fromisoformat(iso_ts.replace("Z", "+00:00"))
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        age_hours = max(0.0, (datetime.now(timezone.utc) - dt).total_seconds() / 3600.0)
        # Half-life ~48 hours: fresh discoveries rank strong while remaining legible for days.
        return round(math.exp(-age_hours / 68.0), 4)
    except Exception:
        return 0.35


def _metric_signal(primary_val: Optional[float], delta_val: Optional[float]) -> float:
    base = 0.0
    if primary_val is not None and primary_val > 0:
        base = min(1.0, math.log10(primary_val + 1.0) / 4.2)
    delta_bonus = 0.0
    if delta_val is not None and delta_val > 0:
        delta_bonus = min(0.45, math.log10(delta_val + 1.0) / 3.0)
    return min(1.0, base * 0.7 + delta_bonus)


def rank_discoveries(
    db: RadarDatabase,
    aligned_ratio: float = 0.70,
    explore_ratio: float = 0.30,
) -> int:
    """Recomputes transparent rank scores & 70/30 exploratory flags across all stored discoveries."""
    prefs = {p["category_code"]: p for p in db.get_topic_preferences()}
    with db.connect() as conn:
        follow_rows = conn.execute("SELECT target_key FROM user_follows").fetchall()
        followed_keys: Set[str] = {r["target_key"].lower() for r in follow_rows}

        feedback_rows = conn.execute(
            "SELECT discovery_id, action FROM user_read_history"
        ).fetchall()
        liked_ids: Set[str] = set()
        disliked_ids: Set[str] = set()
        for fr in feedback_rows:
            if fr["action"] in ("relevant", "save", "deep_dive"):
                liked_ids.add(fr["discovery_id"])
            elif fr["action"] in ("not_relevant", "hide"):
                disliked_ids.add(fr["discovery_id"])

        rows = conn.execute("SELECT * FROM discoveries").fetchall()

        scored_items: List[Dict[str, Any]] = []
        for r in rows:
            item = dict(r)
            disc_id = item["id"]
            cat = item["primary_category"]
            pref = prefs.get(cat, {})

            if pref.get("is_muted") or disc_id in disliked_ids:
                conn.execute(
                    "UPDATE discoveries SET final_rank_score = -1.0, relevance_score = 0.0 WHERE id = ?",
                    (disc_id,),
                )
                continue

            muted_kws = [str(k).lower() for k in pref.get("muted_keywords", [])]
            corpus = f"{item['title']} {item.get('raw_summary') or ''}".lower()
            if any(mk and mk in corpus for mk in muted_kws):
                conn.execute(
                    "UPDATE discoveries SET final_rank_score = -1.0, relevance_score = 0.0 WHERE id = ?",
                    (disc_id,),
                )
                continue

            src_cnt_row = conn.execute(
                "SELECT COUNT(DISTINCT connector) AS cnt FROM discovery_sources WHERE discovery_id = ?",
                (disc_id,),
            ).fetchone()
            src_diversity = int(src_cnt_row["cnt"]) if src_cnt_row else 1

            priority_level = pref.get("priority_level") or item.get("priority_tier") or "P1"
            prio_w = PRIORITY_WEIGHTS.get(priority_level, 0.5)
            fresh_w = _freshness_score(item.get("published_at") or item.get("discovered_at"))
            corrob_w = min(1.0, (src_diversity - 1) * 0.45 + 0.25)
            vel_w = _metric_signal(item.get("primary_metric_value"), item.get("metric_delta_value"))
            novelty_w = float(item.get("novelty_score") or 0.5)
            action_w = float(item.get("actionability_score") or 0.5)

            boost_kws = [str(k).lower() for k in pref.get("boost_keywords", [])]
            kw_hits = sum(1 for bk in boost_kws if bk and bk in corpus)
            affinity = float(pref.get("affinity_adjustment") or 0.0)
            kw_w = min(1.0, kw_hits * 0.22 + max(0.0, affinity))

            author = (item.get("author_or_org") or "").lower()
            follow_w = 1.0 if (author and author in followed_keys) or (cat.lower() in followed_keys) else 0.0
            like_w = 0.20 if disc_id in liked_ids else 0.0

            relevance = (
                prio_w * 0.30
                + fresh_w * 0.22
                + corrob_w * 0.14
                + vel_w * 0.12
                + novelty_w * 0.08
                + action_w * 0.06
                + kw_w * 0.08
                + follow_w * 0.12
                + like_w
            )
            relevance = round(min(1.5, relevance), 4)
            is_exploratory = 1 if priority_level in ("P2", "P3") else 0

            scored_items.append(
                {
                    "id": disc_id,
                    "relevance": relevance,
                    "priority_level": priority_level,
                    "is_exploratory": is_exploratory,
                    "fresh_w": fresh_w,
                }
            )

        # Apply configurable alignment / exploratory mix in final_rank_score ordering
        aligned = sorted(
            [s for s in scored_items if s["is_exploratory"] == 0],
            key=lambda x: -x["relevance"],
        )
        exploratory = sorted(
            [s for s in scored_items if s["is_exploratory"] == 1],
            key=lambda x: -(x["relevance"] + x["fresh_w"] * 0.15),
        )

        # Interleave preserving configured explore_ratio (e.g. ~3 out of every 10 slots)
        step = max(1, round(aligned_ratio / max(0.05, explore_ratio))) if explore_ratio > 0 else 999
        merged: List[Dict[str, Any]] = []
        a_idx = 0
        e_idx = 0
        while a_idx < len(aligned) or e_idx < len(exploratory):
            for _ in range(step):
                if a_idx < len(aligned):
                    merged.append(aligned[a_idx])
                    a_idx += 1
            if e_idx < len(exploratory):
                merged.append(exploratory[e_idx])
                e_idx += 1
            elif a_idx < len(aligned):
                continue

        total = max(1, len(merged))
        for idx, entry in enumerate(merged):
            # Rank score decreases monotonically in interleaved order so SQL ORDER BY yields desired 70/30 mix
            rank_score = round(1000.0 - (idx * (900.0 / total)), 4)
            conn.execute(
                """
                UPDATE discoveries
                SET relevance_score = ?, final_rank_score = ?, is_exploratory = ?
                WHERE id = ?
                """,
                (entry["relevance"], rank_score, entry["is_exploratory"], entry["id"]),
            )

    return len(scored_items)

