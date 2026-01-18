#!/bin/bash

get_compact_ascii() {
    local distro="$1"

    case "$distro" in
        arch|archlinux)
            cat << 'EOF'
      /\
     /  \
    /    \
   /  ,,  \
  /  |  |  \
 /_-`    `-_\
EOF
            ;;
        debian)
            cat << 'EOF'
   ,---._
  /  __  \
 |  /  \  |
 |  \__/  |
  \       /
   `-----'
EOF
            ;;
        ubuntu)
            cat << 'EOF'
       _
   ---(_)
 /  ---  \
|    O    |
 \  ---  /
   ---(_)
EOF
            ;;
        fedora)
            cat << 'EOF'
    ____
   /    \
  |  f   |
  |  ____|
  |  |
  |__|
EOF
            ;;
        opensuse|suse)
            cat << 'EOF'
   .---.
  /     \
  \_.-._/
  /`   `\
  \     /
   `---'
EOF
            ;;
        gentoo)
            cat << 'EOF'
   .-----.
  /  O O  \
 |    >    |
  \  ---  /
   `-----'
EOF
            ;;
        nixos|nix)
            cat << 'EOF'
  \\ //
 ==\\/==
  //\\
 //  \\
==    ==
EOF
            ;;
        void|voidlinux)
            cat << 'EOF'
   ____
  /    \
 |  \/  |
 |  /\  |
  \____/
EOF
            ;;
        alpine)
            cat << 'EOF'
   /\\
  /  \\
 / /\ \\
/      \\
EOF
            ;;
        manjaro)
            cat << 'EOF'
 ||| |||
 ||| |||
 ||   ||
 || | ||
 || | ||
EOF
            ;;
        pikaos|pika)
            cat << 'EOF'
  __  __
 /  \/  \
| o    o |
|   <>   |
 \  --  /
  \____/
EOF
            ;;
        mint|linuxmint)
            cat << 'EOF'
 _______
|       |
| | L M |
| |     |
| |_____|
|_______|
EOF
            ;;
        pop|pop_os|popos)
            cat << 'EOF'
  ____
 /    \
| P! _ |
 \  (_)
  \___/
EOF
            ;;
        endeavouros|endeavour)
            cat << 'EOF'
    /\\
   /  \\
  / /\ \\
 / /__\ \\
/________\\
EOF
            ;;
        artix|artixlinux)
            cat << 'EOF'
    /\\
   /  \\
  /,   \\
 /      \\
/`.    .'\\
EOF
            ;;
        slackware)
            cat << 'EOF'
  ____
 /    |
 \__  |
 ___| |
|     /
|____/
EOF
            ;;
        centos)
            cat << 'EOF'
  ____
 /    \\
|  <>  |
 \____/
  ||||
EOF
            ;;
        rocky|rockylinux)
            cat << 'EOF'
   /\\
  /  \\
 / R  \\
/______\\
EOF
            ;;
        alma|almalinux)
            cat << 'EOF'
   /\\
  /A \\
 /____\\
 |    |
EOF
            ;;
        kali)
            cat << 'EOF'
  _____
 /     \\
< KALI >
 \_____/
EOF
            ;;
        parrot|parrotos)
            cat << 'EOF'
   ___
  /   \\
 <  P  >
  \\   /
   ---
EOF
            ;;
        elementary|elementaryos)
            cat << 'EOF'
  _____
 /  e  \\
|   O   |
 \\_____/
EOF
            ;;
        zorin|zorinos)
            cat << 'EOF'
  _____
 |     |
 |  Z  |
 |_____|
EOF
            ;;
        garuda)
            cat << 'EOF'
   ___
  / G \\
 /=====\\
/_______\\
EOF
            ;;
        cachyos|cachy)
            cat << 'EOF'
   ___
  / C \\
 |  @  |
  \\___/
EOF
            ;;
        nobara)
            cat << 'EOF'
   ___
  / N \\
 |  *  |
  \\___/
EOF
            ;;
        bazzite)
            cat << 'EOF'
   ___
  / B \\
 | |>  |
  \\___/
EOF
            ;;
        raspbian|raspberry)
            cat << 'EOF'
   sp
  sp sp
 sp  sp
  \\  /
EOF
            ;;
        redhat|rhel)
            cat << 'EOF'
   ___
  / R \\
 | H   |
  \\___/
EOF
            ;;
        nerd)
            cat << 'EOF'

EOF
            ;;
        tux|linux|*)
            cat << 'EOF'
  .---.
 /     \\
|  @ @  |
 \\_____/
   | |
EOF
            ;;
    esac
}

get_nerd_font_icon() {
    local distro="$1"

    case "$distro" in
        arch|archlinux)     echo "" ;;
        artix|artixlinux)   echo "" ;;
        debian)             echo "" ;;
        ubuntu)             echo "" ;;
        fedora)             echo "" ;;
        opensuse|suse)      echo "" ;;
        gentoo)             echo "" ;;
        nixos|nix)          echo "" ;;
        void|voidlinux)     echo "" ;;
        alpine)             echo "" ;;
        manjaro)            echo "" ;;
        pikaos|pika)        echo "" ;;
        mint|linuxmint)     echo "" ;;
        pop|pop_os|popos)   echo "" ;;
        endeavouros)        echo "" ;;
        garuda)             echo "" ;;
        cachyos|cachy)      echo "" ;;
        nobara)             echo "" ;;
        bazzite)            echo "" ;;
        kali)               echo "" ;;
        parrot|parrotos)    echo "" ;;
        centos)             echo "" ;;
        rocky|rockylinux)   echo "" ;;
        alma|almalinux)     echo "" ;;
        slackware)          echo "" ;;
        elementary)         echo "" ;;
        zorin|zorinos)      echo "" ;;
        raspbian)           echo "" ;;
        redhat|rhel)        echo "" ;;
        coreos)             echo "" ;;
        freebsd)            echo "" ;;
        openbsd)            echo "" ;;
        windows)            echo "" ;;
        macos|darwin)       echo "" ;;
        android)            echo "" ;;
        nerd)               echo "" ;;
        tux|linux|*)        echo "" ;;
    esac
}

get_neofetch_colors() {
    local variant="${1:-night}"

    case "$variant" in
        night|storm)
            echo "colors=(4 6 5 2 1 3)"
            ;;
        light)
            echo "colors=(4 6 5 2 1 3)"
            ;;
    esac
}

get_fastfetch_colors() {
    local variant="${1:-night}"

    case "$variant" in
        night|storm)
            cat << 'EOF'
"color": {
    "keys": "blue",
    "title": "magenta",
    "output": "white"
}
EOF
            ;;
        light)
            cat << 'EOF'
"color": {
    "keys": "blue",
    "title": "magenta",
    "output": "black"
}
EOF
            ;;
    esac
}

get_nerdfetch_colors() {
    local variant="${1:-night}"

    case "$variant" in
        night|storm)
            cat << 'EOF'
COLOR1="\e[38;2;122;162;247m"
COLOR2="\e[38;2;125;207;255m"
COLOR3="\e[38;2;187;154;247m"
COLOR4="\e[38;2;158;206;106m"
COLOR5="\e[38;2;247;118;142m"
COLOR6="\e[38;2;224;175;104m"
RESET="\e[0m"
EOF
            ;;
        light)
            cat << 'EOF'
COLOR1="\e[38;2;52;84;138m"
COLOR2="\e[38;2;15;75;110m"
COLOR3="\e[38;2;90;74;120m"
COLOR4="\e[38;2;51;99;92m"
COLOR5="\e[38;2;140;67;81m"
COLOR6="\e[38;2;150;80;39m"
RESET="\e[0m"
EOF
            ;;
    esac
}

generate_neofetch_config() {
    local variant="${1:-night}"
    local ascii_file="$2"

    cat << NEOFETCHCFG
print_info() {
    info title
    info underline
    info "OS" distro
    info "Kernel" kernel
    info "Shell" shell
    info "WM" wm
    info "Term" term
    info "CPU" cpu
    info "Mem" memory
}

title_fqdn="off"
kernel_shorthand="on"
distro_shorthand="on"
os_arch="off"
uptime_shorthand="tiny"
memory_percent="off"
memory_unit="gib"
shell_path="off"
shell_version="off"
speed_shorthand="on"
cpu_brand="off"
cpu_speed="off"
cpu_cores="off"
cpu_temp="off"
gpu_brand="off"
gpu_type="dedicated"
de_version="off"
bold="on"
underline_enabled="on"
underline_char="-"
separator=" :"
image_backend="ascii"
image_source="$ascii_file"
ascii_bold="on"
gap=2
NEOFETCHCFG
}

generate_fastfetch_config() {
    local variant="${1:-night}"
    local ascii_file="$2"
    local logo_type="${3:-small}"

    local logo_config
    case "$logo_type" in
        small)
            logo_config="\"source\": \"$ascii_file\",
        \"type\": \"file\""
            ;;
        auto)
            logo_config="\"type\": \"auto\""
            ;;
        none)
            logo_config="\"type\": \"none\""
            ;;
    esac

    cat << FASTFETCHCFG
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        $logo_config,
        "padding": {
            "top": 0,
            "left": 1,
            "right": 2
        }
    },
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
FASTFETCHCFG
}

generate_nerdfetch_config() {
    local distro="$1"
    local style="${2:-icon}"
    local variant="${3:-night}"

    local icon
    icon=$(get_nerd_font_icon "$distro")

    cat << NERDFETCHCONF
ICON="$icon"
STYLE="$style"

$(get_nerdfetch_colors "$variant")
NERDFETCHCONF
}

generate_nerdfetch_script() {
    cat << 'NERDFETCHSCRIPT'
#!/bin/bash

source "$HOME/.config/nerdfetch/config" 2>/dev/null

: "${ICON:=}"
: "${STYLE:=icon}"
: "${COLOR1:=\e[34m}"
: "${COLOR2:=\e[36m}"
: "${COLOR3:=\e[35m}"
: "${COLOR4:=\e[32m}"
: "${COLOR5:=\e[31m}"
: "${COLOR6:=\e[33m}"
: "${RESET:=\e[0m}"

get_info() {
    USER_HOST="${USER}@$(hostname)"
    OS=$(grep "^PRETTY_NAME" /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Linux")
    KERNEL=$(uname -r | cut -d'-' -f1)
    SHELL_NAME=$(basename "$SHELL")
    WM="${XDG_CURRENT_DESKTOP:-$(wmctrl -m 2>/dev/null | head -1 | cut -d: -f2 | tr -d ' ' || echo 'Unknown')}"
    TERM="${TERM_PROGRAM:-${TERM:-Unknown}}"
    MEM=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3"/"$2}' || echo "N/A")
}

print_fetch() {
    get_info

    case "$STYLE" in
        minimal)
            echo -e "${COLOR1}${ICON}${RESET}"
            ;;
        icon)
            echo ""
            echo -e "  ${COLOR1}${ICON}${RESET}   ${COLOR3}${USER_HOST}${RESET}"
            echo -e "      ${COLOR1}os${RESET}    ${OS}"
            echo -e "      ${COLOR2}ker${RESET}   ${KERNEL}"
            echo -e "      ${COLOR4}sh${RESET}    ${SHELL_NAME}"
            echo -e "      ${COLOR6}wm${RESET}    ${WM}"
            echo -e "      ${COLOR3}term${RESET}  ${TERM}"
            echo -e "      ${COLOR2}mem${RESET}   ${MEM}"
            echo ""
            ;;
        full)
            echo ""
            echo -e "  ${COLOR1}${ICON}${RESET}"
            echo ""
            echo -e "  ${COLOR3}${USER_HOST}${RESET}"
            echo -e "  ${COLOR1}──────────────────${RESET}"
            echo -e "  ${COLOR1}os${RESET}     ${OS}"
            echo -e "  ${COLOR2}ker${RESET}    ${KERNEL}"
            echo -e "  ${COLOR4}sh${RESET}     ${SHELL_NAME}"
            echo -e "  ${COLOR6}wm${RESET}     ${WM}"
            echo -e "  ${COLOR3}term${RESET}   ${TERM}"
            echo -e "  ${COLOR2}mem${RESET}    ${MEM}"
            echo ""
            ;;
    esac
}

print_fetch
NERDFETCHSCRIPT
}

generate_fetch_aliases() {
    cat << 'ALIASCONF'
alias fetch='tokyo-fetch'
alias nf='tokyo-fetch'

tokyo-fetch() {
    if command -v fastfetch &>/dev/null; then
        fastfetch "$@"
    elif command -v neofetch &>/dev/null; then
        neofetch "$@"
    elif [ -x "$HOME/.config/nerdfetch/tokyo-night-nerdfetch" ]; then
        "$HOME/.config/nerdfetch/tokyo-night-nerdfetch"
    elif command -v nerdfetch &>/dev/null; then
        nerdfetch "$@"
    else
        echo "No fetch tool found"
    fi
}
ALIASCONF
}

setup_fastfetch_presets() {
    local preset_source="$1"
    local variant="${2:-night}"
    local fastfetch_dir="$HOME/.config/fastfetch"
    local cache_dir="$HOME/.cache/tokyo-night-fastfetch"

    mkdir -p "$fastfetch_dir" "$cache_dir"

    log_info "Setting up fastfetch presets from $preset_source..."

    case "$preset_source" in
        lierb)
            download_lierb_presets "$cache_dir" "$fastfetch_dir" "$variant"
            ;;
        m3tozz)
            download_m3tozz_presets "$cache_dir" "$fastfetch_dir" "$variant"
            ;;
        sofijacom)
            download_sofijacom_presets "$cache_dir" "$fastfetch_dir" "$variant"
            ;;
        *)
            log_error "Unknown preset source: $preset_source"
            return 1
            ;;
    esac

    log_success "Fastfetch presets configured with Tokyo Night theme"
}

download_lierb_presets() {
    local cache_dir="$1"
    local config_dir="$2"
    local variant="$3"

    local repo_url="https://github.com/LierB/fastfetch"
    local temp_dir="$cache_dir/lierb"

    if [ ! -d "$temp_dir" ]; then
        log_info "Cloning LierB fastfetch presets..."
        git clone --depth=1 "$repo_url" "$temp_dir" 2>/dev/null || {
            log_warn "Failed to clone LierB repo, using fallback presets"
            create_fallback_fastfetch_preset "$config_dir" "$variant"
            return 0
        }
    else
        log_info "Updating LierB presets..."
        git -C "$temp_dir" pull 2>/dev/null || true
    fi

    find "$temp_dir" -name "*.jsonc" -o -name "*.json" | head -5 | while read -r preset_file; do
        local preset_name
        preset_name=$(basename "$preset_file" .jsonc)
        preset_name=$(basename "$preset_name" .json)
        local output_file="$config_dir/${preset_name}-tokyonight.jsonc"

        log_info "Processing preset: $preset_name"

        cp "$preset_file" "$output_file"
        modify_fastfetch_colors "$output_file" "$variant"

        if [ ! -f "$config_dir/config.jsonc" ]; then
            ln -sf "$(basename "$output_file")" "$config_dir/config.jsonc"
        fi
    done
}

download_m3tozz_presets() {
    local cache_dir="$1"
    local config_dir="$2"
    local variant="$3"

    local repo_url="https://github.com/m3tozz/FastCat"
    local temp_dir="$cache_dir/m3tozz"

    if [ ! -d "$temp_dir" ]; then
        log_info "Cloning m3tozz FastCat presets..."
        git clone --depth=1 "$repo_url" "$temp_dir" 2>/dev/null || {
            log_warn "Failed to clone m3tozz repo, using fallback presets"
            create_fallback_fastfetch_preset "$config_dir" "$variant"
            return 0
        }
    else
        log_info "Updating m3tozz presets..."
        git -C "$temp_dir" pull 2>/dev/null || true
    fi

    find "$temp_dir" -name "*.jsonc" -o -name "*.json" | head -5 | while read -r preset_file; do
        local preset_name
        preset_name=$(basename "$preset_file" .jsonc)
        preset_name=$(basename "$preset_name" .json)
        local output_file="$config_dir/${preset_name}-tokyonight.jsonc"

        log_info "Processing preset: $preset_name"

        cp "$preset_file" "$output_file"
        modify_fastfetch_colors "$output_file" "$variant"
    done
}

download_sofijacom_presets() {
    local cache_dir="$1"
    local config_dir="$2"
    local variant="$3"

    local repo_url="https://github.com/sofijacom/dotfiles-fastfetch"
    local temp_dir="$cache_dir/sofijacom"

    if [ ! -d "$temp_dir" ]; then
        log_info "Cloning sofijacom fastfetch presets..."
        git clone --depth=1 "$repo_url" "$temp_dir" 2>/dev/null || {
            log_warn "Failed to clone sofijacom repo, using fallback presets"
            create_fallback_fastfetch_preset "$config_dir" "$variant"
            return 0
        }
    else
        log_info "Updating sofijacom presets..."
        git -C "$temp_dir" pull 2>/dev/null || true
    fi

    find "$temp_dir" -name "*.jsonc" -o -name "*.json" | head -5 | while read -r preset_file; do
        local preset_name
        preset_name=$(basename "$preset_file" .jsonc)
        preset_name=$(basename "$preset_name" .json)
        local output_file="$config_dir/${preset_name}-tokyonight.jsonc"

        log_info "Processing preset: $preset_name"

        cp "$preset_file" "$output_file"
        modify_fastfetch_colors "$output_file" "$variant"
    done
}

modify_fastfetch_colors() {
    local config_file="$1"
    local variant="$2"

    cp "$config_file" "${config_file}.backup"

    case "$variant" in
        night|storm)
            sed -i 's/"color":\s*"[^"]*"/"color": "blue"/g' "$config_file" 2>/dev/null || true
            sed -i 's/"title":\s*"[^"]*"/"title": "magenta"/g' "$config_file" 2>/dev/null || true
            sed -i 's/"separator":\s*"[^"]*"/"separator": "cyan"/g' "$config_file" 2>/dev/null || true

            if ! grep -q '"color"' "$config_file"; then
                sed -i 's/"display":\s*{/"display": {\n    "color": {\n      "keys": "blue",\n      "title": "magenta"\n    },/g' "$config_file" 2>/dev/null || true
            fi
            ;;
        light)
            sed -i 's/"color":\s*"[^"]*"/"color": "blue"/g' "$config_file" 2>/dev/null || true
            sed -i 's/"title":\s*"[^"]*"/"title": "magenta"/g' "$config_file" 2>/dev/null || true
            sed -i 's/"separator":\s*"[^"]*"/"separator": "cyan"/g' "$config_file" 2>/dev/null || true

            if ! grep -q '"color"' "$config_file"; then
                sed -i 's/"display":\s*{/"display": {\n    "color": {\n      "keys": "blue",\n      "title": "magenta"\n    },/g' "$config_file" 2>/dev/null || true
            fi
            ;;
    esac

    if command -v jq &>/dev/null; then
        jq '.' "$config_file" > "${config_file}.tmp" 2>/dev/null && mv "${config_file}.tmp" "$config_file" || {
            log_warn "JSON validation failed, restoring backup"
            mv "${config_file}.backup" "$config_file"
        }
    fi

    rm -f "${config_file}.backup"
}

create_fallback_fastfetch_preset() {
    local config_dir="$1"
    local variant="$2"
    local config_file="$config_dir/config.jsonc"

    log_info "Creating fallback fastfetch preset..."

    cat > "$config_file" << FASTFETCHFB
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
FASTFETCHFB

    log_success "Fallback fastfetch preset created"
}

list_available_distros() {
    cat << 'DISTROLIST'
arch        - Arch Linux
artix       - Artix Linux
debian      - Debian
ubuntu      - Ubuntu
fedora      - Fedora
opensuse    - openSUSE
gentoo      - Gentoo
nixos       - NixOS
void        - Void Linux
alpine      - Alpine Linux
manjaro     - Manjaro
pikaos      - PikaOS
mint        - Linux Mint
pop         - Pop!_OS
endeavouros - EndeavourOS
garuda      - Garuda Linux
cachyos     - CachyOS
nobara      - Nobara
bazzite     - Bazzite
kali        - Kali Linux
parrot      - Parrot OS
centos      - CentOS
rocky       - Rocky Linux
alma        - AlmaLinux
slackware   - Slackware
elementary  - elementary OS
zorin       - Zorin OS
raspbian    - Raspberry Pi OS
redhat      - Red Hat
nerd        - Nerd Font Icon
tux         - Generic Linux
DISTROLIST
}

preview_distro_icon() {
    local distro="$1"

    echo "ASCII Art:"
    echo "----------"
    get_compact_ascii "$distro"
    echo ""
    echo "Nerd Font Icon: $(get_nerd_font_icon "$distro")"
}
