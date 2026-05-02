#!/usr/bin/env bash
# ─── Quick Resolution Picker ───────────────────────────

MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')

CHOICE=$(printf "1920x1080@60\n1920x1080@144\n2560x1440@60\n2560x1440@144\n3840x2160@60\n1280x720@60\nCustom..." \
    | rofi -dmenu -p "󰹑  Resolution" -theme ~/.config/rofi/gruvbox.rasi)

if [[ "$CHOICE" == "Custom..." ]]; then
    CHOICE=$(rofi -dmenu -p "󰹑  Enter resolution (WxH@Hz)" -theme ~/.config/rofi/gruvbox.rasi <<< "")
fi

[[ -z "$CHOICE" ]] && exit 0

IFS='@' read -r RES RATE <<< "$CHOICE"
IFS='x' read -r W H <<< "$RES"
RATE=${RATE:-60}

hyprctl keyword monitor "$MONITOR,${W}x${H}@${RATE},auto,1"
notify-send "󰹑 Resolution" "Set to ${W}×${H} @ ${RATE}Hz"
