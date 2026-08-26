#!/usr/bin/env bash

dir="$HOME/Pictures/screenshots"
mkdir -p "$dir"

file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$1" in
  file)
    sleep 1 && maim --noopengl "$file" && notify-send "Screenshot" "Saved: $file"
    ;;
  clipboard)
    sleep 1 && maim --noopengl "$file" && ffmpeg -y -i "$file" -vf "format=rgb24" -update 1 "${file%.png}.rgb.png" 2>/dev/null && xclip -selection clipboard -t image/png "${file%.png}.rgb.png" && rm -f "${file%.png}.rgb.png" && notify-send "Screenshot" "Copied to clipboard"
    ;;
  *)
    echo "Usage: screenshot.sh {file|clipboard}"
    ;;
esac
