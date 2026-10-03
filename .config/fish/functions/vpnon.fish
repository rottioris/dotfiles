function vpnon --description "Connect to VPN (WireGuard)"
    set -l connections (nmcli -t -f NAME,TYPE connection show | grep wireguard | cut -d: -f1)
    if test (count $connections) -eq 0
        echo "No WireGuard connections found. Import first with:"
        echo "  doas nmcli connection import type wireguard file ~/.config/wireguard/<file>.conf"
        return 1
    end
    if test (count $connections) -eq 1
        nmcli connection up $connections[1]
    else
        set -l chosen (printf '%s\n' $connections | fzf --prompt="VPN> " --height=40%)
        if test -n "$chosen"
            nmcli connection up $chosen
        else
            echo "Cancelled"
            return 1
        end
    end
end
