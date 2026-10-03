#!/usr/bin/env bash

PIDFILE="/tmp/recording.pid"
ACTIVEFILE="/tmp/recording.active"
OUTDIR="$HOME/Videos"

if [ -f "$ACTIVEFILE" ]; then
  pid=$(cat /tmp/recording.pid 2>/dev/null)
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    kill -INT "$pid" 2>/dev/null
    rm -f /tmp/recording.active /tmp/recording.pid
  else
    rm -f /tmp/recording.active /tmp/recording.pid
  fi
else
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
  echo $! > /tmp/recording.pid
  touch /tmp/recording.active
fi
