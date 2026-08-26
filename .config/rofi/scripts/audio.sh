#!/usr/bin/env bash
THEME="$HOME/.config/rofi/themes/audio.rasi"

get_desc() {
    local name="$1" type="$2"
    pactl list "${type}s" 2>/dev/null | awk -v n="$name" '
        /Name:/ { found = $2 }
        /Description:/ && found == n { sub(/^[ \t]*Description: /, ""); print; exit }
    '
}

get_volume() {
    local name="$1" type="$2"
    pactl get-${type}-volume "$name" 2>/dev/null | awk -F'/' '{print $2}' | xargs
}

volume_bar() {
    local pct="$1"
    pct=${pct%\%}
    [[ "$pct" =~ ^[0-9]+$ ]] || { echo "-----"; return; }
    local full=$((pct / 20))
    [ "$full" -gt 5 ] && full=5
    [ "$full" -lt 0 ] && full=0
    local empty=$((5 - full))
    local bar=""
    for ((i=0; i<full; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    echo "$bar"
}

main_menu() {
    local options
    options="󰕾  Output device"
    options+="\n  Input device"

    echo -e "$options" | rofi -dmenu -p "󰓃  Audio" -theme-str 'window { width: 200px; }' -theme "$THEME" 2>/dev/null
}

output_menu() {
    while true; do
        local default_sink options result code sink_muted
        declare -A names
        default_sink=$(pactl get-default-sink 2>/dev/null)
        options=""

        if pactl get-sink-mute "$default_sink" 2>/dev/null | grep -q "yes"; then
            sink_muted="  Unmute"
        else
            sink_muted="󰕾  Mute"
        fi

        while IFS= read -r line; do
            name=$(echo "$line" | awk '{print $2}')
            desc=$(get_desc "$name" sink)
            vol=$(get_volume "$name" sink)
            bar=$(volume_bar "$vol")
            [ "$name" = "$default_sink" ] && mark="●" || mark="○"
            entry="${mark}  ${desc::25}  [${bar}]  ${vol}"
            options+="${entry}\n"
            names["$entry"]="$name"
        done < <(pactl list sinks short 2>/dev/null)

        [ -z "$options" ] && { notify-send "Audio" "No output devices"; return 0; }

        options+="${sink_muted}\n"
        options+="←  Back"

        result=$(echo -e "$options" | rofi -dmenu -p "󰕾  ▲ Alt+A    ▼ Alt+D" -theme-str 'window { width: 380px; }' \
            -kb-custom-1 "Alt+a" -kb-custom-2 "Alt+d" -theme "$THEME" 2>/dev/null)
        code=$?

        [ -z "$result" ] && [ "$code" -ne 10 ] && [ "$code" -ne 11 ] && return 0

        case $code in
            0)
                if [[ "$result" == *"Unmute"* ]]; then
                    pactl set-sink-mute "$default_sink" 0
                    notify-send "Audio" "Output unmuted"
                    continue
                elif [[ "$result" == *"Mute"* ]]; then
                    pactl set-sink-mute "$default_sink" 1
                    notify-send "Audio" "Output muted"
                    continue
                elif [[ "$result" == *"Back"* ]]; then
                    return 1
                fi

                name="${names[$result]}"
                [ -z "$name" ] && continue
                pactl set-default-sink "$name"
                desc=$(get_desc "$name" sink)
                notify-send "Audio" "Output: ${desc}"
                return 0
                ;;
            10)
                cur=$(pactl get-sink-volume "$default_sink" 2>/dev/null | awk -F'/' '{print $2}' | xargs)
                cur=${cur%\%}
                [[ "$cur" =~ ^[0-9]+$ ]] || cur=0
                new=$((cur - 5))
                [ "$new" -lt 0 ] && new=0
                pactl set-sink-volume "$default_sink" "${new}%"
                ;;
            11)
                cur=$(pactl get-sink-volume "$default_sink" 2>/dev/null | awk -F'/' '{print $2}' | xargs)
                cur=${cur%\%}
                [[ "$cur" =~ ^[0-9]+$ ]] || cur=0
                new=$((cur + 5))
                [ "$new" -gt 150 ] && new=150
                pactl set-sink-volume "$default_sink" "${new}%"
                ;;
            *) return 0 ;;
        esac
    done
}

input_menu() {
    while true; do
        local default_source options result code source_muted
        declare -A names
        default_source=$(pactl get-default-source 2>/dev/null)
        options=""

        if pactl get-source-mute "$default_source" 2>/dev/null | grep -q "yes"; then
            source_muted="  Unmute"
        else
            source_muted="  Mute"
        fi

        while IFS= read -r line; do
            name=$(echo "$line" | awk '{print $2}')
            echo "$name" | grep -qi "monitor" && continue
            desc=$(get_desc "$name" source)
            vol=$(get_volume "$name" source)
            bar=$(volume_bar "$vol")
            [ "$name" = "$default_source" ] && mark="●" || mark="○"
            entry="${mark}  ${desc::25}  [${bar}]  ${vol}"
            options+="${entry}\n"
            names["$entry"]="$name"
        done < <(pactl list sources short 2>/dev/null)

        [ -z "$options" ] && { notify-send "Audio" "No input devices"; return 0; }

        options+="${source_muted}\n"
        options+="←  Back"

        result=$(echo -e "$options" | rofi -dmenu -p "  ▲ Alt+A    ▼ Alt+D" -theme-str 'window { width: 380px; }' \
            -kb-custom-1 "Alt+a" -kb-custom-2 "Alt+d" -theme "$THEME" 2>/dev/null)
        code=$?

        [ -z "$result" ] && [ "$code" -ne 10 ] && [ "$code" -ne 11 ] && return 0

        case $code in
            0)
                if [[ "$result" == *"Unmute"* ]]; then
                    pactl set-source-mute "$default_source" 0
                    notify-send "Mic" "Unmuted"
                    continue
                elif [[ "$result" == *"Mute"* ]]; then
                    pactl set-source-mute "$default_source" 1
                    notify-send "Mic" "Muted"
                    continue
                elif [[ "$result" == *"Back"* ]]; then
                    return 1
                fi

                name="${names[$result]}"
                [ -z "$name" ] && continue
                pactl set-default-source "$name"
                desc=$(get_desc "$name" source)
                notify-send "Audio" "Input: ${desc}"
                return 0
                ;;
            10)
                cur=$(pactl get-source-volume "$default_source" 2>/dev/null | awk -F'/' '{print $2}' | xargs)
                cur=${cur%\%}
                [[ "$cur" =~ ^[0-9]+$ ]] || cur=0
                new=$((cur - 5))
                [ "$new" -lt 0 ] && new=0
                pactl set-source-volume "$default_source" "${new}%"
                ;;
            11)
                cur=$(pactl get-source-volume "$default_source" 2>/dev/null | awk -F'/' '{print $2}' | xargs)
                cur=${cur%\%}
                [[ "$cur" =~ ^[0-9]+$ ]] || cur=0
                new=$((cur + 5))
                [ "$new" -gt 150 ] && new=150
                pactl set-source-volume "$default_source" "${new}%"
                ;;
            *) return 0 ;;
        esac
    done
}

# === Main ===

while true; do
    choice=$(main_menu)
    [ -z "$choice" ] && exit

    case "$choice" in
        *"Output device"*)
            output_menu
            [ $? -ne 1 ] && exit
            ;;
        *"Input device"*)
            input_menu
            [ $? -ne 1 ] && exit
            ;;
    esac
done
