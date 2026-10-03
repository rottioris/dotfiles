#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Initialize update cache files
echo 0 > /tmp/polybar-updates
echo 0 > /tmp/polybar-updates-official
echo 0 > /tmp/polybar-updates-aur

# Launch the main bar
polybar main &

# Start clipboard monitor (saves mouse selection to history)
~/.config/polybar/scripts/clipboard-monitor.sh &

# Auto-reload on config change
if command -v inotifywait &>/dev/null; then
    while true; do
        inotifywait -q -e modify -e create -e delete \
            "$DIR/config.ini" \
            "$DIR/colors.ini" \
            "$DIR/modules.ini"
        polybar-msg cmd restart
    done
fi
