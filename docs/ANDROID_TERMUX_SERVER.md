# ProgressOS Radar — Android Termux Server Deployment Guide

> **Deploy, operate, monitor, and maintain the ProgressOS Radar intelligence backend 24/7 on your Android phone using Termux.**  
> **Zero code editing or manual configuration required on your phone.** All operations are performed using simple, copy-pasteable terminal commands.

---

## Table of Contents

1. [Why Run Radar on Android Termux?](#1-why-run-radar-on-android-termux)
2. [Termux Installation & Preparation](#2-termux-installation--preparation)
3. [First-Time Deployment (1-Command Installer)](#3-first-time-deployment-1-command-installer)
4. [Configuring API Keys Without Editing Files](#4-configuring-api-keys-without-editing-files)
5. [Operating the Server (The `radar` CLI)](#5-operating-the-server-the-radar-cli)
6. [Updating the Server via Git](#6-updating-the-server-via-git)
7. [Automatic Startup on Android Boot (Termux:Boot)](#7-automatic-startup-on-android-boot-termuxboot)
8. [Android Battery & Power Management](#8-android-battery--power-management)
9. [Network Access & Security](#9-network-access--security)
10. [Data Persistence & Backups](#10-data-persistence--backups)
11. [Health Checks & Troubleshooting](#11-health-checks--troubleshooting)
12. [Resource Footprint & Performance](#12-resource-footprint--performance)
13. [Complete Command Cheat Sheet](#13-complete-command-cheat-sheet)

---

## 1. Why Run Radar on Android Termux?

The ProgressOS Radar backend is an autonomous technology discovery platform that gathers insights across 18 technical categories (AI, open source, robotics, devtools, cloud, research, and security). 

Because the backend is engineered in **pure Python standard library** (using built-in `http.server`, `urllib.request`, `sqlite3`, `json`, and `threading`), it requires **zero external pip compilation** or heavy scientific dependencies.

- **Ultra-lightweight:** Consumes only **~30–45 MB of RAM** at runtime.
- **Low Power:** Sleeps between collection cycles, producing negligible CPU load (<1% idle) and zero heat.
- **Always-On Hardware:** An Android smartphone already features a built-in battery backup (UPS), Wi-Fi connectivity, and low idle power consumption (less than 1 watt).
- **Self-Contained Data:** All SQLite data, bookmarks, trends, and briefings stay private and local on your device.

---

## 2. Termux Installation & Preparation

### ⚠️ Critical Warning: Do NOT Install Termux from Google Play Store!
The Google Play Store version of Termux was **deprecated in 2020** due to Android SDK 29 restrictions and revoked signing keys. Installing from Google Play will cause repository update failures (`404 Not Found` errors on `pkg update`).

### Step 1: Install Termux from F-Droid or GitHub
Choose one of the official, actively maintained distribution sources:

- **Option A (Recommended): F-Droid**
  1. Open [F-Droid Termux Page](https://f-droid.org/en/packages/com.termux/) in your phone's browser.
  2. Download and install the APK (or install via the F-Droid app).
- **Option B: GitHub Releases**
  1. Open [Termux GitHub Releases](https://github.com/termux/termux-app/releases).
  2. Download the APK matching your device CPU architecture (typically `termux-app_v..._arm64-v8a.apk` or `universal`).

### Step 2: (Optional) Install Termux:Boot for Auto-Start on Reboot
If you want Radar to automatically start when your phone boots:
- Install **Termux:Boot** from [F-Droid Termux:Boot Page](https://f-droid.org/en/packages/com.termux.boot/) (must be from the same source as Termux so signing keys match).
- **Crucial:** Open the **Termux:Boot** app icon once after installation to grant the initial background broadcast permission.

### Step 3: Initialize Termux Environment
Open the Termux app on your phone and copy-paste these commands to update package mirrors and install dependencies:

```bash
# 1. Update Termux package repositories
pkg update && pkg upgrade -y

# 2. Install required packages (Git, Python 3, cURL, Tar)
pkg install -y git python curl tar
```

### Step 4: Verify Runtime
Confirm that Python and Git are installed:

```bash
python --version
git --version
```
*(You should see Python 3.11+ and Git 2.40+).*

---

## 3. First-Time Deployment (1-Command Installer)

You do not need to create scripts or write backend code on your phone. The repository provides a self-contained installer.

Run these exact commands in Termux:

```bash
# 1. Clone your ProgressOS repository into your home directory
git clone https://github.com/krushnasaruk/FALL.git ~/FALL

# 2. Enter the repository directory
cd ~/FALL

# 3. Run the automated installer
bash deploy/termux/install.sh
```

### What the installer automatically does:
1. Detects your Termux environment and repository root (`$HOME/FALL`).
2. Creates isolated persistent directories at `~/.radar/data/` (for SQLite) and `~/.radar/logs/` (for server logs).
3. Creates a private configuration file at `~/.radar/radar.env` with safe default parameters.
4. Installs the `radar` CLI executable into `$PREFIX/bin/radar` so you can type `radar` from any directory.
5. Verifies command execution and system health.

---

## 4. Configuring API Keys Without Editing Files

The ProgressOS Radar server works **completely offline or without any API keys** using deterministic heuristics, zero-quota Atom RSS feeds, arXiv preprints, Hacker News, and Hugging Face.

However, to unlock full Gemini 3 Flash discovery synthesis, 5,000 req/hr GitHub searches, and YouTube data queries, configure your keys using the `radar config` command.

### Configuration Variables

| Variable | Required? | Default | Purpose |
|---|---|---|---|
| `GEMINI_API_KEY` | Optional | *Empty* | Enables Gemini 3 Flash synthesis, plain-English executive summaries, and takeaways. |
| `GITHUB_TOKEN` | Optional | *Empty* | Personal Access Token boosting GitHub API limit from 60 to 5,000 requests/hour. |
| `YOUTUBE_API_KEY` | Optional | *Empty* | YouTube Data API v3 key for search (channel feeds work without this). |
| `GEMINI_MODEL` | No | `gemini-3-flash-preview` | Gemini model variant (`gemini-3-flash-preview` or `gemini-1.5-flash`). |
| `GEMINI_DAILY_BUDGET` | No | `120` | Max calls per day circuit-breaker to prevent accidental quota exhaustion. |
| `RADAR_HOST` | No | `0.0.0.0` | Bind IP (`0.0.0.0` allows other devices on your Wi-Fi network to access it). |
| `RADAR_PORT` | No | `8787` | HTTP port for the API server. |
| `RADAR_AUTO_COLLECT` | No | `true` | Automatically triggers background discovery cycles every 2 hours. |
| `RADAR_DB_PATH` | No | `~/.radar/data/radar.sqlite3` | Persistent SQLite path (stored outside Git). |

### Set Your Secrets via Commands (No Text Editor Needed!)

Copy and paste the commands below, substituting your keys:

```bash
# Set your Gemini API Key
radar config set GEMINI_API_KEY "YOUR_GEMINI_KEY_HERE"

# Set your GitHub Personal Access Token
radar config set GITHUB_TOKEN "YOUR_GITHUB_PAT_HERE"

# Set your YouTube Data API Key
radar config set YOUTUBE_API_KEY "YOUR_YOUTUBE_KEY_HERE"
```

### Inspect Your Configuration
Verify your keys without risking sensitive secrets leaking to shoulder-surfers or screenshots:

```bash
radar config show
```

*Output:*
```text
=== ProgressOS Radar Configuration ===
Config File: /data/data/com.termux/files/home/.radar/radar.env

  RADAR_HOST             = 0.0.0.0
  RADAR_PORT             = 8787
  RADAR_AUTO_COLLECT     = true
  RADAR_DB_PATH          = /data/data/com.termux/files/home/.radar/data/radar.sqlite3
  GEMINI_MODEL           = gemini-3-flash-preview
  GEMINI_DAILY_BUDGET    = 120
  GEMINI_API_KEY         = AQ.Ab8****gwY-A
  GITHUB_TOKEN           = github****rT8l
  YOUTUBE_API_KEY        = AIzaSy****sYNw
```
*(Notice that all secrets are automatically masked in output).*

---

## 5. Operating the Server (The `radar` CLI)

You do not need to keep a terminal tab open or write complex `python` commands. Use the built-in `radar` command.

### Start the Server
```bash
radar start
```
- Starts the server in the background using a persistent daemon process.
- Automatically requests an Android wake-lock (`termux-wake-lock`) to prevent the phone's CPU from entering deep sleep.
- Logs output to `~/.radar/logs/radar.log`.
- Verifies that the HTTP `/health` endpoint responds before reporting success.

### Check Status & Network Addresses
```bash
radar status
```
*Output:*
```text
=== ProgressOS Radar Server Status ===
Status:     RUNNING (PID: 14820)
Memory:     32.4 MB RSS
Bind URL:   http://0.0.0.0:8787
Database:   /data/data/com.termux/files/home/.radar/data/radar.sqlite3
DB Size:    2.4M

Network Access URLs:
  Local on phone:  http://127.0.0.1:8787
  Wi-Fi / LAN:     http://192.168.1.45:8787
  (Use the Wi-Fi URL inside the ProgressOS app settings on your computer or other devices)
```

### View Live Logs
```bash
# View the last 60 lines of logs:
radar logs

# Follow logs continuously (press Ctrl+C to exit):
radar logs -f
```

### Trigger an Instant Discovery Run
To fetch new discoveries immediately without waiting for the 2-hour scheduled cycle:
```bash
radar collect
```

### Stop the Server
```bash
radar stop
```
- Sends a graceful `SIGTERM` signal to allow any active database transactions to flush cleanly.
- Releases the Android wake-lock.

### Restart the Server
```bash
radar restart
```

---

## 6. Updating the Server via Git

When you push new features or fixes to GitHub from your development computer, updating your Android phone takes **one single command**:

```bash
radar update
```

### What `radar update` handles automatically:
1. Navigates to your local repository clone (`~/FALL`).
2. Pulls the latest code using `git fetch` and `git pull --ff-only origin main`.
3. **Guarantees data safety:** Your SQLite database (`~/.radar/data/radar.sqlite3`) and environment configuration (`~/.radar/radar.env`) live outside the Git repository, so they are **never overwritten, reset, or touched**.
4. Automatically updates the `radar` CLI binary in Termux `$PREFIX/bin`.
5. If the server was running before the update, it restarts the service seamlessly and executes a health check.

### Rollback Procedure (If Remote Changes Cause an Issue)
If you ever pull changes that break on your phone, rollback to the previous commit with zero data loss:

```bash
cd ~/FALL
git reset --hard HEAD@{1}
radar restart
```

---

## 7. Automatic Startup on Android Boot (Termux:Boot)

With **Termux:Boot**, your phone can restart after an OS update, dead battery recharge, or unexpected reboot and immediately restore your Radar server without opening Termux manually.

### Enable Auto-Boot in 1 Command:
```bash
radar boot enable
```

### Verify Boot Configuration:
```bash
radar boot status
```
*Output: `Termux:Boot Auto-Start: ENABLED (/data/data/com.termux/files/home/.termux/boot/start-radar.sh)`*

### Disable Auto-Boot:
```bash
radar boot disable
```

---

## 8. Android Battery & Power Management

Android's aggressive Low Memory Killer (LMK) and OEM battery savers can suspend background apps if not configured properly.

### 1. Disable Battery Optimization (Essential)
1. Open Android **Settings** on your phone.
2. Go to **Apps** -> **Termux**.
3. Tap **Battery** (or *App Battery Usage*).
4. Select **Unrestricted** (or *Don't optimize*).
5. Repeat the exact same step for the **Termux:Boot** app.

### 2. OEM-Specific Settings (Samsung, Xiaomi, Vivo, Oppo)
Different manufacturers have custom task-killers:
- **Samsung One UI:** Settings -> Battery and device care -> Battery -> Background usage limits -> Add Termux to **Never sleeping apps**.
- **Xiaomi (MIUI/HyperOS):** App Info -> Battery Saver -> Choose **No restrictions**. In App Permissions, enable **Autostart**.
- **OnePlus/Oppo/Realme:** Settings -> Battery -> App Battery Management -> Termux -> Allow background activity & Allow auto-launch.
- **Reference:** Visit [dontkillmyapp.com](https://dontkillmyapp.com/) for device-specific instructions.

### 3. Wake Lock & Charging Recommendations
- `radar start` automatically engages `termux-wake-lock`, instructing the Linux kernel not to enter CPU deep sleep while keeping the screen off.
- **Power Tip:** If you intend to use the phone as a dedicated 24/7 server, keep it plugged into a charger or low-power USB port. To protect battery health, enable your phone's built-in **"Protect Battery"** feature (which caps charging at 80% or 85%).

---

## 9. Network Access & Security

### Access Modes

#### Mode 1: On the Phone Itself
When running the ProgressOS Android app on the same phone as Termux:
- Set Backend URL to: `http://127.0.0.1:8787`

#### Mode 2: Same Wi-Fi Network (LAN)
To access Radar from your laptop, desktop, or tablet on the same Wi-Fi:
1. Run `radar status` to find your phone's local IP (e.g. `192.168.1.45`).
2. Point your ProgressOS client to: `http://192.168.1.45:8787`
3. *Recommendation:* In your home Wi-Fi router settings, assign a **static DHCP lease** to your phone so its local IP does not change.

#### Mode 3: Remote Access Over the Internet
> ⚠️ **Security Notice:** Do NOT use standard router port forwarding to expose port 8787 directly to the public internet without an authentication layer.

Use one of these two secure, encrypted options:

- **Option A (Recommended): Cloudflare Tunnel (Free & Secure)**
  Cloudflare Tunnel creates an encrypted outbound tunnel from Termux to Cloudflare's edge, giving you an HTTPS URL (e.g. `https://radar.yourdomain.com`) without opening any router ports:
  ```bash
  # Install Cloudflare CLI in Termux
  pkg install cloudflared
  # Run a quick temporary tunnel:
  cloudflared tunnel --url http://127.0.0.1:8787
  ```
- **Option B: Tailscale (Private Mesh VPN)**
  Install Tailscale on your Android phone and other devices from Google Play. You can then connect to your phone's 100.x.y.z Tailscale IP from anywhere in the world securely with zero port forwarding.

---

## 10. Data Persistence & Backups

Radar stores all discoveries, 18-category classifications, Gemini syntheses, user bookmarks, and trend observations in SQLite:

```text
~/.radar/data/radar.sqlite3
```

Because this path is isolated from `~/FALL`, **pulling updates or switching git branches will never delete your data.**

### Create a Backup
To create a timestamped, gzip-compressed backup of your database and settings:

```bash
radar backup
```
*Output: `Backup created: /data/data/com.termux/files/home/radar_backup_20261113_140834.tar.gz (2.4M)`*

### Export Backup to Android Internal Storage
To copy the backup to your phone's visible `Download` folder so you can save it to Google Drive or your PC:

```bash
# Grant Termux storage access (one-time prompt)
termux-setup-storage

# Copy the backup file to your phone's Download folder
cp ~/radar_backup_*.tar.gz /sdcard/Download/
```

### Restore from Backup
```bash
radar restore ~/radar_backup_20261113_140834.tar.gz
```
*(The command creates an emergency safety copy of your current state before restoring).*

---

## 11. Health Checks & Troubleshooting

### Run Complete Health Audit
Execute a 5-point system diagnostic:

```bash
radar health
```
*Checks process status, port accessibility, Gemini budget, GitHub limits, and SQLite integrity.*

### Common Troubleshooting Scenarios

#### 1. Port 8787 is already in use
If an orphaned process is holding port 8787:
```bash
# Stop radar and kill any lingering listeners on 8787:
radar stop
python -c "import socket, os; s = socket.socket(); s.close()"
radar start
```

#### 2. Server stopped running in background
If Android terminated Termux while your screen was off:
1. Re-check Section 8: verify Termux battery is set to **Unrestricted**.
2. Run `radar start` (which re-acquires `termux-wake-lock`).
3. Check `radar logs` to see if Android triggered an out-of-memory kill.

#### 3. Git update reports merge conflicts
If you accidentally modified files in `~/FALL`:
```bash
cd ~/FALL
git reset --hard HEAD
radar update
```
*(Your SQLite data and API keys in `~/.radar` will remain 100% intact).*

#### 4. Gemini API returns quota error
ProgressOS Radar includes a built-in circuit breaker. If Gemini quota is exceeded, the server automatically falls back to deterministic keyword analysis without crashing.
- Check current budget status in `radar status`.
- To increase the daily limit: `radar config set GEMINI_DAILY_BUDGET 200` followed by `radar restart`.

---

## 12. Resource Footprint & Performance

| Resource | Typical Measurement | Termux Impact |
|---|---|---|
| **RAM (Resident Memory)** | `29.5 MB – 42.0 MB` | Negligible (typical Android has 4,000–8,000 MB). |
| **CPU (Idle)** | `< 0.5%` | Sleeps between collection cycles; phone stays cool. |
| **CPU (Active Collection)** | `3% – 8% for ~45 seconds` | Background thread runs once every 2 hours. |
| **Disk Storage** | `~15 MB` (Code) + `~2–10 MB` (DB) | Very small; SQLite auto-vacuums old raw items. |
| **Network Bandwidth** | `~2–4 MB per collection cycle` | Minimal data usage over Wi-Fi. |

---

## 13. Complete Command Cheat Sheet

| Command | Action / Purpose |
|---|---|
| `radar start` | Start the server in background with wake-lock |
| `radar stop` | Gracefully stop the server process |
| `radar restart` | Restart server to apply updates or settings |
| `radar status` | View running status, PID, RAM, and network URLs |
| `radar logs` | Display last 60 lines of output logs |
| `radar logs -f` | Stream live server logs in real time (Ctrl+C to stop) |
| `radar health` | Run comprehensive health check and API audit |
| `radar collect` | Trigger an immediate discovery cycle manually |
| `radar update` | Pull latest code from GitHub and restart safely |
| `radar config show` | View current configuration with keys masked |
| `radar config set <K> <V>` | Set/update an environment variable |
| `radar config unset <K>` | Remove a setting from configuration |
| `radar backup` | Create a timestamped `.tar.gz` backup |
| `radar restore <file>` | Restore database and config from backup archive |
| `radar boot enable` | Enable automatic server start on phone reboot |
| `radar boot disable` | Disable auto-start on boot |
| `radar boot status` | Check if auto-start on boot is enabled |
| `radar help` | Display built-in CLI help reference |

---

*Deployed with ❤️ by ProgressOS Architecture Team.*
