"""Central configuration, 18-category taxonomy (A-R), source definitions, and env loading."""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional


BASE_DIR = Path(__file__).resolve().parent
DEFAULT_DATA_DIR = BASE_DIR / "data"
DEFAULT_DB_PATH = DEFAULT_DATA_DIR / "radar.sqlite3"


def load_dotenv(env_path: Optional[Path] = None) -> None:
    """Loads key=value pairs from .env into os.environ if not already set."""
    target = env_path or (BASE_DIR / ".env")
    if not target.exists():
        return
    for raw_line in target.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


@dataclass(frozen=True)
class TopicCategoryDef:
    code: str
    slug: str
    name: str
    default_priority: str  # P0, P1, P2, P3
    description: str
    keywords: List[str] = field(default_factory=list)
    poll_interval_hours: int = 12


# Complete 18-category taxonomy A-R per ProgressOS Radar specification.
TOPIC_CATEGORIES: List[TopicCategoryDef] = [
    # P0 — Core Discovery Areas
    TopicCategoryDef(
        code="A",
        slug="ai_ml",
        name="Artificial Intelligence & ML",
        default_priority="P0",
        description="Foundation models, open LLMs, AI agents, RAG, quantization, local inference & tools.",
        keywords=[
            "llm", "ai agent", "rag", "mcp", "model", "gemini", "claude", "openai", "deepseek",
            "llama", "qwen", "mistral", "vllm", "ollama", "gguf", "transformer", "diffusion",
            "embedding", "fine-tuning", "evals", "reasoning", "multimodal", "neural", "inference",
        ],
        poll_interval_hours=2,
    ),
    TopicCategoryDef(
        code="B",
        slug="open_source_github",
        name="Open Source & GitHub Ecosystem",
        default_priority="P0",
        description="Trending repositories, developer utilities, CLI tools, SDKs & open-source infrastructure.",
        keywords=[
            "github", "open source", "oss", "repository", "cli", "sdk", "library", "package",
            "release", "self-hosted", "mit license", "apache-2.0", "crate", "npm", "pypi",
        ],
        poll_interval_hours=2,
    ),
    TopicCategoryDef(
        code="C",
        slug="programming_swe",
        name="Programming Languages & Software Eng",
        default_priority="P0",
        description="Rust, TypeScript, Python, Go, Dart, Zig, compilers, architecture & devtools.",
        keywords=[
            "rust", "typescript", "python", "golang", "dart", "zig", "compiler", "wasm",
            "webassembly", "lsp", "ide", "testing", "benchmark", "architecture", "refactoring",
            "c++", "swift", "kotlin", "runtime",
        ],
        poll_interval_hours=4,
    ),
    TopicCategoryDef(
        code="D",
        slug="startups_indie",
        name="Startups, Products & Indie Craft",
        default_priority="P0",
        description="Developer-first startups, SaaS launches, Indie Hackers, Show HN & micro-products.",
        keywords=[
            "launch", "show hn", "startup", "saas", "indie", "product hunt", "founder",
            "Developer tool", "devtools", "bootstrapped", "open-core", "pricing",
        ],
        poll_interval_hours=4,
    ),
    TopicCategoryDef(
        code="E",
        slug="dev_creators",
        name="Developer Creators & Video",
        default_priority="P0",
        description="Technical YouTube creators, walkthroughs, AI engineering breakdowns & system builds.",
        keywords=[
            "youtube", "walkthrough", "tutorial", "deep dive", "coding video", "tech creator",
            "fireship", "theo", "primeagen", "karpathy", "podcast", "demo",
        ],
        poll_interval_hours=6,
    ),
    TopicCategoryDef(
        code="F",
        slug="dev_communities",
        name="Developer Community Highlights",
        default_priority="P0",
        description="Hacker News, Reddit programming/ML, DEV Community, Lobsters & high-signal discussions.",
        keywords=[
            "hacker news", "lobsters", "dev.to", "ask hn", "postmortem", "discussion",
            "reddit", "community", "engineering debate",
        ],
        poll_interval_hours=2,
    ),
    # P1 — High Priority Related Areas
    TopicCategoryDef(
        code="G",
        slug="major_companies",
        name="Major Companies & Platforms",
        default_priority="P1",
        description="Official announcements from Google, Anthropic, OpenAI, Microsoft, Meta, Apple & OSS foundations.",
        keywords=[
            "google", "deepmind", "anthropic", "openai", "microsoft", "meta", "apple",
            "nvidia", "aws", "cloudflare", "vercel", "supabase", "linux foundation",
        ],
        poll_interval_hours=6,
    ),
    TopicCategoryDef(
        code="H",
        slug="research_papers",
        name="Scientific & Technical Research",
        default_priority="P1",
        description="arXiv preprints in AI/ML, systems, vision, robotics & practical engineering translations.",
        keywords=[
            "arxiv", "paper", "preprint", "abstract", "benchmark", "state of the art",
            "ablation", "theorem", "survey", "cs.ai", "cs.lg", "cs.se", "cs.ro", "cs.cv",
        ],
        poll_interval_hours=8,
    ),
    TopicCategoryDef(
        code="I",
        slug="robotics_hardware_iot",
        name="Robotics, Hardware & Embedded",
        default_priority="P1",
        description="Embodied AI, ROS, edge chips, Raspberry Pi, ESP32, drones & custom silicon.",
        keywords=[
            "robotics", "ros2", "embodied", "humanoid", "esp32", "raspberry pi", "fpga",
            "asic", "microcontroller", "firmware", "embedded", "edge ai", "jetson", "drone",
            "hardware", "actuator", "sensor",
        ],
        poll_interval_hours=12,
    ),
    TopicCategoryDef(
        code="J",
        slug="cloud_devops",
        name="Cloud, DevOps & Infrastructure",
        default_priority="P1",
        description="Kubernetes, Docker, Terraform, observability, edge compute & serverless tooling.",
        keywords=[
            "kubernetes", "docker", "container", "terraform", "opentofu", "ci/cd",
            "observability", "opentelemetry", "prometheus", "ebpf", "linux", "systemd",
            "serverless", "cdn", "deployment",
        ],
        poll_interval_hours=8,
    ),
    TopicCategoryDef(
        code="K",
        slug="databases_data",
        name="Databases & Data Engineering",
        default_priority="P1",
        description="Postgres, SQLite, DuckDB, vector DBs, lakehouse, streaming & storage internals.",
        keywords=[
            "postgres", "postgresql", "sqlite", "duckdb", "vector", "pgvector", "qdrant",
            "clickhouse", "kafka", "iceberg", "parquet", "database", "storage engine",
            "query optimizer", "distributed", "crdt",
        ],
        poll_interval_hours=8,
    ),
    TopicCategoryDef(
        code="L",
        slug="design_ui_ux",
        name="Web Design, UI/UX & Craft",
        default_priority="P1",
        description="Design systems, motion choreography, typography, accessibility, Figma & interactive web craft.",
        keywords=[
            "ui", "ux", "design system", "typography", "accessibility", "a11y", "animation",
            "css", "tailwind", "figma", "micro-interaction", "component library", "motion",
        ],
        poll_interval_hours=12,
    ),
    TopicCategoryDef(
        code="M",
        slug="mobile_apps",
        name="App Dev & Mobile Ecosystem",
        default_priority="P1",
        description="Flutter, Android, iOS, Kotlin Multiplatform, on-device AI & mobile performance.",
        keywords=[
            "flutter", "dart", "android", "ios", "swiftui", "jetpack compose", "kotlin",
            "mobile", "react native", "expo", "widget", "apk", "play store",
        ],
        poll_interval_hours=6,
    ),
    # P2 — Complementary Priorities
    TopicCategoryDef(
        code="N",
        slug="cybersecurity_privacy",
        name="Cybersecurity & Privacy",
        default_priority="P2",
        description="Vulnerabilities, zero-trust tooling, encryption, supply-chain security & privacy.",
        keywords=[
            "security", "cve", "vulnerability", "zero-day", "encryption", "passkey",
            "oauth", "supply chain", "malware", "sandbox", "privacy", "penetration", "sbom",
        ],
        poll_interval_hours=12,
    ),
    TopicCategoryDef(
        code="O",
        slug="india_tech",
        name="Tech Ecosystem in India",
        default_priority="P2",
        description="Indian startups, Bengaluru/IIT/IIIT labs, DPI (ONDC/UPI/Bhashini) & local OSS.",
        keywords=[
            "india", "bengaluru", "bangalore", "iit", "upi", "ondc", "bhashini", "sarvam",
            "krutrim", "indian startup", "isro", "razorpay", "zerodha", "postman",
        ],
        poll_interval_hours=18,
    ),
    TopicCategoryDef(
        code="P",
        slug="careers_opportunities",
        name="Developer Careers & Opportunities",
        default_priority="P2",
        description="Hackathons, open-source grants, GSOC/LFX, Fellowships, bounties & portfolio ideas.",
        keywords=[
            "hackathon", "gsoc", "grant", "bounty", "fellowship", "internship",
            "hiring", "open source program", "competition", "challenge", "build idea",
        ],
        poll_interval_hours=18,
    ),
    # P3 — Exploratory Priority
    TopicCategoryDef(
        code="Q",
        slug="emerging_future",
        name="Emerging & Future Technologies",
        default_priority="P3",
        description="Quantum computing, BCI, photonics, biotech/computational science & spatial computing.",
        keywords=[
            "quantum", "bci", "brain-computer", "photonic", "spatial computing", "ar glasses",
            "xr", "neuromorphic", "biotech", "alphafold", "fusion", "nanotech",
        ],
        poll_interval_hours=24,
    ),
    TopicCategoryDef(
        code="R",
        slug="events_launches",
        name="Technology Events & Launches",
        default_priority="P3",
        description="Major keynotes, Google I/O, WWDC, NeurIPS, KubeCon, FOSSASIA & launch recaps.",
        keywords=[
            "keynote", "conference", "neurips", "iclr", "kubecon", "google i/o", "wwdc",
            "fossasia", "defcon", "summit", "hackathon recap", "release week",
        ],
        poll_interval_hours=24,
    ),
]

CATEGORY_MAP: Dict[str, TopicCategoryDef] = {c.code: c for c in TOPIC_CATEGORIES}

PRIORITY_WEIGHTS: Dict[str, float] = {
    "P0": 1.0,
    "P1": 0.72,
    "P2": 0.48,
    "P3": 0.30,
}


@dataclass(frozen=True)
class RssFeedSource:
    id: str
    title: str
    url: str
    default_categories: List[str]
    priority: str = "P1"
    source_kind: str = "rss"


RSS_FEEDS: List[RssFeedSource] = [
    RssFeedSource("github_blog", "The GitHub Blog", "https://github.blog/feed/", ["B", "C", "G"]),
    RssFeedSource("cloudflare_blog", "Cloudflare Blog", "https://blog.cloudflare.com/rss/", ["J", "N", "G"]),
    RssFeedSource("simon_willison", "Simon Willison's Weblog", "https://simonwillison.net/atom/everything/", ["A", "B", "K"]),
    RssFeedSource("huggingface_blog", "Hugging Face Blog", "https://huggingface.co/blog/feed.xml", ["A", "B", "H"]),
    RssFeedSource("google_research", "Google Research Blog", "https://research.google/blog/rss/", ["A", "H", "G"]),
    RssFeedSource("flutter_medium", "Flutter Engineering", "https://medium.com/feed/flutter", ["M", "C", "L"]),
    RssFeedSource("product_hunt", "Product Hunt", "https://www.producthunt.com/feed", ["D", "L"]),
    RssFeedSource("mit_tech_review", "MIT Technology Review", "https://www.technologyreview.com/feed/", ["A", "Q", "I"]),
    RssFeedSource("reddit_localllama", "r/LocalLLaMA", "https://www.reddit.com/r/LocalLLaMA/.rss", ["A", "F", "B"], priority="P0"),
    RssFeedSource("reddit_ml", "r/MachineLearning", "https://www.reddit.com/r/MachineLearning/.rss", ["A", "H", "F"], priority="P0"),
    RssFeedSource("reddit_programming", "r/programming", "https://www.reddit.com/r/programming/.rss", ["C", "F"], priority="P0"),
    RssFeedSource("reddit_flutter", "r/FlutterDev", "https://www.reddit.com/r/FlutterDev/.rss", ["M", "F"], priority="P1"),
    RssFeedSource("reddit_robotics", "r/robotics", "https://www.reddit.com/r/robotics/.rss", ["I", "F"], priority="P1"),
    RssFeedSource("reddit_devtools", "r/IndiaTech", "https://www.reddit.com/r/developersIndia/.rss", ["O", "P", "F"], priority="P2"),
    RssFeedSource("krebs_security", "Krebs on Security", "https://krebsonsecurity.com/feed/", ["N"], priority="P2"),
    RssFeedSource("smashing_mag", "Smashing Magazine", "https://www.smashingmagazine.com/feed/", ["L", "C"], priority="P1"),
    RssFeedSource("cncf_blog", "CNCF Blog", "https://www.cncf.io/blog/feed/", ["J", "B"], priority="P1"),
]

# Tracked seed YouTube channels (zero-quota Atom RSS!) — expanded dynamically via discovery.
SEED_YOUTUBE_CHANNELS: List[Dict[str, str]] = [
    {"channel_id": "UCbfYPyITQ-7l4upoX8nvctg", "name": "Two Minute Papers", "category": "H"},
    {"channel_id": "UCsBjURrPoezykLs9EqgamOA", "name": "Fireship", "category": "C"},
    {"channel_id": "UCXUPKJO5MZQN11PqgIvyuvQ", "name": "Andrej Karpathy", "category": "A"},
    {"channel_id": "UCZHmQk67mSJgfCCTn7xBfew", "name": "Yannic Kilcher", "category": "A"},
    {"channel_id": "UCvjgXvBlbQiydffZU7m1_aw", "name": "The Coding Train", "category": "L"},
    {"channel_id": "UCVHFbqXqoYvEWM1Ddxl0QDg", "name": "Android Developers", "category": "M"},
]

YOUTUBE_SEARCH_QUERIES: List[Dict[str, str]] = [
    {"q": "open source AI agent framework walkthrough", "category": "A"},
    {"q": "Rust developer tools systems programming", "category": "C"},
    {"q": "Flutter mobile app architecture 2026", "category": "M"},
    {"q": "robotics embedded edge AI project", "category": "I"},
    {"q": "hackathon open source startup build", "category": "D"},
]

GITHUB_SEED_QUERIES: List[Dict[str, str]] = [
    {"q": "topic:ai-agents stars:>40", "category": "A"},
    {"q": "topic:mcp stars:>25", "category": "A"},
    {"q": "topic:flutter stars:>25", "category": "M"},
    {"q": "topic:rust cli stars:>50", "category": "C"},
    {"q": "topic:robotics OR topic:ros2 stars:>20", "category": "I"},
    {"q": "topic:database OR topic:sqlite stars:>30", "category": "K"},
    {"q": "topic:security OR topic:cybersecurity stars:>30", "category": "N"},
    {"q": "topic:india OR topic:upi OR topic:bhashini stars:>10", "category": "O"},
]

ARXIV_CATEGORIES: List[str] = ["cs.AI", "cs.LG", "cs.SE", "cs.RO", "cs.CV", "eess.SP"]


@dataclass
class RadarConfig:
    db_path: Path
    gemini_api_key: str
    github_token: str
    youtube_api_key: str
    gemini_model: str = "gemini-3-flash-preview"
    gemini_daily_budget: int = 120
    host: str = "0.0.0.0"
    port: int = 8787
    auto_collect: bool = False
    aligned_ratio: float = 0.70
    explore_ratio: float = 0.30
    request_timeout_sec: int = 15

    @classmethod
    def from_env(cls, db_path: Optional[Path] = None, env_path: Optional[Path] = None) -> "RadarConfig":
        load_dotenv(env_path)
        DEFAULT_DATA_DIR.mkdir(parents=True, exist_ok=True)
        env_db = os.environ.get("RADAR_DB_PATH", "").strip()
        resolved_db = db_path or (Path(env_db) if env_db else DEFAULT_DB_PATH)
        resolved_port = int(
            os.environ.get("RADAR_PORT", "").strip()
            or os.environ.get("PORT", "").strip()
            or "8787"
        )
        return cls(
            db_path=resolved_db,
            gemini_api_key=os.environ.get("GEMINI_API_KEY", "").strip(),
            github_token=os.environ.get("GITHUB_TOKEN", "").strip(),
            youtube_api_key=os.environ.get("YOUTUBE_API_KEY", "").strip(),
            gemini_model=os.environ.get("GEMINI_MODEL", "gemini-3-flash-preview").strip() or "gemini-3-flash-preview",
            gemini_daily_budget=int(os.environ.get("GEMINI_DAILY_BUDGET", "120")),
            host=os.environ.get("RADAR_HOST", "0.0.0.0").strip() or "0.0.0.0",
            port=resolved_port,
            auto_collect=os.environ.get("RADAR_AUTO_COLLECT", "false").lower() == "true",
        )
