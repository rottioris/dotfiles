#!/usr/bin/env bash

xset q | grep -qi "caps lock.*on" && caps="" || caps=""

i3lock \
  --color=191c20 \
  --blur=5 \
  --clock \
  --ignore-empty-password \
  --show-failed-attempts \
  --time-str="%I:%M %p" \
  --date-str="%A, %B %d $caps" \
  --time-color=a6b5c4 \
  --date-color=74879f \
  --time-size=72 \
  --date-size=18 \
  --inside-color=00000000 \
  --ring-color=00000000 \
  --line-color=00000000 \
  --keyhl-color=00000000 \
  --bshl-color=00000000 \
  --separator-color=00000000 \
  --insidever-color=00000000 \
  --insidewrong-color=00000000 \
  --ringver-color=00000000 \
  --ringwrong-color=00000000 \
  --verif-color=a6b5c4 \
  --wrong-color=e53935 \
  --screen=1
