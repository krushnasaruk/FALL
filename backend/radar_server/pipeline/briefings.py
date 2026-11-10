"""Structured 10-section Daily Briefing, Weekly Recap & Notification Event curator."""

from __future__ import annotations

import json
import uuid
from datetime import datetime, timedelta, timezone
from typing import Any, Dict, List, Set

from ..config import CATEGORY_MAP
from ..db import RadarDatabase, today_utc_date, utc_now_iso


def _pick_unique(
    candidates: List[Dict[str, Any]],
    used_ids: Set[str],
    predicate,
    limit: int = 2,
) -> List[Dict[str, Any]]:
    picked = []
    for item in candidates:
        if item["id"] in used_ids:
            continue
        if predicate(item):
            used_ids.add(item["id"])
            picked.append(
                {
                    "discovery_id": item["id"],
                    "title": item["title"],
                    "summary": item.get("plain_english_summary") or item.get("raw_summary") or "",
                    "why_it_matters": item.get("why_it_matters") or "",
                    "source_name": item["source_name"],
                    "canonical_url": item["canonical_url"],
                    "category_code": item["primary_category"],
                    "discovery_type": item["discovery_type"],
                }
            )
            if len(picked) >= limit:
                break
    return picked


def build_and_store_briefing(
    db: RadarDatabase,
    briefing_type: str = "daily",
) -> Dict[str, Any]:
    """Assembles a non-repeating 10-section Daily Briefing or Weekly Recap from real DB rows."""
    window_days = 7 if briefing_type == "weekly" else 3
    cutoff = (datetime.now(timezone.utc) - timedelta(days=window_days)).isoformat()
    used_ids: Set[str] = set()

    with db.connect() as conn:
        rows = conn.execute(
            """
            SELECT * FROM discoveries
            WHERE final_rank_score >= 0 AND discovered_at >= ?
            ORDER BY final_rank_score DESC
            LIMIT 120
            """,
            (cutoff,),
        ).fetchall()
        candidates = [dict(r) for r in rows]

        trends = [
            dict(t)
            for t in conn.execute(
                "SELECT * FROM trend_candidates WHERE status != 'insufficient_evidence' ORDER BY trend_score DESC LIMIT 5"
            ).fetchall()
        ]

    sections: List[Dict[str, Any]] = []

    def add_section(key: str, title: str, items: List[Dict[str, Any]], empty_note: str):
        sections.append(
            {
                "key": key,
                "title": title,
                "items": items,
                "empty_note": empty_note if not items else None,
            }
        )

    add_section(
        "ai_breakthroughs",
        "1. Major AI Breakthroughs & Models",
        _pick_unique(candidates, used_ids, lambda d: d["primary_category"] == "A" or d["discovery_type"] == "model", 2),
        "No qualifying AI model or breakthrough items in this window.",
    )
    add_section(
        "top_github",
        "2. Top GitHub & Open Source",
        _pick_unique(candidates, used_ids, lambda d: d["discovery_type"] == "repo" or d["primary_category"] == "B", 2),
        "No newly synced open-source repositories yet.",
    )
    add_section(
        "top_video",
        "3. Top Technical Video",
        _pick_unique(candidates, used_ids, lambda d: d["discovery_type"] == "video" or d["primary_category"] == "E", 2),
        "No developer video walkthroughs synced yet.",
    )
    add_section(
        "platform_update",
        "4. Platform & Company Updates",
        _pick_unique(candidates, used_ids, lambda d: d["primary_category"] in ("G", "J", "M"), 2),
        "No platform announcements recorded yet.",
    )
    add_section(
        "research_paper",
        "5. Research Paper Worth Knowing",
        _pick_unique(candidates, used_ids, lambda d: d["discovery_type"] == "research" or d["primary_category"] == "H", 2),
        "No recent research preprints matching filters.",
    )
    add_section(
        "startup_launch",
        "6. Startup & Product Highlight",
        _pick_unique(candidates, used_ids, lambda d: d["discovery_type"] == "product" or d["primary_category"] in ("D", "O"), 2),
        "No Show HN or startup launches in this window.",
    )
    add_section(
        "design_dev",
        "7. Engineering Craft & UI/UX",
        _pick_unique(candidates, used_ids, lambda d: d["primary_category"] in ("C", "K", "L", "N"), 2),
        "No language, database, security, or UI craft highlights yet.",
    )
    sections.append(
        {
            "key": "emerging_trend",
            "title": "8. Emerging Multi-Source Trends",
            "items": [
                {
                    "discovery_id": None,
                    "title": f"{t['label']} ({t['status'].replace('_', ' ').title()})",
                    "summary": t["explanation"],
                    "why_it_matters": f"{t['mention_count']} items across {t['source_diversity_count']} sources.",
                    "source_name": "Trend Engine",
                    "canonical_url": "",
                    "category_code": t["primary_category"],
                    "discovery_type": "trend",
                }
                for t in trends[:2]
            ],
            "empty_note": "Insufficient multi-source evidence to flag a cross-platform trend yet."
            if not trends
            else None,
        }
    )
    add_section(
        "wildcard",
        "9. Unexpected Exploratory Discovery",
        _pick_unique(
            candidates,
            used_ids,
            lambda d: bool(d.get("is_exploratory")) or d["primary_category"] in ("I", "Q", "R"),
            1,
        ),
        "Run another collection cycle to surface an exploratory wildcard.",
    )
    add_section(
        "learn_build_idea",
        "10. One Learning or Build Idea",
        _pick_unique(
            candidates,
            used_ids,
            lambda d: bool(d.get("try_it_suggestion")),
            1,
        ),
        "Save or explore any discovery to generate a concrete project experiment.",
    )

    briefing_date = today_utc_date()
    total_items = sum(len(s["items"]) for s in sections)
    headline = (
        f"Tech Radar {briefing_type.title()}: {total_items} grounded highlights"
        if total_items > 0
        else f"Tech Radar {briefing_type.title()}: Awaiting collection data"
    )
    now_iso = utc_now_iso()
    b_id = str(uuid.uuid4())

    with db.connect() as conn:
        conn.execute(
            """
            INSERT INTO daily_briefings (id, briefing_type, briefing_date, headline, sections_json, generated_by, created_at)
            VALUES (?, ?, ?, ?, ?, 'radar_curator', ?)
            ON CONFLICT(briefing_type, briefing_date) DO UPDATE SET
                headline = excluded.headline,
                sections_json = excluded.sections_json,
                created_at = excluded.created_at
            """,
            (b_id, briefing_type, briefing_date, headline, json.dumps(sections), now_iso),
        )

    return {
        "id": b_id,
        "briefing_type": briefing_type,
        "briefing_date": briefing_date,
        "headline": headline,
        "sections": sections,
        "generated_by": "radar_curator",
        "created_at": now_iso,
    }


def generate_notification_events(db: RadarDatabase) -> List[Dict[str, Any]]:
    """Creates high-signal notification events conservatively without duplicates or spam."""
    created: List[Dict[str, Any]] = []
    now_iso = utc_now_iso()
    today = today_utc_date()

    with db.connect() as conn:
        top_rows = conn.execute(
            """
            SELECT d.* FROM discoveries d
            LEFT JOIN notification_events n ON n.discovery_id = d.id
            WHERE n.id IS NULL AND d.final_rank_score >= 920
            ORDER BY d.final_rank_score DESC
            LIMIT 2
            """
        ).fetchall()

        for r in top_rows:
            cat_def = CATEGORY_MAP.get(r["primary_category"])
            cat_label = cat_def.name if cat_def else r["primary_category"]
            ev_id = str(uuid.uuid4())
            title = f"Radar Highlight · {cat_label}"
            body = r["title"]
            conn.execute(
                """
                INSERT INTO notification_events (id, event_type, discovery_id, title, body, priority, is_read, created_at)
                VALUES (?, 'high_signal', ?, ?, ?, 'normal', 0, ?)
                """,
                (ev_id, r["id"], title, body, now_iso),
            )
            created.append({"id": ev_id, "event_type": "high_signal", "title": title, "body": body})

        # Ensure at most one daily briefing alert per UTC day
        existing_daily = conn.execute(
            "SELECT id FROM notification_events WHERE event_type = 'daily_briefing' AND created_at LIKE ?",
            (f"{today}%",),
        ).fetchone()
        if existing_daily is None:
            cnt = conn.execute("SELECT COUNT(*) AS c FROM discoveries").fetchone()["c"]
            if cnt > 0:
                ev_id = str(uuid.uuid4())
                conn.execute(
                    """
                    INSERT INTO notification_events (id, event_type, discovery_id, title, body, priority, is_read, created_at)
                    VALUES (?, 'daily_briefing', NULL, 'Your Daily Tech Briefing is ready', ?, 'normal', 0, ?)
                    """,
                    (ev_id, f"Curated highlights across {cnt} tracked discoveries.", now_iso),
                )
                created.append(
                    {
                        "id": ev_id,
                        "event_type": "daily_briefing",
                        "title": "Your Daily Tech Briefing is ready",
                    }
                )
    return created

