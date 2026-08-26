#!/usr/bin/env bash
lines=""

while IFS=: read -r type device conn; do
  case "$type" in
    *wireless*)
      ip=$(ip -4 addr show "$device" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f1)
      speed=$(cat /sys/class/net/"$device"/speed 2>/dev/null || echo "?")
      gateway=$(ip route show default 2>/dev/null | awk '{print $3}')
      lines+="  ${conn}\n"
      lines+="   ${ip}  ·  ${speed} Mb/s  ·  Gateway ${gateway}\n"
      ;;
    *ethernet*)
      ip=$(ip -4 addr show "$device" 2>/dev/null | grep -w inet | awk '{print $2}' | cut -d/ -f1)
      speed=$(cat /sys/class/net/"$device"/speed 2>/dev/null || echo "?")
      gateway=$(ip route show default 2>/dev/null | awk '{print $3}')
      lines+="  ${conn:-${device}}\n"
      lines+="   ${ip}  ·  ${speed} Mb/s  ·  Gateway ${gateway}\n"
      ;;
  esac
done < <(nmcli -t -f TYPE,DEVICE,NAME con show --active 2>/dev/null)

while IFS=: read -r ssid signal security; do
  [ -z "$ssid" ] && continue
  if [ "$signal" -le 25 ]; then
    icon="󰤟"
  elif [ "$signal" -le 50 ]; then
    icon="󰤢"
  elif [ "$signal" -le 75 ]; then
    icon="󰤥"
  else
    icon="󰤨"
  fi
  lines+="${icon}  ${ssid}  (${signal}%)  ${security}\n"
done < <(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list --rescan auto 2>/dev/null | sort -t: -k2 -rn | uniq)

lines+="  Rescan\n"
lines+="  Disconnect"

chosen=$(echo -e "$lines" | rofi -dmenu -p "󰖩  Network" -theme ~/.config/rofi/themes/network.rasi 2>/dev/null)
[ -z "$chosen" ] && exit

case "$chosen" in
  "  Rescan")
    nmcli dev wifi rescan
    notify-send "Network" "Wi-Fi scan done"
    ;;
  "  Disconnect")
    nmcli networking off && sleep 1 && nmcli networking on
    notify-send "Network" "Reconnecting..."
    ;;
  *)
    ssid=$(echo "$chosen" | sed 's/^[^ ]*  //; s/  ([0-9]\+%)  .*//')
    security=$(echo "$chosen" | grep -oP '\([0-9]+%\)\s+\K.*' || echo "")
    if [ -n "$ssid" ] && echo "$security" | grep -qi "wpa\|WPA\|WEP\|wep"; then
      pass=$(rofi -dmenu -p "Password for $ssid" -password \
        -theme-str 'window { width: 360px; } inputbar { children: [ prompt, entry ]; }' \
        -theme ~/.config/rofi/themes/network.rasi 2>/dev/null)
      [ -z "$pass" ] && exit
      nmcli dev wifi connect "$ssid" password "$pass" 2>/dev/null && notify-send "Network" "Connected to $ssid" || notify-send "Network" "Failed to connect to $ssid"
    elif [ -n "$ssid" ]; then
      nmcli dev wifi connect "$ssid" 2>/dev/null && notify-send "Network" "Connected to $ssid" || notify-send "Network" "Failed to connect to $ssid"
    fi
    ;;
esac
