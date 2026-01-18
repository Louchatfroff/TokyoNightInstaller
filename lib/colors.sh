#!/bin/bash


declare -A TOKYO_NIGHT
declare -A TOKYO_STORM
declare -A TOKYO_LIGHT


TOKYO_NIGHT[bg]="#1a1b26"
TOKYO_NIGHT[bg_dark]="#16161e"
TOKYO_NIGHT[bg_highlight]="#292e42"
TOKYO_NIGHT[terminal_black]="#414868"
TOKYO_NIGHT[fg]="#c0caf5"
TOKYO_NIGHT[fg_dark]="#a9b1d6"
TOKYO_NIGHT[fg_gutter]="#3b4261"
TOKYO_NIGHT[dark3]="#545c7e"
TOKYO_NIGHT[comment]="#565f89"
TOKYO_NIGHT[dark5]="#737aa2"
TOKYO_NIGHT[blue0]="#3d59a1"
TOKYO_NIGHT[blue]="#7aa2f7"
TOKYO_NIGHT[cyan]="#7dcfff"
TOKYO_NIGHT[blue1]="#2ac3de"
TOKYO_NIGHT[blue2]="#0db9d7"
TOKYO_NIGHT[blue5]="#89ddff"
TOKYO_NIGHT[blue6]="#b4f9f8"
TOKYO_NIGHT[blue7]="#394b70"
TOKYO_NIGHT[magenta]="#bb9af7"
TOKYO_NIGHT[magenta2]="#ff007c"
TOKYO_NIGHT[purple]="#9d7cd8"
TOKYO_NIGHT[orange]="#ff9e64"
TOKYO_NIGHT[yellow]="#e0af68"
TOKYO_NIGHT[green]="#9ece6a"
TOKYO_NIGHT[green1]="#73daca"
TOKYO_NIGHT[green2]="#41a6b5"
TOKYO_NIGHT[teal]="#1abc9c"
TOKYO_NIGHT[red]="#f7768e"
TOKYO_NIGHT[red1]="#db4b4b"


TOKYO_STORM[bg]="#24283b"
TOKYO_STORM[bg_dark]="#1f2335"
TOKYO_STORM[bg_highlight]="#292e42"
TOKYO_STORM[terminal_black]="#414868"
TOKYO_STORM[fg]="#c0caf5"
TOKYO_STORM[fg_dark]="#a9b1d6"
TOKYO_STORM[fg_gutter]="#3b4261"
TOKYO_STORM[dark3]="#545c7e"
TOKYO_STORM[comment]="#565f89"
TOKYO_STORM[dark5]="#737aa2"
TOKYO_STORM[blue0]="#3d59a1"
TOKYO_STORM[blue]="#7aa2f7"
TOKYO_STORM[cyan]="#7dcfff"
TOKYO_STORM[blue1]="#2ac3de"
TOKYO_STORM[blue2]="#0db9d7"
TOKYO_STORM[blue5]="#89ddff"
TOKYO_STORM[blue6]="#b4f9f8"
TOKYO_STORM[blue7]="#394b70"
TOKYO_STORM[magenta]="#bb9af7"
TOKYO_STORM[magenta2]="#ff007c"
TOKYO_STORM[purple]="#9d7cd8"
TOKYO_STORM[orange]="#ff9e64"
TOKYO_STORM[yellow]="#e0af68"
TOKYO_STORM[green]="#9ece6a"
TOKYO_STORM[green1]="#73daca"
TOKYO_STORM[green2]="#41a6b5"
TOKYO_STORM[teal]="#1abc9c"
TOKYO_STORM[red]="#f7768e"
TOKYO_STORM[red1]="#db4b4b"


TOKYO_LIGHT[bg]="#d5d6db"
TOKYO_LIGHT[bg_dark]="#d5d6db"
TOKYO_LIGHT[bg_highlight]="#c4c8da"
TOKYO_LIGHT[terminal_black]="#0f0f14"
TOKYO_LIGHT[fg]="#343b58"
TOKYO_LIGHT[fg_dark]="#6172b0"
TOKYO_LIGHT[fg_gutter]="#a8aecb"
TOKYO_LIGHT[dark3]="#68709a"
TOKYO_LIGHT[comment]="#9699a3"
TOKYO_LIGHT[dark5]="#9699a3"
TOKYO_LIGHT[blue0]="#7890dd"
TOKYO_LIGHT[blue]="#34548a"
TOKYO_LIGHT[cyan]="#0f4b6e"
TOKYO_LIGHT[blue1]="#188092"
TOKYO_LIGHT[blue2]="#07879d"
TOKYO_LIGHT[blue5]="#006a83"
TOKYO_LIGHT[blue6]="#2e7de9"
TOKYO_LIGHT[blue7]="#a8aecb"
TOKYO_LIGHT[magenta]="#5a4a78"
TOKYO_LIGHT[magenta2]="#d20065"
TOKYO_LIGHT[purple]="#7847bd"
TOKYO_LIGHT[orange]="#965027"
TOKYO_LIGHT[yellow]="#8f5e15"
TOKYO_LIGHT[green]="#33635c"
TOKYO_LIGHT[green1]="#387068"
TOKYO_LIGHT[green2]="#118c74"
TOKYO_LIGHT[teal]="#118c74"
TOKYO_LIGHT[red]="#8c4351"
TOKYO_LIGHT[red1]="#c64343"


get_color() {
    local variant="$1"
    local color_name="$2"
    
    case "$variant" in
        night)
            echo "${TOKYO_NIGHT[$color_name]}"
            ;;
        storm)
            echo "${TOKYO_STORM[$color_name]}"
            ;;
        light)
            echo "${TOKYO_LIGHT[$color_name]}"
            ;;
        *)
            echo "${TOKYO_NIGHT[$color_name]}"
            ;;
    esac
}


get_palette() {
    local variant="$1"
    
    case "$variant" in
        night)
            for key in "${!TOKYO_NIGHT[@]}"; do
                echo "$key=${TOKYO_NIGHT[$key]}"
            done
            ;;
        storm)
            for key in "${!TOKYO_STORM[@]}"; do
                echo "$key=${TOKYO_STORM[$key]}"
            done
            ;;
        light)
            for key in "${!TOKYO_LIGHT[@]}"; do
                echo "$key=${TOKYO_LIGHT[$key]}"
            done
            ;;
    esac
}


hex_to_rgb() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    echo "$r $g $b"
}


hex_to_rgb_comma() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    echo "$r, $g, $b"
}


hex_to_ansi() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    echo "38;2;$r;$g;$b"
}


hex_to_ansi_bg() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    echo "48;2;$r;$g;$b"
}


strip_hash() {
    echo "${1#\#}"
}
