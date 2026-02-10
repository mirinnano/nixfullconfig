#!/usr/bin/env bash
# 全画面録画 / Fullscreen recording
set -euo pipefail

DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="fullscreen_${TIMESTAMP}.mp4"

dunstify "Recording" "Fullscreen... Press Super+Shift+R to stop" -t 3000 -i media-record
wf-recorder -f "$DIR/$FILENAME" --audio=pulse
dunstify "Recording" "Saved: $FILENAME" -t 5000 -i document-save
