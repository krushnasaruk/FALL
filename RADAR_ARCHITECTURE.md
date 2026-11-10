# ProgressOS Radar — Personal Technology Intelligence & Discovery Architecture

## 1. Core Objective & System Separation
ProgressOS Radar continuously discovers, normalizes, analyzes, ranks, explains, tracks trends, and curates Daily Briefings across **all 18 technology categories (A–R)** prioritized by user-configurable levels (**P0**, **P1**, **P2**, **P3**).

### Security & Secret Boundary
- **Desktop/Self-Hosted Collector Server (`backend/radar_server/`):** Reads `GEMINI_API_KEY`, `GITHUB_TOKEN`, and `YOUTUBE_API_KEY` exclusively from gitignored `backend/radar_server/.env` (`.env.example` provides placeholders).
- **Flutter Android App (`lib/features/radar/`):** Contains **zero API secrets**. Connects over local/LAN HTTP (`http://10.0.2.2:8787` default for Android emulator host loopback; restricted cleartext allowed solely for `10.0.2.2`, `127.0.0.1`, and `localhost` via `res/xml/network_security_config.xml`) plus optional key-free public API fallback when away from the host collector.

## 2. Backend Collector, Normalizer & Intelligence Pipeline (`backend/radar_server/`)
- **Independent Connectors (`connectors/`):**
  - `github_connector.py` — GitHub Search REST API (emerging repos & topics) logging point-in-time `discovery_observations`.
  - `hackernews_connector.py` — Hacker News Firebase API (`topstories`, `showstories`, `beststories`).
  - `huggingface_connector.py` — Hugging Face Hub trending models & Spaces (`/api/models`, `/api/spaces`).
  - `arxiv_connector.py` — arXiv Atom API (`cs.AI`, `cs.LG`, `cs.SE`, `cs.RO`, `cs.CV`, `eess.SP`).
  - `rss_connector.py` — Engineering blogs, Reddit technical subreddits (`.rss`), Product Hunt, CNCF, Krebs, Smashing, India ecosystem feeds.
  - `community_connector.py` — DEV Community REST API & Lobsters (`hottest.json`).
  - `youtube_connector.py` — Quota-free tracked channel Atom RSS + bounded YouTube Data API v3 search/stats discovery storing new creators into `tracked_creators`.
- **Pipeline (`pipeline/`):**
  - `normalizer.py` — Tracking-param URL stripping, arXiv PDF/abs/version normalization, title token matching, multi-source provenance linking (`discovery_sources`), and factual observation deltas computed strictly when `>= 2` snapshots exist.
  - `gemini_layer.py` — Uses Gemini (`gemini-3-flash-preview` default with automatic model fallback, `x-goog-api-key` auth, strict JSON schema validation, prompt-injection delimiters, SHA-256 content-hash deduplication cache, daily budget cap in `gemini_usage`, consecutive-error circuit breaker, and **Deterministic Fallback Engine**).
  - `ranking.py` — 9-signal scorer respecting muted categories/keywords and configurable **70% interest-aligned / 30% exploratory** slot interleaving.
  - `adaptive_discovery.py` — Bounded follow-up query queue (`discovery_queries`, capped at 24 active adaptive queries with cooldowns).
  - `trends.py` — Multi-source trend detector (`emerging`, `growing`, `established`, `cooling`, or `insufficient_evidence` when single-source and zero positive deltas) backed by `trend_evidence`.
  - `briefings.py` — Non-duplicative 10-section Daily Briefing & Weekly Recap curator + conservative `notification_events`.

## 3. Offline-First Flutter Persistence (`lib/data/database/`)
- Drift `schemaVersion: 3` adds 5 local tables (`RadarDiscoveries`, `RadarTopicPrefs`, `RadarFollows`, `RadarFeedbackLogs`, `RadarBriefings`), wiped cleanly alongside core workspace tables inside `AppDatabase.clearAllData()`.
- Detail views clearly label provenance (*AI Explanation · Grounded in Source* vs *Deterministic Summary* vs *Source-Reported Excerpt*) and offer direct browser launch (`MainActivity.kt` `openUrl`), bookmark collections/notes, and one-tap conversion into FALL Tasks or Learning Skills.

