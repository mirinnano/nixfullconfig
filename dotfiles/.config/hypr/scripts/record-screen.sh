#!/usr/bin/env bash
# 領域選択画面録画 / Region screen recording
set -euo pipefail

DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="recording_${TIMESTAMP}.mp4"
FULLPATH="$DIR/$FILENAME"

# 録画領域を選択 / Select region
REGION=$(slurp) || { dunstify "Recording" "Cancelled" -t 2000; exit 0; }

# 通知開始 / Start notification
dunstify "Recording" "Starting... Press Super+Shift+R to stop" -t 3000 -i media-record

# 録画開始（音声付き）/ Start with audio
wf-recorder -g "$REGION" -f "$FULLPATH" --audio=pulse

# 通知終了 / End notification
dunstify "Recording" "Saved: $FILENAME" -t 5000 -i document-save
