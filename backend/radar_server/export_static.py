"""Exports sanitized static JSON snapshots + clean web status page for 24/7 static CDN hosting (e.g. GitHub Pages / Netlify)."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List

from .config import TOPIC_CATEGORIES, RadarConfig
from .db import RadarDatabase, utc_now_iso
from .pipeline.briefings import build_and_store_briefing
from .server import _enrich_discovery_row, run_collection_cycle


def export_static_site(db: RadarDatabase, config: RadarConfig, output_dir: Path) -> Dict[str, Any]:
    """Writes static JSON endpoints matching RadarSyncNotifier expectations with zero secrets."""
    out = Path(output_dir)
    api_dir = out / "api" / "radar"
    api_dir.mkdir(parents=True, exist_ok=True)

    summary = db.get_health_summary()
    health_payload = {
        "status": "ok",
        "mode": "always_on_static",
        "service": "progressos-radar",
        "generated_at": utc_now_iso(),
        "is_collecting": False,
        "gemini_configured": bool(config.gemini_api_key),
        "github_configured": bool(config.github_token),
        "youtube_configured": bool(config.youtube_api_key),
        "gemini_daily_budget": config.gemini_daily_budget,
        **summary,
    }
    (out / "health.json").write_text(json.dumps(health_payload, ensure_ascii=False, indent=2), encoding="utf-8")

    with db.connect() as conn:
        for_you_rows = conn.execute(
            """
            SELECT * FROM discoveries
            WHERE final_rank_score >= 0
            ORDER BY final_rank_score DESC, discovered_at DESC
            LIMIT 80
            """
        ).fetchall()
        for_you_items = [_enrich_discovery_row(conn, dict(r)) for r in for_you_rows]

        explore_rows = conn.execute(
            """
            SELECT * FROM discoveries
            WHERE final_rank_score >= 0 AND (is_exploratory = 1 OR priority_tier IN ('P2','P3'))
            ORDER BY final_rank_score DESC, discovered_at DESC
            LIMIT 40
            """
        ).fetchall()
        explore_items = [_enrich_discovery_row(conn, dict(r)) for r in explore_rows]

        t_rows = conn.execute(
            "SELECT * FROM trend_candidates ORDER BY trend_score DESC LIMIT 25"
        ).fetchall()
        trends: List[Dict[str, Any]] = []
        for tr in t_rows:
            t_item = dict(tr)
            t_item["evidence"] = [
                dict(e)
                for e in conn.execute(
                    "SELECT * FROM trend_evidence WHERE trend_id = ? ORDER BY observed_at DESC LIMIT 6",
                    (t_item["id"],),
                ).fetchall()
            ]
            trends.append(t_item)

        b_row = conn.execute(
            "SELECT * FROM daily_briefings WHERE briefing_type = 'daily' ORDER BY briefing_date DESC LIMIT 1"
        ).fetchone()
        if b_row is not None:
            briefing = dict(b_row)
            briefing["sections"] = json.loads(briefing.pop("sections_json", "[]"))
        else:
            briefing = build_and_store_briefing(db, "daily")

    (api_dir / "feed_for_you.json").write_text(
        json.dumps({"view": "for_you", "count": len(for_you_items), "items": for_you_items}, ensure_ascii=False),
        encoding="utf-8",
    )
    (api_dir / "feed_explore.json").write_text(
        json.dumps({"view": "explore", "count": len(explore_items), "items": explore_items}, ensure_ascii=False),
        encoding="utf-8",
    )
    (api_dir / "trends.json").write_text(
        json.dumps({"trends": trends}, ensure_ascii=False),
        encoding="utf-8",
    )
    (api_dir / "briefing_daily.json").write_text(
        json.dumps(briefing, ensure_ascii=False),
        encoding="utf-8",
    )
    (api_dir / "taxonomy.json").write_text(
        json.dumps(
            {
                "categories": [
                    {
                        "code": c.code,
                        "slug": c.slug,
                        "name": c.name,
                        "default_priority": c.default_priority,
                        "description": c.description,
                    }
                    for c in TOPIC_CATEGORIES
                ]
            },
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )

    html = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>FALL · ProgressOS Radar Live Feed</title>
  <style>
    body {{ font-family: system-ui, -apple-system, sans-serif; max-width: 720px; margin: 40px auto; padding: 0 20px; background: #f8f9fc; color: #0f172a; }}
    .card {{ background: #fff; border: 1px solid #e2e8f0; border-radius: 14px; padding: 20px; margin-bottom: 16px; }}
    code {{ background: #f1f5f9; padding: 2px 6px; border-radius: 6px; }}
  </style>
</head>
<body>
  <div class="card">
    <h1>ProgressOS Radar — Always-On Cloud Feed</h1>
    <p>Status: <strong>{health_payload['status'].upper()}</strong> · Discoveries: <strong>{health_payload['total_discoveries']}</strong> · Updated: <code>{health_payload['generated_at']}</code></p>
    <p>Connect the <strong>FALL Android App</strong> under <em>Tech Radar &rarr; Settings</em> using this site root URL.</p>
    <ul>
      <li><a href="./health.json"><code>/health.json</code></a></li>
      <li><a href="./api/radar/feed_for_you.json"><code>/api/radar/feed_for_you.json</code></a> ({len(for_you_items)} items)</li>
      <li><a href="./api/radar/feed_explore.json"><code>/api/radar/feed_explore.json</code></a> ({len(explore_items)} items)</li>
      <li><a href="./api/radar/trends.json"><code>/api/radar/trends.json</code></a> ({len(trends)} trends)</li>
      <li><a href="./api/radar/briefing_daily.json"><code>/api/radar/briefing_daily.json</code></a></li>
    </ul>
  </div>
</body>
</html>
"""
    (out / "index.html").write_text(html, encoding="utf-8")
    return {
        "output_dir": str(out),
        "for_you_count": len(for_you_items),
        "explore_count": len(explore_items),
        "trends_count": len(trends),
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Collect and export static Radar JSON feeds")
    parser.add_argument("--collect", action="store_true", help="Run collection cycle before export")
    parser.add_argument("--no-gemini", action="store_true")
    parser.add_argument("--out", default="backend/radar_server/dist")
    parser.add_argument("--db-path", default=None)
    args = parser.parse_args(argv)

    config = RadarConfig.from_env(db_path=Path(args.db_path) if args.db_path else None)
    db = RadarDatabase(config.db_path)
    if args.collect:
        run_collection_cycle(db, config, enable_gemini=not args.no_gemini)
    res = export_static_site(db, config, Path(args.out))
    print(json.dumps(res, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
