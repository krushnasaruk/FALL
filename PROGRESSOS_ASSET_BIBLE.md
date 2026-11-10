# FALL (`progress_os`) — Visual Asset Bible

This Asset Bible defines the unified visual world, geometric rules, colour harmony, stroke weights, and export discipline for all custom artwork across FALL.

---

## 1. Visual World & Art Direction
- **Identity:** *Warm Editorial Craft* — friendly rounded 2D silhouettes pairing warm autumn-fox tangerine coats with cool indigo/sky/mint workspace surfaces.
- **Originality:** Original **Pip** the FALL Fox companion derived strictly from FALL's maple-leaf emblem ([fall_logo_light.png](assets/images/fall_logo_light.png)). Zero third-party mascot elements.

## 2. Geometry, Outlines & Proportions
- **Coordinate Grid:** Drawn natively on a 4x supersampled `2048x2048` canvas mapped to a `512x512` logical artboard before `Image.Resampling.LANCZOS` downsampling.
- **Line Weight:** Constant `10px` logical (`#6D452B` warm espresso outline) on hero silhouettes; `5px–8px` logical on secondary props & inner details, with rounded curve joins.
- **Shadow Style:** Subtle low-opacity contact shadow beneath grounded items (`#6D452B` at `~11%` opacity) plus clean flat ambient circular pastel halo (`~25%–35%` alpha) behind characters/illustrations — never drop-shadow fuzz or blurry glow blobs.
- **Background Treatment:** Pure RGBA transparent backgrounds for every companion, empty state, achievement badge, and Android widget sticker so artwork sits cleanly over both Light (`#F8F9FC` / `#FFFFFF`) and Dark (`#0D1117` / `#161B22`) canvases.

## 3. Master Palette Rules
| Role | Hex | Usage |
|---|---|---|
| Espresso Stroke | `#6D452B` | Outlines, eyes, nose, mouths, glasses |
| Coat Orange | `#F8A055` | Pip fur body, ears, head |
| Warm Cream | `#FDF5E2` | Inner cheeks, chest bib, tail tip, notes paper |
| Blush Tint | `#F4A5AE` | Soft cheek oval highlights |
| Maple Leaf Gold | `#EAB464` | Autumn emblem accent |
| Primary Indigo | `#7167E8` | Book cover, focus center, sparkle accents |
| Sky Blue | `#70BDEB` | Clipboard clip, focus arc, search accent |
| Mint Green | `#62B989` | Habit sprout, achievement checkmarks |

## 4. Naming & Resolution Standards
- **Companions (`384x384` PNG):** `assets/images/companion/pip_<expression>.png`
- **Empty States (`320x320` PNG):** `assets/images/empty/empty_<module>.png`
- **Achievements (`256x256` PNG):** `assets/images/achievements/badge_<category>.png`
- **Onboarding (`420x420` PNG):** `assets/images/onboarding/onboard_<stage>.png`
- **Android Widgets (`160x160` PNG):** `android/app/src/main/res/drawable-nodpi/widget_companion_<variant>.png`
- **Audio Assets (22.05kHz 16-bit mono WAV):** `assets/sounds/<event>.wav`

