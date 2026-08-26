#!/bin/bash
# Polybar updates check (fast, no sync)

official=$(pacman -Qu 2>/dev/null | wc -l)
aur=$(paru -Qum 2>/dev/null | wc -l)
total=$((official + aur))

if [[ "$total" -gt 0 ]]; then
    echo ""
    exit 0
else
    exit 1
fi
