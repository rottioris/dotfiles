#!/usr/bin/env bash
PIDFILE="/tmp/recording.pid"
ACTIVEFILE="/tmp/recording.active"
OUTDIR="$HOME/Videos"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
OUTFILE="$OUTDIR/recording-$TIMESTAMP.mp4"

mkdir -p "$OUTDIR"

if [ -f "$ACTIVEFILE" ]; then
    sleep 0.1
    if [ -f "$PIDFILE" ]; then
        kill "$(cat "$PIDFILE")" 2>/dev/null
        rm -f "$PIDFILE"
    fi
    rm -f "$ACTIVEFILE"
    notify-send "  Recording stopped"
else
    RESOLUTION=$(xrandr | grep ' connected' | grep -oP '\d+x\d+' | head -1)
    DEFAULT_SINK=$(pactl get-default-sink)
    MONITOR_SOURCE="${DEFAULT_SINK}.monitor"
    ffmpeg -y -nostdin \
           -f x11grab -framerate 60 -s "$RESOLUTION" -i :0.0 \
           -f pulse -i "$MONITOR_SOURCE" \
           -c:v libx264 -preset medium -crf 20 \
           -c:a aac -b:a 192k \
           -movflags +frag_keyframe+empty_moov \
           "$OUTFILE" &
    echo $! > "$PIDFILE"
    touch "$ACTIVEFILE"
    notify-send "  Recording started" "$OUTFILE"
fi
