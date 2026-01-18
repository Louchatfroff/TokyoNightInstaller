#!/bin/bash

get_anifetch_config() {
    local variant="${1:-night}"
    local distro="${2:-auto}"
    local config_dir="$HOME/.config/anifetch"
    local config_file="$config_dir/config.jsonc"

    mkdir -p "$config_dir"

    local bg_color, fg_color, accent_color, secondary_color, text_color

    case "$variant" in
        night|storm)
            bg_color="#1a1b26"
            fg_color="#c0caf5"
            accent_color="#7aa2f7"
            secondary_color="#bb9af7"
            text_color="#7dcfff"
            ;;
        light)
            bg_color="#d5d6db"
            fg_color="#343b58"
            accent_color="#34548a"
            secondary_color="#5a4a78"
            text_color="#0f4b6e"
            ;;
        *)
            bg_color="#1a1b26"
            fg_color="#c0caf5"
            accent_color="#7aa2f7"
            secondary_color="#bb9af7"
            text_color="#7dcfff"
            ;;
    esac

    cat > "$config_file" << ANIFETCHCONF
{
    "theme": {
        "background": "$bg_color",
        "foreground": "$fg_color",
        "accent": "$accent_color",
        "secondary": "$secondary_color",
        "text": "$text_color"
    },
    "logo": {
        "type": "distro",
        "distro": "$distro",
        "size": "medium",
        "color": "$accent_color"
    },
    "info": {
        "show": true,
        "format": "compact",
        "color": "$fg_color",
        "key_color": "$accent_color",
        "separator": " : "
    },
    "modules": [
        "os",
        "kernel",
        "shell",
        "wm",
        "terminal",
        "cpu",
        "memory"
    ],
    "ascii": {
        "show": true,
        "color": "$accent_color",
        "secondary_color": "$secondary_color"
    }
}
ANIFETCHCONF

    echo "$config_file"
}

get_anime_ascii() {
    local anime="${1:-default}"
    local color="${2:-#7aa2f7}"

    case "$anime" in
        default|tokyo)
            cat << ASCII
  ______
 /      \\
|  T N  |
 \\______/
   | |
ASCII
            ;;
        catgirl)
            cat << ASCII
  /\\_/\\
 ( o.o )
  > ^ <
ASCII
            ;;
        fox)
            cat << ASCII
  /\\_/\\
 ( -.- )
  > ^ <
ASCII
            ;;
        wolf)
            cat << ASCII
  /\\_/\\
 ( @.@ )
  > ^ <
ASCII
            ;;
        dragon)
            cat << ASCII
  /\\_/\\
 ( O.O )
  > ^ <
ASCII
            ;;
        *)
            cat << ASCII
  ______
 /      \\
|  T N  |
 \\______/
   | |
ASCII
            ;;
    esac
}

create_anime_fetch() {
    local variant="${1:-night}"
    local anime_theme="${2:-default}"
    local output_file="$HOME/.config/tokyo-night/anifetch.sh"

    mkdir -p "$(dirname "$output_file")"

    local bg_color, fg_color, accent_color, secondary_color

    case "$variant" in
        night|storm)
            bg_color="#1a1b26"
            fg_color="#c0caf5"
            accent_color="#7aa2f7"
            secondary_color="#bb9af7"
            ;;
        light)
            bg_color="#d5d6db"
            fg_color="#343b58"
            accent_color="#34548a"
            secondary_color="#5a4a78"
            ;;
        *)
            bg_color="#1a1b26"
            fg_color="#c0caf5"
            accent_color="#7aa2f7"
            secondary_color="#bb9af7"
            ;;
    esac

    cat > "$output_file" << ANIFETCHSCRIPT
#!/bin/bash

COLOR_BG="$bg_color"
COLOR_FG="$fg_color"
COLOR_ACCENT="$accent_color"
COLOR_SECONDARY="$secondary_color"

get_system_info() {
    USER_HOST="\${USER}@\$(hostname)"
    OS=\$(grep "^PRETTY_NAME" /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Linux")
    KERNEL=\$(uname -r | cut -d'-' -f1)
    SHELL_NAME=\$(basename "\$SHELL")
    WM="\${XDG_CURRENT_DESKTOP:-\$(wmctrl -m 2>/dev/null | head -1 | cut -d: -f2 | tr -d ' ' || echo 'Unknown')}"
    TERM="\${TERM_PROGRAM:-\${TERM:-Unknown}}"
    MEM=\$(free -h 2>/dev/null | awk '/^Mem:/ {print \$3"/"\$2}' || echo "N/A")
}

print_anime_fetch() {
    get_system_info

    echo ""
    echo -e "\033[38;2;122;162;247m  ______"
    echo -e "\033[38;2;122;162;247m /      \\\\"
    echo -e "\033[38;2;122;162;247m|  T N  |"
    echo -e "\033[38;2;122;162;247m \\\\______/"
    echo -e "\033[38;2;122;162;247m   | |"
    echo ""
    echo -e "\033[38;2;187;154;247m\${USER_HOST}\033[0m"
    echo -e "\033[38;2;125;207;255m──────────────────\033[0m"
    echo -e "\033[38;2;122;162;247mos\033[0m     \${OS}"
    echo -e "\033[38;2;125;207;255mker\033[0m    \${KERNEL}"
    echo -e "\033[38;2;158;206;106msh\033[0m     \${SHELL_NAME}"
    echo -e "\033[38;2;224;175;104mwm\033[0m     \${WM}"
    echo -e "\033[38;2;187;154;247mterm\033[0m   \${TERM}"
    echo -e "\033[38;2;125;207;255mmem\033[0m    \${MEM}"
    echo ""
}

print_anime_fetch
ANIFETCHSCRIPT

    chmod +x "$output_file"
    echo "$output_file"
}
