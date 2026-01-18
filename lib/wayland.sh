#!/bin/bash

get_tokyonight_colors() {
    local variant="${1:-night}"

    case "$variant" in
        night)
            BG="#1a1b26"
            FG="#c0caf5"
            SELECTION="#33467c"
            COMMENT="#565f89"
            RED="#f7768e"
            ORANGE="#ff9e64"
            YELLOW="#e0af68"
            GREEN="#9ece6a"
            CYAN="#7dcfff"
            BLUE="#7aa2f7"
            MAGENTA="#bb9af7"
            ;;
        storm)
            BG="#24283b"
            FG="#c0caf5"
            SELECTION="#364a82"
            COMMENT="#565f89"
            RED="#f7768e"
            ORANGE="#ff9e64"
            YELLOW="#e0af68"
            GREEN="#9ece6a"
            CYAN="#7dcfff"
            BLUE="#7aa2f7"
            MAGENTA="#bb9af7"
            ;;
        light)
            BG="#d5d6db"
            FG="#343b58"
            SELECTION="#99a7df"
            COMMENT="#9699a3"
            RED="#8c4351"
            ORANGE="#965027"
            YELLOW="#8f5e15"
            GREEN="#33635c"
            CYAN="#0f4b6e"
            BLUE="#34548a"
            MAGENTA="#5a4a78"
            ;;
    esac
}

configure_niri() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local niri_dir="$HOME/.config/niri"
    local config_file="$niri_dir/config.kdl"

    mkdir -p "$niri_dir"

    log_info "Configuring Niri with Tokyo Night theme..."

    cat > "$config_file" << NIRICONF
input {
    keyboard {
        xkb {
            layout "us"
            options "compose:ralt"
        }
    }

    touchpad {
        tap
        dnd
        natural-scroll
        accel-speed 0.2
        accel-profile "adaptive"
    }

    mouse {
        accel-speed 0.2
        accel-profile "adaptive"
    }

    trackpoint {
        accel-speed 0.2
        accel-profile "adaptive"
    }
}

output "eDP-1" {
    scale 1.0
    transform "normal"
    position x=0 y=0
}

layout {
    gaps 8
    center-focused-column "never"

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }

    default-column-width { proportion 0.5; }

    focus-ring {
        off
    }

    border {
        width 2
        active-color "${BLUE}"
        inactive-color "${COMMENT}"
    }

    shadow {
        on
        softness 30
        spread 5
        color "#00000064"
    }

    insert-hint {
        color "${BLUE}80"
    }
}

cursor {
    xcursor-theme "Adwaita"
    xcursor-size 24
}

prefer-no-csd

screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

window-rule {
    geometry-corner-radius 8
    clip-to-geometry true
}

window-rule {
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
}

window-rule {
    match app-id="firefox"
    match app-id="chromium"
    match app-id="google-chrome"
    open-maximized true
}

environment {
    DISPLAY ":0"
    QT_QPA_PLATFORM "wayland"
    GDK_BACKEND "wayland"
    SDL_VIDEODRIVER "wayland"
    XDG_SESSION_TYPE "wayland"
    XDG_CURRENT_DESKTOP "niri"
}

hotkey-overlay {
    skip-at-startup
}

binds {
    Mod+Shift+Slash { show-hotkey-overlay; }
    Mod+T { spawn "wezterm"; }
    Mod+D { spawn "fuzzel"; }
    Mod+Return { spawn "wezterm"; }
    Mod+Q { close-window; }
    Mod+Shift+Q { quit; }
    Mod+Shift+E { quit; skip-confirm; }

    Mod+H { focus-column-left; }
    Mod+J { focus-window-down; }
    Mod+K { focus-window-up; }
    Mod+L { focus-column-right; }

    Mod+Shift+H { move-column-left; }
    Mod+Shift+J { move-window-down; }
    Mod+Shift+K { move-window-up; }
    Mod+Shift+L { move-column-right; }

    Mod+Home { focus-column-first; }
    Mod+End { focus-column-last; }
    Mod+Shift+Home { move-column-to-first; }
    Mod+Shift+End { move-column-to-last; }

    Mod+Page_Down { focus-workspace-down; }
    Mod+Page_Up { focus-workspace-up; }
    Mod+U { focus-workspace-down; }
    Mod+I { focus-workspace-up; }
    Mod+Shift+Page_Down { move-window-to-workspace-down; }
    Mod+Shift+Page_Up { move-window-to-workspace-up; }
    Mod+Shift+U { move-window-to-workspace-down; }
    Mod+Shift+I { move-window-to-workspace-up; }

    Mod+WheelScrollDown { focus-workspace-down; }
    Mod+WheelScrollUp { focus-workspace-up; }
    Mod+Ctrl+WheelScrollDown { move-window-to-workspace-down; }
    Mod+Ctrl+WheelScrollUp { move-window-to-workspace-up; }

    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }

    Mod+Shift+1 { move-window-to-workspace 1; }
    Mod+Shift+2 { move-window-to-workspace 2; }
    Mod+Shift+3 { move-window-to-workspace 3; }
    Mod+Shift+4 { move-window-to-workspace 4; }
    Mod+Shift+5 { move-window-to-workspace 5; }
    Mod+Shift+6 { move-window-to-workspace 6; }
    Mod+Shift+7 { move-window-to-workspace 7; }
    Mod+Shift+8 { move-window-to-workspace 8; }
    Mod+Shift+9 { move-window-to-workspace 9; }

    Mod+Comma { consume-window-into-column; }
    Mod+Period { expel-window-from-column; }

    Mod+R { switch-preset-column-width; }
    Mod+Shift+R { reset-window-height; }
    Mod+F { maximize-column; }
    Mod+Shift+F { fullscreen-window; }
    Mod+C { center-column; }

    Mod+Minus { set-column-width "-10%"; }
    Mod+Equal { set-column-width "+10%"; }

    Mod+Shift+Minus { set-window-height "-10%"; }
    Mod+Shift+Equal { set-window-height "+10%"; }

    Mod+Tab { focus-window-previous; }

    XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
    XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
    XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
    XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

    XF86MonBrightnessUp { spawn "brightnessctl" "s" "+10%"; }
    XF86MonBrightnessDown { spawn "brightnessctl" "s" "10%-"; }
}

spawn-at-startup "waybar"
spawn-at-startup "mako"
spawn-at-startup "swww-daemon"
spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"
spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"
NIRICONF

    log_success "Niri configured with Tokyo Night theme"
}

configure_swww() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    log_info "SWWW is a wallpaper daemon, no configuration needed for Tokyo Night theme"
    log_info "Use 'swww img /path/to/wallpaper.jpg' to set wallpapers"
}

configure_waybar() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local waybar_dir="$HOME/.config/waybar"
    local style_file="$waybar_dir/style.css"
    local config_file="$waybar_dir/config.jsonc"

    mkdir -p "$waybar_dir"

    log_info "Configuring Waybar with Tokyo Night theme..."

    cat > "$config_file" << WAYBARCONFIG
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,
    "modules-left": [
        "hyprland/workspaces",
        "hyprland/submap"
    ],
    "modules-center": [
        "hyprland/window"
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
        "tray"
    ],
    "hyprland/workspaces": {
        "format": "{name}",
        "on-click": "activate",
        "sort-by-number": true,
        "active-only": false,
        "all-outputs": false,
        "show-special": false
    },
    "hyprland/submap": {
        "format": "✦ {}",
        "tooltip": false
    },
    "hyprland/window": {
        "format": "{}",
        "max-length": 50,
        "tooltip": false
    },
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
        "on-click-right": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    },
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "max-length": 50,
        "on-click": "nm-connection-editor"
    },
    "cpu": {
        "format": "{usage}% ",
        "tooltip": false
    },
    "memory": {
        "format": "{}% "
    },
    "temperature": {
        "thermal-zone": 2,
        "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
        "critical-threshold": 80,
        "format-critical": "{temperatureC}°C {icon}",
        "format": "{temperatureC}°C {icon}",
        "format-icons": ["", "", ""]
    },
    "backlight": {
        "device": "intel_backlight",
        "format": "{percent}% {icon}",
        "format-icons": ["", ""]
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
        "format-icons": ["", "", "", "", ""]
    },
    "clock": {
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format-alt": "{:%Y-%m-%d}"
    },
    "tray": {
        "spacing": 10
    }
}
WAYBARCONFIG

    cat > "$style_file" << WAYBARCSS
* {
    font-family: "JetBrains Mono", "Font Awesome 6 Free", monospace;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: ${BG};
    color: ${FG};
    border-bottom: 2px solid ${BLUE};
}

window#waybar.hidden {
    opacity: 0.5;
}

#workspaces {
    background-color: ${BG};
    border-radius: 8px;
    margin: 4px;
    padding: 0 4px;
}

#workspaces button {
    background-color: transparent;
    color: ${COMMENT};
    padding: 4px 8px;
    margin: 4px 2px;
    border-radius: 6px;
    border: none;
}

#workspaces button:hover {
    background-color: ${SELECTION};
    color: ${FG};
}

#workspaces button.active,
#workspaces button.focused {
    background-color: ${BLUE};
    color: ${BG};
}

#workspaces button.urgent {
    background-color: ${RED};
    color: ${BG};
}

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
}

#clock {
    color: ${MAGENTA};
    font-weight: bold;
}

#battery {
    color: ${GREEN};
}

#battery.charging, #battery.plugged {
    color: ${CYAN};
}

#battery.warning:not(.charging) {
    color: ${YELLOW};
}

#battery.critical:not(.charging) {
    background-color: ${RED};
    color: ${BG};
    animation: blink 0.5s linear infinite alternate;
}

@keyframes blink {
    to {
        background-color: ${BG};
        color: ${RED};
    }
}

#cpu {
    color: ${CYAN};
}

#memory {
    color: ${MAGENTA};
}

#disk {
    color: ${YELLOW};
}

#backlight {
    color: ${YELLOW};
}

#network {
    color: ${CYAN};
}

#network.disconnected {
    color: ${RED};
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
}

#idle_inhibitor {
    color: ${COMMENT};
}

#idle_inhibitor.activated {
    color: ${CYAN};
}

#mpd {
    color: ${ORANGE};
}

#mpd.disconnected {
    color: ${RED};
}

#mpd.stopped {
    color: ${COMMENT};
}

#mpd.paused {
    color: ${YELLOW};
}

tooltip {
    background-color: ${BG};
    border: 1px solid ${BLUE};
    border-radius: 8px;
}

tooltip label {
    color: ${FG};
    padding: 4px;
}

#window {
    color: ${FG};
    padding: 4px 12px;
}

#submap {
    background-color: ${YELLOW};
    color: ${BG};
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 8px;
}
WAYBARCSS

    log_success "Waybar configured with Tokyo Night theme"
}

configure_mako() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local mako_dir="$HOME/.config/mako"
    local config_file="$mako_dir/config"

    mkdir -p "$mako_dir"

    log_info "Configuring Mako with Tokyo Night theme..."

    cat > "$config_file" << MAKOCONFIG
font=JetBrains Mono 10
background-color=${BG}e6
text-color=${FG}
border-color=${BLUE}
border-size=2
border-radius=8

[urgency=low]
background-color=${BG}e6
text-color=${FG}
border-color=${BLUE}

[urgency=normal]
background-color=${BG}e6
text-color=${FG}
border-color=${BLUE}

[urgency=high]
background-color=${RED}e6
text-color=${BG}
border-color=${RED}

[mode=dnd]
invisible=1
MAKOCONFIG

    log_success "Mako configured with Tokyo Night theme"
}

configure_nwg_look() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    log_info "NWG-Look is a GTK theme configurator, applying Tokyo Night GTK settings..."

    local gtk3_dir="$HOME/.config/gtk-3.0"
    local gtk4_dir="$HOME/.config/gtk-4.0"

    mkdir -p "$gtk3_dir" "$gtk4_dir"

    cat > "$gtk3_dir/settings.ini" << GTK3CONF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=TokyoNight-SE
gtk-font-name=JetBrains Mono 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
GTK3CONF

    cat > "$gtk4_dir/settings.ini" << GTK4CONF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=TokyoNight-SE
gtk-font-name=JetBrains Mono 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
GTK4CONF

    log_success "NWG-Look GTK settings configured with Tokyo Night theme"
}

configure_qt5ct() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local qt5ct_dir="$HOME/.config/qt5ct"
    local qt5ct_conf="$qt5ct_dir/qt5ct.conf"

    mkdir -p "$qt5ct_dir"

    log_info "Configuring QT5CT with Tokyo Night theme..."

    cat > "$qt5ct_conf" << QT5CTCONF
[Appearance]
style=kvantum-dark
color_scheme_path=
icon_theme=TokyoNight-SE

[Fonts]
general=JetBrains Mono,10,-1,5,50,0,0,0,0,0

[Interface]
activate_item_on_single_click=0
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
menus_have_icons=1
show_shortcuts_in_context_menus=1
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()
QT5CTCONF

    log_success "QT5CT configured with Tokyo Night theme"
}

configure_qt6ct() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local qt6ct_dir="$HOME/.config/qt6ct"
    local qt6ct_conf="$qt6ct_dir/qt6ct.conf"

    mkdir -p "$qt6ct_dir"

    log_info "Configuring QT6CT with Tokyo Night theme..."

    cat > "$qt6ct_conf" << QT6CTCONF
[Appearance]
style=kvantum-dark
color_scheme_path=
icon_theme=TokyoNight-SE

[Fonts]
general=JetBrains Mono,10,-1,5,50,0,0,0,0,0

[Interface]
activate_item_on_single_click=0
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
menus_have_icons=1
show_shortcuts_in_context_menus=1
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()
QT6CTCONF

    log_success "QT6CT configured with Tokyo Night theme"
}

configure_foot() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local foot_dir="$HOME/.config/foot"
    local foot_ini="$foot_dir/foot.ini"

    mkdir -p "$foot_dir"

    log_info "Configuring Foot with Tokyo Night theme..."

    cat > "$foot_ini" << FOOTCONF
font=JetBrains Mono:size=10
dpi-aware=yes

[colors]
foreground=${FG:1}
background=${BG:1}

regular0=15161e
regular1=${RED:1}
regular2=${GREEN:1}
regular3=${YELLOW:1}
regular4=${BLUE:1}
regular5=${MAGENTA:1}
regular6=${CYAN:1}
regular7=a9b1d6

bright0=${COMMENT:1}
bright1=${RED:1}
bright2=${GREEN:1}
bright3=${YELLOW:1}
bright4=${BLUE:1}
bright5=${MAGENTA:1}
bright6=${CYAN:1}
bright7=${FG:1}

selection-foreground=${FG:1}
selection-background=${SELECTION:1}

[scrollback]
lines=10000

[mouse]
hide-when-typing=yes

[key-bindings]
scrollback-up-page=Mod1+Page_Up
scrollback-down-page=Mod1+Page_Down
clipboard-copy=Mod1+c
clipboard-paste=Mod1+v
FOOTCONF

    log_success "Foot configured with Tokyo Night theme"
}

configure_alacritty() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local alacritty_dir="$HOME/.config/alacritty"
    local alacritty_yml="$alacritty_dir/alacritty.yml"

    mkdir -p "$alacritty_dir"

    log_info "Configuring Alacritty with Tokyo Night theme..."

    cat > "$alacritty_yml" << ALACRITTYCONF
window:
  padding:
    x: 12
    y: 12
  decorations: none
  opacity: 0.9
  startup_mode: Windowed
  title: Alacritty
  dynamic_title: true

scrolling:
  history: 10000
  multiplier: 3

font:
  normal:
    family: JetBrains Mono
    style: Regular
  bold:
    family: JetBrains Mono
    style: Bold
  italic:
    family: JetBrains Mono
    style: Italic
  size: 10.0
  offset:
    x: 0
    y: 0
  glyph_offset:
    x: 0
    y: 0

colors:
  primary:
    background: '${BG}'
    foreground: '${FG}'

  cursor:
    text: '${BG}'
    cursor: '${FG}'

  selection:
    text: '${FG}'
    background: '${SELECTION}'

  normal:
    black:   '#15161e'
    red:     '${RED}'
    green:   '${GREEN}'
    yellow:  '${YELLOW}'
    blue:    '${BLUE}'
    magenta: '${MAGENTA}'
    cyan:    '${CYAN}'
    white:   '#a9b1d6'

  bright:
    black:   '${COMMENT}'
    red:     '${RED}'
    green:   '${GREEN}'
    yellow:  '${YELLOW}'
    blue:    '${BLUE}'
    magenta: '${MAGENTA}'
    cyan:    '${CYAN}'
    white:   '${FG}'

cursor:
  style:
    shape: Block
    blinking: On
  blink_interval: 750
  unfocused_hollow: true
  thickness: 0.15

live_config_reload: true

mouse:
  double_click: { threshold: 300 }
  triple_click: { threshold: 300 }
  hide_when_typing: true

hints:
  enabled:
    - regex: "(mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)\
              [^\u0000-\u001f\u007f-\u009f<>\"\\s{-}\\^⟨⟩`]+"
      command: xdg-open
      post_processing: true
      mouse:
        enabled: true
        mods: None
      binding:
        key: U
        mods: Control|Shift

key_bindings:
  - { key: N, mods: Control|Shift, action: SpawnNewInstance }
  - { key: Q, mods: Control|Shift, action: Quit }
  - { key: C, mods: Control|Shift, action: Copy }
  - { key: V, mods: Control|Shift, action: Paste }
  - { key: Equals, mods: Control, action: IncreaseFontSize }
  - { key: Minus, mods: Control, action: DecreaseFontSize }
  - { key: Key0, mods: Control, action: ResetFontSize }
  - { key: L, mods: Control|Shift, action: ClearHistory }
ALACRITTYCONF

    log_success "Alacritty configured with Tokyo Night theme"
}

configure_fuzzel() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local fuzzel_dir="$HOME/.config/fuzzel"
    local fuzzel_ini="$fuzzel_dir/fuzzel.ini"

    mkdir -p "$fuzzel_dir"

    log_info "Configuring Fuzzel with Tokyo Night theme..."

    cat > "$fuzzel_ini" << FUZZELCONF
font=JetBrains Mono:size=10
dpi-aware=yes

[colors]
background=${BG}ff
text=${FG}ff
match=${BLUE}ff
selection=${SELECTION}ff
selection-text=${FG}ff
border=${BLUE}ff

[dmenu]
exit-immediately-if-empty=yes

[main]
terminal=foot
FUZZELCONF

    log_success "Fuzzel configured with Tokyo Night theme"
}

configure_eww() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local eww_dir="$HOME/.config/eww"
    local eww_scss="$eww_dir/eww.scss"

    mkdir -p "$eww_dir"

    log_info "Configuring EWW with Tokyo Night theme..."

    cat > "$eww_scss" << EWWSCSS
* {
    font-family: "JetBrains Mono", monospace;
    font-size: 13px;
}

.background {
    background-color: ${BG};
}

.foreground {
    color: ${FG};
}

.accent {
    color: ${BLUE};
}

.urgent {
    color: ${RED};
}

.widget {
    background-color: ${BG};
    color: ${FG};
    border: 1px solid ${BLUE};
    border-radius: 8px;
    padding: 8px;
    margin: 4px;
}

.button {
    background-color: ${SELECTION};
    color: ${FG};
    border: none;
    border-radius: 4px;
    padding: 4px 8px;
    margin: 2px;
}

.button:hover {
    background-color: ${BLUE};
    color: ${BG};
}
EWWSCSS

    log_success "EWW configured with Tokyo Night theme"
}

configure_ags() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local ags_dir="$HOME/.config/ags"
    local ags_js="$ags_dir/config.js"

    mkdir -p "$ags_dir"

    log_info "Configuring AGS with Tokyo Night theme..."

    cat > "$ags_js" << AGSJS
const colors = {
    background: "${BG}",
    foreground: "${FG}",
    accent: "${BLUE}",
    urgent: "${RED}",
    selection: "${SELECTION}",
    comment: "${COMMENT}",
    red: "${RED}",
    orange: "${ORANGE}",
    yellow: "${YELLOW}",
    green: "${GREEN}",
    cyan: "${CYAN}",
    blue: "${BLUE}",
    magenta: "${MAGENTA}",
};

export default {
    style: \`
        * {
            font-family: "JetBrains Mono", monospace;
            font-size: 13px;
        }

        window {
            background-color: \${colors.background};
            color: \${colors.foreground};
        }

        .widget {
            background-color: \${colors.background};
            color: \${colors.foreground};
            border: 1px solid \${colors.accent};
            border-radius: 8px;
            padding: 8px;
        }

        .button {
            background-color: \${colors.selection};
            color: \${colors.foreground};
            border: none;
            border-radius: 4px;
            padding: 4px 8px;
        }

        .button:hover {
            background-color: \${colors.accent};
            color: \${colors.background};
        }
    \`,
    closeWindowDelay: {
        launcher: 300,
        overview: 300,
        quicksettings: 300,
        dashboard: 300,
    },
};
AGSJS

    log_success "AGS configured with Tokyo Night theme"
}

configure_grim_slurp() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    log_info "Grim and Slurp are screenshot tools, no configuration needed for Tokyo Night theme"
    log_info "Use 'grim -g \"\$(slurp)\" screenshot.png' to take screenshots"
}

configure_wlogout() {
    local variant="${1:-night}"
    get_tokyonight_colors "$variant"

    local wlogout_dir="$HOME/.config/wlogout"
    local style_css="$wlogout_dir/style.css"

    mkdir -p "$wlogout_dir"

    log_info "Configuring WLogout with Tokyo Night theme..."

    cat > "$style_css" << WLOGOUTCSS
* {
    font-family: "JetBrains Mono", monospace;
    font-size: 13px;
}

window {
    background-color: ${BG}e6;
    color: ${FG};
}

button {
    background-color: ${SELECTION};
    color: ${FG};
    border: 2px solid ${BLUE};
    border-radius: 8px;
    padding: 12px;
    margin: 8px;
    min-width: 120px;
    transition: all 0.2s ease;
}

button:hover {
    background-color: ${BLUE};
    color: ${BG};
    border-color: ${CYAN};
}

button:active {
    background-color: ${CYAN};
    color: ${BG};
}

#logout {
    border-color: ${RED};
}

#logout:hover {
    background-color: ${RED};
    color: ${BG};
}

#shutdown {
    border-color: ${ORANGE};
}

#shutdown:hover {
    background-color: ${ORANGE};
    color: ${BG};
}

#reboot {
    border-color: ${YELLOW};
}

#reboot:hover {
    background-color: ${YELLOW};
    color: ${BG};
}

#sleep {
    border-color: ${CYAN};
}

#sleep:hover {
    background-color: ${CYAN};
    color: ${BG};
}

#hibernate {
    border-color: ${MAGENTA};
}

#hibernate:hover {
    background-color: ${MAGENTA};
    color: ${BG};
}
WLOGOUTCSS

    log_success "WLogout configured with Tokyo Night theme"
}

configure_wayland_tools() {
    local tools="$1"
    local variant="${2:-night}"

    log_info "Configuring Wayland tools with Tokyo Night theme..."

    for tool in $tools; do
        case "$tool" in
            niri)
                configure_niri "$variant"
                ;;
            swww)
                configure_swww "$variant"
                ;;
            waybar)
                configure_waybar "$variant"
                ;;
            mako)
                configure_mako "$variant"
                ;;
            nwg-look)
                configure_nwg_look "$variant"
                ;;
            qt5ct)
                configure_qt5ct "$variant"
                ;;
            qt6ct)
                configure_qt6ct "$variant"
                ;;
            foot)
                configure_foot "$variant"
                ;;
            alacritty)
                configure_alacritty "$variant"
                ;;
            fuzzel)
                configure_fuzzel "$variant"
                ;;
            eww)
                configure_eww "$variant"
                ;;
            ags)
                configure_ags "$variant"
                ;;
            grim|slurp)
                configure_grim_slurp "$variant"
                ;;
            wlogout)
                configure_wlogout "$variant"
                ;;
            *)
                log_warn "Unknown Wayland tool: $tool"
                ;;
        esac
    done

    log_success "Wayland tools configured with Tokyo Night theme"
}
