#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# ProgressOS Radar — Termux:Boot Startup Script
# ==============================================================================
# Executed automatically when your Android device finishes booting.
# Starts the ProgressOS Radar background server.
#
# Requirements:
# 1. Termux:Boot add-on installed from F-Droid
# 2. Termux:Boot opened at least once to grant boot permissions
# ==============================================================================

# Allow network stack and storage to settle
sleep 5

# Prevent CPU from sleeping
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock
fi

# Launch Radar service
if command -v radar >/dev/null 2>&1; then
    radar start
elif [ -x "$HOME/FALL/deploy/termux/radar" ]; then
    "$HOME/FALL/deploy/termux/radar" start
fi
