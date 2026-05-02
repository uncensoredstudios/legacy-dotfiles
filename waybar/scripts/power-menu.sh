#!/usr/bin/env bash

CHOICE=$(printf "󰐥  Shutdown\n󰜉  Reboot\n󰌾  Lock\n󰏥  Suspend\n󰗼  Logout\n✕  Cancel" \
    | rofi -dmenu -p "  Power" -theme ~/.config/rofi/gruvbox.rasi -l 6)

case "$CHOICE" in
    *Shutdown) systemctl poweroff ;;
    *Reboot)   systemctl reboot ;;
    *Lock)     hyprlock ;;
    *Suspend)  systemctl suspend ;;
    *Logout)   hyprctl dispatch exit ;;
esac
