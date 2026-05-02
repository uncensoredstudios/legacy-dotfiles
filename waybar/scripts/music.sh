#!/usr/bin/env bash
# Waybar music widget

STATUS=$(playerctl status 2>/dev/null)

if [[ "$STATUS" == "Playing" ]]; then
    ARTIST=$(playerctl metadata artist 2>/dev/null | head -c 20)
    TITLE=$(playerctl metadata title 2>/dev/null | head -c 24)
    if [[ -n "$TITLE" ]]; then
        echo "󰎇  $ARTIST — $TITLE"
    else
        echo "󰎇  Playing"
    fi
elif [[ "$STATUS" == "Paused" ]]; then
    TITLE=$(playerctl metadata title 2>/dev/null | head -c 24)
    echo "󰏤  ${TITLE:-Paused}"
else
    echo ""
fi
