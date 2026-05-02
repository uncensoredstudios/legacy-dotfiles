#!/usr/bin/env bash
# ─── FPS Overlay Toggle (MangoHud) ─────────────────────

LOCK="/tmp/mangohud_overlay.lock"

if [[ -f "$LOCK" ]]; then
    pkill -f "mangohud" 2>/dev/null
    rm "$LOCK"
    notify-send -t 1500 "󰊴 FPS Overlay" "Disabled"
else
    touch "$LOCK"
    # wlr-randr based overlay via wl-roots
    notify-send -t 1500 "󰊴 FPS Overlay" "Enabled — launch game with MANGOHUD=1"
fi
