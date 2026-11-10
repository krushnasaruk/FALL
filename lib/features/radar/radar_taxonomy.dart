import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Complete 18-category Technology Taxonomy (A-R) across configurable priority levels P0-P3.
class RadarCategoryDef {
  final String code;
  final String slug;
  final String name;
  final String shortLabel;
  final String defaultPriority; // P0, P1, P2, P3
  final String description;
  final List<String> defaultKeywords;
  final IconData icon;
  final Color accentColor;

  const RadarCategoryDef({
    required this.code,
    required this.slug,
    required this.name,
    required this.shortLabel,
    required this.defaultPriority,
    required this.description,
    required this.defaultKeywords,
    required this.icon,
    required this.accentColor,
  });
}

class RadarTaxonomy {
  RadarTaxonomy._();

  static const List<RadarCategoryDef> categories = [
    // P0 — Core Interests
    RadarCategoryDef(
      code: 'A',
      slug: 'ai_ml',
      name: 'Artificial Intelligence & ML',
      shortLabel: 'AI & ML',
      defaultPriority: 'P0',
      description: 'New LLMs, agents, RAG, local inference & multimodal tools.',
      defaultKeywords: ['llm', 'ai agent', 'rag', 'mcp', 'gemini', 'claude', 'vllm'],
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.primary,
    ),
    RadarCategoryDef(
      code: 'B',
      slug: 'open_source_github',
      name: 'Open Source & GitHub',
      shortLabel: 'Open Source',
      defaultPriority: 'P0',
      description: 'Emerging repositories, developer utilities, CLI tools & SDKs.',
      defaultKeywords: ['github', 'open source', 'cli', 'sdk', 'self-hosted'],
      icon: Icons.code_rounded,
      accentColor: Color(0xFF0EA5E9),
    ),
    RadarCategoryDef(
      code: 'C',
      slug: 'programming_swe',
      name: 'Programming & Software Eng',
      shortLabel: 'Languages & SWE',
      defaultPriority: 'P0',
      description: 'Rust, TypeScript, Python, Go, Dart, Zig, compilers & devtools.',
      defaultKeywords: ['rust', 'typescript', 'python', 'golang', 'dart', 'zig'],
      icon: Icons.terminal_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    RadarCategoryDef(
      code: 'D',
      slug: 'startups_indie',
      name: 'Startups & Indie Products',
      shortLabel: 'Startups',
      defaultPriority: 'P0',
      description: 'Developer startups, SaaS tools, Show HN & Product Hunt launches.',
      defaultKeywords: ['launch', 'show hn', 'startup', 'saas', 'indie', 'devtools'],
      icon: Icons.rocket_launch_rounded,
      accentColor: Color(0xFFF97316),
    ),
    RadarCategoryDef(
      code: 'E',
      slug: 'dev_creators',
      name: 'Creators & Tech Video',
      shortLabel: 'Creators',
      defaultPriority: 'P0',
      description: 'Technical YouTube walkthroughs, demos, podcasts & breakdowns.',
      defaultKeywords: ['youtube', 'walkthrough', 'deep dive', 'tutorial'],
      icon: Icons.play_circle_outline_rounded,
      accentColor: Color(0xFFEF4444),
    ),
    RadarCategoryDef(
      code: 'F',
      slug: 'dev_communities',
      name: 'Developer Communities',
      shortLabel: 'Communities',
      defaultPriority: 'P0',
      description: 'Hacker News, Lobsters, DEV Community, Reddit technical threads.',
      defaultKeywords: ['hacker news', 'lobsters', 'dev.to', 'postmortem'],
      icon: Icons.forum_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    // P1 — High Priority Related Areas
    RadarCategoryDef(
      code: 'G',
      slug: 'major_companies',
      name: 'Major Tech Companies',
      shortLabel: 'Platforms',
      defaultPriority: 'P1',
      description: 'Official announcements from Google, Anthropic, OpenAI, Cloudflare & more.',
      defaultKeywords: ['google', 'anthropic', 'openai', 'cloudflare', 'apple'],
      icon: Icons.apartment_rounded,
      accentColor: Color(0xFF3B82F6),
    ),
    RadarCategoryDef(
      code: 'H',
      slug: 'research_papers',
      name: 'Scientific & Research Papers',
      shortLabel: 'Research',
      defaultPriority: 'P1',
      description: 'arXiv preprints translated into practical engineering takeaways.',
      defaultKeywords: ['arxiv', 'paper', 'preprint', 'benchmark'],
      icon: Icons.science_rounded,
      accentColor: Color(0xFF6366F1),
    ),
    RadarCategoryDef(
      code: 'I',
      slug: 'robotics_hardware_iot',
      name: 'Robotics, Hardware & IoT',
      shortLabel: 'Robotics & IoT',
      defaultPriority: 'P1',
      description: 'Embodied AI, ROS2, ESP32, Raspberry Pi, edge chips & drones.',
      defaultKeywords: ['robotics', 'ros2', 'esp32', 'embedded', 'edge ai'],
      icon: Icons.precision_manufacturing_rounded,
      accentColor: Color(0xFF14B8A6),
    ),
    RadarCategoryDef(
      code: 'J',
      slug: 'cloud_devops',
      name: 'Cloud, DevOps & Infra',
      shortLabel: 'Cloud & Infra',
      defaultPriority: 'P1',
      description: 'Containers, Kubernetes, CI/CD, observability & Linux internals.',
      defaultKeywords: ['kubernetes', 'docker', 'ebpf', 'observability', 'linux'],
      icon: Icons.cloud_queue_rounded,
      accentColor: Color(0xFF0284C7),
    ),
    RadarCategoryDef(
      code: 'K',
      slug: 'databases_data',
      name: 'Databases & Data Eng',
      shortLabel: 'Databases',
      defaultPriority: 'P1',
      description: 'SQLite, Postgres, DuckDB, vector DBs, streaming & storage internals.',
      defaultKeywords: ['sqlite', 'postgres', 'duckdb', 'vector', 'storage'],
      icon: Icons.storage_rounded,
      accentColor: Color(0xFF0D9488),
    ),
    RadarCategoryDef(
      code: 'L',
      slug: 'design_ui_ux',
      name: 'Web Design, UI/UX & Craft',
      shortLabel: 'UI/UX Craft',
      defaultPriority: 'P1',
      description: 'Design systems, motion design, accessibility, CSS & interactive craft.',
      defaultKeywords: ['design system', 'typography', 'a11y', 'motion', 'css'],
      icon: Icons.palette_outlined,
      accentColor: Color(0xFFEC4899),
    ),
    RadarCategoryDef(
      code: 'M',
      slug: 'mobile_apps',
      name: 'App Dev & Mobile Ecosystem',
      shortLabel: 'Mobile Dev',
      defaultPriority: 'P1',
      description: 'Flutter, Dart, Android, iOS, widgets & on-device AI tools.',
      defaultKeywords: ['flutter', 'dart', 'android', 'ios', 'kotlin', 'mobile'],
      icon: Icons.smartphone_rounded,
      accentColor: Color(0xFF10B981),
    ),
    // P2 — Complementary Priorities
    RadarCategoryDef(
      code: 'N',
      slug: 'cybersecurity_privacy',
      name: 'Cybersecurity & Privacy',
      shortLabel: 'Security',
      defaultPriority: 'P2',
      description: 'Vulnerabilities, zero-trust tooling, supply-chain security & privacy.',
      defaultKeywords: ['security', 'cve', 'passkey', 'encryption', 'privacy'],
      icon: Icons.shield_outlined,
      accentColor: Color(0xFF64748B),
    ),
    RadarCategoryDef(
      code: 'O',
      slug: 'india_tech',
      name: 'Tech Ecosystem in India',
      shortLabel: 'India Tech',
      defaultPriority: 'P2',
      description: 'Indian startups, IIT/IIIT research, UPI/ONDC/Bhashini & local OSS.',
      defaultKeywords: ['india', 'bengaluru', 'upi', 'bhashini', 'sarvam'],
      icon: Icons.public_rounded,
      accentColor: Color(0xFFD97706),
    ),
    RadarCategoryDef(
      code: 'P',
      slug: 'careers_opportunities',
      name: 'Careers & Opportunities',
      shortLabel: 'Opportunities',
      defaultPriority: 'P2',
      description: 'Hackathons, open-source grants, GSOC, fellowships & build challenges.',
      defaultKeywords: ['hackathon', 'gsoc', 'grant', 'fellowship', 'bounty'],
      icon: Icons.work_outline_rounded,
      accentColor: Color(0xFF059669),
    ),
    // P3 — Exploratory
    RadarCategoryDef(
      code: 'Q',
      slug: 'emerging_future',
      name: 'Emerging & Future Tech',
      shortLabel: 'Future Tech',
      defaultPriority: 'P3',
      description: 'Quantum computing, BCI, photonics, biotech & spatial computing.',
      defaultKeywords: ['quantum', 'bci', 'photonic', 'spatial', 'biotech'],
      icon: Icons.explore_outlined,
      accentColor: Color(0xFF7C3AED),
    ),
    RadarCategoryDef(
      code: 'R',
      slug: 'events_launches',
      name: 'Tech Events & Launches',
      shortLabel: 'Events',
      defaultPriority: 'P3',
      description: 'Major keynotes, I/O, WWDC, NeurIPS, KubeCon & release weeks.',
      defaultKeywords: ['keynote', 'conference', 'neurips', 'kubecon', 'summit'],
      icon: Icons.event_available_rounded,
      accentColor: Color(0xFF475569),
    ),
  ];

  static RadarCategoryDef byCode(String code) {
    final upper = code.toUpperCase();
    for (final c in categories) {
      if (c.code == upper) return c;
    }
    return categories[1]; // B fallback
  }

  static double priorityWeight(String priority) {
    switch (priority.toUpperCase()) {
      case 'P0':
        return 1.0;
      case 'P1':
        return 0.72;
      case 'P2':
        return 0.48;
      case 'P3':
        return 0.30;
      default:
        return 0.50;
    }
  }
}

