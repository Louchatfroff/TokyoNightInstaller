#!/bin/bash

install_anifetch() {
    echo "[VERBOSE] Starting anifetch installation..."

    local anifetch_dir="$HOME/.config/anifetch"
    local config_file="$anifetch_dir/config.jsonc"

    mkdir -p "$anifetch_dir"

    echo "[VERBOSE] Creating anifetch configuration directory: $anifetch_dir"

    local variant="${SELECTED[variant]:-night}"
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

    echo "[VERBOSE] Generating anifetch config with Tokyo Night colors"
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
        "distro": "auto",
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

    echo "[VERBOSE] Creating anifetch script with Tokyo Night theme"
    local anifetch_script="$HOME/.config/tokyo-night/anifetch.sh"

    cat > "$anifetch_script" << 'ANIFETCHSCRIPT'
#!/bin/bash

ANIFETCH_CONFIG="$HOME/.config/anifetch/config.jsonc"

if [ ! -f "$ANIFETCH_CONFIG" ]; then
    echo "[ANIFETCH] Config file not found: $ANIFETCH_CONFIG"
    echo "[ANIFETCH] Please run the Tokyo Night installer to generate the config"
    exit 1
fi

if ! command -v jq &>/dev/null; then
    echo "[ANIFETCH] jq not found, installing..."
    if command -v apt &>/dev/null; then
        sudo apt install -y jq
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y jq
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm jq
    else
        echo "[ANIFETCH] Please install jq manually"
        exit 1
    fi
fi

get_system_info() {
    local bg_color=$(jq -r '.theme.background' "$ANIFETCH_CONFIG")
    local fg_color=$(jq -r '.theme.foreground' "$ANIFETCH_CONFIG")
    local accent_color=$(jq -r '.theme.accent' "$ANIFETCH_CONFIG")
    local secondary_color=$(jq -r '.theme.secondary' "$ANIFETCH_CONFIG")

    USER_HOST="${USER}@$(hostname)"
    OS=$(grep "^PRETTY_NAME" /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Linux")
    KERNEL=$(uname -r | cut -d'-' -f1)
    SHELL_NAME=$(basename "$SHELL")
    WM="${XDG_CURRENT_DESKTOP:-$(wmctrl -m 2>/dev/null | head -1 | cut -d: -f2 | tr -d ' ' || echo 'Unknown')}"
    TERM="${TERM_PROGRAM:-${TERM:-Unknown}}"
    MEM=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3"/"$2}' || echo "N/A")
}

print_anime_fetch() {
    get_system_info

    echo ""
    echo -e "\033[38;2;122;162;247m  ______"
    echo -e "\033[38;2;122;162;247m /      \\"
    echo -e "\033[38;2;122;162;247m|  T N  |"
    echo -e "\033[38;2;122;162;247m \\______/"
    echo -e "\033[38;2;122;162;247m   | |"
    echo ""
    echo -e "\033[38;2;187;154;247m${USER_HOST}\033[0m"
    echo -e "\033[38;2;125;207;255m──────────────────\033[0m"
    echo -e "\033[38;2;122;162;247mos\033[0m     ${OS}"
    echo -e "\033[38;2;125;207;255mker\033[0m    ${KERNEL}"
    echo -e "\033[38;2;158;206;106msh\033[0m     ${SHELL_NAME}"
    echo -e "\033[38;2;224;175;104mwm\033[0m     ${WM}"
    echo -e "\033[38;2;187;154;247mterm\033[0m   ${TERM}"
    echo -e "\033[38;2;125;207;255mmem\033[0m    ${MEM}"
    echo ""
}

print_anime_fetch
ANIFETCHSCRIPT

    chmod +x "$anifetch_script"
    echo "[SUCCESS] Anifetch configured with Tokyo Night theme"
    echo "$anifetch_script"
}
