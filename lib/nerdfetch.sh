#!/bin/bash

get_nerd_font_icon() {
    local distro="$1"

    case "$distro" in
        arch|archlinux)     echo "" ;;
        artix|artixlinux)   echo "" ;;
        debian)             echo "" ;;
        ubuntu)             echo "" ;;
        fedora)             echo "" ;;
        opensuse|suse)      echo "" ;;
        gentoo)             echo "" ;;
        nixos|nix)          echo "" ;;
        void|voidlinux)     echo "" ;;
        alpine)             echo "" ;;
        manjaro)            echo "" ;;
        pikaos|pika)        echo "" ;;
        mint|linuxmint)     echo "" ;;
        pop|pop_os|popos)   echo "" ;;
        endeavouros)        echo "" ;;
        garuda)             echo "" ;;
        cachyos|cachy)      echo "" ;;
        nobara)             echo "" ;;
        bazzite)            echo "" ;;
        kali)               echo "" ;;
        parrot|parrotos)    echo "" ;;
        centos)             echo "" ;;
        rocky|rockylinux)   echo "" ;;
        alma|almalinux)     echo "" ;;
        slackware)          echo "" ;;
        elementary)         echo "" ;;
        zorin|zorinos)      echo "" ;;
        raspbian)           echo "" ;;
        redhat|rhel)        echo "" ;;
        coreos)             echo "" ;;
        freebsd)            echo "" ;;
        openbsd)            echo "" ;;
        windows)            echo "" ;;
        macos|darwin)       echo "" ;;
        android)            echo "" ;;
        nerd)               echo "" ;;
        tux|linux|*)        echo "" ;;
    esac
}

get_nerdfetch_config() {
    local variant="${1:-night}"
    local distro="${2:-auto}"
    local config_dir="$HOME/.config/nerdfetch"
    local config_file="$config_dir/config"

    mkdir -p "$config_dir"

    local color1, color2, color3, color4, color5, color6

    case "$variant" in
        night|storm)
            color1="#7aa2f7"
            color2="#7dcfff"
            color3="#bb9af7"
            color4="#9ece6a"
            color5="#f7768e"
            color6="#e0af68"
            ;;
        light)
            color1="#34548a"
            color2="#0f4b6e"
            color3="#5a4a78"
            color4="#33635c"
            color5="#8c4351"
            color6="#8f5e15"
            ;;
        *)
            color1="#7aa2f7"
            color2="#7dcfff"
            color3="#bb9af7"
            color4="#9ece6a"
            color5="#f7768e"
            color6="#e0af68"
            ;;
    esac

    local icon
    icon=$(get_nerd_font_icon "$distro")

    cat > "$config_file" << NERDFETCHCONF
ICON="$icon"
STYLE="icon"

COLOR1="$color1"
COLOR2="$color2"
COLOR3="$color3"
COLOR4="$color4"
COLOR5="$color5"
COLOR6="$color6"
RESET="\e[0m"
NERDFETCHCONF

    echo "$config_file"
}

create_nerdfetch_script() {
    local variant="${1:-night}"
    local distro="${2:-auto}"
    local output_file="$HOME/.config/tokyo-night/nerdfetch.sh"

    mkdir -p "$(dirname "$output_file")"

    local color1, color2, color3, color4, color5, color6

    case "$variant" in
        night|storm)
            color1="#7aa2f7"
            color2="#7dcfff"
            color3="#bb9af7"
            color4="#9ece6a"
            color5="#f7768e"
            color6="#e0af68"
            ;;
        light)
            color1="#34548a"
            color2="#0f4b6e"
            color3="#5a4a78"
            color4="#33635c"
            color5="#8c4351"
            color6="#8f5e15"
            ;;
        *)
            color1="#7aa2f7"
            color2="#7dcfff"
            color3="#bb9af7"
            color4="#9ece6a"
            color5="#f7768e"
            color6="#e0af68"
            ;;
    esac

    local icon
    icon=$(get_nerd_font_icon "$distro")

    cat > "$output_file" << NERDFETCHSCRIPT
#!/bin/bash

ICON="$icon"

COLOR1="\e[38;2;122;162;247m"
COLOR2="\e[38;2;125;207;255m"
COLOR3="\e[38;2;187;154;247m"
COLOR4="\e[38;2;158;206;106m"
COLOR5="\e[38;2;247;118;142m"
COLOR6="\e[38;2;224;175;104m"
RESET="\e[0m"

get_system_info() {
    USER_HOST="\${USER}@\$(hostname)"
    OS=\$(grep "^PRETTY_NAME" /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Linux")
    KERNEL=\$(uname -r | cut -d'-' -f1)
    SHELL_NAME=\$(basename "\$SHELL")
    WM="\${XDG_CURRENT_DESKTOP:-\$(wmctrl -m 2>/dev/null | head -1 | cut -d: -f2 | tr -d ' ' || echo 'Unknown')}"
    TERM="\${TERM_PROGRAM:-\${TERM:-Unknown}}"
    MEM=\$(free -h 2>/dev/null | awk '/^Mem:/ {print \$3"/"\$2}' || echo "N/A")
}

print_nerdfetch() {
    get_system_info

    echo ""
    echo -e "\${COLOR1}\${ICON}\${RESET}   \${COLOR3}\${USER_HOST}\${RESET}"
    echo -e "      \${COLOR1}os\${RESET}    \${OS}"
    echo -e "      \${COLOR2}ker\${RESET}   \${KERNEL}"
    echo -e "      \${COLOR4}sh\${RESET}    \${SHELL_NAME}"
    echo -e "      \${COLOR6}wm\${RESET}    \${WM}"
    echo -e "      \${COLOR3}term\${RESET}  \${TERM}"
    echo -e "      \${COLOR2}mem\${RESET}   \${MEM}"
    echo ""
}

print_nerdfetch
NERDFETCHSCRIPT

    chmod +x "$output_file"
    echo "$output_file"
}
