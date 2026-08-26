#!/usr/bin/env bash

if [ -f /tmp/recording.active ]; then
  pid=$(cat /tmp/recording.pid 2>/dev/null)
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    echo "%{F#e53935}󰑌%{F-}"
  else
    rm -f /tmp/recording.active /tmp/recording.pid
    echo "󰄀"
  fi
else
  echo "󰄀"
fi
