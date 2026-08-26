#!/usr/bin/env bash
sink=$(pactl get-default-sink 2>/dev/null) || exit
source=$(pactl get-default-source 2>/dev/null) || source=""

vol=$(pactl get-sink-volume "$sink" 2>/dev/null | grep -oP '\d+(?=%)' | head -1)
[ -z "$vol" ] && vol="0"
muted=$(pactl get-sink-mute "$sink" 2>/dev/null | grep -q yes && echo 1 || echo 0)
[ "$muted" = 1 ] && out="  ${vol}%" || out="  ${vol}%"

if [ -n "$source" ] && pactl get-source-mute "$source" 2>/dev/null | grep -q yes; then
  out+="  "
fi

echo "$out"
