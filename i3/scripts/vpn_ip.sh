#!/bin/bash

ICON_VPN="    "
ICON_NO_VPN="    "
ICON_OFFLINE="   "

# Interfaces VPN a buscar
vpn_interfaces=("tun0" "wg0" "ppp0" "proton0" "pvpnksintrf1")

vpn_active=false
for iface in "${vpn_interfaces[@]}"; do
    if ip addr show "$iface" up scope global >/dev/null 2>&1; then
        vpn_active=true
        break
    fi
done

# Verificar conexión a internet
if ! curl -s --max-time 2 https://ipinfo.io/ip >/dev/null; then
    echo "$ICON_OFFLINE Sin conexión"
    exit 0
fi

ip=$(curl -s --max-time 2 https://ipinfo.io/ip)

if [ -z "$ip" ]; then
    ip="Sin conexión"
fi

if $vpn_active; then
    echo "$ICON_VPN $ip"
else
    echo "$ICON_NO_VPN $ip"
fi
