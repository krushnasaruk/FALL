#!/bin/bash
# ==============================================================================
# ProgressOS Radar — Termux 1-Command Automated Installer
# ==============================================================================
# Installs dependencies, sets up isolated data and config directories outside Git,
# configures the 'radar' CLI tool in Termux PATH, and prepares the environment.
#
# Idempotent: safe to run multiple times without overwriting existing data.
# ==============================================================================

set -e

# Detect environment
if [ -n "$PREFIX" ] && [ -d "$PREFIX" ]; then
    IS_TERMUX=true
    BIN_DIR="$PREFIX/bin"
else
    IS_TERMUX=false
    BIN_DIR="$HOME/.local/bin"
    mkdir -p "$BIN_DIR"
fi

RADAR_HOME="$HOME/.radar"
RADAR_DATA_DIR="$RADAR_HOME/data"
RADAR_LOG_DIR="$RADAR_HOME/logs"
RADAR_ENV_FILE="$RADAR_HOME/radar.env"
REPO_PATH_FILE="$RADAR_HOME/repo_path"

echo "============================================================"
echo "    ProgressOS Radar — Android Termux Server Setup          "
echo "============================================================"

# Step 1: Detect repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
if [ -d "$SCRIPT_DIR/../../backend/radar_server" ]; then
    REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
elif [ -d "$PWD/backend/radar_server" ]; then
    REPO_DIR="$PWD"
elif [ -d "$HOME/FALL/backend/radar_server" ]; then
    REPO_DIR="$HOME/FALL"
else
    echo "[ERROR] Could not find ProgressOS repository with backend/radar_server."
    echo "Please run this script from inside the cloned FALL repository:"
    echo "  cd ~/FALL && bash deploy/termux/install.sh"
    exit 1
fi

echo "[1/5] Repository detected at: $REPO_DIR"

# Step 2: Ensure required packages in Termux
echo "[2/5] Checking runtime packages..."
if [ "$IS_TERMUX" = true ]; then
    PACKAGES_TO_INSTALL=""
    command -v python >/dev/null 2>&1 || PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL python"
    command -v git    >/dev/null 2>&1 || PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL git"
    command -v curl   >/dev/null 2>&1 || PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL curl"
    command -v tar    >/dev/null 2>&1 || PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL tar"

    if [ -n "$PACKAGES_TO_INSTALL" ]; then
        echo "Installing missing packages:$PACKAGES_TO_INSTALL..."
        pkg update -y
        # shellcheck disable=SC2086
        pkg install -y $PACKAGES_TO_INSTALL
    else
        echo "All required packages (python, git, curl, tar) are already installed."
    fi
else
    echo "Running outside Termux; ensuring required commands exist..."
    for cmd in python3 git curl tar; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "[WARN] Command '$cmd' not found in PATH."
        fi
    done
fi

# Step 3: Set up persistent directories outside Git
echo "[3/5] Setting up persistent data directories in $RADAR_HOME..."
mkdir -p "$RADAR_HOME" "$RADAR_DATA_DIR" "$RADAR_LOG_DIR"
echo "$REPO_DIR" > "$REPO_PATH_FILE"

# Create default radar.env if not already existing
if [ ! -f "$RADAR_ENV_FILE" ]; then
    cat << EOF > "$RADAR_ENV_FILE"
# ProgressOS Radar Server Configuration
# Stored outside Git to protect secrets and ensure safe git updates.

RADAR_HOST=0.0.0.0
RADAR_PORT=8787
RADAR_AUTO_COLLECT=true
RADAR_DB_PATH=$RADAR_DATA_DIR/radar.sqlite3
GEMINI_MODEL=gemini-3-flash-preview
GEMINI_DAILY_BUDGET=120

# Optional API Keys: Configure using 'radar config set <KEY> <VALUE>'
GEMINI_API_KEY=
GITHUB_TOKEN=
YOUTUBE_API_KEY=
EOF
    chmod 600 "$RADAR_ENV_FILE"
    echo "Created default configuration file: $RADAR_ENV_FILE"
else
    echo "Preserved existing configuration: $RADAR_ENV_FILE"
fi

# Step 4: Install the 'radar' CLI wrapper into PATH
echo "[4/5] Installing 'radar' CLI tool into $BIN_DIR/radar..."
cp -f "$REPO_DIR/deploy/termux/radar" "$BIN_DIR/radar"
chmod +x "$BIN_DIR/radar"

# If outside Termux and BIN_DIR is not in PATH, advise user
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Tip: Add $BIN_DIR to your PATH or run: export PATH=\"\$PATH:$BIN_DIR\""
fi

# Step 5: Verify installation
echo "[5/5] Verifying installation..."
"$BIN_DIR/radar" help >/dev/null

echo ""
echo "============================================================"
echo "    ProgressOS Radar Server Installed Successfully!         "
echo "============================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. (Optional) Set your API keys without editing any files:"
echo "   radar config set GEMINI_API_KEY \"your_gemini_key\""
echo "   radar config set GITHUB_TOKEN \"your_github_token\""
echo "   radar config set YOUTUBE_API_KEY \"your_youtube_key\""
echo ""
echo "2. Start your Radar server in the background:"
echo "   radar start"
echo ""
echo "3. Check server status and network access URLs:"
echo "   radar status"
echo ""
echo "4. (Recommended) Enable auto-start on phone reboot:"
echo "   radar boot enable"
echo ""
echo "Run 'radar help' anytime to view all available commands."
echo "============================================================"
