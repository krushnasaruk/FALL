"""URL canonicalization, cross-source deduplication, observation history & entity extraction."""

from __future__ import annotations

import json
import re
import urllib.parse
import uuid
from typing import Dict, List, Optional, Tuple

from ..config import TOPIC_CATEGORIES
from ..connectors.base import RawDiscovery, compute_content_hash, extract_domain, normalize_timestamp
from ..db import RadarDatabase, utc_now_iso


TRACKING_QUERY_PARAMS = {
    "utm_source", "utm_medium", "utm_campaign", "utm_term", "utm_content",
    "ref", "ref_src", "fbclid", "gclid", "mc_cid", "mc_eid", "source",
}


def canonicalize_url(raw_url: str) -> str:
    url = raw_url.strip()
    if not url:
        return ""
    try:
        parsed = urllib.parse.urlparse(url)
    except Exception:
        return url

    scheme = (parsed.scheme or "https").lower()
    netloc = parsed.netloc.lower()
    if netloc.startswith("www."):
        netloc = netloc[4:]
    path = parsed.path.rstrip("/") or "/"

    # Normalize arXiv PDF / version suffixes to canonical abs URL
    if "arxiv.org" in netloc:
        m = re.search(r"/(?:abs|pdf)/([0-9]+\.[0-9]+)(?:v[0-9]+)?", path)
        if m:
            path = f"/abs/{m.group(1)}"
    # Normalize GitHub .git suffix
    if "github.com" in netloc and path.endswith(".git"):
        path = path[:-4]

    # Strip tracking query params while preserving meaningful ones (e.g. YouTube v=..., HN id=...)
    qs = urllib.parse.parse_qsl(parsed.query, keep_blank_values=False)
    filtered_qs = [(k, v) for k, v in qs if k.lower() not in TRACKING_QUERY_PARAMS]
    query_str = urllib.parse.urlencode(sorted(filtered_qs))
    return urllib.parse.urlunparse((scheme, netloc, path, "", query_str, ""))


def normalize_title(title: str) -> str:
    cleaned = re.sub(r"[^a-z0-9\s]", " ", title.lower())
    cleaned = re.sub(r"\s+", " ", cleaned).strip()
    return cleaned


def _infer_categories_from_text(title: str, summary: str, tags: List[str], defaults: List[str]) -> List[str]:
    corpus = f"{title} {summary} {' '.join(tags)}".lower()
    scored: List[Tuple[int, str]] = []
    for cat in TOPIC_CATEGORIES:
        hits = sum(1 for kw in cat.keywords if kw in corpus)
        if hits > 0:
            scored.append((hits, cat.code))
    scored.sort(key=lambda pair: (-pair[0], pair[1]))

    cats = list(defaults)
    for hits, code in scored:
        if hits >= 1 and code not in cats:
            cats.append(code)
    return cats[:4] if cats else ["B"]


def _title_tokens(norm_title: str) -> set[str]:
    return {w for w in norm_title.split() if len(w) >= 3 or w.isdigit()}


def _find_existing_discovery(
    conn,
    canonical_url: str,
    norm_title: str,
) -> Optional[str]:
    row = conn.execute(
        "SELECT id FROM discoveries WHERE canonical_url = ?", (canonical_url,)
    ).fetchone()
    if row:
        return row["id"]

    if not norm_title or len(norm_title) < 12:
        return None

    # Exact normalized title match
    row2 = conn.execute(
        "SELECT id FROM discoveries WHERE normalized_title = ? LIMIT 1", (norm_title,)
    ).fetchone()
    if row2:
        return row2["id"]

    # High Jaccard title similarity against recent discoveries to catch cross-posted mirrors
    tokens_new = _title_tokens(norm_title)
    if len(tokens_new) < 4:
        return None
    recent = conn.execute(
        "SELECT id, normalized_title FROM discoveries ORDER BY discovered_at DESC LIMIT 250"
    ).fetchall()
    for r in recent:
        tokens_old = _title_tokens(r["normalized_title"])
        if len(tokens_old) < 4:
            continue
        inter = len(tokens_new & tokens_old)
        union = len(tokens_new | tokens_old)
        if union > 0 and (inter / union) >= 0.88:
            return r["id"]
    return None


def _pick_metric_pair(raw: RawDiscovery) -> Tuple[Optional[str], Optional[float], Optional[str], Optional[float]]:
    if raw.primary_metric_label and raw.primary_metric_value is not None:
        return (
            raw.primary_metric_label,
            float(raw.primary_metric_value),
            raw.secondary_metric_label,
            float(raw.secondary_metric_value) if raw.secondary_metric_value is not None else None,
        )
    if raw.stars_count is not None:
        return ("Stars", float(raw.stars_count), "Forks" if raw.forks_count is not None else None, float(raw.forks_count) if raw.forks_count is not None else None)
    if raw.reported_score is not None:
        return ("Score", float(raw.reported_score), "Comments" if raw.reported_comments is not None else None, float(raw.reported_comments) if raw.reported_comments is not None else None)
    if raw.views_count is not None:
        return ("Views", float(raw.views_count), "Likes" if raw.likes_count is not None else None, float(raw.likes_count) if raw.likes_count is not None else None)
    if raw.downloads_count is not None:
        return ("Downloads", float(raw.downloads_count), "Likes" if raw.likes_count is not None else None, float(raw.likes_count) if raw.likes_count is not None else None)
    return (None, None, None, None)


def ingest_raw_discoveries(db: RadarDatabase, items: List[RawDiscovery]) -> int:
    """Deduplicates, stores canonical discoveries, links sources, and logs metric observations."""
    upserted = 0
    now = utc_now_iso()

    pref_map: Dict[str, str] = {}
    for pref in db.get_topic_preferences():
        pref_map[pref["category_code"]] = pref["priority_level"]

    for raw in items:
        c_url = canonicalize_url(raw.canonical_url)
        if not c_url or not raw.title.strip():
            continue

        norm_title = normalize_title(raw.title)
        cats = _infer_categories_from_text(
            raw.title, raw.raw_summary or "", raw.tags, raw.default_categories
        )
        primary_cat = cats[0]
        priority_tier = pref_map.get(primary_cat, "P1")
        published_iso = normalize_timestamp(raw.published_at) or now
        domain = extract_domain(c_url)
        content_hash = compute_content_hash(raw.title, raw.raw_summary or "", c_url)
        pm_label, pm_val, sm_label, sm_val = _pick_metric_pair(raw)

        with db.connect() as conn:
            existing_id = _find_existing_discovery(conn, c_url, norm_title)
            if existing_id is None:
                disc_id = str(uuid.uuid4())
                conn.execute(
                    """
                    INSERT INTO discoveries (
                        id, canonical_url, title, normalized_title, discovery_type,
                        primary_category, priority_tier, source_name, source_domain,
                        author_or_org, published_at, discovered_at, updated_at,
                        raw_summary, analysis_source, content_hash, confidence_level,
                        primary_metric_label, primary_metric_value,
                        secondary_metric_label, secondary_metric_value, extra_json
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?, 'source_reported', ?, ?, ?, ?, ?)
                    """,
                    (
                        disc_id,
                        c_url,
                        raw.title.strip(),
                        norm_title,
                        raw.discovery_type,
                        primary_cat,
                        priority_tier,
                        raw.source_name,
                        domain,
                        raw.author_or_org,
                        published_iso,
                        now,
                        now,
                        (raw.raw_summary or "")[:1500],
                        content_hash,
                        pm_label,
                        pm_val,
                        sm_label,
                        sm_val,
                        json.dumps(raw.extra or {}),
                    ),
                )
            else:
                disc_id = existing_id
                conn.execute(
                    """
                    UPDATE discoveries SET
                        updated_at = ?,
                        priority_tier = ?,
                        primary_metric_label = COALESCE(?, primary_metric_label),
                        primary_metric_value = COALESCE(?, primary_metric_value),
                        secondary_metric_label = COALESCE(?, secondary_metric_label),
                        secondary_metric_value = COALESCE(?, secondary_metric_value)
                    WHERE id = ?
                    """,
                    (now, priority_tier, pm_label, pm_val, sm_label, sm_val, disc_id),
                )

            # Link provenance source (idempotent across connectors)
            conn.execute(
                """
                INSERT INTO discovery_sources (
                    id, discovery_id, connector, source_name, source_url, external_id,
                    reported_score, reported_comments, fetched_at, metadata_json
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT(discovery_id, connector, source_url) DO UPDATE SET
                    reported_score = COALESCE(excluded.reported_score, discovery_sources.reported_score),
                    reported_comments = COALESCE(excluded.reported_comments, discovery_sources.reported_comments),
                    fetched_at = excluded.fetched_at
                """,
                (
                    str(uuid.uuid4()),
                    disc_id,
                    raw.connector,
                    raw.source_name,
                    raw.source_url,
                    raw.external_id,
                    raw.reported_score,
                    raw.reported_comments,
                    now,
                    json.dumps(raw.extra or {}),
                ),
            )

            # Record factual point-in-time observation whenever any numeric metric exists
            if any(
                v is not None
                for v in (
                    raw.stars_count,
                    raw.forks_count,
                    raw.reported_score,
                    raw.reported_comments,
                    raw.downloads_count,
                    raw.views_count,
                    raw.likes_count,
                )
            ):
                conn.execute(
                    """
                    INSERT INTO discovery_observations (
                        id, discovery_id, observed_at, stars_count, forks_count,
                        score_count, comments_count, downloads_count, views_count, likes_count
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    (
                        str(uuid.uuid4()),
                        disc_id,
                        now,
                        raw.stars_count,
                        raw.forks_count,
                        int(raw.reported_score) if raw.reported_score is not None else None,
                        int(raw.reported_comments) if raw.reported_comments is not None else None,
                        raw.downloads_count,
                        raw.views_count,
                        raw.likes_count,
                    ),
                )

            # Record honest observation delta ONLY if >= 2 recorded snapshots exist
            delta_val = db.get_observation_delta_with_conn(conn, disc_id, "stars_count")
            delta_label = "Star delta" if delta_val is not None else None
            if delta_val is None:
                delta_val = db.get_observation_delta_with_conn(conn, disc_id, "score_count")
                if delta_val is not None:
                    delta_label = "Score delta"
            if delta_label is not None and delta_val is not None and delta_val != 0:
                conn.execute(
                    "UPDATE discoveries SET metric_delta_label = ?, metric_delta_value = ? WHERE id = ?",
                    (delta_label, delta_val, disc_id),
                )

            for code in cats:
                conn.execute(
                    """
                    INSERT OR IGNORE INTO discovery_categories (discovery_id, category_code, confidence, source)
                    VALUES (?, ?, 0.85, 'heuristic')
                    """,
                    (disc_id, code),
                )

            for tag in raw.tags[:10]:
                clean_tag = re.sub(r"[^a-z0-9\-_+.]", "", tag.lower()).strip()
                if clean_tag:
                    conn.execute(
                        "INSERT OR IGNORE INTO discovery_tags (discovery_id, tag) VALUES (?, ?)",
                        (disc_id, clean_tag),
                    )

            # Entity tracking for author/org/creator/repo
            if raw.author_or_org:
                ent_ref = f"{raw.connector}:{raw.author_or_org.lower()}"
                conn.execute(
                    """
                    INSERT INTO tracked_entities (
                        id, name, entity_type, canonical_ref, primary_category,
                        first_seen_at, last_seen_at, mention_count
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, 1)
                    ON CONFLICT(canonical_ref) DO UPDATE SET
                        last_seen_at = excluded.last_seen_at,
                        mention_count = tracked_entities.mention_count + 1
                    """,
                    (
                        str(uuid.uuid4()),
                        raw.author_or_org,
                        "creator" if raw.discovery_type == "video" else "organization_or_author",
                        ent_ref,
                        primary_cat,
                        now,
                        now,
                    ),
                )
                conn.execute(
                    """
                    INSERT OR IGNORE INTO discovery_relationships (
                        id, from_discovery_id, relation_type, target_label, created_at
                    ) VALUES (?, ?, 'created_by', ?, ?)
                    """,
                    (str(uuid.uuid4()), disc_id, raw.author_or_org, now),
                )

        upserted += 1

    return upserted
