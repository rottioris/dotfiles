#!/usr/bin/env bash
dir="$HOME/Pictures/screenshots"
mkdir -p "$dir"

OUTDIR="$HOME/Videos"
PIDFILE="/tmp/recording.pid"
ACTIVEFILE="/tmp/recording.active"

if [ -f "$ACTIVEFILE" ]; then
    rec_option="󰑉  Stop recording"
else
    rec_option="󰀹  Start recording"
fi

options="󰹑  Full screen → file"
options+="\n󰖲  Active window → file"
options+="\n󰆞  Select region → file"
options+="\n󰃌  Full screen → clipboard"
options+="\n󰃐  Region → clipboard"
options+="\n${rec_option}"

chosen=$(echo -e "$options" | rofi -dmenu -p "󰄀  Capture" -theme ~/.config/rofi/themes/capture.rasi 2>/dev/null)
[ -z "$chosen" ] && exit

file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

case "$chosen" in
  *"Full screen → file")
    sleep 1 && maim --noopengl "$file" && notify-send "Screenshot" "Saved: $file"
    ;;
  *"Active window → file")
    sleep 1 && id=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $5}') && [ -n "$id" ] && maim --noopengl -i "$id" "$file" && notify-send "Screenshot" "Saved: $file"
    ;;
  *"Select region → file")
    sleep 1 && maim --noopengl -s "$file" && notify-send "Screenshot" "Saved: $file"
    ;;
  *"Full screen → clipboard")
    sleep 1 && maim --noopengl "$file" && ffmpeg -y -i "$file" -vf "format=rgb24" -update 1 "${file%.png}.rgb.png" 2>/dev/null && xclip -selection clipboard -t image/png "${file%.png}.rgb.png" && rm -f "${file%.png}.rgb.png" && notify-send "Screenshot" "Copied to clipboard"
    ;;
  *"Region → clipboard")
    sleep 1 && maim --noopengl -s "$file" && ffmpeg -y -i "$file" -vf "format=rgb24" -update 1 "${file%.png}.rgb.png" 2>/dev/null && xclip -selection clipboard -t image/png "${file%.png}.rgb.png" && rm -f "${file%.png}.rgb.png" && notify-send "Screenshot" "Copied to clipboard"
    ;;
  *"Start recording"*)
    mkdir -p "$OUTDIR"
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    OUTFILE="$OUTDIR/recording-$TIMESTAMP.mp4"
    RESOLUTION=$(xrandr | grep ' connected' | grep -oP '\d+x\d+' | head -1)
    DEFAULT_SINK=$(pactl get-default-sink)
    MONITOR_SOURCE="${DEFAULT_SINK}.monitor"
    ffmpeg -y -nostdin \
           -f x11grab -framerate 60 -s "$RESOLUTION" -i :0.0 \
           -f pulse -i "$MONITOR_SOURCE" \
           -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
           -c:a aac -b:a 192k \
           -movflags +frag_keyframe+empty_moov \
           "$OUTFILE" &
    echo $! > "$PIDFILE"
    touch "$ACTIVEFILE"
    notify-send "  Recording started" "$OUTFILE"
    ;;
  *"Stop recording"*)
    sleep 0.1
    if [ -f "$PIDFILE" ]; then
        kill -INT "$(cat "$PIDFILE")" 2>/dev/null
        rm -f "$PIDFILE"
    fi
    rm -f "$ACTIVEFILE"
    notify-send "  Recording stopped"
    ;;
esac
