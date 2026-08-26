#!/usr/bin/env bash

HISTORY_FILE="$HOME/.local/share/clipboard-history"
MAX_ENTRIES=50

mkdir -p "$(dirname "$HISTORY_FILE")"
touch "$HISTORY_FILE"

last_hash=""

add_to_history() {
    local content="$1"
    [ -z "$content" ] && return
    [ ${#content} -gt 500 ] && return

    grep -v -F "$content" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" 2>/dev/null
    mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

    printf '%s\n' "$content" | cat - "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"

    tail -n "$MAX_ENTRIES" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}

while true; do
    # Check if clipboard has text content using xsel (timeout to avoid hang)
    current=$(timeout 1 xsel --clipboard --output 2>/dev/null)
    exit_code=$?

    # Only process if xsel succeeded (exit 0) and content is non-empty text
    if [ $exit_code -eq 0 ] && [ -n "$current" ]; then
        current_hash=$(echo "$current" | md5sum | cut -d' ' -f1)
        if [ "$current_hash" != "$last_hash" ]; then
            last_hash="$current_hash"
            add_to_history "$current"
        fi
    else
        # Clipboard contains non-text (image) or xsel failed, reset hash
        last_hash=""
    fi

    sleep 1
done
