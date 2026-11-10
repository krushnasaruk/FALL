"""arXiv Atom API connector across CS/AI/SE/Robotics/Vision/Signal preprints."""

from __future__ import annotations

import urllib.parse
import xml.etree.ElementTree as ET
from typing import List, Optional

from ..config import ARXIV_CATEGORIES
from .base import RawDiscovery, clean_html_text, safe_fetch_text


ARXIV_NS = {
    "atom": "http://www.w3.org/2005/Atom",
    "arxiv": "http://arxiv.org/schemas/atom",
}

CAT_TO_RADAR = {
    "cs.AI": ["A", "H"],
    "cs.LG": ["A", "H"],
    "cs.SE": ["C", "H"],
    "cs.RO": ["I", "H"],
    "cs.CV": ["A", "H"],
    "eess.SP": ["I", "Q", "H"],
}


def fetch_arxiv_discoveries(
    categories: Optional[List[str]] = None,
    max_results: int = 18,
    timeout: int = 18,
) -> List[RawDiscovery]:
    cats = categories or ARXIV_CATEGORIES
    query = " OR ".join(f"cat:{c}" for c in cats)
    url = (
        "https://export.arxiv.org/api/query"
        f"?search_query={urllib.parse.quote(query)}"
        f"&sortBy=submittedDate&sortOrder=descending&max_results={max_results}"
    )
    try:
        xml_text = safe_fetch_text(url, timeout=timeout)
        root = ET.fromstring(xml_text)
    except Exception:
        return []

    results: List[RawDiscovery] = []
    for entry in root.findall("atom:entry", ARXIV_NS):
        id_el = entry.find("atom:id", ARXIV_NS)
        title_el = entry.find("atom:title", ARXIV_NS)
        summary_el = entry.find("atom:summary", ARXIV_NS)
        pub_el = entry.find("atom:published", ARXIV_NS)
        prim_el = entry.find("arxiv:primary_category", ARXIV_NS)

        abs_url = id_el.text.strip() if id_el is not None and id_el.text else ""
        title = clean_html_text(title_el.text if title_el is not None else "", max_len=240)
        if not abs_url or not title:
            continue

        authors = []
        for auth in entry.findall("atom:author/atom:name", ARXIV_NS):
            if auth.text:
                authors.append(auth.text.strip())
        primary_arxiv = prim_el.attrib.get("term", "cs.AI") if prim_el is not None else "cs.AI"
        mapped_cats = CAT_TO_RADAR.get(primary_arxiv, ["H", "A"])

        abstract = clean_html_text(summary_el.text if summary_el is not None else "", max_len=1400)
        author_label = ", ".join(authors[:3]) + (" et al." if len(authors) > 3 else "")

        results.append(
            RawDiscovery(
                canonical_url=abs_url,
                title=title,
                discovery_type="research",
                connector="arxiv",
                source_name=f"arXiv · {primary_arxiv}",
                source_url=abs_url,
                default_categories=mapped_cats,
                external_id=abs_url.rsplit("/", 1)[-1],
                author_or_org=author_label or "arXiv Authors",
                published_at=pub_el.text.strip() if pub_el is not None and pub_el.text else None,
                raw_summary=abstract,
                tags=["arxiv", primary_arxiv.lower(), "research-paper"],
                extra={"arxiv_category": primary_arxiv, "authors": authors[:6]},
            )
        )
    return results

