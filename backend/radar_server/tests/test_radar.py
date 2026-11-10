"""Comprehensive automated tests for ProgressOS Radar backend."""

from __future__ import annotations

import json
import sys
import tempfile
import threading
import unittest
import urllib.request
from pathlib import Path
from unittest.mock import patch

BACKEND_PARENT = Path(__file__).resolve().parents[2]
if str(BACKEND_PARENT) not in sys.path:
    sys.path.insert(0, str(BACKEND_PARENT))

from radar_server.config import TOPIC_CATEGORIES, RadarConfig
from radar_server.connectors.base import RawDiscovery
from radar_server.connectors.rss_connector import parse_feed_xml
from radar_server.config import RssFeedSource
from radar_server.db import RadarDatabase, utc_now_iso
from radar_server.pipeline.adaptive_discovery import run_adaptive_discovery
from radar_server.pipeline.briefings import build_and_store_briefing, generate_notification_events
from radar_server.pipeline.gemini_layer import _validate_gemini_payload, analyze_discoveries
from radar_server.pipeline.normalizer import canonicalize_url, ingest_raw_discoveries
from radar_server.pipeline.ranking import rank_discoveries
from radar_server.pipeline.trends import detect_and_store_trends
from radar_server.export_static import export_static_site
from radar_server.server import RadarApp, create_http_server


class RadarBackendTests(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.db_path = Path(self.tmp.name) / "test_radar.sqlite3"
        self.db = RadarDatabase(self.db_path)
        self.config = RadarConfig(
            db_path=self.db_path,
            gemini_api_key="",
            github_token="",
            youtube_api_key="",
            gemini_daily_budget=5,
        )

    def tearDown(self) -> None:
        self.tmp.cleanup()

    def test_18_categories_seeded_with_priorities(self) -> None:
        prefs = self.db.get_topic_preferences()
        self.assertEqual(len(prefs), 18)
        codes = {p["category_code"] for p in prefs}
        expected = {chr(c) for c in range(ord("A"), ord("R") + 1)}
        self.assertEqual(codes, expected)
        by_code = {p["category_code"]: p for p in prefs}
        self.assertEqual(by_code["A"]["priority_level"], "P0")
        self.assertEqual(by_code["O"]["priority_level"], "P2")
        self.assertEqual(by_code["Q"]["priority_level"], "P3")

    def test_url_canonicalization_and_deduplication_preserves_sources_and_real_deltas(self) -> None:
        u1 = canonicalize_url("https://github.com/org/cool-agent/?utm_source=hn&ref=daily")
        u2 = canonicalize_url("https://www.github.com/org/cool-agent.git")
        self.assertEqual(u1, "https://github.com/org/cool-agent")
        self.assertEqual(u1, u2)

        raw_gh = RawDiscovery(
            canonical_url="https://github.com/org/cool-agent/?utm_source=twitter",
            title="org/cool-agent",
            discovery_type="repo",
            connector="github",
            source_name="GitHub Search",
            source_url="https://github.com/org/cool-agent",
            default_categories=["A", "B"],
            stars_count=120,
            forks_count=15,
            tags=["ai-agents", "rust"],
        )
        raw_hn = RawDiscovery(
            canonical_url="https://github.com/org/cool-agent",
            title="Show HN: org/cool-agent",
            discovery_type="community",
            connector="hackernews",
            source_name="Show HN",
            source_url="https://news.ycombinator.com/item?id=999",
            default_categories=["D", "F"],
            reported_score=85,
            tags=["show-hn", "ai-agents"],
        )

        ingest_raw_discoveries(self.db, [raw_gh])
        # Single observation: must NOT fabricate a delta!
        with self.db.connect() as conn:
            row = conn.execute("SELECT * FROM discoveries").fetchone()
            self.assertIsNone(row["metric_delta_value"])

        # Second observation with updated stars (180 vs 120 => +60 real delta) + second source link
        raw_gh2 = RawDiscovery(
            canonical_url="https://github.com/org/cool-agent",
            title="org/cool-agent",
            discovery_type="repo",
            connector="github",
            source_name="GitHub Search",
            source_url="https://github.com/org/cool-agent",
            default_categories=["A", "B"],
            stars_count=180,
            forks_count=22,
            tags=["ai-agents", "rust"],
        )
        ingest_raw_discoveries(self.db, [raw_hn, raw_gh2])

        with self.db.connect() as conn:
            cnt = conn.execute("SELECT COUNT(*) AS c FROM discoveries").fetchone()["c"]
            self.assertEqual(cnt, 1)
            row = conn.execute("SELECT * FROM discoveries").fetchone()
            self.assertEqual(row["metric_delta_label"], "Star delta")
            self.assertEqual(row["metric_delta_value"], 60.0)
            src_cnt = conn.execute("SELECT COUNT(*) AS c FROM discovery_sources").fetchone()["c"]
            self.assertEqual(src_cnt, 2)

    def test_missing_metadata_remains_null_honestly(self) -> None:
        raw = RawDiscovery(
            canonical_url="https://example.org/post-no-metrics",
            title="Technical Post Without Metrics",
            discovery_type="article",
            connector="rss",
            source_name="Engineering Blog",
            source_url="https://example.org/rss.xml",
            default_categories=["C"],
            raw_summary="Short engineering write-up.",
        )
        ingest_raw_discoveries(self.db, [raw])
        with self.db.connect() as conn:
            row = conn.execute("SELECT * FROM discoveries").fetchone()
            self.assertIsNone(row["primary_metric_value"])
            self.assertIsNone(row["metric_delta_value"])
            obs_cnt = conn.execute("SELECT COUNT(*) AS c FROM discovery_observations").fetchone()["c"]
            self.assertEqual(obs_cnt, 0)

    def test_gemini_validation_and_budget_fallback_to_deterministic(self) -> None:
        self.assertIsNone(_validate_gemini_payload({"plain_english_summary": "only one field"}))
        valid = _validate_gemini_payload({
            "plain_english_summary": "Summary",
            "why_it_matters": "Matters",
            "who_it_is_for": "Engineers",
            "how_it_compares": "Faster setup",
            "practical_takeaway": "Read docs",
            "try_it_suggestion": "Run CLI",
            "beginner_note": "CLI tool",
            "category_codes": ["A", "INVALID"],
            "tags": ["Rust", "MCP"],
            "novelty_score": 1.8,
            "actionability_score": -0.4,
        })
        self.assertIsNotNone(valid)
        self.assertEqual(valid["category_codes"], ["A"])
        self.assertEqual(valid["novelty_score"], 1.0)
        self.assertEqual(valid["actionability_score"], 0.0)

        # Ingest discovery & exhaust Gemini budget -> must cleanly use deterministic fallback
        ingest_raw_discoveries(
            self.db,
            [
                RawDiscovery(
                    canonical_url="https://github.com/acme/mcp-bridge",
                    title="acme/mcp-bridge",
                    discovery_type="repo",
                    connector="github",
                    source_name="GitHub Search",
                    source_url="https://github.com/acme/mcp-bridge",
                    default_categories=["A", "B"],
                    stars_count=90,
                    raw_summary="Lightweight bridge server for MCP tool discovery.",
                )
            ],
        )
        cfg_with_key = RadarConfig(
            db_path=self.db_path,
            gemini_api_key="dummy-test-key",
            github_token="",
            youtube_api_key="",
            gemini_daily_budget=1,
        )
        # Pre-fill daily quota
        self.db.log_gemini_usage("gemini-2.5-flash", "hash1", "success", 100)
        res = analyze_discoveries(self.db, cfg_with_key, enable_gemini=True)
        self.assertEqual(res["gemini"], 0)
        self.assertEqual(res["deterministic"], 1)

        with self.db.connect() as conn:
            row = conn.execute("SELECT analysis_source, plain_english_summary FROM discoveries").fetchone()
            self.assertEqual(row["analysis_source"], "deterministic")
            self.assertIn("MCP", row["plain_english_summary"])

    def test_gemini_circuit_breaker_falls_back_cleanly_after_two_errors(self) -> None:
        items = [
            RawDiscovery(
                canonical_url=f"https://example.org/cb/{i}",
                title=f"Circuit Breaker Repo {i}",
                discovery_type="repo",
                connector="github",
                source_name="GitHub Search",
                source_url=f"https://example.org/cb/{i}",
                default_categories=["B"],
            )
            for i in range(4)
        ]
        ingest_raw_discoveries(self.db, items)
        cfg = RadarConfig(
            db_path=self.db_path,
            gemini_api_key="dummy-key",
            github_token="",
            youtube_api_key="",
            gemini_daily_budget=50,
        )
        with patch("radar_server.pipeline.gemini_layer._call_gemini_json", side_effect=RuntimeError("boom")) as mocked:
            res = analyze_discoveries(self.db, cfg, max_gemini_calls=10, enable_gemini=True)
            self.assertEqual(mocked.call_count, 2)
            self.assertEqual(res["gemini"], 0)
            self.assertEqual(res["deterministic"], 4)

    def test_ranking_respects_muted_topics_and_70_30_exploratory_mix(self) -> None:
        # Ingest 7 P0 items (A) + 3 P3 exploratory items (Q)
        items = []
        for i in range(7):
            items.append(
                RawDiscovery(
                    canonical_url=f"https://example.org/p0/{i}",
                    title=f"AI Agent Release {i}",
                    discovery_type="article",
                    connector="rss",
                    source_name="AI Blog",
                    source_url=f"https://example.org/p0/{i}",
                    default_categories=["A"],
                    published_at=utc_now_iso(),
                )
            )
        for i in range(3):
            items.append(
                RawDiscovery(
                    canonical_url=f"https://example.org/p3/{i}",
                    title=f"Quantum Photonics Breakthrough {i}",
                    discovery_type="research",
                    connector="arxiv",
                    source_name="arXiv",
                    source_url=f"https://example.org/p3/{i}",
                    default_categories=["Q"],
                    published_at=utc_now_iso(),
                )
            )
        ingest_raw_discoveries(self.db, items)
        analyze_discoveries(self.db, self.config, enable_gemini=False)
        ranked = rank_discoveries(self.db, aligned_ratio=0.70, explore_ratio=0.30)
        self.assertEqual(ranked, 10)

        with self.db.connect() as conn:
            top10 = conn.execute(
                "SELECT is_exploratory, primary_category FROM discoveries ORDER BY final_rank_score DESC LIMIT 10"
            ).fetchall()
            expl_count = sum(1 for r in top10 if r["is_exploratory"] == 1)
            self.assertGreaterEqual(expl_count, 2)

        # Muting category Q removes all Q items from ranked feed (final_rank_score < 0)
        self.db.update_topic_preference("Q", is_muted=True)
        rank_discoveries(self.db)
        with self.db.connect() as conn:
            visible_q = conn.execute(
                "SELECT COUNT(*) AS c FROM discoveries WHERE primary_category = 'Q' AND final_rank_score >= 0"
            ).fetchone()["c"]
            self.assertEqual(visible_q, 0)

    def test_trend_detection_requires_cross_source_evidence_and_adaptive_cap(self) -> None:
        # Single-source topic -> insufficient_evidence
        ingest_raw_discoveries(
            self.db,
            [
                RawDiscovery(
                    canonical_url="https://github.com/u/local-only-1",
                    title="Tool 1",
                    discovery_type="repo",
                    connector="github",
                    source_name="GitHub",
                    source_url="https://github.com/u/local-only-1",
                    default_categories=["C"],
                    tags=["zig-wasm"],
                ),
                RawDiscovery(
                    canonical_url="https://github.com/u/local-only-2",
                    title="Tool 2",
                    discovery_type="repo",
                    connector="github",
                    source_name="GitHub",
                    source_url="https://github.com/u/local-only-2",
                    default_categories=["C"],
                    tags=["zig-wasm"],
                ),
            ],
        )
        # Cross-source topic -> emerging
        ingest_raw_discoveries(
            self.db,
            [
                RawDiscovery(
                    canonical_url="https://github.com/u/mcp-eval",
                    title="MCP Eval Harness",
                    discovery_type="repo",
                    connector="github",
                    source_name="GitHub",
                    source_url="https://github.com/u/mcp-eval",
                    default_categories=["A"],
                    tags=["mcp-protocol"],
                ),
                RawDiscovery(
                    canonical_url="https://news.ycombinator.com/item?id=5555",
                    title="MCP Protocol Benchmarks",
                    discovery_type="community",
                    connector="hackernews",
                    source_name="Hacker News",
                    source_url="https://news.ycombinator.com/item?id=5555",
                    default_categories=["A"],
                    tags=["mcp-protocol"],
                ),
            ],
        )
        trends = detect_and_store_trends(self.db)
        by_key = {t["topic_key"]: t for t in trends}
        self.assertEqual(by_key["zig-wasm"]["status"], "insufficient_evidence")
        self.assertEqual(by_key["mcp-protocol"]["status"], "emerging")

        # Adaptive discovery creates bounded queries
        analyze_discoveries(self.db, self.config, enable_gemini=False)
        rank_discoveries(self.db)
        added = run_adaptive_discovery(self.db, max_new_queries=3)
        self.assertLessEqual(len(added), 3)

    def test_briefings_non_duplicative_and_http_api_roundtrip(self) -> None:
        ingest_raw_discoveries(
            self.db,
            [
                RawDiscovery(
                    canonical_url="https://github.com/flutter/sample-ai",
                    title="flutter/sample-ai",
                    discovery_type="repo",
                    connector="github",
                    source_name="GitHub",
                    source_url="https://github.com/flutter/sample-ai",
                    default_categories=["M", "A"],
                    stars_count=410,
                    tags=["flutter", "ai-agents"],
                ),
                RawDiscovery(
                    canonical_url="https://arxiv.org/abs/2601.00001",
                    title="Compact Local Reasoning Agents",
                    discovery_type="research",
                    connector="arxiv",
                    source_name="arXiv",
                    source_url="https://arxiv.org/abs/2601.00001",
                    default_categories=["A", "H"],
                    tags=["reasoning"],
                ),
            ],
        )
        analyze_discoveries(self.db, self.config, enable_gemini=False)
        rank_discoveries(self.db)
        detect_and_store_trends(self.db)
        briefing = build_and_store_briefing(self.db, "daily")
        self.assertEqual(len(briefing["sections"]), 10)
        seen_ids = []
        for s in briefing["sections"]:
            for it in s["items"]:
                if it.get("discovery_id"):
                    seen_ids.append(it["discovery_id"])
        # Same item may appear in top_github/ai etc only once in briefing items (except learn_build_idea step)
        non_idea_ids = [
            it["discovery_id"]
            for s in briefing["sections"][:-1]
            for it in s["items"]
            if it.get("discovery_id")
        ]
        self.assertEqual(len(non_idea_ids), len(set(non_idea_ids)))

        generate_notification_events(self.db)

        app = RadarApp(self.db, self.config)
        server = create_http_server(app, host="127.0.0.1", port=0)
        port = server.server_address[1]
        t = threading.Thread(target=server.serve_forever, daemon=True)
        t.start()
        try:
            with urllib.request.urlopen(f"http://127.0.0.1:{port}/health") as r:
                health = json.loads(r.read().decode("utf-8"))
                self.assertEqual(health["status"], "ok")
                self.assertEqual(health["total_discoveries"], 2)

            with urllib.request.urlopen(f"http://127.0.0.1:{port}/api/radar/feed?view=for_you") as r:
                feed = json.loads(r.read().decode("utf-8"))
                self.assertEqual(feed["count"], 2)
                first_id = feed["items"][0]["id"]

            # Test bookmark POST + search + feedback POST
            req = urllib.request.Request(
                f"http://127.0.0.1:{port}/api/radar/discoveries/{first_id}/bookmark",
                data=json.dumps({"saved": True, "collection_name": "Build Later"}).encode("utf-8"),
                headers={"Content-Type": "application/json"},
                method="POST",
            )
            with urllib.request.urlopen(req) as r:
                self.assertEqual(json.loads(r.read().decode("utf-8"))["saved"], True)

            with urllib.request.urlopen(f"http://127.0.0.1:{port}/api/radar/feed?view=saved") as r:
                saved_feed = json.loads(r.read().decode("utf-8"))
                self.assertEqual(saved_feed["count"], 1)
                self.assertEqual(saved_feed["items"][0]["bookmark_collection"], "Build Later")

            # RSS parser sanity check
            rss_sample = """<?xml version="1.0"?><rss><channel><item><title>Hello Rust</title><link>https://example.org/rust</link><description>&lt;p&gt;Body&lt;/p&gt;</description></item></channel></rss>"""
            parsed_rss = parse_feed_xml(RssFeedSource("s", "Sample", "https://example.org/rss", ["C"]), rss_sample)
            self.assertEqual(len(parsed_rss), 1)
            self.assertEqual(parsed_rss[0].raw_summary, "Body")

            # Static export creates sanitized CDN JSON snapshots without secrets
            dist_dir = Path(self.tmp.name) / "dist"
            exp = export_static_site(self.db, self.config, dist_dir)
            self.assertEqual(exp["for_you_count"], 2)
            self.assertTrue((dist_dir / "health.json").exists())
            self.assertTrue((dist_dir / "api" / "radar" / "feed_for_you.json").exists())
            self.assertTrue((dist_dir / "api" / "radar" / "briefing_daily.json").exists())
            self.assertTrue((dist_dir / "index.html").exists())
            health_static = json.loads((dist_dir / "health.json").read_text(encoding="utf-8"))
            self.assertEqual(health_static["mode"], "always_on_static")
            self.assertNotIn("gemini_api_key", health_static)
        finally:
            server.shutdown()
            server.server_close()


if __name__ == "__main__":
    unittest.main()
