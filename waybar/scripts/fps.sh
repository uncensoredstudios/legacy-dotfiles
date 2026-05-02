#!/usr/bin/env bash
# Waybar FPS widget — reads MangoHud log if active, else show "—"

MANGO_LOG="/tmp/mangohud_fps.log"

if [[ -f "$MANGO_LOG" ]]; then
    FPS=$(tail -1 "$MANGO_LOG" 2>/dev/null | awk '{print $1}')
    echo "${FPS:-—} FPS"
else
    echo "— FPS"
fi
