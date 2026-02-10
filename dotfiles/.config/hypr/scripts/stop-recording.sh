#!/usr/bin/env bash
# 録画停止 / Stop recording
set -euo pipefail

if pgrep -x wf-recorder > /dev/null; then
    pkill -INT wf-recorder
    dunstify "Recording" "Stopped" -t 2000 -i media-playback-stop
else
    dunstify "Recording" "No recording in progress" -t 2000 -i dialog-error
fi
