function vpnoff --description "Disconnect VPN (WireGuard)"
    set -l active (nmcli -t -f NAME,TYPE connection show --active | grep wireguard | cut -d: -f1)
    if test -z "$active"
        echo "No active WireGuard connection."
        return 1
    end
    for conn in $active
        nmcli connection down $conn
    end
end
