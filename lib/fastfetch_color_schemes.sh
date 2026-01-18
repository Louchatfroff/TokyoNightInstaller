#!/bin/bash

configure_fastfetch_color_scheme() {
    local color_scheme="${1:-tokyo-night}"
    local fastfetch_dir="$HOME/.config/fastfetch"
    local config_file="$fastfetch_dir/config.jsonc"

    echo "[VERBOSE] Creating fastfetch directory: $fastfetch_dir"
    mkdir -p "$fastfetch_dir"

    echo "[VERBOSE] Configuring fastfetch with $color_scheme color scheme..."

    if [ ! -f "$config_file" ]; then
        echo "[VERBOSE] No existing config found, generating default..."
        generate_fastfetch_config "" "" "small" > "$config_file"
    else
        echo "[VERBOSE] Using existing config file: $config_file"
    fi

    case "$color_scheme" in
        tokyo-night)
            jq '.display.color = {"keys": "blue", "title": "magenta", "separator": "cyan"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-storm)
            jq '.display.color = {"keys": "cyan", "title": "magenta", "separator": "blue"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-light)
            jq '.display.color = {"keys": "blue", "title": "magenta", "separator": "cyan"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-night-night)
            jq '.display.color = {"keys": "#7aa2f7", "title": "#bb9af7", "separator": "#7dcfff"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-night-storm)
            jq '.display.color = {"keys": "#7dcfff", "title": "#bb9af7", "separator": "#7aa2f7"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-night-light)
            jq '.display.color = {"keys": "#34548a", "title": "#5a4a78", "separator": "#0f4b6e"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        classic)
            jq '.display.color = {"keys": "red", "title": "green", "separator": "blue"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        rainbow)
            jq '.display.color = {"keys": "red", "title": "yellow", "separator": "green"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        *)
            echo "[WARN] Unknown color scheme: $color_scheme, using tokyo-night"
            configure_fastfetch_color_scheme "tokyo-night"
            return
            ;;
    esac

    echo "[SUCCESS] Fastfetch configured with $color_scheme color scheme"
}

generate_fastfetch_config() {
    local logo_source="$1"
    local logo_type="$2"
    local logo_size="$3"

    echo "[VERBOSE] Generating fastfetch config with logo_source=$logo_source, logo_type=$logo_type, logo_size=$logo_size"

    local logo_config
    if [ -n "$logo_source" ]; then
        logo_config=$(cat << LOGOCONF
    "logo": {
        "source": "$logo_source",
        "type": "$logo_type",
        "padding": {
            "top": 0,
            "left": 1,
            "right": 2
        }
    },
LOGOCONF
)
    else
        logo_config=$(cat << LOGOCONF
    "logo": {
        "type": "auto",
        "padding": {
            "top": 0,
            "left": 1,
            "right": 2
        }
    },
LOGOCONF
)
    fi

    cat << FASTFETCHCONF
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
$logo_config
    "display": {
        "separator": " : ",
        "color": {
            "keys": "blue",
            "title": "magenta"
        }
    },
    "modules": [
        {
            "type": "title",
            "format": "{user-name}@{host-name}"
        },
        {
            "type": "separator",
            "string": "─"
        },
        {
            "type": "os",
            "key": "OS   ",
            "keyColor": "blue"
        },
        {
            "type": "kernel",
            "key": "Ker  ",
            "keyColor": "cyan"
        },
        {
            "type": "shell",
            "key": "Sh   ",
            "keyColor": "green"
        },
        {
            "type": "wm",
            "key": "WM   ",
            "keyColor": "yellow"
        },
        {
            "type": "terminal",
            "key": "Term ",
            "keyColor": "magenta"
        },
        {
            "type": "cpu",
            "key": "CPU  ",
            "keyColor": "red",
            "showPeCoreCount": false
        },
        {
            "type": "memory",
            "key": "Mem  ",
            "keyColor": "cyan"
        }
    ]
}
FASTFETCHCONF
}
