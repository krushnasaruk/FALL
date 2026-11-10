"""Hugging Face Hub connector for trending open models & interactive Spaces."""

from __future__ import annotations

from typing import List

from .base import RawDiscovery, safe_fetch_json


def fetch_huggingface_discoveries(
    model_limit: int = 12,
    space_limit: int = 6,
    timeout: int = 15,
) -> List[RawDiscovery]:
    results: List[RawDiscovery] = []

    try:
        models = safe_fetch_json(
            f"https://huggingface.co/api/models?sort=trendingScore&direction=-1&limit={model_limit}",
            timeout=timeout,
        )
    except Exception:
        models = []

    for m in models or []:
        model_id = m.get("id")
        if not model_id:
            continue
        url = f"https://huggingface.co/{model_id}"
        likes = m.get("likes")
        downloads = m.get("downloads")
        pipeline = m.get("pipeline_tag")
        tags = [str(t).lower() for t in (m.get("tags") or [])[:8] if t]
        if pipeline:
            tags.insert(0, str(pipeline).lower())

        summary_parts = []
        if pipeline:
            summary_parts.append(f"Task: {pipeline}.")
        if m.get("library_name"):
            summary_parts.append(f"Library: {m['library_name']}.")
        raw_summary = " ".join(summary_parts) or "Trending open-weight AI model on Hugging Face Hub."

        results.append(
            RawDiscovery(
                canonical_url=url,
                title=model_id,
                discovery_type="model",
                connector="huggingface",
                source_name="Hugging Face Models",
                source_url=url,
                default_categories=["A", "B"],
                external_id=str(model_id),
                author_or_org=model_id.split("/")[0] if "/" in model_id else None,
                published_at=m.get("createdAt") or m.get("lastModified"),
                raw_summary=raw_summary,
                tags=list(dict.fromkeys(["huggingface", "open-model", *tags])),
                likes_count=int(likes) if likes is not None else None,
                downloads_count=int(downloads) if downloads is not None else None,
                primary_metric_label="Likes" if likes is not None else None,
                primary_metric_value=float(likes) if likes is not None else None,
                secondary_metric_label="Downloads" if downloads is not None else None,
                secondary_metric_value=float(downloads) if downloads is not None else None,
                extra={"pipeline_tag": pipeline, "library_name": m.get("library_name")},
            )
        )

    try:
        spaces = safe_fetch_json(
            f"https://huggingface.co/api/spaces?sort=trendingScore&direction=-1&limit={space_limit}",
            timeout=timeout,
        )
    except Exception:
        spaces = []

    for sp in spaces or []:
        space_id = sp.get("id")
        if not space_id:
            continue
        url = f"https://huggingface.co/spaces/{space_id}"
        likes = sp.get("likes")
        results.append(
            RawDiscovery(
                canonical_url=url,
                title=f"HF Space: {space_id}",
                discovery_type="model",
                connector="huggingface",
                source_name="Hugging Face Spaces",
                source_url=url,
                default_categories=["A", "L"],
                external_id=f"space:{space_id}",
                author_or_org=space_id.split("/")[0] if "/" in space_id else None,
                published_at=sp.get("createdAt") or sp.get("lastModified"),
                raw_summary=f"Interactive AI application or demo hosted on Hugging Face Spaces ({space_id}).",
                tags=["huggingface-space", "demo", "ai"],
                likes_count=int(likes) if likes is not None else None,
                primary_metric_label="Likes" if likes is not None else None,
                primary_metric_value=float(likes) if likes is not None else None,
                extra={"sdk": sp.get("sdk")},
            )
        )

    return results

