#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh" 2>/dev/null || true


install_konsole_theme() {
    local variant="${1:-night}"
    log_info "Installing Tokyo Night theme for Konsole..."
    
    local konsole_dir="$HOME/.local/share/konsole"
    mkdir -p "$konsole_dir"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    cat > "$konsole_dir/TokyoNight.colorscheme" << KONSOLECONF
[Background]
Color=${bg:1:2},${bg:3:2},${bg:5:2}

[BackgroundFaint]
Color=${bg:1:2},${bg:3:2},${bg:5:2}

[BackgroundIntense]
Color=${bg:1:2},${bg:3:2},${bg:5:2}

[Color0]
Color=21,22,30

[Color0Faint]
Color=21,22,30

[Color0Intense]
Color=${comment:1:2},${comment:3:2},${comment:5:2}

[Color1]
Color=${red:1:2},${red:3:2},${red:5:2}

[Color1Faint]
Color=${red:1:2},${red:3:2},${red:5:2}

[Color1Intense]
Color=${red:1:2},${red:3:2},${red:5:2}

[Color2]
Color=${green:1:2},${green:3:2},${green:5:2}

[Color2Faint]
Color=${green:1:2},${green:3:2},${green:5:2}

[Color2Intense]
Color=${green:1:2},${green:3:2},${green:5:2}

[Color3]
Color=${yellow:1:2},${yellow:3:2},${yellow:5:2}

[Color3Faint]
Color=${yellow:1:2},${yellow:3:2},${yellow:5:2}

[Color3Intense]
Color=${yellow:1:2},${yellow:3:2},${yellow:5:2}

[Color4]
Color=${blue:1:2},${blue:3:2},${blue:5:2}

[Color4Faint]
Color=${blue:1:2},${blue:3:2},${blue:5:2}

[Color4Intense]
Color=${blue:1:2},${blue:3:2},${blue:5:2}

[Color5]
Color=${magenta:1:2},${magenta:3:2},${magenta:5:2}

[Color5Faint]
Color=${magenta:1:2},${magenta:3:2},${magenta:5:2}

[Color5Intense]
Color=${magenta:1:2},${magenta:3:2},${magenta:5:2}

[Color6]
Color=${cyan:1:2},${cyan:3:2},${cyan:5:2}

[Color6Faint]
Color=${cyan:1:2},${cyan:3:2},${cyan:5:2}

[Color6Intense]
Color=${cyan:1:2},${cyan:3:2},${cyan:5:2}

[Color7]
Color=169,177,214

[Color7Faint]
Color=169,177,214

[Color7Intense]
Color=${fg:1:2},${fg:3:2},${fg:5:2}

[Foreground]
Color=${fg:1:2},${fg:3:2},${fg:5:2}

[ForegroundFaint]
Color=${comment:1:2},${comment:3:2},${comment:5:2}

[ForegroundIntense]
Color=${fg:1:2},${fg:3:2},${fg:5:2}

[General]
Anchor=0.5,0.5
Blur=false
ColorRandomization=false
Description=Tokyo Night
FillStyle=Tile
Opacity=1
Wallpaper=
WallpaperFlipType=NoFlip
WallpaperOpacity=1
KONSOLECONF

    log_success "Konsole theme installed"
}


install_xfce4_terminal_theme() {
    local variant="${1:-night}"
    log_info "Installing Tokyo Night theme for XFCE4 Terminal..."
    
    local xfce_dir="$HOME/.local/share/xfce4/terminal/colorschemes"
    mkdir -p "$xfce_dir"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    cat > "$xfce_dir/tokyo-night.theme" << XFCECONF
[Scheme]
Name=Tokyo Night
ColorBackground=$bg
ColorForeground=$fg
ColorCursor=$fg
ColorCursorForeground=$bg
ColorSelection=$blue
ColorSelectionBackground=#33467c
ColorPalette=#15161e;$red;$green;$yellow;$blue;$magenta;$cyan;#a9b1d6;$comment;$red;$green;$yellow;$blue;$magenta;$cyan;$fg
XFCECONF

    log_success "XFCE4 Terminal theme installed"
}


install_tilix_theme() {
    local variant="${1:-night}"
    log_info "Installing Tokyo Night theme for Tilix..."
    
    local tilix_dir="$HOME/.config/tilix/schemes"
    mkdir -p "$tilix_dir"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    cat > "$tilix_dir/tokyo-night.json" << TILIXCONF
{
    "name": "Tokyo Night",
    "comment": "Tokyo Night color scheme",
    "foreground-color": "$fg",
    "background-color": "$bg",
    "cursor-foreground-color": "$bg",
    "cursor-background-color": "$fg",
    "highlight-foreground-color": "$fg",
    "highlight-background-color": "#33467c",
    "palette": [
        "#15161e",
        "$red",
        "$green",
        "$yellow",
        "$blue",
        "$magenta",
        "$cyan",
        "#a9b1d6",
        "$comment",
        "$red",
        "$green",
        "$yellow",
        "$blue",
        "$magenta",
        "$cyan",
        "$fg"
    ],
    "use-badge-color": false,
    "use-bold-color": false,
    "use-cursor-color": true,
    "use-highlight-color": true,
    "use-theme-colors": false
}
TILIXCONF

    log_success "Tilix theme installed"
}


install_terminator_theme() {
    local variant="${1:-night}"
    log_info "Installing Tokyo Night theme for Terminator..."
    
    local terminator_dir="$HOME/.config/terminator"
    mkdir -p "$terminator_dir"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    local config_file="$terminator_dir/config"
    
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << TERMINATORCONF
[global_config]
[keybindings]
[profiles]
  [[default]]
    background_color = "$bg"
    cursor_color = "$fg"
    foreground_color = "$fg"
    palette = "#15161e:$red:$green:$yellow:$blue:$magenta:$cyan:#a9b1d6:$comment:$red:$green:$yellow:$blue:$magenta:$cyan:$fg"
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
TERMINATORCONF
    else
        log_warn "Terminator config exists. Please add Tokyo Night colors manually."
    fi
    
    log_success "Terminator theme installed"
}


install_st_theme() {
    local variant="${1:-night}"
    log_info "Generating Tokyo Night theme for st (suckless terminal)..."
    
    local st_dir="$HOME/.config/st"
    mkdir -p "$st_dir"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    cat > "$st_dir/tokyo-night.h" << STCONF
/* Tokyo Night color scheme for st */

static const char *colorname[] = {
    /* 8 normal colors */
    "#15161e", /* black   */
    "$red",    /* red     */
    "$green",  /* green   */
    "$yellow", /* yellow  */
    "$blue",   /* blue    */
    "$magenta",/* magenta */
    "$cyan",   /* cyan    */
    "#a9b1d6", /* white   */

    /* 8 bright colors */
    "$comment",/* black   */
    "$red",    /* red     */
    "$green",  /* green   */
    "$yellow", /* yellow  */
    "$blue",   /* blue    */
    "$magenta",/* magenta */
    "$cyan",   /* cyan    */
    "$fg",     /* white   */

    [255] = 0,

    /* special colors */
    "$fg",     /* foreground */
    "$bg",     /* background */
    "$fg",     /* cursor */
};

/* Default colors (colorname index) */
unsigned int defaultfg = 256;
unsigned int defaultbg = 257;
unsigned int defaultcs = 258;
unsigned int defaultrcs = 257;
STCONF

    log_success "st theme generated at $st_dir/tokyo-night.h"
    log_info "To apply: copy the colors to your st config.h and recompile"
}


install_urxvt_theme() {
    local variant="${1:-night}"
    log_info "Installing Tokyo Night theme for urxvt..."
    
    local xresources="$HOME/.Xresources"
    local theme_file="$HOME/.config/urxvt/tokyo-night.xresources"
    
    mkdir -p "$(dirname "$theme_file")"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    cat > "$theme_file" << URXVTCONF
! Tokyo Night color scheme for urxvt

URxvt*background: $bg
URxvt*foreground: $fg
URxvt*cursorColor: $fg
URxvt*cursorColor2: $bg

! black
URxvt*color0: #15161e
URxvt*color8: $comment

! red
URxvt*color1: $red
URxvt*color9: $red

! green
URxvt*color2: $green
URxvt*color10: $green

! yellow
URxvt*color3: $yellow
URxvt*color11: $yellow

! blue
URxvt*color4: $blue
URxvt*color12: $blue

! magenta
URxvt*color5: $magenta
URxvt*color13: $magenta

! cyan
URxvt*color6: $cyan
URxvt*color14: $cyan

! white
URxvt*color7: #a9b1d6
URxvt*color15: $fg
URXVTCONF

    if [ -f "$xresources" ]; then
        if ! grep -q "tokyo-night.xresources" "$xresources"; then
            echo "" >> "$xresources"
            echo "#include \"$theme_file\"" >> "$xresources"
        fi
    else
        echo "#include \"$theme_file\"" > "$xresources"
    fi
    
    if command -v xrdb &>/dev/null; then
        xrdb -merge "$theme_file"
    fi
    
    log_success "urxvt theme installed"
}


install_xterm_theme() {
    local variant="${1:-night}"
    log_info "Installing Tokyo Night theme for xterm..."
    
    local xresources="$HOME/.Xresources"
    local theme_file="$HOME/.config/xterm/tokyo-night.xresources"
    
    mkdir -p "$(dirname "$theme_file")"
    
    local bg=$(get_color "$variant" "bg")
    local fg=$(get_color "$variant" "fg")
    local red=$(get_color "$variant" "red")
    local green=$(get_color "$variant" "green")
    local yellow=$(get_color "$variant" "yellow")
    local blue=$(get_color "$variant" "blue")
    local magenta=$(get_color "$variant" "magenta")
    local cyan=$(get_color "$variant" "cyan")
    local comment=$(get_color "$variant" "comment")
    
    cat > "$theme_file" << XTERMCONF
! Tokyo Night color scheme for xterm

XTerm*background: $bg
XTerm*foreground: $fg
XTerm*cursorColor: $fg

! black
XTerm*color0: #15161e
XTerm*color8: $comment

! red
XTerm*color1: $red
XTerm*color9: $red

! green
XTerm*color2: $green
XTerm*color10: $green

! yellow
XTerm*color3: $yellow
XTerm*color11: $yellow

! blue
XTerm*color4: $blue
XTerm*color12: $blue

! magenta
XTerm*color5: $magenta
XTerm*color13: $magenta

! cyan
XTerm*color6: $cyan
XTerm*color14: $cyan

! white
XTerm*color7: #a9b1d6
XTerm*color15: $fg
XTERMCONF

    if [ -f "$xresources" ]; then
        if ! grep -q "xterm/tokyo-night.xresources" "$xresources"; then
            echo "" >> "$xresources"
            echo "#include \"$theme_file\"" >> "$xresources"
        fi
    else
        echo "#include \"$theme_file\"" > "$xresources"
    fi
    
    if command -v xrdb &>/dev/null; then
        xrdb -merge "$theme_file"
    fi
    
    log_success "xterm theme installed"
}
