# FALL (`progress_os`) — Companion Character Specification (**Pip**)

---

## Character Identity
- **Name:** Pip (the FALL Fox Companion)
- **Role:** Quiet, calm companion celebrating milestones, softening empty screens, greeting new users, and enriching Android home-screen widgets without cluttering active lists.
- **Proportions:** `1 : 1.05` head-to-body ratio (`head center y=206`, `body base y=434` on a `512` grid), wide cream-cheek jawline, pointed triangular rounded ears, tapered shoulder tuck, curling fluffy tail at bottom-right.

## All 12 Expression States (`CompanionExpression`)

| # | State Key | Asset File | Visual Cue | Screen Usage |
|---|---|---|---|---|
| 1 | `welcome` | `pip_welcome.png` | Raised waving left paw + golden maple leaf | First-launch Onboarding Page 1 |
| 2 | `idle` | `pip_idle.png` | Relaxed seated stance, calm eyes | Feature Guide / Idle Hub header |
| 3 | `happy` | `pip_happy.png` | Joyful curved eyes (`^ ^`) & warm sparkle | Task / Daily Progress widget |
| 4 | `celebrating` | `pip_celebrating.png` | Both paws raised + 4 pastel sparkles | Goal reached, Focus session finished |
| 5 | `thinking` | `pip_thinking.png` | Head tilted + paw on chin + thought bubbles | Planning / Active Project widget |
| 6 | `focused` | `pip_focused.png` | Concentrated brow + cyan progress halo | Active Focus Mode & Focus Widget |
| 7 | `curious` | `pip_curious.png` | Tilted head + wide bright eyes + magnifier | Discovery tips & search recovery |
| 8 | `encouraging` | `pip_encouraging.png` | Calm confident smile + mint/maple leaf | Streak widget & Habits encouragement |
| 9 | `sleeping` | `pip_sleeping.png` | Closed peaceful eyes + subtle `Z` glyphs | Quiet hours / Late night rest prompt |
| 10 | `supportive` | `pip_supportive.png` | Gentle warm eyes holding cozy mug + leaf | Recovery after missed habit days / breaks |
| 11 | `learning` | `pip_learning.png` | Round espresso glasses + open lavender book | Learning empty state & Learning Widget |
| 12 | `achievement` | `pip_achievement.png` | Smiling with gleaming gold-indigo crest | Badge Unlock overlay & Trophy Shelf |

## Animation-Ready States (`CompanionAvatar`)
- Static default (`animate: false`) for list headers and resting screens (zero idle CPU cost).
- Gentle `900ms` breathing/celebration float (`1.0 -> 1.035` scale, `-2.5px` vertical lift) only on active celebration sheets, completion dialogs, and onboarding steps — automatically disabled under `MediaQuery.maybeDisableAnimationsOf(context)`.

