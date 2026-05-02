#!/usr/bin/env bash
# ─── System Snapshot / Rollback ────────────────────────
# Использует Timeshift (если установлен) или Snapper

CHOICE=$(printf "📸 Create snapshot\n🔄 List snapshots\n⏪ Rollback (latest)\n❌ Cancel" \
    | rofi -dmenu -p "󰆓  System Snapshot" -theme ~/.config/rofi/gruvbox.rasi)

case "$CHOICE" in
    "📸 Create snapshot")
        if command -v timeshift &>/dev/null; then
            kitty -e sudo timeshift --create --comments "Legacy-auto-$(date +%Y%m%d_%H%M)"
        elif command -v snapper &>/dev/null; then
            kitty -e sudo snapper create --description "Legacy-$(date +%Y%m%d_%H%M)"
        else
            notify-send -u critical "Snapshot" "Install timeshift or snapper first"
        fi
        ;;
    "🔄 List snapshots")
        if command -v timeshift &>/dev/null; then
            kitty -e sudo timeshift --list
        elif command -v snapper &>/dev/null; then
            kitty -e sudo snapper list
        fi
        ;;
    "⏪ Rollback (latest)")
        CONFIRM=$(printf "Yes, rollback\nNo, cancel" \
            | rofi -dmenu -p "⚠ Confirm rollback?" -theme ~/.config/rofi/gruvbox.rasi)
        if [[ "$CONFIRM" == "Yes, rollback" ]]; then
            if command -v timeshift &>/dev/null; then
                kitty -e sudo timeshift --restore
            fi
        fi
        ;;
esac
