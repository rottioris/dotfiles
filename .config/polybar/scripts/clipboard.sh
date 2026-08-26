#!/usr/bin/env bash

HISTORY_FILE="$HOME/.local/share/clipboard-history"
MAX_ENTRIES=50

mkdir -p "$(dirname "$HISTORY_FILE")"
touch "$HISTORY_FILE"

case "$1" in
    copy)
        # Copy selected text to clipboard and save to history
        text=$(xclip -selection clipboard -o 2>/dev/null)
        if [ -n "$text" ]; then
            # Remove duplicate if exists
            grep -v -F "$text" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" 2>/dev/null
            mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
            # Add to top
            echo "$text" | cat - "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
            # Trim history
            tail -n "$MAX_ENTRIES" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
        fi
        ;;
    choose)
        # Show clipboard history in rofi and copy selection
        if [ -s "$HISTORY_FILE" ]; then
            chosen=$(cat "$HISTORY_FILE" | rofi -dmenu -p "󰅊 Clipboard" -theme ~/.config/rofi/themes/clipboard.rasi 2>/dev/null)
            if [ -n "$chosen" ]; then
                echo -n "$chosen" | xclip -selection clipboard
            fi
        fi
        ;;
    clear)
        > "$HISTORY_FILE"
        ;;
    *)
        echo "Usage: clipboard.sh {copy|choose|clear}"
        ;;
esac
