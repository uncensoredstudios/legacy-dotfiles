#!/usr/bin/env bash
# ─── Volume Notification ───────────────────────────────

VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)

if [[ "$MUTED" -gt 0 ]]; then
    ICON="󰝟"
    MSG="Muted"
elif [[ "$VOL" -lt 30 ]]; then
    ICON="󰕿"
    MSG="${VOL}%"
elif [[ "$VOL" -lt 70 ]]; then
    ICON="󰖀"
    MSG="${VOL}%"
else
    ICON="󰕾"
    MSG="${VOL}%"
fi

notify-send -t 1500 -h string:x-dunst-stack-tag:volume \
    -h "int:value:${VOL}" \
    "$ICON Volume" "$MSG"

# Тихий звук обратной связи
paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga 2>/dev/null &
