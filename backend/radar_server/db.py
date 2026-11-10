"""SQLite storage layer implementing all 19 ProgressOS Radar tables."""

from __future__ import annotations

import json
import sqlite3
import threading
import uuid
from contextlib import contextmanager
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Tuple

from .config import TOPIC_CATEGORIES, PRIORITY_WEIGHTS


def utc_now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def today_utc_date() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%d")


SCHEMA_SQL = """
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS discoveries (
    id TEXT PRIMARY KEY,
    canonical_url TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    normalized_title TEXT NOT NULL,
    discovery_type TEXT NOT NULL,
    primary_category TEXT NOT NULL,
    priority_tier TEXT NOT NULL DEFAULT 'P1',
    source_name TEXT NOT NULL,
    source_domain TEXT NOT NULL,
    author_or_org TEXT,
    published_at TEXT,
    discovered_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    raw_summary TEXT,
    plain_english_summary TEXT,
    why_it_matters TEXT,
    who_it_is_for TEXT,
    how_it_compares TEXT,
    practical_takeaway TEXT,
    try_it_suggestion TEXT,
    beginner_note TEXT,
    analysis_source TEXT NOT NULL DEFAULT 'pending',
    content_hash TEXT NOT NULL,
    confidence_level TEXT NOT NULL DEFAULT 'source_reported',
    relevance_score REAL NOT NULL DEFAULT 0.0,
    novelty_score REAL NOT NULL DEFAULT 0.0,
    trend_score REAL NOT NULL DEFAULT 0.0,
    actionability_score REAL NOT NULL DEFAULT 0.0,
    final_rank_score REAL NOT NULL DEFAULT 0.0,
    is_exploratory INTEGER NOT NULL DEFAULT 0,
    primary_metric_label TEXT,
    primary_metric_value REAL,
    secondary_metric_label TEXT,
    secondary_metric_value REAL,
    metric_delta_label TEXT,
    metric_delta_value REAL,
    extra_json TEXT NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS discovery_sources (
    id TEXT PRIMARY KEY,
    discovery_id TEXT NOT NULL,
    connector TEXT NOT NULL,
    source_name TEXT NOT NULL,
    source_url TEXT NOT NULL,
    external_id TEXT,
    reported_score REAL,
    reported_comments REAL,
    fetched_at TEXT NOT NULL,
    metadata_json TEXT NOT NULL DEFAULT '{}',
    UNIQUE(discovery_id, connector, source_url),
    FOREIGN KEY(discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS discovery_observations (
    id TEXT PRIMARY KEY,
    discovery_id TEXT NOT NULL,
    observed_at TEXT NOT NULL,
    stars_count INTEGER,
    forks_count INTEGER,
    score_count INTEGER,
    comments_count INTEGER,
    downloads_count INTEGER,
    views_count INTEGER,
    likes_count INTEGER,
    FOREIGN KEY(discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS discovery_categories (
    discovery_id TEXT NOT NULL,
    category_code TEXT NOT NULL,
    confidence REAL NOT NULL DEFAULT 0.8,
    source TEXT NOT NULL DEFAULT 'deterministic',
    PRIMARY KEY(discovery_id, category_code),
    FOREIGN KEY(discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS discovery_tags (
    discovery_id TEXT NOT NULL,
    tag TEXT NOT NULL,
    PRIMARY KEY(discovery_id, tag),
    FOREIGN KEY(discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS discovery_relationships (
    id TEXT PRIMARY KEY,
    from_discovery_id TEXT NOT NULL,
    to_discovery_id TEXT,
    relation_type TEXT NOT NULL,
    target_label TEXT NOT NULL,
    created_at TEXT NOT NULL,
    FOREIGN KEY(from_discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tracked_entities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    canonical_ref TEXT NOT NULL UNIQUE,
    primary_category TEXT NOT NULL,
    first_seen_at TEXT NOT NULL,
    last_seen_at TEXT NOT NULL,
    mention_count INTEGER NOT NULL DEFAULT 1,
    metadata_json TEXT NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS tracked_creators (
    id TEXT PRIMARY KEY,
    platform TEXT NOT NULL,
    channel_id TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    feed_url TEXT,
    primary_category TEXT NOT NULL DEFAULT 'E',
    discovered_from TEXT NOT NULL DEFAULT 'seed',
    is_followed INTEGER NOT NULL DEFAULT 0,
    last_checked_at TEXT,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS user_follows (
    id TEXT PRIMARY KEY,
    follow_type TEXT NOT NULL,
    target_key TEXT NOT NULL,
    display_name TEXT NOT NULL,
    metadata_json TEXT NOT NULL DEFAULT '{}',
    created_at TEXT NOT NULL,
    UNIQUE(follow_type, target_key)
);

CREATE TABLE IF NOT EXISTS user_bookmarks (
    discovery_id TEXT PRIMARY KEY,
    collection_name TEXT NOT NULL DEFAULT 'Saved',
    user_note TEXT NOT NULL DEFAULT '',
    saved_at TEXT NOT NULL,
    FOREIGN KEY(discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_read_history (
    id TEXT PRIMARY KEY,
    discovery_id TEXT NOT NULL,
    action TEXT NOT NULL,
    dwell_seconds INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    FOREIGN KEY(discovery_id) REFERENCES discoveries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS topic_preferences (
    category_code TEXT PRIMARY KEY,
    category_name TEXT NOT NULL,
    priority_level TEXT NOT NULL,
    is_muted INTEGER NOT NULL DEFAULT 0,
    boost_keywords_json TEXT NOT NULL DEFAULT '[]',
    muted_keywords_json TEXT NOT NULL DEFAULT '[]',
    affinity_adjustment REAL NOT NULL DEFAULT 0.0,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS trend_candidates (
    id TEXT PRIMARY KEY,
    topic_key TEXT NOT NULL UNIQUE,
    label TEXT NOT NULL,
    primary_category TEXT NOT NULL,
    status TEXT NOT NULL,
    trend_score REAL NOT NULL DEFAULT 0.0,
    source_diversity_count INTEGER NOT NULL DEFAULT 0,
    mention_count INTEGER NOT NULL DEFAULT 0,
    window_start TEXT NOT NULL,
    window_end TEXT NOT NULL,
    explanation TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS trend_evidence (
    id TEXT PRIMARY KEY,
    trend_id TEXT NOT NULL,
    discovery_id TEXT,
    source_name TEXT NOT NULL,
    evidence_summary TEXT NOT NULL,
    metric_delta REAL,
    observed_at TEXT NOT NULL,
    FOREIGN KEY(trend_id) REFERENCES trend_candidates(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS discovery_queries (
    id TEXT PRIMARY KEY,
    connector TEXT NOT NULL,
    query_text TEXT NOT NULL,
    category_code TEXT NOT NULL,
    origin TEXT NOT NULL,
    priority REAL NOT NULL DEFAULT 0.5,
    last_run_at TEXT,
    cooldown_hours INTEGER NOT NULL DEFAULT 12,
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL,
    UNIQUE(connector, query_text)
);

CREATE TABLE IF NOT EXISTS gemini_usage (
    id TEXT PRIMARY KEY,
    usage_date TEXT NOT NULL,
    model_name TEXT NOT NULL,
    prompt_hash TEXT NOT NULL,
    request_status TEXT NOT NULL,
    estimated_tokens INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS collection_runs (
    id TEXT PRIMARY KEY,
    connector TEXT NOT NULL,
    started_at TEXT NOT NULL,
    finished_at TEXT,
    status TEXT NOT NULL,
    items_fetched INTEGER NOT NULL DEFAULT 0,
    items_upserted INTEGER NOT NULL DEFAULT 0,
    error_message TEXT
);

CREATE TABLE IF NOT EXISTS notification_events (
    id TEXT PRIMARY KEY,
    event_type TEXT NOT NULL,
    discovery_id TEXT,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    priority TEXT NOT NULL DEFAULT 'normal',
    is_read INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS daily_briefings (
    id TEXT PRIMARY KEY,
    briefing_type TEXT NOT NULL,
    briefing_date TEXT NOT NULL,
    headline TEXT NOT NULL,
    sections_json TEXT NOT NULL,
    generated_by TEXT NOT NULL,
    created_at TEXT NOT NULL,
    UNIQUE(briefing_type, briefing_date)
);

CREATE INDEX IF NOT EXISTS idx_discoveries_category ON discoveries(primary_category);
CREATE INDEX IF NOT EXISTS idx_discoveries_type ON discoveries(discovery_type);
CREATE INDEX IF NOT EXISTS idx_discoveries_rank ON discoveries(final_rank_score DESC);
CREATE INDEX IF NOT EXISTS idx_discoveries_published ON discoveries(published_at DESC);
CREATE INDEX IF NOT EXISTS idx_obs_discovery ON discovery_observations(discovery_id, observed_at DESC);
"""


class RadarDatabase:
    def __init__(self, db_path: Path):
        self.db_path = Path(db_path)
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        self._lock = threading.RLock()
        self.init_schema()

    @contextmanager
    def connect(self):
        with self._lock:
            conn = sqlite3.connect(str(self.db_path), timeout=30.0)
            conn.row_factory = sqlite3.Row
            conn.execute("PRAGMA foreign_keys = ON;")
            try:
                yield conn
                conn.commit()
            except Exception:
                conn.rollback()
                raise
            finally:
                conn.close()

    def init_schema(self) -> None:
        with self.connect() as conn:
            conn.executescript(SCHEMA_SQL)
            now = utc_now_iso()
            for cat in TOPIC_CATEGORIES:
                conn.execute(
                    """
                    INSERT OR IGNORE INTO topic_preferences (
                        category_code, category_name, priority_level, is_muted,
                        boost_keywords_json, muted_keywords_json, affinity_adjustment, updated_at
                    ) VALUES (?, ?, ?, 0, ?, '[]', 0.0, ?)
                    """,
                    (
                        cat.code,
                        cat.name,
                        cat.default_priority,
                        json.dumps(cat.keywords[:6]),
                        now,
                    ),
                )

    def get_topic_preferences(self) -> List[Dict[str, Any]]:
        with self.connect() as conn:
            rows = conn.execute(
                "SELECT * FROM topic_preferences ORDER BY category_code ASC"
            ).fetchall()
        out = []
        for r in rows:
            item = dict(r)
            item["boost_keywords"] = json.loads(item.pop("boost_keywords_json", "[]"))
            item["muted_keywords"] = json.loads(item.pop("muted_keywords_json", "[]"))
            item["is_muted"] = bool(item["is_muted"])
            out.append(item)
        return out

    def update_topic_preference(
        self,
        category_code: str,
        priority_level: Optional[str] = None,
        is_muted: Optional[bool] = None,
        boost_keywords: Optional[List[str]] = None,
        muted_keywords: Optional[List[str]] = None,
    ) -> Optional[Dict[str, Any]]:
        with self.connect() as conn:
            row = conn.execute(
                "SELECT * FROM topic_preferences WHERE category_code = ?", (category_code,)
            ).fetchone()
            if row is None:
                return None
            new_priority = priority_level if priority_level in PRIORITY_WEIGHTS else row["priority_level"]
            new_muted = int(is_muted) if is_muted is not None else row["is_muted"]
            new_boost = json.dumps(boost_keywords) if boost_keywords is not None else row["boost_keywords_json"]
            new_muted_kw = json.dumps(muted_keywords) if muted_keywords is not None else row["muted_keywords_json"]
            conn.execute(
                """
                UPDATE topic_preferences
                SET priority_level = ?, is_muted = ?, boost_keywords_json = ?, muted_keywords_json = ?, updated_at = ?
                WHERE category_code = ?
                """,
                (new_priority, new_muted, new_boost, new_muted_kw, utc_now_iso(), category_code),
            )
        for item in self.get_topic_preferences():
            if item["category_code"] == category_code:
                return item
        return None

    def adjust_topic_affinity(self, category_code: str, delta: float) -> None:
        with self.connect() as conn:
            row = conn.execute(
                "SELECT affinity_adjustment FROM topic_preferences WHERE category_code = ?",
                (category_code,),
            ).fetchone()
            if not row:
                return
            # Clamp adaptation between -0.35 and +0.45 so shifts stay gradual & reversible.
            new_val = max(-0.35, min(0.45, float(row["affinity_adjustment"]) + delta))
            conn.execute(
                "UPDATE topic_preferences SET affinity_adjustment = ?, updated_at = ? WHERE category_code = ?",
                (new_val, utc_now_iso(), category_code),
            )

    def record_collection_run(
        self,
        connector: str,
        status: str,
        items_fetched: int,
        items_upserted: int,
        started_at: str,
        error_message: Optional[str] = None,
    ) -> str:
        run_id = str(uuid.uuid4())
        with self.connect() as conn:
            conn.execute(
                """
                INSERT INTO collection_runs (
                    id, connector, started_at, finished_at, status,
                    items_fetched, items_upserted, error_message
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    run_id,
                    connector,
                    started_at,
                    utc_now_iso(),
                    status,
                    items_fetched,
                    items_upserted,
                    error_message,
                ),
            )
        return run_id

    def count_gemini_requests_today(self) -> int:
        with self.connect() as conn:
            row = conn.execute(
                "SELECT COUNT(*) AS cnt FROM gemini_usage WHERE usage_date = ? AND request_status = 'success'",
                (today_utc_date(),),
            ).fetchone()
        return int(row["cnt"]) if row else 0

    def log_gemini_usage(
        self,
        model_name: str,
        prompt_hash: str,
        request_status: str,
        estimated_tokens: int = 0,
    ) -> None:
        with self.connect() as conn:
            conn.execute(
                """
                INSERT INTO gemini_usage (id, usage_date, model_name, prompt_hash, request_status, estimated_tokens, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    str(uuid.uuid4()),
                    today_utc_date(),
                    model_name,
                    prompt_hash,
                    request_status,
                    estimated_tokens,
                    utc_now_iso(),
                ),
            )

    def enqueue_discovery_query(
        self,
        connector: str,
        query_text: str,
        category_code: str,
        origin: str = "adaptive",
        priority: float = 0.5,
        cooldown_hours: int = 12,
    ) -> None:
        clean_q = query_text.strip()
        if not clean_q or len(clean_q) > 120:
            return
        with self.connect() as conn:
            conn.execute(
                """
                INSERT OR IGNORE INTO discovery_queries (
                    id, connector, query_text, category_code, origin, priority,
                    cooldown_hours, is_active, created_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?)
                """,
                (
                    str(uuid.uuid4()),
                    connector,
                    clean_q,
                    category_code,
                    origin,
                    priority,
                    cooldown_hours,
                    utc_now_iso(),
                ),
            )

    def get_due_adaptive_queries(self, connector: str, limit: int = 3) -> List[Dict[str, Any]]:
        now_dt = datetime.now(timezone.utc)
        with self.connect() as conn:
            rows = conn.execute(
                """
                SELECT * FROM discovery_queries
                WHERE connector = ? AND is_active = 1
                ORDER BY priority DESC, created_at DESC
                """,
                (connector,),
            ).fetchall()
            due: List[Dict[str, Any]] = []
            for r in rows:
                last_run = r["last_run_at"]
                if last_run:
                    try:
                        prev = datetime.fromisoformat(last_run.replace("Z", "+00:00"))
                        if prev + timedelta(hours=int(r["cooldown_hours"])) > now_dt:
                            continue
                    except ValueError:
                        pass
                due.append(dict(r))
                if len(due) >= limit:
                    break
            for item in due:
                conn.execute(
                    "UPDATE discovery_queries SET last_run_at = ? WHERE id = ?",
                    (utc_now_iso(), item["id"]),
                )
        return due

    def upsert_tracked_creator(
        self,
        platform: str,
        channel_id: str,
        name: str,
        feed_url: Optional[str],
        primary_category: str,
        discovered_from: str = "seed",
        is_followed: bool = False,
    ) -> None:
        with self.connect() as conn:
            conn.execute(
                """
                INSERT INTO tracked_creators (
                    id, platform, channel_id, name, feed_url, primary_category,
                    discovered_from, is_followed, created_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT(channel_id) DO UPDATE SET
                    name = excluded.name,
                    feed_url = COALESCE(excluded.feed_url, tracked_creators.feed_url)
                """,
                (
                    str(uuid.uuid4()),
                    platform,
                    channel_id,
                    name,
                    feed_url,
                    primary_category,
                    discovered_from,
                    int(is_followed),
                    utc_now_iso(),
                ),
            )

    def get_tracked_creators(self, limit: int = 40) -> List[Dict[str, Any]]:
        with self.connect() as conn:
            rows = conn.execute(
                "SELECT * FROM tracked_creators ORDER BY is_followed DESC, created_at DESC LIMIT ?",
                (limit,),
            ).fetchall()
        return [dict(r) for r in rows]

    def get_observation_delta_with_conn(
        self, conn: sqlite3.Connection, discovery_id: str, metric: str
    ) -> Optional[float]:
        """Returns delta between oldest and newest real recorded observations ONLY when >=2 exist."""
        allowed = {
            "stars_count", "forks_count", "score_count",
            "comments_count", "downloads_count", "views_count", "likes_count",
        }
        if metric not in allowed:
            return None
        rows = conn.execute(
            f"""
            SELECT {metric} AS val FROM discovery_observations
            WHERE discovery_id = ? AND {metric} IS NOT NULL
            ORDER BY observed_at ASC, rowid ASC
            """,
            (discovery_id,),
        ).fetchall()
        if len(rows) < 2:
            return None
        first = float(rows[0]["val"])
        latest = float(rows[-1]["val"])
        return latest - first

    def get_observation_delta(self, discovery_id: str, metric: str) -> Optional[float]:
        with self.connect() as conn:
            return self.get_observation_delta_with_conn(conn, discovery_id, metric)

    def get_health_summary(self) -> Dict[str, Any]:
        with self.connect() as conn:
            disc_count = conn.execute("SELECT COUNT(*) AS c FROM discoveries").fetchone()["c"]
            bm_count = conn.execute("SELECT COUNT(*) AS c FROM user_bookmarks").fetchone()["c"]
            follow_count = conn.execute("SELECT COUNT(*) AS c FROM user_follows").fetchone()["c"]
            trend_count = conn.execute("SELECT COUNT(*) AS c FROM trend_candidates").fetchone()["c"]
            runs = conn.execute(
                "SELECT connector, status, items_fetched, items_upserted, finished_at, error_message "
                "FROM collection_runs ORDER BY started_at DESC LIMIT 20"
            ).fetchall()
        return {
            "total_discoveries": disc_count,
            "total_bookmarks": bm_count,
            "total_follows": follow_count,
            "total_trends": trend_count,
            "gemini_requests_today": self.count_gemini_requests_today(),
            "recent_runs": [dict(r) for r in runs],
        }
