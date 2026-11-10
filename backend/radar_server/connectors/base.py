"""Shared connector abstractions, HTTP client with retry/backoff, and strict no-fabrication dataclass."""

from __future__ import annotations

import hashlib
import json
import re
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass, field
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
from typing import Any, Dict, List, Optional


USER_AGENT = "ProgressOS-Radar/1.0 (+personal-tech-intelligence)"


@dataclass
class RawDiscovery:
    canonical_url: str
    title: str
    discovery_type: str  # repo, video, research, article, product, community, release, model, space, event
    connector: str
    source_name: str
    source_url: str
    default_categories: List[str]
    external_id: Optional[str] = None
    author_or_org: Optional[str] = None
    published_at: Optional[str] = None
    raw_summary: Optional[str] = None
    tags: List[str] = field(default_factory=list)
    reported_score: Optional[float] = None
    reported_comments: Optional[float] = None
    stars_count: Optional[int] = None
    forks_count: Optional[int] = None
    downloads_count: Optional[int] = None
    views_count: Optional[int] = None
    likes_count: Optional[int] = None
    primary_metric_label: Optional[str] = None
    primary_metric_value: Optional[float] = None
    secondary_metric_label: Optional[str] = None
    secondary_metric_value: Optional[float] = None
    extra: Dict[str, Any] = field(default_factory=dict)


def clean_html_text(raw: Optional[str], max_len: int = 1200) -> str:
    if not raw:
        return ""
    text = re.sub(r"<script[^>]*>.*?</script>", " ", raw, flags=re.IGNORECASE | re.DOTALL)
    text = re.sub(r"<style[^>]*>.*?</style>", " ", text, flags=re.IGNORECASE | re.DOTALL)
    text = re.sub(r"<[^>]+>", " ", text)
    text = (
        text.replace("&amp;", "&")
        .replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&quot;", '"')
        .replace("&#39;", "'")
        .replace("&nbsp;", " ")
    )
    text = re.sub(r"\s+", " ", text).strip()
    return text[:max_len]


def normalize_timestamp(value: Optional[str]) -> Optional[str]:
    if not value:
        return None
    val = value.strip()
    if not val:
        return None
    try:
        dt = datetime.fromisoformat(val.replace("Z", "+00:00"))
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt.astimezone(timezone.utc).replace(microsecond=0).isoformat()
    except ValueError:
        pass
    try:
        dt = parsedate_to_datetime(val)
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt.astimezone(timezone.utc).replace(microsecond=0).isoformat()
    except Exception:
        return None


def compute_content_hash(title: str, summary: str, url: str) -> str:
    payload = f"{title.strip()}|{summary.strip()[:500]}|{url.strip()}".encode("utf-8", errors="ignore")
    return hashlib.sha256(payload).hexdigest()


def safe_fetch_text(
    url: str,
    headers: Optional[Dict[str, str]] = None,
    timeout: int = 15,
    retries: int = 2,
) -> str:
    req_headers = {"User-Agent": USER_AGENT, "Accept": "application/json, application/xml, text/xml, */*"}
    if headers:
        req_headers.update(headers)
    last_err: Optional[Exception] = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(url, headers=req_headers, method="GET")
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                raw = resp.read()
                charset = resp.headers.get_content_charset() or "utf-8"
                return raw.decode(charset, errors="replace")
        except urllib.error.HTTPError as exc:
            last_err = exc
            if exc.code in (429, 500, 502, 503, 504) and attempt < retries:
                time.sleep(0.8 * (attempt + 1))
                continue
            raise
        except Exception as exc:
            last_err = exc
            if attempt < retries:
                time.sleep(0.6 * (attempt + 1))
                continue
            raise
    assert last_err is not None
    raise last_err


def safe_fetch_json(
    url: str,
    headers: Optional[Dict[str, str]] = None,
    timeout: int = 15,
    retries: int = 2,
) -> Any:
    text = safe_fetch_text(url, headers=headers, timeout=timeout, retries=retries)
    return json.loads(text)


def extract_domain(url: str) -> str:
    try:
        host = urllib.parse.urlparse(url).netloc.lower()
        return host.removeprefix("www.")
    except Exception:
        return ""

