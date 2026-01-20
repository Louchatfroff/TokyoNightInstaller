#!/bin/bash

configure_hyprland_waybar() {
    local variant="${1:-night}"
    local waybar_dir="$HOME/.config/waybar"
    local config_file="$waybar_dir/config.jsonc"
    local style_file="$waybar_dir/style.css"
    local hyprland_config_file="$waybar_dir/hyprland-config.jsonc"

    echo "[VERBOSE] Configuring Hyprland-specific Waybar compatibility..."

    mkdir -p "$waybar_dir"

    get_tokyonight_colors "$variant"

    cat > "$hyprland_config_file" << HYPRWAYBARCONF
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,
    "modules-left": [
        "hyprland/workspaces",
        "hyprland/submap",
        "hyprland/window"
    ],
    "modules-center": [
        "hyprland/active-workspace"
    ],
    "modules-right": [
        "pulseaudio",
        "network",
        "cpu",
        "memory",
        "temperature",
        "backlight",
        "battery",
        "clock",
        "tray",
        "hyprland/keyboard-layout"
    ],

    // Hyprland-specific modules
    "hyprland/workspaces": {
        "format": "{name}",
        "on-click": "activate",
        "sort-by-number": true,
        "active-only": false,
        "all-outputs": false,
        "show-special": false,
        "tooltip": true,
        "tooltip-format": "Workspace {name}"
    },

    "hyprland/submap": {
        "format": "✦ {}",
        "tooltip": true,
        "tooltip-format": "Submap: {}"
    },

    "hyprland/window": {
        "format": "{}",
        "max-length": 50,
        "tooltip": true,
        "tooltip-format": "Window: {}"
    },

    "hyprland/active-workspace": {
        "format": "🎯 {}",
        "tooltip": true,
        "tooltip-format": "Active Workspace: {}"
    },

    "hyprland/keyboard-layout": {
        "format": "{}",
        "tooltip": true,
        "tooltip-format": "Keyboard Layout: {}"
    },

    // Standard modules with Hyprland enhancements
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon}",
        "format-muted": "🔇",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["🔊", "🔊"]
        },
        "on-click": "pavucontrol",
        "on-click-right": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "tooltip": true,
        "tooltip-format": "Volume: {volume}%"
    },

    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "max-length": 50,
        "on-click": "nm-connection-editor",
        "tooltip": true
    },

    "cpu": {
        "format": "{usage}% ",
        "tooltip": true,
        "tooltip-format": "CPU Usage: {usage}%"
    },

    "memory": {
        "format": "{}% ",
        "tooltip": true,
        "tooltip-format": "Memory: {used}/{total} ({percent}%)"
    },

    "temperature": {
        "thermal-zone": 2,
        "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "critical-threshold": 80,
        "format-critical": "{temperatureC}°C {icon}",
        "format": "{temperatureC}°C {icon}",
        "format-icons": ["", "", ""],
        "tooltip": true,
        "tooltip-format": "Temperature: {temperatureC}°C"
    },

    "backlight": {
        "device": "intel_backlight",
        "format": "{percent}% {icon}",
        "format-icons": ["", ""],
        "tooltip": true,
        "tooltip-format": "Backlight: {percent}%"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{capacity}% {icon}",
        "format-charging": "{capacity}% ",
        "format-plugged": "{capacity}% ",
        "format-alt": "{time} {icon}",
        "format-icons": ["", "", "", "", ""],
        "tooltip": true,
        "tooltip-format": "Battery: {capacity}% ({time})"
    },

    "clock": {
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format-alt": "{:%Y-%m-%d}",
        "tooltip": true,
        "tooltip-format": "Date: {:%Y-%m-%d}\nTime: {:%H:%M:%S}"
    },

    "tray": {
        "spacing": 10,
        "tooltip": true
    }
}
HYPRWAYBARCONF

    # Create enhanced Hyprland-specific CSS styling
    local hyprland_style_file="$waybar_dir/hyprland-style.css"
    cat > "$hyprland_style_file" << HYPRWAYBARCSS
* {
    font-family: "JetBrains Mono", "Fira Code", "Font Awesome 6 Free", "Nerd Font", monospace;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: ${BG};
    color: ${FG};
    border-bottom: 2px solid ${BLUE};
    transition: all 0.3s ease;
}

window#waybar.hidden {
    opacity: 0.5;
    transition: opacity 0.3s ease;
}

window#waybar:hover {
    border-bottom: 3px solid ${CYAN};
}

/* Hyprland-specific workspace styling */
#workspaces {
    background-color: ${BG};
    border-radius: 8px;
    margin: 4px;
    padding: 0 4px;
    transition: all 0.2s ease;
}

#workspaces button {
    background-color: transparent;
    color: ${COMMENT};
    padding: 4px 8px;
    margin: 4px 2px;
    border-radius: 6px;
    border: none;
    transition: all 0.2s ease;
}

#workspaces button:hover {
    background-color: ${SELECTION};
    color: ${FG};
    transform: translateY(-1px);
}

#workspaces button.active,
#workspaces button.focused {
    background-color: ${BLUE};
    color: ${BG};
    box-shadow: 0 2px 4px rgba(122, 162, 247, 0.3);
}

#workspaces button.urgent {
    background-color: ${RED};
    color: ${BG};
    animation: pulse 1s infinite;
}

/* Submap indicator */
#submap {
    background-color: ${YELLOW};
    color: ${BG};
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 8px;
    font-weight: bold;
    transition: all 0.2s ease;
}

#submap:hover {
    background-color: ${ORANGE};
    transform: scale(1.05);
}

/* Active workspace indicator */
#hyprland-active-workspace {
    background-color: ${MAGENTA};
    color: ${BG};
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 8px;
    font-weight: bold;
}

/* Keyboard layout indicator */
#hyprland-keyboard-layout {
    background-color: ${CYAN};
    color: ${BG};
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 8px;
}

/* Module styling with enhanced tooltips */
#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#tray,
#mode,
#idle_inhibitor,
#power-profiles-daemon,
#mpd {
    background-color: ${BG};
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 8px;
    transition: all 0.2s ease;
}

#clock {
    color: ${MAGENTA};
    font-weight: bold;
}

#clock:hover {
    background-color: ${SELECTION};
    transform: translateY(-1px);
}

#battery {
    color: ${GREEN};
    transition: all 0.3s ease;
}

#battery.charging, #battery.plugged {
    color: ${CYAN};
}

#battery.warning:not(.charging) {
    color: ${YELLOW};
    animation: blink 0.8s linear infinite alternate;
}

#battery.critical:not(.charging) {
    background-color: ${RED};
    color: ${BG};
    animation: pulse 0.5s infinite;
}

@keyframes blink {
    to {
        background-color: ${BG};
        color: ${RED};
    }
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

#cpu {
    color: ${CYAN};
}

#memory {
    color: ${MAGENTA};
}

#network {
    color: ${CYAN};
}

#network.disconnected {
    color: ${RED};
    animation: blink 0.8s linear infinite alternate;
}

#pulseaudio,
#wireplumber {
    color: ${BLUE};
}

#pulseaudio.muted,
#wireplumber.muted {
    color: ${COMMENT};
}

#temperature {
    color: ${GREEN};
}

#temperature.critical {
    background-color: ${RED};
    color: ${BG};
    animation: pulse 0.5s infinite;
}

#tray {
    color: ${FG};
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: ${YELLOW};
    animation: pulse 0.8s infinite;
}

#window {
    color: ${FG};
    padding: 4px 12px;
    transition: all 0.2s ease;
}

#window:hover {
    background-color: ${SELECTION};
}

/* Enhanced tooltip styling */
tooltip {
    background-color: ${BG};
    border: 1px solid ${BLUE};
    border-radius: 8px;
    padding: 8px 12px;
    font-size: 12px;
    max-width: 400px;
}

tooltip label {
    color: ${FG};
    padding: 4px;
}

/* Window title styling */
#hyprland-window {
    background-color: ${SELECTION};
    color: ${FG};
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 8px;
    max-width: 300px;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;
}
HYPRWAYBARCSS

    # Merge configurations if they exist
    if [ -f "$config_file" ]; then
        echo "[VERBOSE] Merging Hyprland Waybar configuration with existing config..."
        local backup_file="$config_file.backup.$(date +%Y%m%d%H%M%S)"
        cp "$config_file" "$backup_file"
        log_info "Backed up existing Waybar config to $backup_file"

        # Create merged configuration
        jq -s '.[0] * .[1]' "$config_file" "$hyprland_config_file" > "${config_file}.tmp" 2>/dev/null && mv "${config_file}.tmp" "$config_file" || cp "$hyprland_config_file" "$config_file"
    else
        cp "$hyprland_config_file" "$config_file"
    fi

    # Merge CSS styles
    if [ -f "$style_file" ]; then
        echo "[VERBOSE] Merging Hyprland Waybar CSS with existing style..."
        local backup_style="$style_file.backup.$(date +%Y%m%d%H%M%S)"
        cp "$style_file" "$backup_style"
        log_info "Backed up existing Waybar style to $backup_style"

        # Append Hyprland-specific styles
        cat "$hyprland_style_file" >> "$style_file"
    else
        cat > "$style_file" << WAYBARMAINCSS
@import "hyprland-style.css";

* {
    font-family: "JetBrains Mono", "Fira Code", "Font Awesome 6 Free", monospace;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: ${BG};
    color: ${FG};
    border-bottom: 2px solid ${BLUE};
}
WAYBARMAINCSS
    fi

    echo "[SUCCESS] Hyprland Waybar compatibility configured"
}

configure_hyprland_fastfetch() {
    local variant="${1:-night}"
    local fastfetch_dir="$HOME/.config/fastfetch"
    local config_file="$fastfetch_dir/config.jsonc"
    local hyprland_config_file="$fastfetch_dir/hyprland-config.jsonc"

    echo "[VERBOSE] Configuring Hyprland-specific Fastfetch compatibility..."

    mkdir -p "$fastfetch_dir"

    get_tokyonight_colors "$variant"

    cat > "$hyprland_config_file" << HYPRFASTFETCHCONF
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "auto",
        "padding": {
            "top": 0,
            "left": 1,
            "right": 2
        }
    },
    "display": {
        "separator": " : ",
        "color": {
            "keys": "#7aa2f7",
            "title": "#bb9af7",
            "separator": "#7dcfff"
        },
        "show-errors": false,
        "show-warnings": false
    },
    "modules": [
        {
            "type": "title",
            "format": "{user-name}@{host-name}",
            "key": "User",
            "keyColor": "#7aa2f7"
        },
        {
            "type": "separator",
            "string": "─"
        },
        {
            "type": "os",
            "key": "OS   ",
            "keyColor": "#7aa2f7",
            "format": "{name} {version}"
        },
        {
            "type": "kernel",
            "key": "Ker  ",
            "keyColor": "#7dcfff",
            "format": "{version}"
        },
        {
            "type": "wm",
            "key": "WM   ",
            "keyColor": "#e0af68",
            "format": "{name} {version}"
        },
        {
            "type": "de",
            "key": "DE   ",
            "keyColor": "#9ece6a",
            "format": "{name} {version}"
        },
        {
            "type": "shell",
            "key": "Sh   ",
            "keyColor": "#9ece6a",
            "format": "{name} {version}"
        },
        {
            "type": "terminal",
            "key": "Term ",
            "keyColor": "#bb9af7",
            "format": "{name} {version}"
        },
        {
            "type": "cpu",
            "key": "CPU  ",
            "keyColor": "#f7768e",
            "format": "{name} ({usage}%)",
            "showPeCoreCount": false
        },
        {
            "type": "memory",
            "key": "Mem  ",
            "keyColor": "#7dcfff",
            "format": "{used}/{total} ({percent}%)"
        },
        {
            "type": "gpu",
            "key": "GPU  ",
            "keyColor": "#ff9e64",
            "format": "{name} {driver} ({usage}%)"
        },
        {
            "type": "disk",
            "key": "Disk ",
            "keyColor": "#e0af68",
            "format": "{used}/{total} ({percent}%)",
            "mount": "/"
        },
        {
            "type": "battery",
            "key": "Bat  ",
            "keyColor": "#9ece6a",
            "format": "{capacity}% {time}"
        },
        {
            "type": "temperature",
            "key": "Temp ",
            "keyColor": "#7dcfff",
            "format": "{temperatureC}°C"
        },
        {
            "type": "uptime",
            "key": "Up   ",
            "keyColor": "#bb9af7",
            "format": "{days}d {hours}h {minutes}m"
        },
        {
            "type": "localip",
            "key": "IP   ",
            "keyColor": "#7aa2f7",
            "format": "{ipaddr}"
        },
        {
            "type": "publicip",
            "key": "PubIP",
            "keyColor": "#7aa2f7",
            "format": "{ipaddr}"
        }
    ],
    "custom": {
        "hyprland": {
            "key": "Hypr ",
            "keyColor": "#bb9af7",
            "format": "Hyprland {version}",
            "command": "hyprctl version | head -1 | cut -d' ' -f2"
        },
        "waybar": {
            "key": "Bar  ",
            "keyColor": "#e0af68",
            "format": "Waybar {version}",
            "command": "waybar --version | head -1"
        },
        "swww": {
            "key": "Wall ",
            "keyColor": "#9ece6a",
            "format": "swww {version}",
            "command": "swww --version 2>/dev/null || echo 'swww not installed'"
        }
    }
}
HYPRFASTFETCHCONF

    # Merge configurations if they exist
    if [ -f "$config_file" ]; then
        echo "[VERBOSE] Merging Hyprland Fastfetch configuration with existing config..."
        local backup_file="$config_file.backup.$(date +%Y%m%d%H%M%S)"
        cp "$config_file" "$backup_file"
        log_info "Backed up existing Fastfetch config to $backup_file"

        # Create merged configuration
        jq -s '.[0] * .[1]' "$config_file" "$hyprland_config_file" > "${config_file}.tmp" 2>/dev/null && mv "${config_file}.tmp" "$config_file" || cp "$hyprland_config_file" "$config_file"
    else
        cp "$hyprland_config_file" "$config_file"
    fi

    # Apply Tokyo Night color scheme
    source "$SCRIPT_DIR/lib/fastfetch_color_schemes.sh"
    configure_fastfetch_color_scheme "tokyo-night-${variant}"

    echo "[SUCCESS] Hyprland Fastfetch compatibility configured"
}

configure_hyprland_compatibility() {
    local variant="${1:-night}"

    echo "[VERBOSE] Starting Hyprland compatibility configuration..."

    # Configure Waybar for Hyprland
    configure_hyprland_waybar "$variant"

    # Configure Fastfetch for Hyprland
    configure_hyprland_fastfetch "$variant"

    # Create Hyprland-specific scripts and configurations
    create_hyprland_scripts "$variant"

    echo "[SUCCESS] Hyprland compatibility configuration completed"
}

create_hyprland_scripts() {
    local variant="${1:-night}"
    local scripts_dir="$HOME/.config/tokyo-night/hyprland"
    local hyprland_dir="$HOME/.config/hypr"

    echo "[VERBOSE] Creating Hyprland-specific scripts..."

    mkdir -p "$scripts_dir" "$hyprland_dir"

    # Create Waybar launcher script
    local waybar_launcher="$scripts_dir/waybar-launcher.sh"
    cat > "$waybar_launcher" << WAYBARLAUNCHER
#!/bin/bash

# Waybar launcher for Hyprland with Tokyo Night theme
# Kills existing waybar instances and starts a new one

pkill waybar
sleep 0.5

# Start waybar with Tokyo Night theme
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"

echo "Waybar started with Tokyo Night theme"
WAYBARLAUNCHER

    chmod +x "$waybar_launcher"

    # Create Fastfetch launcher script
    local fastfetch_launcher="$scripts_dir/fastfetch-launcher.sh"
    cat > "$fastfetch_launcher" << FASTFETCHLAUNCHER
#!/bin/bash

# Fastfetch launcher with Tokyo Night theme
# Runs fastfetch with the configured Tokyo Night theme

fastfetch -c "$HOME/.config/fastfetch/config.jsonc"

echo "Fastfetch executed with Tokyo Night theme"
FASTFETCHLAUNCHER

    chmod +x "$fastfetch_launcher"

    # Create Hyprland startup script
    local hyprland_startup="$scripts_dir/hyprland-startup.sh"
    cat > "$hyprland_startup" << HYPRSTARTUP
#!/bin/bash

# Hyprland startup script with Tokyo Night compatibility
# This script ensures all Tokyo Night components are properly started

echo "Starting Hyprland with Tokyo Night compatibility..."

# Start Waybar
"$waybar_launcher" &

# Set wallpaper if swww is available
if command -v swww &>/dev/null; then
    if ! pgrep -x "swww-daemon" &>/dev/null; then
        swww-daemon &
        sleep 0.5
    fi

    # Find a Tokyo Night wallpaper
    local wallpaper
    wallpaper=$(find "$HOME/.local/share/tokyo-night-wallpapers" -name "*.jpg" -o -name "*.png" 2>/dev/null | head -1)

    if [ -n "$wallpaper" ]; then
        swww img "$wallpaper" --transition-type none
        echo "Set Tokyo Night wallpaper: $wallpaper"
    fi
fi

# Apply GTK theme
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'TokyoNight-SE'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

echo "Hyprland Tokyo Night startup completed"
HYPRSTARTUP

    chmod +x "$hyprland_startup"

    # Create Hyprland config snippet for Tokyo Night
    local hyprland_snippet="$hyprland_dir/tokyo-night-snippet.conf"
    cat > "$hyprland_snippet" << HYPRSNIPPET
# Tokyo Night Hyprland Configuration Snippet
# Add this to your Hyprland config for Tokyo Night compatibility

# Window decorations
windowrulev2 = float,class:^pavucontrol$
windowrulev2 = float,class:^blueman-manager$
windowrulev2 = float,class:^nm-connection-editor$

# Tokyo Night color scheme
\$bg = rgb(26, 27, 38)
\$bg_dark = rgb(26, 27, 38, 0.9)
\$fg = rgb(192, 202, 245)
\$inactive = rgb(86, 95, 137)
\$urgent = rgb(247, 118, 142)
\$focused = rgb(122, 162, 247)
\$unfocused = rgb(51, 70, 124)
\$indicator = rgb(187, 154, 247)

# Border colors
general {
    col.active_border = \$focused \$indicator 45deg
    col.inactive_border = \$inactive
}

# Window decorations
decoration {
    rounding = 8
    blur {
        enabled = true
        size = 8
        passes = 2
    }
    shadow {
        enabled = true
        color = rgba(\$bg, 0.9)
    }
}

# Group bar colors
group {
    col.border_active = \$focused
    col.border_inactive = \$inactive
    groupbar {
        col.active = \$focused
        col.inactive = \$unfocused
    }
}

# Startup applications
exec-once = waybar
exec-once = mako
exec-once = swww-daemon
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = nm-applet --indicator
exec-once = blueman-applet
exec-once = /usr/bin/wl-paste --type text --watch cliphist store
exec-once = /usr/bin/wl-paste --type image --watch cliphist store

# Keybindings for Tokyo Night tools
\$mod = SUPER

bind = \$mod, F1, exec, kitty -e "$HOME/.config/tokyo-night/hyprland/fastfetch-launcher.sh"
bind = \$mod, F2, exec, alacritty -e htop
bind = \$mod, F3, exec, kitty -e nvim
bind = \$mod, F4, exec, firefox
bind = \$mod, F5, exec, thunar
bind = \$mod, F12, exec, "$HOME/.config/tokyo-night/hyprland/waybar-launcher.sh"

# Tokyo Night specific keybindings
bind = \$mod SHIFT, T, exec, kitty
bind = \$mod SHIFT, F, exec, firefox
bind = \$mod SHIFT, N, exec, nautilus
bind = \$mod SHIFT, C, exec, code

# Reload keybindings
bind = \$mod, escape, exec, hyprctl reload
bind = \$mod SHIFT, R, exec, hyprctl reload
HYPRSNIPPET

    # Create README for Hyprland compatibility
    local readme_file="$scripts_dir/README.md"
    cat > "$readme_file" << HYPRREADME
# Tokyo Night Hyprland Compatibility

This directory contains scripts and configurations for enhanced Hyprland compatibility with the Tokyo Night theme.

## Files

- **waybar-launcher.sh**: Launcher script for Waybar with Tokyo Night theme
- **fastfetch-launcher.sh**: Launcher script for Fastfetch with Tokyo Night theme
- **hyprland-startup.sh**: Startup script for Hyprland with Tokyo Night compatibility
- **tokyo-night-snippet.conf**: Hyprland configuration snippet with Tokyo Night settings

## Usage

### Waybar Launcher

To start Waybar with Tokyo Night theme:

```bash
$HOME/.config/tokyo-night/hyprland/waybar-launcher.sh
```

### Fastfetch Launcher

To run Fastfetch with Tokyo Night theme:

```bash
$HOME/.config/tokyo-night/hyprland/fastfetch-launcher.sh
```

### Hyprland Startup

Add this to your Hyprland config to use the startup script:

```conf
exec-once = $HOME/.config/tokyo-night/hyprland/hyprland-startup.sh
```

### Hyprland Configuration Snippet

Add this to your main Hyprland config file:

```conf
source = ~/.config/hypr/tokyo-night-snippet.conf
```

## Features

- **Enhanced Waybar**: Hyprland-specific modules and styling
- **Enhanced Fastfetch**: Hyprland-specific information and Tokyo Night colors
- **Startup Management**: Proper initialization of all Tokyo Night components
- **Keybindings**: Tokyo Night specific keybindings for common applications
- **Window Rules**: Proper floating and decoration rules for system tools

## Compatibility

This configuration is designed to work with:
- Hyprland (latest versions)
- Waybar (latest versions)
- Fastfetch (latest versions)
- Tokyo Night theme variants (night, storm, light)

## Troubleshooting

If you experience issues:
1. Ensure all dependencies are installed
2. Check that the scripts are executable
3. Verify file paths in the configurations
4. Check Hyprland logs for errors
HYPRREADME

    echo "[SUCCESS] Hyprland-specific scripts created"
}

# Integration with main installer
install_hyprland_compatibility() {
    local variant="${1:-night}"

    log_info "Installing Hyprland compatibility for Tokyo Night..."

    # Source the wayland functions for color schemes
    source "$SCRIPT_DIR/lib/wayland.sh"

    # Configure Hyprland-specific Waybar and Fastfetch
    configure_hyprland_compatibility "$variant"

    # Update main Hyprland config if it exists
    local hypr_config="$HOME/.config/hypr/hyprland.conf"
    if [ -f "$hypr_config" ]; then
        if ! grep -q "tokyo-night-snippet.conf" "$hypr_config"; then
            echo "" >> "$hypr_config"
            echo "# Tokyo Night Hyprland Compatibility" >> "$hypr_config"
            echo "source = ~/.config/hypr/tokyo-night-snippet.conf" >> "$hypr_config"
            log_info "Added Tokyo Night snippet to Hyprland config"
        fi

        # Add Waybar launcher to Hyprland config if not present
        if ! grep -q "waybar-launcher.sh" "$hypr_config"; then
            if grep -q "exec.*waybar" "$hypr_config"; then
                sed -i 's|exec.*waybar|exec-once = '"$HOME/.config/tokyo-night/hyprland/waybar-launcher.sh"'|' "$hypr_config"
            else
                echo "" >> "$hypr_config"
                echo "exec-once = $HOME/.config/tokyo-night/hyprland/waybar-launcher.sh" >> "$hypr_config"
            fi
            log_info "Updated Waybar execution in Hyprland config"
        fi

        # Add startup script to Hyprland config
        if ! grep -q "hyprland-startup.sh" "$hypr_config"; then
            echo "" >> "$hypr_config"
            echo "exec-once = $HOME/.config/tokyo-night/hyprland/hyprland-startup.sh" >> "$hypr_config"
            log_info "Added Tokyo Night startup script to Hyprland config"
        fi
    else
        log_warn "Hyprland config not found at $hypr_config"
    fi

    log_success "Hyprland compatibility installed"
}
