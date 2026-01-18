#!/bin/bash

configure_fastfetch_color_scheme() {
    local color_scheme="${1:-tokyo-night}"
    local fastfetch_dir="$HOME/.config/fastfetch"
    local config_file="$fastfetch_dir/config.jsonc"

    mkdir -p "$fastfetch_dir"

    log_info "Configuring fastfetch with $color_scheme color scheme..."

    # Read existing config or create default
    if [ ! -f "$config_file" ]; then
        generate_fastfetch_config "" "" "small" > "$config_file"
    fi

    case "$color_scheme" in
        tokyo-night)
            # Default Tokyo Night colors (blue, magenta, cyan)
            jq '.display.color = {"keys": "blue", "title": "magenta", "separator": "cyan"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-storm)
            # Tokyo Storm variant (slightly darker)
            jq '.display.color = {"keys": "cyan", "title": "magenta", "separator": "blue"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        tokyo-light)
            # Tokyo Light colors
            jq '.display.color = {"keys": "blue", "title": "magenta", "separator": "cyan"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        classic)
            # Classic colors (red, green, blue)
            jq '.display.color = {"keys": "red", "title": "green", "separator": "blue"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        rainbow)
            # Rainbow colors
            jq '.display.color = {"keys": "red", "title": "yellow", "separator": "green"}' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            ;;
        *)
            log_warn "Unknown color scheme: $color_scheme, using tokyo-night"
            configure_fastfetch_color_scheme "tokyo-night"
            return
            ;;
    esac

    log_success "Fastfetch configured with $color_scheme color scheme"
}
