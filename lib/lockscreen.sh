#!/bin/bash

configure_swaylock() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local swaylock_dir="$HOME/.config/swaylock"
    local config_file="$swaylock_dir/config"

    mkdir -p "$swaylock_dir"

    log_info "Configuring Swaylock with Tokyo Night theme..."

    cat > "$config_file" << SWAYLOCKCONF
# Tokyo Night Theme for Swaylock

# Colors
color=${BG}ff
inside-color=${SELECTION}ff
ring-color=${COMMENT}ff
line-color=${BG}ff
text-color=${FG}ff
key-hl-color=${BLUE}ff
bs-hl-color=${RED}ff
inside-clear-color=${GREEN}ff
ring-clear-color=${GREEN}ff
inside-caps-lock-color=${YELLOW}ff
ring-caps-lock-color=${YELLOW}ff
inside-ver-color=${MAGENTA}ff
ring-ver-color=${MAGENTA}ff
inside-wrong-color=${RED}ff
ring-wrong-color=${RED}ff
separator-color=${COMMENT}ff

# Layout
indicator-radius=100
indicator-thickness=7

# Font
font=JetBrains Mono
font-size=24

# Effects
effect-blur=7x5
effect-vignette=0.5:0.5

# Clock
clock
timestr=%R
datestr=%a, %e of %B

# Images (uncomment if you want to use a wallpaper)
# image=/path/to/wallpaper.png

# Other options
show-failed-attempts
ignore-empty-password
SWAYLOCKCONF

    log_success "Swaylock configured with Tokyo Night theme"
}

configure_hyprlock() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local hyprlock_dir="$HOME/.config/hypr"
    local config_file="$hyprlock_dir/hyprlock.conf"

    mkdir -p "$hyprlock_dir"

    log_info "Configuring Hyprlock with Tokyo Night theme..."

    cat > "$config_file" << HYPRLOCKCONF
# Tokyo Night Theme for Hyprlock

# General
general {
    disable_loading_bar = true
    hide_cursor = true
    no_fade_in = false
}

# Background
background {
    monitor =
    path = screenshot
    blur_passes = 3
    blur_size = 8
    noise = 0.0117
    contrast = 0.8916
    brightness = 0.8172
    vibrancy = 0.1696
    vibrancy_darkness = 0.0
}

# Input field
input-field {
    monitor =
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.33
    dots_spacing = 0.15
    dots_center = true
    outer_color = rgb(${BLUE})
    inner_color = rgb(${BG})
    font_color = rgb(${FG})
    fade_on_empty = true
    placeholder_text = <i>Input Password...</i>
    hide_input = false
    position = 0, -20
    halign = center
    valign = center
}

# Label
label {
    monitor =
    text = Hi there, \$USER
    color = rgb(${FG})
    font_size = 25
    font_family = JetBrains Mono
    position = 0, 160
    halign = center
    valign = center
}

# Time
label {
    monitor =
    text = \$TIME
    color = rgb(${BLUE})
    font_size = 90
    font_family = JetBrains Mono
    position = 0, 80
    halign = center
    valign = center
}

# Date
label {
    monitor =
    text = \$DATE
    color = rgb(${COMMENT})
    font_size = 25
    font_family = JetBrains Mono
    position = 0, 0
    halign = center
    valign = center
}
HYPRLOCKCONF

    log_success "Hyprlock configured with Tokyo Night theme"
}

configure_niri_lockscreen() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local niri_dir="$HOME/.config/niri"
    local lockscreen_config="$niri_dir/lockscreen.kdl"

    mkdir -p "$niri_dir"

    log_info "Configuring Niri lockscreen with Tokyo Night theme..."

    cat > "$lockscreen_config" << NIRILOCKCONF
lock-screen {
    background {
        color "${BG}"
    }

    clock {
        format "%H:%M"
        font "JetBrains Mono 48"
        color "${FG}"
        position { x 50%; y 40%; anchor "center"; }
    }

    date {
        format "%A, %B %e"
        font "JetBrains Mono 24"
        color "${COMMENT}"
        position { x 50%; y 50%; anchor "center"; }
    }

    input-field {
        font "JetBrains Mono 24"
        color "${FG}"
        background-color "${SELECTION}"
        border-color "${BLUE}"
        border-width 2
        border-radius 8
        position { x 50%; y 60%; anchor "center"; }
        width 300
    }
}
NIRILOCKCONF

    log_success "Niri lockscreen configured with Tokyo Night theme"
}

configure_lockscreen_tools() {
    local tools="$1"
    local variant="${2:-night}"

    log_info "Configuring lockscreen tools with Tokyo Night theme..."

    for tool in $tools; do
        case "$tool" in
            swaylock)
                configure_swaylock "$variant"
                ;;
            hyprlock)
                configure_hyprlock "$variant"
                ;;
            niri-lock)
                configure_niri_lockscreen "$variant"
                ;;
            wlogout)
                configure_wlogout "$variant"
                ;;
            *)
                log_warn "Unknown lockscreen tool: $tool"
                ;;
        esac
    done

    log_success "Lockscreen tools configured with Tokyo Night theme"
}
