#!/usr/bin/env bash
timeout 3 nmcli -t -f TYPE,DEVICE,NAME con show --active 2>/dev/null | while IFS=: read -r type device conn; do
  case "$type" in
    *wireless*)
      ip=$(ip -4 addr show "$device" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f1)
      [ -n "$ip" ] && echo "󰖩 ${ip}" || echo "󰖩"
      break
      ;;
    *ethernet*)
      ip=$(ip -4 addr show "$device" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f1)
      [ -n "$ip" ] && echo "󰈀 ${ip}" || echo "󰈀"
      break
      ;;
  esac
done
