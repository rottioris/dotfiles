#!/usr/bin/env bash
sink=$(pactl get-default-sink)
cur=$(pactl get-sink-volume "$sink" | grep -oP '\d+(?=%)' | head -1)
[[ "$cur" =~ ^[0-9]+$ ]] || cur=0
case "$1" in
    up)
        new=$((cur + ${2:-5}))
        [ "$new" -gt 150 ] && new=150
        pactl set-sink-volume "$sink" "${new}%"
        ;;
    down)
        new=$((cur - ${2:-5}))
        [ "$new" -lt 0 ] && new=0
        pactl set-sink-volume "$sink" "${new}%"
        ;;
esac
