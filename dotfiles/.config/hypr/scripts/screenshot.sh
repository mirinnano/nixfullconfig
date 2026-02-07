#!/usr/bin/env bash

# Screenshot script for Hyprland
# Dependencies: grim, slurp, swappy, wl-clipboard, notify-send

DIR="$HOME/Pictures/Screenshots"
NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"

option1="Selected area"
option2="Selected area (edit)"
option3="Fullscreen"
option4="Fullscreen (edit)"
option5="Active window"
option6="Active window (edit)"

options="$option1\n$option2\n$option3\n$option4\n$option5\n$option6"

choice=$(echo -e "$options" | rofi -dmenu -i -p "Screenshot")

case $choice in
    $option1)
        grim -g "$(slurp)" "$DIR/$NAME"
        wl-copy < "$DIR/$NAME"
        notify-send "Screenshot" "Area screenshot saved and copied to clipboard" -i "$DIR/$NAME"
        ;;
    $option2)
        grim -g "$(slurp)" - | swappy -f - -o "$DIR/$NAME"
        wl-copy < "$DIR/$NAME"
        notify-send "Screenshot" "Edited screenshot saved and copied to clipboard" -i "$DIR/$NAME"
        ;;
    $option3)
        grim "$DIR/$NAME"
        wl-copy < "$DIR/$NAME"
        notify-send "Screenshot" "Fullscreen screenshot saved and copied to clipboard" -i "$DIR/$NAME"
        ;;
    $option4)
        grim - | swappy -f - -o "$DIR/$NAME"
        wl-copy < "$DIR/$NAME"
        notify-send "Screenshot" "Edited screenshot saved and copied to clipboard" -i "$DIR/$NAME"
        ;;
    $option5)
        hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$DIR/$NAME"
        wl-copy < "$DIR/$NAME"
        notify-send "Screenshot" "Window screenshot saved and copied to clipboard" -i "$DIR/$NAME"
        ;;
    $option6)
        hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | swappy -f - -o "$DIR/$NAME"
        wl-copy < "$DIR/$NAME"
        notify-send "Screenshot" "Edited window screenshot saved and copied to clipboard" -i "$DIR/$NAME"
        ;;
esac
