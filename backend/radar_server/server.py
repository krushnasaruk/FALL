"""ProgressOS Radar HTTP API Server, Orchestration Pipeline & Background Collector."""

from __future__ import annotations

import argparse
import json
import sys
import threading
import time
import urllib.parse
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any, Dict, List, Optional

from .config import CATEGORY_MAP, RadarConfig, TOPIC_CATEGORIES
from .connectors import (
    fetch_arxiv_discoveries,
    fetch_community_discoveries,
    fetch_github_discoveries,
    fetch_hackernews_discoveries,
    fetch_huggingface_discoveries,
    fetch_rss_discoveries,
    fetch_youtube_discoveries,
)
from .db import RadarDatabase, utc_now_iso
from .pipeline import (
    analyze_discoveries,
    build_and_store_briefing,
    detect_and_store_trends,
    generate_notification_events,
    ingest_raw_discoveries,
    rank_discoveries,
    run_adaptive_discovery,
)


def run_collection_cycle(
    db: RadarDatabase,
    config: RadarConfig,
    enable_gemini: bool = True,
    connectors_filter: Optional[List[str]] = None,
) -> Dict[str, Any]:
    """Runs connectors -> normalize/dedup -> Gemini/deterministic analysis -> rank -> adaptive -> trends -> briefings."""
    enabled = set(connectors_filter) if connectors_filter else {
        "github", "hackernews", "huggingface", "arxiv", "rss", "community", "youtube"
    }
    connector_stats: Dict[str, Dict[str, Any]] = {}
    all_raw = []

    def _run_one(name: str, fn):
        started = utc_now_iso()
        try:
            items = fn()
            upserted = ingest_raw_discoveries(db, items)
            db.record_collection_run(name, "success", len(items), upserted, started)
            connector_stats[name] = {"status": "success", "fetched": len(items), "upserted": upserted}
            all_raw.extend(items)
        except Exception as exc:
            db.record_collection_run(name, "error", 0, 0, started, str(exc)[:300])
            connector_stats[name] = {"status": "error", "error": str(exc)[:200], "fetched": 0, "upserted": 0}

    if "github" in enabled:
        adaptive_gh = [
            {"q": q["query_text"], "category": q["category_code"]}
            for q in db.get_due_adaptive_queries("github", limit=2)
        ]
        _run_one("github", lambda: fetch_github_discoveries(
            github_token=config.github_token, extra_queries=adaptive_gh, timeout=config.request_timeout_sec
        ))
    if "hackernews" in enabled:
        _run_one("hackernews", lambda: fetch_hackernews_discoveries(limit_per_feed=10, timeout=config.request_timeout_sec))
    if "huggingface" in enabled:
        _run_one("huggingface", lambda: fetch_huggingface_discoveries(model_limit=10, space_limit=5, timeout=config.request_timeout_sec))
    if "arxiv" in enabled:
        _run_one("arxiv", lambda: fetch_arxiv_discoveries(max_results=14, timeout=config.request_timeout_sec))
    if "rss" in enabled:
        _run_one("rss", lambda: fetch_rss_discoveries(per_feed=3, timeout=config.request_timeout_sec))
    if "community" in enabled:
        _run_one("community", lambda: fetch_community_discoveries(dev_limit=8, lobsters_limit=8, timeout=config.request_timeout_sec))
    if "youtube" in enabled:
        adaptive_yt = db.get_due_adaptive_queries("youtube", limit=1)
        _run_one("youtube", lambda: fetch_youtube_discoveries(
            db=db,
            youtube_api_key=config.youtube_api_key,
            extra_queries=adaptive_yt,
            enable_api_search=bool(config.youtube_api_key),
            max_search_queries=2,
            timeout=config.request_timeout_sec,
        ))

    analysis_stats = analyze_discoveries(
        db=db,
        config=config,
        max_gemini_calls=8,
        enable_gemini=enable_gemini,
    )
    ranked_count = rank_discoveries(
        db=db,
        aligned_ratio=config.aligned_ratio,
        explore_ratio=config.explore_ratio,
    )
    adaptive_added = run_adaptive_discovery(db)
    trends = detect_and_store_trends(db)
    briefing = build_and_store_briefing(db, "daily")
    build_and_store_briefing(db, "weekly")
    notifs = generate_notification_events(db)

    return {
        "connectors": connector_stats,
        "total_fetched": len(all_raw),
        "analysis": analysis_stats,
        "ranked_count": ranked_count,
        "adaptive_queries_added": len(adaptive_added),
        "trends_detected": len(trends),
        "briefing_date": briefing["briefing_date"],
        "notifications_created": len(notifs),
    }


def _enrich_discovery_row(conn, row: Dict[str, Any]) -> Dict[str, Any]:
    disc_id = row["id"]
    sources = [
        dict(s)
        for s in conn.execute(
            "SELECT connector, source_name, source_url, reported_score, reported_comments, fetched_at "
            "FROM discovery_sources WHERE discovery_id = ?",
            (disc_id,),
        ).fetchall()
    ]
    categories = [
        r["category_code"]
        for r in conn.execute(
            "SELECT category_code FROM discovery_categories WHERE discovery_id = ?",
            (disc_id,),
        ).fetchall()
    ]
    tags = [
        r["tag"]
        for r in conn.execute(
            "SELECT tag FROM discovery_tags WHERE discovery_id = ?",
            (disc_id,),
        ).fetchall()
    ]
    bm = conn.execute(
        "SELECT collection_name, user_note, saved_at FROM user_bookmarks WHERE discovery_id = ?",
        (disc_id,),
    ).fetchone()
    obs_count = conn.execute(
        "SELECT COUNT(*) AS c FROM discovery_observations WHERE discovery_id = ?",
        (disc_id,),
    ).fetchone()["c"]

    out = dict(row)
    out["extra"] = json.loads(out.pop("extra_json", "{}") or "{}")
    out["is_exploratory"] = bool(out.get("is_exploratory"))
    out["sources"] = sources
    out["categories"] = categories or [out["primary_category"]]
    out["tags"] = tags
    out["observation_count"] = obs_count
    out["is_bookmarked"] = bm is not None
    out["bookmark_collection"] = bm["collection_name"] if bm else None
    out["bookmark_note"] = bm["user_note"] if bm else None
    cat_def = CATEGORY_MAP.get(out["primary_category"])
    out["primary_category_name"] = cat_def.name if cat_def else out["primary_category"]
    return out


class RadarApp:
    def __init__(self, db: RadarDatabase, config: RadarConfig):
        self.db = db
        self.config = config
        self._collect_lock = threading.Lock()
        self._is_collecting = False

    def trigger_collect(self, enable_gemini: bool = True) -> Dict[str, Any]:
        if not self._collect_lock.acquire(blocking=False):
            return {"status": "already_running"}
        self._is_collecting = True
        try:
            res = run_collection_cycle(self.db, self.config, enable_gemini=enable_gemini)
            res["status"] = "completed"
            return res
        finally:
            self._is_collecting = False
            self._collect_lock.release()


def create_http_server(app: RadarApp, host: Optional[str] = None, port: Optional[int] = None) -> ThreadingHTTPServer:
    bind_host = host or app.config.host
    bind_port = port if port is not None else app.config.port

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, format: str, *args: Any) -> None:
            return

        def _send_json(self, code: int, payload: Any) -> None:
            raw = json.dumps(payload, ensure_ascii=False).encode("utf-8")
            self.send_response(code)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(raw)))
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
            self.send_header("Access-Control-Allow-Headers", "Content-Type")
            self.end_headers()
            self.wfile.write(raw)

        def _read_json_body(self) -> Dict[str, Any]:
            length = int(self.headers.get("Content-Length", "0") or 0)
            if length <= 0:
                return {}
            raw = self.rfile.read(min(length, 262144))
            try:
                data = json.loads(raw.decode("utf-8"))
                return data if isinstance(data, dict) else {}
            except Exception:
                return {}

        def do_OPTIONS(self) -> None:
            self._send_json(204, {})

        def do_GET(self) -> None:
            parsed = urllib.parse.urlparse(self.path)
            path = parsed.path.rstrip("/") or "/"
            qs = urllib.parse.parse_qs(parsed.query)

            def q_str(key: str, default: str = "") -> str:
                vals = qs.get(key)
                return vals[0].strip() if vals else default

            def q_int(key: str, default: int) -> int:
                try:
                    return max(1, min(150, int(q_str(key, str(default)))))
                except ValueError:
                    return default

            if path == "/health":
                summary = app.db.get_health_summary()
                self._send_json(
                    200,
                    {
                        "status": "ok",
                        "service": "progressos-radar",
                        "is_collecting": app._is_collecting,
                        "gemini_configured": bool(app.config.gemini_api_key),
                        "github_configured": bool(app.config.github_token),
                        "youtube_configured": bool(app.config.youtube_api_key),
                        "gemini_daily_budget": app.config.gemini_daily_budget,
                        **summary,
                    },
                )
                return

            if path == "/api/radar/taxonomy":
                self._send_json(
                    200,
                    {
                        "categories": [
                            {
                                "code": c.code,
                                "slug": c.slug,
                                "name": c.name,
                                "default_priority": c.default_priority,
                                "description": c.description,
                                "keywords": c.keywords,
                            }
                            for c in TOPIC_CATEGORIES
                        ]
                    },
                )
                return

            if path == "/api/radar/feed":
                view = q_str("view", "for_you")
                category = q_str("category", "")
                limit = q_int("limit", 40)
                where_parts = ["d.final_rank_score >= 0"]
                params: List[Any] = []

                if category:
                    where_parts.append(
                        "(d.primary_category = ? OR EXISTS (SELECT 1 FROM discovery_categories dc WHERE dc.discovery_id = d.id AND dc.category_code = ?))"
                    )
                    params.extend([category.upper(), category.upper()])
                elif view == "explore":
                    where_parts.append("(d.is_exploratory = 1 OR d.priority_tier IN ('P2','P3'))")
                elif view == "github":
                    where_parts.append("d.discovery_type = 'repo'")
                elif view == "creators":
                    where_parts.append("d.discovery_type = 'video'")
                elif view == "ai_models":
                    where_parts.append("(d.primary_category = 'A' OR d.discovery_type = 'model')")
                elif view == "research":
                    where_parts.append("(d.discovery_type = 'research' OR d.primary_category = 'H')")
                elif view == "opportunities":
                    where_parts.append("d.primary_category IN ('D','O','P','R')")
                elif view == "saved":
                    where_parts = ["EXISTS (SELECT 1 FROM user_bookmarks ub WHERE ub.discovery_id = d.id)"]

                sql = f"""
                    SELECT d.* FROM discoveries d
                    WHERE {' AND '.join(where_parts)}
                    ORDER BY d.final_rank_score DESC, d.discovered_at DESC
                    LIMIT ?
                """
                params.append(limit)
                with app.db.connect() as conn:
                    rows = conn.execute(sql, params).fetchall()
                    items = [_enrich_discovery_row(conn, dict(r)) for r in rows]
                self._send_json(200, {"view": view, "count": len(items), "items": items})
                return

            if path == "/api/radar/search":
                q = q_str("q", "").lower()
                category = q_str("category", "")
                disc_type = q_str("type", "")
                limit = q_int("limit", 40)
                where_parts = ["d.final_rank_score >= 0"]
                params: List[Any] = []
                if q:
                    like = f"%{q}%"
                    where_parts.append(
                        "(LOWER(d.title) LIKE ? OR LOWER(d.raw_summary) LIKE ? OR LOWER(COALESCE(d.plain_english_summary,'')) LIKE ? OR LOWER(COALESCE(d.author_or_org,'')) LIKE ? OR EXISTS (SELECT 1 FROM discovery_tags dt WHERE dt.discovery_id = d.id AND dt.tag LIKE ?))"
                    )
                    params.extend([like, like, like, like, like])
                if category:
                    where_parts.append("d.primary_category = ?")
                    params.append(category.upper())
                if disc_type:
                    where_parts.append("d.discovery_type = ?")
                    params.append(disc_type.lower())
                with app.db.connect() as conn:
                    rows = conn.execute(
                        f"SELECT d.* FROM discoveries d WHERE {' AND '.join(where_parts)} ORDER BY d.final_rank_score DESC LIMIT ?",
                        [*params, limit],
                    ).fetchall()
                    items = [_enrich_discovery_row(conn, dict(r)) for r in rows]
                self._send_json(200, {"query": q, "count": len(items), "items": items})
                return

            if path.startswith("/api/radar/discoveries/"):
                disc_id = path.rsplit("/", 1)[-1]
                with app.db.connect() as conn:
                    row = conn.execute("SELECT * FROM discoveries WHERE id = ?", (disc_id,)).fetchone()
                    if row is None:
                        self._send_json(404, {"error": "Discovery not found"})
                        return
                    item = _enrich_discovery_row(conn, dict(row))
                    obs = [
                        dict(o)
                        for o in conn.execute(
                            "SELECT observed_at, stars_count, forks_count, score_count, comments_count, downloads_count, views_count, likes_count "
                            "FROM discovery_observations WHERE discovery_id = ? ORDER BY observed_at DESC LIMIT 10",
                            (disc_id,),
                        ).fetchall()
                    ]
                    item["observations"] = obs
                self._send_json(200, item)
                return

            if path == "/api/radar/preferences/topics":
                self._send_json(
                    200,
                    {
                        "aligned_ratio": app.config.aligned_ratio,
                        "explore_ratio": app.config.explore_ratio,
                        "topics": app.db.get_topic_preferences(),
                    },
                )
                return

            if path == "/api/radar/follows":
                with app.db.connect() as conn:
                    rows = conn.execute("SELECT * FROM user_follows ORDER BY created_at DESC").fetchall()
                    creators = app.db.get_tracked_creators(limit=25)
                self._send_json(
                    200,
                    {
                        "follows": [dict(r) for r in rows],
                        "tracked_creators": creators,
                    },
                )
                return

            if path == "/api/radar/trends":
                with app.db.connect() as conn:
                    t_rows = conn.execute(
                        "SELECT * FROM trend_candidates ORDER BY trend_score DESC LIMIT 25"
                    ).fetchall()
                    trends = []
                    for t in t_rows:
                        item = dict(t)
                        ev = [
                            dict(e)
                            for e in conn.execute(
                                "SELECT * FROM trend_evidence WHERE trend_id = ? ORDER BY observed_at DESC LIMIT 6",
                                (item["id"],),
                            ).fetchall()
                        ]
                        item["evidence"] = ev
                        trends.append(item)
                self._send_json(200, {"trends": trends})
                return

            if path in ("/api/radar/briefings/latest", "/api/radar/briefings"):
                b_type = q_str("type", "daily")
                with app.db.connect() as conn:
                    rows = conn.execute(
                        "SELECT * FROM daily_briefings WHERE briefing_type = ? ORDER BY briefing_date DESC LIMIT 7",
                        (b_type,),
                    ).fetchall()
                briefings = []
                for r in rows:
                    item = dict(r)
                    item["sections"] = json.loads(item.pop("sections_json", "[]"))
                    briefings.append(item)
                if path.endswith("/latest"):
                    self._send_json(200, briefings[0] if briefings else build_and_store_briefing(app.db, b_type))
                else:
                    self._send_json(200, {"briefings": briefings})
                return

            if path == "/api/radar/notifications":
                with app.db.connect() as conn:
                    rows = conn.execute(
                        "SELECT * FROM notification_events ORDER BY created_at DESC LIMIT 30"
                    ).fetchall()
                self._send_json(200, {"notifications": [dict(r) for r in rows]})
                return

            self._send_json(404, {"error": f"Unknown endpoint: {path}"})

        def do_POST(self) -> None:
            parsed = urllib.parse.urlparse(self.path)
            path = parsed.path.rstrip("/") or "/"
            body = self._read_json_body()

            if path == "/api/radar/collect":
                enable_gemini = bool(body.get("enable_gemini", True))
                res = app.trigger_collect(enable_gemini=enable_gemini)
                self._send_json(200, res)
                return

            if path.startswith("/api/radar/discoveries/") and path.endswith("/feedback"):
                disc_id = path.split("/")[-2]
                action = str(body.get("action") or "").strip().lower()
                if action not in ("relevant", "not_relevant", "more_like_this", "hide", "explored", "save"):
                    self._send_json(400, {"error": "Invalid feedback action"})
                    return
                with app.db.connect() as conn:
                    row = conn.execute("SELECT primary_category FROM discoveries WHERE id = ?", (disc_id,)).fetchone()
                    if row is None:
                        self._send_json(404, {"error": "Discovery not found"})
                        return
                    conn.execute(
                        "INSERT INTO user_read_history (id, discovery_id, action, dwell_seconds, created_at) VALUES (?, ?, ?, ?, ?)",
                        (str(uuid.uuid4()), disc_id, action, int(body.get("dwell_seconds") or 0), utc_now_iso()),
                    )
                    cat = row["primary_category"]
                if action in ("relevant", "more_like_this", "save", "explored"):
                    app.db.adjust_topic_affinity(cat, 0.05)
                elif action in ("not_relevant", "hide"):
                    app.db.adjust_topic_affinity(cat, -0.06)
                rank_discoveries(app.db, app.config.aligned_ratio, app.config.explore_ratio)
                self._send_json(200, {"status": "ok", "discovery_id": disc_id, "action": action})
                return

            if path.startswith("/api/radar/discoveries/") and path.endswith("/bookmark"):
                disc_id = path.split("/")[-2]
                saved = bool(body.get("saved", True))
                collection_name = str(body.get("collection_name") or "Saved")[:60]
                user_note = str(body.get("user_note") or "")[:500]
                with app.db.connect() as conn:
                    exists = conn.execute("SELECT id FROM discoveries WHERE id = ?", (disc_id,)).fetchone()
                    if exists is None:
                        self._send_json(404, {"error": "Discovery not found"})
                        return
                    if saved:
                        conn.execute(
                            """
                            INSERT INTO user_bookmarks (discovery_id, collection_name, user_note, saved_at)
                            VALUES (?, ?, ?, ?)
                            ON CONFLICT(discovery_id) DO UPDATE SET
                                collection_name = excluded.collection_name,
                                user_note = excluded.user_note
                            """,
                            (disc_id, collection_name, user_note, utc_now_iso()),
                        )
                    else:
                        conn.execute("DELETE FROM user_bookmarks WHERE discovery_id = ?", (disc_id,))
                self._send_json(200, {"status": "ok", "discovery_id": disc_id, "saved": saved})
                return

            if path == "/api/radar/follows":
                follow_type = str(body.get("follow_type") or "topic")
                target_key = str(body.get("target_key") or "").strip()
                display_name = str(body.get("display_name") or target_key).strip()
                active = bool(body.get("active", True))
                if not target_key:
                    self._send_json(400, {"error": "target_key required"})
                    return
                with app.db.connect() as conn:
                    if active:
                        conn.execute(
                            """
                            INSERT OR IGNORE INTO user_follows (id, follow_type, target_key, display_name, created_at)
                            VALUES (?, ?, ?, ?, ?)
                            """,
                            (str(uuid.uuid4()), follow_type, target_key, display_name, utc_now_iso()),
                        )
                    else:
                        conn.execute(
                            "DELETE FROM user_follows WHERE follow_type = ? AND target_key = ?",
                            (follow_type, target_key),
                        )
                rank_discoveries(app.db, app.config.aligned_ratio, app.config.explore_ratio)
                self._send_json(200, {"status": "ok", "target_key": target_key, "active": active})
                return

            if path == "/api/radar/preferences/topics":
                code = str(body.get("category_code") or "").strip().upper()
                if code:
                    updated = app.db.update_topic_preference(
                        category_code=code,
                        priority_level=body.get("priority_level"),
                        is_muted=body.get("is_muted"),
                        boost_keywords=body.get("boost_keywords"),
                        muted_keywords=body.get("muted_keywords"),
                    )
                    if updated is None:
                        self._send_json(404, {"error": "Unknown category_code"})
                        return
                if "explore_ratio" in body:
                    try:
                        er = max(0.0, min(0.8, float(body["explore_ratio"])))
                        app.config.explore_ratio = er
                        app.config.aligned_ratio = round(1.0 - er, 2)
                    except (TypeError, ValueError):
                        pass
                rank_discoveries(app.db, app.config.aligned_ratio, app.config.explore_ratio)
                self._send_json(
                    200,
                    {
                        "status": "ok",
                        "aligned_ratio": app.config.aligned_ratio,
                        "explore_ratio": app.config.explore_ratio,
                        "topics": app.db.get_topic_preferences(),
                    },
                )
                return

            if path == "/api/radar/notifications/ack":
                ev_id = str(body.get("id") or "").strip()
                with app.db.connect() as conn:
                    if ev_id:
                        conn.execute("UPDATE notification_events SET is_read = 1 WHERE id = ?", (ev_id,))
                    else:
                        conn.execute("UPDATE notification_events SET is_read = 1")
                self._send_json(200, {"status": "ok"})
                return

            self._send_json(404, {"error": f"Unknown POST endpoint: {path}"})

    return ThreadingHTTPServer((bind_host, bind_port), Handler)


def main(argv: Optional[List[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="ProgressOS Radar Intelligence Server")
    parser.add_argument("--collect-once", action="store_true", help="Run one collection cycle and exit")
    parser.add_argument("--no-gemini", action="store_true", help="Use deterministic analysis only")
    parser.add_argument("--host", default=None)
    parser.add_argument("--port", type=int, default=None)
    parser.add_argument("--db-path", default=None)
    args = parser.parse_args(argv)

    config = RadarConfig.from_env(db_path=Path(args.db_path) if args.db_path else None)
    if args.host:
        config.host = args.host
    if args.port:
        config.port = args.port

    db = RadarDatabase(config.db_path)
    app = RadarApp(db, config)

    if args.collect_once:
        res = app.trigger_collect(enable_gemini=not args.no_gemini)
        print(json.dumps(res, indent=2))
        return 0

    if config.auto_collect:
        def _loop():
            while True:
                app.trigger_collect(enable_gemini=True)
                time.sleep(2 * 3600)

        t = threading.Thread(target=_loop, daemon=True)
        t.start()

    server = create_http_server(app)
    print(f"ProgressOS Radar server listening on http://{config.host}:{config.port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        server.shutdown()
    return 0


if __name__ == "__main__":
    sys.exit(main())

