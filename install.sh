#!/bin/bash

set -e


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$HOME/.cache/tokyo-night-installer"
CONFIG_DIR="$HOME/.config/tokyo-night-installer"
ICONS_REPO="https://github.com/ljmill/tokyo-night-icons"
WALLPAPERS_REPO="https://github.com/tokyo-night/wallpapers"
ICONS_RELEASE="https://github.com/ljmill/tokyo-night-icons/releases/download/v0.2.0/TokyoNight-SE.tar.bz2"


declare -A DETECTED
declare -A SELECTED


TOKYONIGHT_NIGHT_BG="#1a1b26"
TOKYONIGHT_NIGHT_FG="#c0caf5"
TOKYONIGHT_NIGHT_SELECTION="#33467c"
TOKYONIGHT_NIGHT_COMMENT="#565f89"
TOKYONIGHT_NIGHT_RED="#f7768e"
TOKYONIGHT_NIGHT_ORANGE="#ff9e64"
TOKYONIGHT_NIGHT_YELLOW="#e0af68"
TOKYONIGHT_NIGHT_GREEN="#9ece6a"
TOKYONIGHT_NIGHT_CYAN="#7dcfff"
TOKYONIGHT_NIGHT_BLUE="#7aa2f7"
TOKYONIGHT_NIGHT_MAGENTA="#bb9af7"

TOKYONIGHT_STORM_BG="#24283b"
TOKYONIGHT_STORM_FG="#c0caf5"
TOKYONIGHT_STORM_SELECTION="#364a82"
TOKYONIGHT_STORM_COMMENT="#565f89"

TOKYONIGHT_LIGHT_BG="#d5d6db"
TOKYONIGHT_LIGHT_FG="#343b58"
TOKYONIGHT_LIGHT_SELECTION="#99a7df"
TOKYONIGHT_LIGHT_COMMENT="#9699a3"
TOKYONIGHT_LIGHT_RED="#8c4351"
TOKYONIGHT_LIGHT_ORANGE="#965027"
TOKYONIGHT_LIGHT_YELLOW="#8f5e15"
TOKYONIGHT_LIGHT_GREEN="#33635c"
TOKYONIGHT_LIGHT_CYAN="#0f4b6e"
TOKYONIGHT_LIGHT_BLUE="#34548a"
TOKYONIGHT_LIGHT_MAGENTA="#5a4a78"


mkdir -p "$CACHE_DIR" "$CONFIG_DIR"


log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;32m[OK]\033[0m $1"
}

log_warn() {
    echo -e "\033[1;33m[WARN]\033[0m $1"
}

log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}


check_dependencies() {
    local missing=()

    for cmd in git curl wget tar; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if ! command -v zenity &>/dev/null && ! command -v yad &>/dev/null; then
        missing+=("zenity or yad")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Please install them using your package manager"
        exit 1
    fi
}


detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DETECTED[distro]="$ID"
        DETECTED[distro_name]="$PRETTY_NAME"
        DETECTED[distro_family]="$ID_LIKE"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DETECTED[distro]="$DISTRIB_ID"
        DETECTED[distro_name]="$DISTRIB_DESCRIPTION"
    elif command -v lsb_release &>/dev/null; then
        DETECTED[distro]=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        DETECTED[distro_name]=$(lsb_release -sd)
    else
        DETECTED[distro]="unknown"
        DETECTED[distro_name]="Unknown Linux Distribution"
    fi

    if [[ "${DETECTED[distro_name]}" == *"PikaOS"* ]] || [[ "${DETECTED[distro]}" == "pika" ]]; then
        DETECTED[distro]="pikaos"
        DETECTED[is_pikaos]="true"
    fi

    log_info "Detected distro: ${DETECTED[distro_name]}"
}


detect_shell() {
    DETECTED[shell]=$(basename "$SHELL")

    local shells=()
    [ -f "$HOME/.bashrc" ] && shells+=("bash")
    [ -f "$HOME/.zshrc" ] && shells+=("zsh")
    [ -f "$HOME/.config/fish/config.fish" ] && shells+=("fish")
    [ -f "$HOME/.config/nushell/config.nu" ] && shells+=("nushell")

    DETECTED[available_shells]="${shells[*]}"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        DETECTED[has_ohmyzsh]="true"
    fi

    if [ -f "$HOME/.p10k.zsh" ] || [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        DETECTED[has_p10k]="true"
    fi

    if command -v starship &>/dev/null; then
        DETECTED[has_starship]="true"
    fi

    if [ -d "${ZDOTDIR:-$HOME}/.zsh/pure" ] || [ -f "$HOME/.zsh/pure/pure.zsh" ]; then
        DETECTED[has_pure]="true"
    fi

    log_info "Detected shell: ${DETECTED[shell]} (available: ${DETECTED[available_shells]})"
}


detect_terminal() {
    local terminals=()

    command -v kitty &>/dev/null && terminals+=("kitty")
    command -v wezterm &>/dev/null && terminals+=("wezterm")
    command -v alacritty &>/dev/null && terminals+=("alacritty")
    command -v foot &>/dev/null && terminals+=("foot")
    command -v gnome-terminal &>/dev/null && terminals+=("gnome-terminal")
    command -v konsole &>/dev/null && terminals+=("konsole")
    command -v xfce4-terminal &>/dev/null && terminals+=("xfce4-terminal")
    command -v tilix &>/dev/null && terminals+=("tilix")
    command -v terminator &>/dev/null && terminals+=("terminator")
    command -v st &>/dev/null && terminals+=("st")
    command -v urxvt &>/dev/null && terminals+=("urxvt")
    command -v xterm &>/dev/null && terminals+=("xterm")

    DETECTED[terminals]="${terminals[*]}"

    if [ -n "$TERM_PROGRAM" ]; then
        DETECTED[current_terminal]="$TERM_PROGRAM"
    elif [ -n "$KITTY_WINDOW_ID" ]; then
        DETECTED[current_terminal]="kitty"
    elif [ -n "$WEZTERM_PANE" ]; then
        DETECTED[current_terminal]="wezterm"
    elif [ -n "$ALACRITTY_SOCKET" ]; then
        DETECTED[current_terminal]="alacritty"
    else
        DETECTED[current_terminal]="unknown"
    fi

    log_info "Detected terminals: ${DETECTED[terminals]}"
}


detect_de_wm() {
    DETECTED[de]="${XDG_CURRENT_DESKTOP:-unknown}"
    DETECTED[session]="${XDG_SESSION_TYPE:-unknown}"

    local wms=()

    if [ "${DETECTED[session]}" = "wayland" ]; then
        pgrep -x "sway" &>/dev/null && wms+=("sway")
        pgrep -x "hyprland" &>/dev/null && wms+=("hyprland")
        pgrep -x "Hyprland" &>/dev/null && wms+=("hyprland")
        pgrep -x "river" &>/dev/null && wms+=("river")
        pgrep -x "wayfire" &>/dev/null && wms+=("wayfire")
        pgrep -x "niri" &>/dev/null && wms+=("niri")
        command -v niri &>/dev/null && wms+=("niri")
        pgrep -x "cosmic" &>/dev/null && wms+=("cosmic")
    else
        pgrep -x "i3" &>/dev/null && wms+=("i3")
        pgrep -x "bspwm" &>/dev/null && wms+=("bspwm")
        pgrep -x "openbox" &>/dev/null && wms+=("openbox")
        pgrep -x "awesome" &>/dev/null && wms+=("awesome")
        pgrep -x "dwm" &>/dev/null && wms+=("dwm")
        pgrep -x "qtile" &>/dev/null && wms+=("qtile")
        pgrep -x "xmonad" &>/dev/null && wms+=("xmonad")
        pgrep -x "herbstluftwm" &>/dev/null && wms+=("herbstluftwm")
    fi

    [ "${DETECTED[de]}" = "GNOME" ] && wms+=("gnome")
    [ "${DETECTED[de]}" = "KDE" ] && wms+=("kde")
    [ "${DETECTED[de]}" = "XFCE" ] && wms+=("xfce")
    [ "${DETECTED[de]}" = "MATE" ] && wms+=("mate")
    [ "${DETECTED[de]}" = "Cinnamon" ] && wms+=("cinnamon")
    [ "${DETECTED[de]}" = "LXQt" ] && wms+=("lxqt")
    [ "${DETECTED[de]}" = "Budgie" ] && wms+=("budgie")
    [ "${DETECTED[de]}" = "COSMIC" ] && wms+=("cosmic")

    command -v swww &>/dev/null && DETECTED[has_swww]="true"
    command -v neofetch &>/dev/null && DETECTED[has_neofetch]="true"
    command -v fastfetch &>/dev/null && DETECTED[has_fastfetch]="true"
    command -v nerdfetch &>/dev/null && DETECTED[has_nerdfetch]="true"
    command -v waybar &>/dev/null && DETECTED[has_waybar]="true"

    local fetch_tools=()
    [ "${DETECTED[has_neofetch]}" = "true" ] && fetch_tools+=("neofetch")
    [ "${DETECTED[has_fastfetch]}" = "true" ] && fetch_tools+=("fastfetch")
    [ "${DETECTED[has_nerdfetch]}" = "true" ] && fetch_tools+=("nerdfetch")
    DETECTED[fetch_tools]="${fetch_tools[*]}"

    [ "${DETECTED[has_waybar]}" = "true" ] && wms+=("waybar")

    if [ -f "/usr/bin/pikabar" ] || [ -f "$HOME/.config/pikabar" ] || command -v pikabar &>/dev/null; then
        DETECTED[has_pikabar]="true"
        wms+=("pikabar")
    fi

    wms=($(echo "${wms[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

    DETECTED[wms]="${wms[*]}"
    log_info "Detected DE: ${DETECTED[de]}, Session: ${DETECTED[session]}, WMs: ${DETECTED[wms]}"
}


detect_gtk_qt() {
    DETECTED[gtk3_config]="$HOME/.config/gtk-3.0/settings.ini"
    DETECTED[gtk4_config]="$HOME/.config/gtk-4.0/settings.ini"

    if [ -f "$HOME/.config/Kvantum/kvantum.kvconfig" ]; then
        DETECTED[kvantum]="true"
    fi

    log_info "GTK/Qt detection complete"
}


show_gui() {
    local gui_cmd="zenity"
    command -v yad &>/dev/null && gui_cmd="yad"

    local theme_variant
    local install_icons
    local install_wallpaper
    local selected_shells
    local selected_terminals
    local selected_wms

    if [ "$gui_cmd" = "zenity" ]; then
        theme_variant=$(zenity --list \
            --title="Tokyo Night Theme Installer" \
            --text="Select theme variant:" \
            --radiolist \
            --column="Select" --column="Variant" --column="Description" \
            TRUE "night" "Dark blue theme (default)" \
            FALSE "storm" "Darker variant" \
            FALSE "light" "Light theme" \
            --width=500 --height=300 2>/dev/null) || exit 1

        local shell_list=""
        for shell in ${DETECTED[available_shells]}; do
            shell_list+="TRUE $shell "
        done

        if [ -n "$shell_list" ]; then
            selected_shells=$(zenity --list \
                --title="Select Shells" \
                --text="Select shells to configure:" \
                --checklist \
                --column="Select" --column="Shell" \
                $shell_list \
                --width=400 --height=300 2>/dev/null) || selected_shells=""
        fi

        local zsh_prompt_type="standard"
        if [[ "$selected_shells" == *"zsh"* ]]; then
            local prompt_options="TRUE standard Standard_zsh_prompt "
            [ "${DETECTED[has_ohmyzsh]}" = "true" ] && prompt_options+="FALSE ohmyzsh Oh_My_Zsh_theme "
            [ "${DETECTED[has_p10k]}" = "true" ] && prompt_options+="FALSE p10k Powerlevel10k "
            [ "${DETECTED[has_starship]}" = "true" ] && prompt_options+="FALSE starship Starship_prompt "
            prompt_options+="FALSE starship_install Install_Starship "
            [ "${DETECTED[has_pure]}" = "true" ] && prompt_options+="FALSE pure Pure_prompt "
            prompt_options+="FALSE pure_install Install_Pure "

            zsh_prompt_type=$(zenity --list \
                --title="Select ZSH Prompt" \
                --text="Choose your ZSH prompt framework:" \
                --radiolist \
                --column="Select" --column="Type" --column="Description" \
                $prompt_options \
                --width=450 --height=350 2>/dev/null) || zsh_prompt_type="standard"

            # Add fastfetch color scheme option
            if [ "${DETECTED[has_fastfetch]}" = "true" ]; then
                local ff_color_scheme
                ff_color_scheme=$(zenity --list \
                    --title="Fastfetch Color Scheme" \
                    --text="Select fastfetch color scheme:" \
                    --radiolist \
                    --column="Select" --column="Scheme" --column="Description" \
                    TRUE "tokyo-night" "Tokyo Night (default)" \
                    FALSE "tokyo-storm" "Tokyo Storm (darker)" \
                    FALSE "tokyo-light" "Tokyo Light" \
                    FALSE "classic" "Classic colors" \
                    FALSE "rainbow" "Rainbow colors" \
                    --width=400 --height=300 2>/dev/null) || ff_color_scheme="tokyo-night"
                SELECTED[fastfetch_color_scheme]="$ff_color_scheme"
            fi
        fi

        local terminal_list=""
        for term in ${DETECTED[terminals]}; do
            terminal_list+="TRUE $term "
        done

        if [ -n "$terminal_list" ]; then
            selected_terminals=$(zenity --list \
                --title="Select Terminals" \
                --text="Select terminal emulators to configure:" \
                --checklist \
                --column="Select" --column="Terminal" \
                $terminal_list \
                --width=400 --height=400 2>/dev/null) || selected_terminals=""
        fi

        local wm_list=""
        for wm in ${DETECTED[wms]}; do
            wm_list+="TRUE $wm "
        done

        if [ -n "$wm_list" ]; then
            selected_wms=$(zenity --list \
                --title="Select Window Managers/DEs" \
                --text="Select WMs/DEs to configure:" \
                --checklist \
                --column="Select" --column="WM/DE" \
                $wm_list \
                --width=400 --height=400 2>/dev/null) || selected_wms=""
        fi

        install_icons=$(zenity --question \
            --title="Install Icons" \
            --text="Install Tokyo Night icon pack?" \
            --width=300 2>/dev/null && echo "yes" || echo "no")

        install_wallpaper=$(zenity --question \
            --title="Install Wallpapers" \
            --text="Download and set Tokyo Night wallpapers?" \
            --width=300 2>/dev/null && echo "yes" || echo "no")
    else
        local form_result
        form_result=$(yad --form \
            --title="Tokyo Night Theme Installer" \
            --text="Configure your Tokyo Night installation" \
            --field="Theme Variant:CB" "night!storm!light" \
            --field="Install Icons:CHK" "TRUE" \
            --field="Install Wallpapers:CHK" "TRUE" \
            --width=500 --height=300 2>/dev/null) || exit 1

        theme_variant=$(echo "$form_result" | cut -d'|' -f1)
        install_icons=$(echo "$form_result" | cut -d'|' -f2 | grep -q "TRUE" && echo "yes" || echo "no")
        install_wallpaper=$(echo "$form_result" | cut -d'|' -f3 | grep -q "TRUE" && echo "yes" || echo "no")
        selected_shells="${DETECTED[available_shells]}"
        selected_terminals="${DETECTED[terminals]}"
        selected_wms="${DETECTED[wms]}"
    fi

    SELECTED[variant]="${theme_variant:-night}"
    SELECTED[icons]="$install_icons"
    SELECTED[wallpaper]="$install_wallpaper"
    SELECTED[shells]="${selected_shells//|/ }"
    SELECTED[terminals]="${selected_terminals//|/ }"
    SELECTED[wms]="${selected_wms//|/ }"
    SELECTED[zsh_prompt]="${zsh_prompt_type:-standard}"

        if [ "${DETECTED[has_neofetch]}" = "true" ] || [ "${DETECTED[has_fastfetch]}" = "true" ] || [ "${DETECTED[has_nerdfetch]}" = "true" ]; then
            local install_fetch
            local fetch_tools_text="Detected: ${DETECTED[fetch_tools]}"
            install_fetch=$(zenity --question \
                --title="Install Fetch Tool Themes" \
                --text="Install Tokyo Night configuration for system fetch tools?\n\n$fetch_tools_text" \
                --width=400 2>/dev/null && echo "yes" || echo "no")
            SELECTED[neofetch]="$install_fetch"

            if [ "$install_fetch" = "yes" ]; then
                local neofetch_distro
                neofetch_distro=$(zenity --list \
                    --title="Select Distro Logo" \
                    --text="Choose distro logo for fetch tools:\n(Current: ${DETECTED[distro]})" \
                    --radiolist \
                    --column="Select" --column="ID" --column="Distro" --column="Style" \
                    TRUE "auto" "Auto-detect" "Uses current distro" \
                    FALSE "arch" "Arch Linux" "Minimal A logo" \
                    FALSE "artix" "Artix Linux" "Arch variant" \
                    FALSE "debian" "Debian" "Swirl logo" \
                    FALSE "ubuntu" "Ubuntu" "Circle of friends" \
                    FALSE "fedora" "Fedora" "Infinity logo" \
                    FALSE "opensuse" "openSUSE" "Geeko chameleon" \
                    FALSE "gentoo" "Gentoo" "G logo" \
                    FALSE "nixos" "NixOS" "Lambda snowflake" \
                    FALSE "void" "Void Linux" "Void symbol" \
                    FALSE "alpine" "Alpine Linux" "Mountain peaks" \
                    FALSE "manjaro" "Manjaro" "M blocks" \
                    FALSE "pikaos" "PikaOS" "Pika mascot" \
                    FALSE "mint" "Linux Mint" "LM leaf" \
                    FALSE "pop" "Pop!_OS" "Pop logo" \
                    FALSE "endeavouros" "EndeavourOS" "Galaxy triangle" \
                    FALSE "garuda" "Garuda Linux" "Eagle" \
                    FALSE "cachyos" "CachyOS" "Performance" \
                    FALSE "nobara" "Nobara" "Gaming focused" \
                    FALSE "bazzite" "Bazzite" "Steam deck" \
                    FALSE "kali" "Kali Linux" "Dragon" \
                    FALSE "parrot" "Parrot OS" "Security" \
                    FALSE "centos" "CentOS" "Enterprise" \
                    FALSE "rocky" "Rocky Linux" "RHEL clone" \
                    FALSE "alma" "AlmaLinux" "RHEL clone" \
                    FALSE "slackware" "Slackware" "Classic" \
                    FALSE "elementary" "elementary OS" "macOS-like" \
                    FALSE "zorin" "Zorin OS" "Windows-like" \
                    FALSE "tux" "Generic Tux" "Linux penguin" \
                    FALSE "nerd" "Nerd Font Icon" "Single glyph" \
                    --width=600 --height=550 \
                    --print-column=2 2>/dev/null) || neofetch_distro="auto"
                SELECTED[neofetch_distro]="$neofetch_distro"

                if [ "${DETECTED[has_fastfetch]}" = "true" ]; then
                    local ff_logo_type
                    ff_logo_type=$(zenity --list \
                        --title="Fastfetch Logo Style" \
                        --text="Select logo style for fastfetch:" \
                        --radiolist \
                        --column="Select" --column="Style" --column="Description" \
                        TRUE "small" "Small ASCII (6-8 lines)" \
                        FALSE "auto" "Auto builtin logo" \
                        FALSE "none" "No logo (text only)" \
                        --width=450 --height=250 2>/dev/null) || ff_logo_type="small"
                    SELECTED[fastfetch_logo_type]="$ff_logo_type"
                fi

                if [ "${DETECTED[has_nerdfetch]}" = "true" ]; then
                    local nf_style
                    nf_style=$(zenity --list \
                        --title="Nerdfetch Style" \
                        --text="Select nerdfetch display style:" \
                        --radiolist \
                        --column="Select" --column="Style" --column="Description" \
                        TRUE "icon" "Nerd Font icon + info" \
                        FALSE "minimal" "Minimal (icon only)" \
                        FALSE "full" "Full info display" \
                        --width=400 --height=220 2>/dev/null) || nf_style="icon"
                    SELECTED[nerdfetch_style]="$nf_style"
                fi

                # Add theme selection from external repositories
                local use_external_themes
                use_external_themes=$(zenity --question \
                    --title="External Theme Selection" \
                    --text="Use themes from external repositories?\n\nThis will fetch themes from:\n- neofetch-themes\n- NeoCat\n- FastCat\n- dotfiles-fastfetch" \
                    --width=400 2>/dev/null && echo "yes" || echo "no")

                if [ "$use_external_themes" = "yes" ]; then
                    # Source the theme selection script
                    source "$SCRIPT_DIR/lib/theme_selection.sh"

                    # Show theme selection menu for each fetch tool
                    if [ "${DETECTED[has_neofetch]}" = "true" ]; then
                        show_theme_selection_menu "neofetch"
                    fi

                    if [ "${DETECTED[has_fastfetch]}" = "true" ]; then
                        # Show enhanced fastfetch theme menu
                        show_fastfetch_theme_menu
                    fi

                    if [ "${DETECTED[has_nerdfetch]}" = "true" ]; then
                        show_theme_selection_menu "nerdfetch"
                    fi

                    # Add Tokyo Night recolor menu option
                    local use_recolor_menu
                    use_recolor_menu=$(zenity --question \
                        --title="Tokyo Night Recolor Menu" \
                        --text="Use Tokyo Night recolor menu for themes?\n\nThis allows you to select Tokyo Night variants (night, storm, light) for recoloring themes." \
                        --width=400 2>/dev/null && echo "yes" || echo "no")

                    if [ "$use_recolor_menu" = "yes" ]; then
                        # Show Tokyo Night recolor menu for each tool
                        if [ "${DETECTED[has_neofetch]}" = "true" ]; then
                            show_tokyo_night_recolor_menu "neofetch"
                        fi

                        if [ "${DETECTED[has_fastfetch]}" = "true" ]; then
                            show_tokyo_night_recolor_menu "fastfetch"
                        fi

                        if [ "${DETECTED[has_nerdfetch]}" = "true" ]; then
                            show_tokyo_night_recolor_menu "nerdfetch"
                        fi
                    fi
                fi
            fi
        fi

    log_info "Selected variant: ${SELECTED[variant]}"
    log_info "Selected shells: ${SELECTED[shells]}"
    log_info "Selected terminals: ${SELECTED[terminals]}"
    log_info "Selected WMs: ${SELECTED[wms]}"
}


get_colors() {
    local variant="${SELECTED[variant]}"

    case "$variant" in
        night)
            BG="$TOKYONIGHT_NIGHT_BG"
            FG="$TOKYONIGHT_NIGHT_FG"
            SELECTION="$TOKYONIGHT_NIGHT_SELECTION"
            COMMENT="$TOKYONIGHT_NIGHT_COMMENT"
            RED="$TOKYONIGHT_NIGHT_RED"
            ORANGE="$TOKYONIGHT_NIGHT_ORANGE"
            YELLOW="$TOKYONIGHT_NIGHT_YELLOW"
            GREEN="$TOKYONIGHT_NIGHT_GREEN"
            CYAN="$TOKYONIGHT_NIGHT_CYAN"
            BLUE="$TOKYONIGHT_NIGHT_BLUE"
            MAGENTA="$TOKYONIGHT_NIGHT_MAGENTA"
            ;;
        storm)
            BG="$TOKYONIGHT_STORM_BG"
            FG="$TOKYONIGHT_STORM_FG"
            SELECTION="$TOKYONIGHT_STORM_SELECTION"
            COMMENT="$TOKYONIGHT_STORM_COMMENT"
            RED="$TOKYONIGHT_NIGHT_RED"
            ORANGE="$TOKYONIGHT_NIGHT_ORANGE"
            YELLOW="$TOKYONIGHT_NIGHT_YELLOW"
            GREEN="$TOKYONIGHT_NIGHT_GREEN"
            CYAN="$TOKYONIGHT_NIGHT_CYAN"
            BLUE="$TOKYONIGHT_NIGHT_BLUE"
            MAGENTA="$TOKYONIGHT_NIGHT_MAGENTA"
            ;;
        light)
            BG="$TOKYONIGHT_LIGHT_BG"
            FG="$TOKYONIGHT_LIGHT_FG"
            SELECTION="$TOKYONIGHT_LIGHT_SELECTION"
            COMMENT="$TOKYONIGHT_LIGHT_COMMENT"
            RED="$TOKYONIGHT_LIGHT_RED"
            ORANGE="$TOKYONIGHT_LIGHT_ORANGE"
            YELLOW="$TOKYONIGHT_LIGHT_YELLOW"
            GREEN="$TOKYONIGHT_LIGHT_GREEN"
            CYAN="$TOKYONIGHT_LIGHT_CYAN"
            BLUE="$TOKYONIGHT_LIGHT_BLUE"
            MAGENTA="$TOKYONIGHT_LIGHT_MAGENTA"
            ;;
    esac
}


install_bash_theme() {
    log_info "Installing Tokyo Night theme for bash..."

    local bashrc="$HOME/.bashrc"
    local theme_file="$HOME/.config/tokyo-night/bash-theme.sh"

    mkdir -p "$(dirname "$theme_file")"

    cat > "$theme_file" << 'BASHTHEME'
export TOKYONIGHT_VARIANT="__VARIANT__"

case "$TOKYONIGHT_VARIANT" in
    night|storm)
        export PS1='\[\e[38;2;122;162;247m\]\u\[\e[0m\]@\[\e[38;2;187;154;247m\]\h\[\e[0m\]:\[\e[38;2;125;207;255m\]\w\[\e[0m\]\$ '
        ;;
    light)
        export PS1='\[\e[38;2;52;84;138m\]\u\[\e[0m\]@\[\e[38;2;90;74;120m\]\h\[\e[0m\]:\[\e[38;2;15;75;110m\]\w\[\e[0m\]\$ '
        ;;
esac

export LS_COLORS="di=38;2;122;162;247:ln=38;2;187;154;247:so=38;2;247;118;142:pi=38;2;224;175;104:ex=38;2;158;206;106:bd=38;2;224;175;104;48;2;26;27;38:cd=38;2;224;175;104;48;2;26;27;38:su=38;2;247;118;142;48;2;26;27;38:sg=38;2;224;175;104;48;2;26;27;38:tw=38;2;26;27;38;48;2;158;206;106:ow=38;2;122;162;247;48;2;26;27;38"
BASHTHEME

    sed -i "s/__VARIANT__/${SELECTED[variant]}/" "$theme_file"

    if ! grep -q "tokyo-night/bash-theme.sh" "$bashrc" 2>/dev/null; then
        echo "" >> "$bashrc"
        echo "# Tokyo Night Theme" >> "$bashrc"
        echo "[ -f \"$theme_file\" ] && source \"$theme_file\"" >> "$bashrc"
    fi

    log_success "Bash theme installed"
}


install_zsh_theme() {
    local prompt_type="${SELECTED[zsh_prompt]:-standard}"
    log_info "Installing Tokyo Night theme for zsh ($prompt_type)..."

    case "$prompt_type" in
        standard)
            install_zsh_standard
            ;;
        ohmyzsh)
            install_zsh_ohmyzsh
            ;;
        p10k)
            install_zsh_p10k
            ;;
        starship|starship_install)
            install_zsh_starship
            ;;
        pure|pure_install)
            install_zsh_pure
            ;;
        *)
            install_zsh_standard
            ;;
    esac

    log_success "Zsh theme installed ($prompt_type)"
}


install_zsh_standard() {
    local zshrc="$HOME/.zshrc"
    local theme_file="$HOME/.config/tokyo-night/zsh-theme.zsh"

    mkdir -p "$(dirname "$theme_file")"

    cat > "$theme_file" << 'ZSHTHEME'
export TOKYONIGHT_VARIANT="__VARIANT__"

case "$TOKYONIGHT_VARIANT" in
    night|storm)
        PROMPT='%F{#7aa2f7}%n%f@%F{#bb9af7}%m%f:%F{#7dcfff}%~%f%# '
        ;;
    light)
        PROMPT='%F{#34548a}%n%f@%F{#5a4a78}%m%f:%F{#0f4b6e}%~%f%# '
        ;;
esac

export LS_COLORS="di=38;2;122;162;247:ln=38;2;187;154;247:so=38;2;247;118;142:pi=38;2;224;175;104:ex=38;2;158;206;106"

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
ZSHTHEME

    sed -i "s/__VARIANT__/${SELECTED[variant]}/" "$theme_file"

    if ! grep -q "tokyo-night/zsh-theme.zsh" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Tokyo Night Theme" >> "$zshrc"
        echo "[ -f \"$theme_file\" ] && source \"$theme_file\"" >> "$zshrc"
    fi
}


install_zsh_ohmyzsh() {
    local omz_theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
    local theme_file="$omz_theme_dir/tokyonight.zsh-theme"

    mkdir -p "$omz_theme_dir"

    get_colors

    cat > "$theme_file" << OMZTHEME
PROMPT='%{\$fg_bold[blue]%}%n%{\$reset_color%}@%{\$fg[magenta]%}%m%{\$reset_color%}:%{\$fg[cyan]%}%~%{\$reset_color%}\$(git_prompt_info) %# '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{\$fg[yellow]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{\$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{\$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

export LS_COLORS="di=38;2;122;162;247:ln=38;2;187;154;247:so=38;2;247;118;142:pi=38;2;224;175;104:ex=38;2;158;206;106"
zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}
OMZTHEME

    local zshrc="$HOME/.zshrc"
    if grep -q "^ZSH_THEME=" "$zshrc"; then
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="tokyonight"/' "$zshrc"
    fi

    log_info "Set ZSH_THEME=\"tokyonight\" in your .zshrc"
}


install_zsh_p10k() {
    local p10k_file="$HOME/.p10k.zsh"
    local colors_file="$HOME/.config/tokyo-night/p10k-colors.zsh"

    mkdir -p "$(dirname "$colors_file")"

    get_colors

    cat > "$colors_file" << P10KCOLORS
typeset -g POWERLEVEL9K_BACKGROUND=
typeset -g POWERLEVEL9K_FOREGROUND=$FG

typeset -g POWERLEVEL9K_DIR_BACKGROUND=$BLUE
typeset -g POWERLEVEL9K_DIR_FOREGROUND=$BG

typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$GREEN
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$BG
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$YELLOW
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$BG
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$RED
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$BG

typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=$GREEN
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$BG
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=$RED
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$BG

typeset -g POWERLEVEL9K_TIME_BACKGROUND=$MAGENTA
typeset -g POWERLEVEL9K_TIME_FOREGROUND=$BG

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$YELLOW
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$BG

typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=$CYAN
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$BG

typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=$COMMENT
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$FG
P10KCOLORS

    local zshrc="$HOME/.zshrc"
    if ! grep -q "tokyo-night/p10k-colors.zsh" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Tokyo Night P10k Colors" >> "$zshrc"
        echo "[ -f \"$colors_file\" ] && source \"$colors_file\"" >> "$zshrc"
    fi

    log_info "P10k Tokyo Night colors installed. You may need to reconfigure p10k for full effect."
}


install_zsh_starship() {
    if ! command -v starship &>/dev/null; then
        log_info "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    local starship_config="$HOME/.config/starship.toml"
    mkdir -p "$(dirname "$starship_config")"

    get_colors

    cat > "$starship_config" << STARSHIPCONF
format = """
[](#7aa2f7)\
\$os\
\$username\
[](bg:#bb9af7 fg:#7aa2f7)\
\$directory\
[](fg:#bb9af7 bg:#9ece6a)\
\$git_branch\
\$git_status\
[](fg:#9ece6a bg:#e0af68)\
\$c\
\$elixir\
\$elm\
\$golang\
\$gradle\
\$haskell\
\$java\
\$julia\
\$nodejs\
\$nim\
\$rust\
\$scala\
\$python\
[](fg:#e0af68 bg:#7dcfff)\
\$docker_context\
[](fg:#7dcfff bg:#565f89)\
\$time\
[ ](fg:#565f89)\
"""

[username]
show_always = true
style_user = "bg:#7aa2f7 fg:#1a1b26"
style_root = "bg:#7aa2f7 fg:#1a1b26"
format = '[\$user ](\$style)'
disabled = false

[os]
style = "bg:#7aa2f7 fg:#1a1b26"
disabled = false

[directory]
style = "bg:#bb9af7 fg:#1a1b26"
format = "[ \$path ](\$style)"
truncation_length = 3
truncation_symbol = ".../"

[directory.substitutions]
"Documents" = " "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:#9ece6a fg:#1a1b26"
format = '[ \$symbol \$branch ](\$style)'

[git_status]
style = "bg:#9ece6a fg:#1a1b26"
format = '[\$all_status\$ahead_behind ](\$style)'

[nodejs]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[rust]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[golang]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[python]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[docker_context]
symbol = ""
style = "bg:#7dcfff fg:#1a1b26"
format = '[ \$symbol \$context ](\$style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#565f89 fg:#c0caf5"
format = '[ \$time ](\$style)'
STARSHIPCONF

    local zshrc="$HOME/.zshrc"
    if ! grep -q 'eval "$(starship init zsh)"' "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Starship prompt" >> "$zshrc"
        echo 'eval "$(starship init zsh)"' >> "$zshrc"
    fi

    log_success "Starship Tokyo Night theme installed"
}


install_zsh_pure() {
    local pure_dir="${ZDOTDIR:-$HOME}/.zsh/pure"

    if [ ! -d "$pure_dir" ]; then
        log_info "Installing Pure prompt..."
        mkdir -p "$(dirname "$pure_dir")"
        git clone https://github.com/sindresorhus/pure.git "$pure_dir"
    fi

    local colors_file="$HOME/.config/tokyo-night/pure-colors.zsh"
    mkdir -p "$(dirname "$colors_file")"

    get_colors

    cat > "$colors_file" << PURECOLORS
zstyle :prompt:pure:path color '#7aa2f7'
zstyle :prompt:pure:git:branch color '#bb9af7'
zstyle :prompt:pure:git:dirty color '#f7768e'
zstyle :prompt:pure:git:arrow color '#7dcfff'
zstyle :prompt:pure:git:stash color '#e0af68'
zstyle :prompt:pure:git:fetch color '#565f89'
zstyle :prompt:pure:git:action color '#ff9e64'
zstyle :prompt:pure:prompt:error color '#f7768e'
zstyle :prompt:pure:prompt:success color '#9ece6a'
zstyle :prompt:pure:prompt:continuation color '#565f89'
zstyle :prompt:pure:user color '#7dcfff'
zstyle :prompt:pure:host color '#bb9af7'
zstyle :prompt:pure:virtualenv color '#e0af68'
PURECOLORS

    local zshrc="$HOME/.zshrc"

    if ! grep -q "fpath+=.*pure" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Pure prompt" >> "$zshrc"
        echo "fpath+=($pure_dir)" >> "$zshrc"
        echo "autoload -U promptinit; promptinit" >> "$zshrc"
        echo "prompt pure" >> "$zshrc"
    fi

    if ! grep -q "tokyo-night/pure-colors.zsh" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Tokyo Night Pure Colors" >> "$zshrc"
        echo "[ -f \"$colors_file\" ] && source \"$colors_file\"" >> "$zshrc"
    fi

    log_success "Pure Tokyo Night theme installed"
}


install_fish_theme() {
    log_info "Installing Tokyo Night theme for fish..."

    local fish_conf="$HOME/.config/fish/conf.d/tokyo-night.fish"
    mkdir -p "$(dirname "$fish_conf")"

    cat > "$fish_conf" << 'FISHTHEME'
set -U TOKYONIGHT_VARIANT "__VARIANT__"

switch $TOKYONIGHT_VARIANT
    case night storm
        set -U fish_color_normal c0caf5
        set -U fish_color_command 7aa2f7
        set -U fish_color_keyword bb9af7
        set -U fish_color_quote 9ece6a
        set -U fish_color_redirection 7dcfff
        set -U fish_color_end ff9e64
        set -U fish_color_error f7768e
        set -U fish_color_param c0caf5
        set -U fish_color_comment 565f89
        set -U fish_color_selection --background=33467c
        set -U fish_color_search_match --background=33467c
        set -U fish_color_operator 9ece6a
        set -U fish_color_escape bb9af7
        set -U fish_color_autosuggestion 565f89
        set -U fish_pager_color_progress 565f89
        set -U fish_pager_color_prefix 7dcfff
        set -U fish_pager_color_completion c0caf5
        set -U fish_pager_color_description 565f89
    case light
        set -U fish_color_normal 343b58
        set -U fish_color_command 34548a
        set -U fish_color_keyword 5a4a78
        set -U fish_color_quote 33635c
        set -U fish_color_redirection 0f4b6e
        set -U fish_color_end 965027
        set -U fish_color_error 8c4351
        set -U fish_color_param 343b58
        set -U fish_color_comment 9699a3
        set -U fish_color_selection --background=99a7df
        set -U fish_color_search_match --background=99a7df
        set -U fish_color_operator 33635c
        set -U fish_color_escape 5a4a78
        set -U fish_color_autosuggestion 9699a3
end
FISHTHEME

    sed -i "s/__VARIANT__/${SELECTED[variant]}/" "$fish_conf"

    log_success "Fish theme installed"
}


install_kitty_theme() {
    log_info "Installing Tokyo Night theme for Kitty..."

    local kitty_conf="$HOME/.config/kitty/tokyo-night.conf"
    mkdir -p "$(dirname "$kitty_conf")"

    get_colors

    cat > "$kitty_conf" << KITTYCONF
foreground $FG
background $BG
selection_foreground $BG
selection_background $SELECTION

cursor $FG
cursor_text_color $BG

url_color $CYAN

color0  #15161e
color8  $COMMENT

color1  $RED
color9  $RED

color2  $GREEN
color10 $GREEN

color3  $YELLOW
color11 $YELLOW

color4  $BLUE
color12 $BLUE

color5  $MAGENTA
color13 $MAGENTA

color6  $CYAN
color14 $CYAN

color7  #a9b1d6
color15 $FG

active_border_color $BLUE
inactive_border_color $COMMENT
bell_border_color $YELLOW

active_tab_foreground   $BG
active_tab_background   $BLUE
inactive_tab_foreground $COMMENT
inactive_tab_background $BG
KITTYCONF

    local main_conf="$HOME/.config/kitty/kitty.conf"
    if [ -f "$main_conf" ]; then
        if ! grep -q "tokyo-night.conf" "$main_conf"; then
            echo "" >> "$main_conf"
            echo "include tokyo-night.conf" >> "$main_conf"
        fi
    else
        echo "include tokyo-night.conf" > "$main_conf"
    fi

    log_success "Kitty theme installed"
}


install_wezterm_theme() {
    log_info "Installing Tokyo Night theme for WezTerm..."

    local wezterm_dir="$HOME/.config/wezterm"
    local theme_file="$wezterm_dir/tokyo-night.lua"
    mkdir -p "$wezterm_dir"

    get_colors

    cat > "$theme_file" << WEZTERMTHEME
local M = {}

M.colors = {
    foreground = "$FG",
    background = "$BG",
    cursor_bg = "$FG",
    cursor_fg = "$BG",
    cursor_border = "$FG",
    selection_fg = "$BG",
    selection_bg = "$SELECTION",
    scrollbar_thumb = "$COMMENT",
    split = "$COMMENT",

    ansi = {
        "#15161e",
        "$RED",
        "$GREEN",
        "$YELLOW",
        "$BLUE",
        "$MAGENTA",
        "$CYAN",
        "#a9b1d6",
    },
    brights = {
        "$COMMENT",
        "$RED",
        "$GREEN",
        "$YELLOW",
        "$BLUE",
        "$MAGENTA",
        "$CYAN",
        "$FG",
    },

    tab_bar = {
        background = "$BG",
        active_tab = {
            bg_color = "$BLUE",
            fg_color = "$BG",
        },
        inactive_tab = {
            bg_color = "$BG",
            fg_color = "$COMMENT",
        },
        inactive_tab_hover = {
            bg_color = "$SELECTION",
            fg_color = "$FG",
        },
        new_tab = {
            bg_color = "$BG",
            fg_color = "$COMMENT",
        },
        new_tab_hover = {
            bg_color = "$SELECTION",
            fg_color = "$FG",
        },
    },
}

return M
WEZTERMTHEME

    local main_conf="$wezterm_dir/wezterm.lua"
    if [ ! -f "$main_conf" ]; then
        cat > "$main_conf" << 'WEZTERMCONF'
local wezterm = require 'wezterm'
local tokyo_night = require 'tokyo-night'

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.colors = tokyo_night.colors

return config
WEZTERMCONF
    else
        if ! grep -q "tokyo-night" "$main_conf"; then
            log_warn "WezTerm config exists. Please manually add: local tokyo_night = require 'tokyo-night' and config.colors = tokyo_night.colors"
        fi
    fi

    log_success "WezTerm theme installed"
}


install_alacritty_theme() {
    log_info "Installing Tokyo Night theme for Alacritty..."

    local alacritty_dir="$HOME/.config/alacritty"
    local theme_file="$alacritty_dir/tokyo-night.toml"
    mkdir -p "$alacritty_dir"

    get_colors

    cat > "$theme_file" << ALACRITTYCONF
[colors.primary]
background = "$BG"
foreground = "$FG"

[colors.selection]
background = "$SELECTION"
foreground = "$FG"

[colors.normal]
black   = "#15161e"
red     = "$RED"
green   = "$GREEN"
yellow  = "$YELLOW"
blue    = "$BLUE"
magenta = "$MAGENTA"
cyan    = "$CYAN"
white   = "#a9b1d6"

[colors.bright]
black   = "$COMMENT"
red     = "$RED"
green   = "$GREEN"
yellow  = "$YELLOW"
blue    = "$BLUE"
magenta = "$MAGENTA"
cyan    = "$CYAN"
white   = "$FG"

[colors.cursor]
cursor = "$FG"
text   = "$BG"
ALACRITTYCONF

    local main_conf="$alacritty_dir/alacritty.toml"
    if [ -f "$main_conf" ]; then
        if ! grep -q "tokyo-night.toml" "$main_conf"; then
            sed -i '1i import = ["~/.config/alacritty/tokyo-night.toml"]' "$main_conf"
        fi
    else
        echo 'import = ["~/.config/alacritty/tokyo-night.toml"]' > "$main_conf"
    fi

    log_success "Alacritty theme installed"
}


install_foot_theme() {
    log_info "Installing Tokyo Night theme for Foot..."

    local foot_dir="$HOME/.config/foot"
    local theme_file="$foot_dir/tokyo-night.ini"
    mkdir -p "$foot_dir"

    get_colors

    cat > "$theme_file" << FOOTCONF
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
FOOTCONF

    local main_conf="$foot_dir/foot.ini"
    if [ -f "$main_conf" ]; then
        if ! grep -q "tokyo-night.ini" "$main_conf"; then
            echo "" >> "$main_conf"
            echo "include=tokyo-night.ini" >> "$main_conf"
        fi
    else
        echo "[main]" > "$main_conf"
        echo "include=tokyo-night.ini" >> "$main_conf"
    fi

    log_success "Foot theme installed"
}


install_gnome_terminal_theme() {
    log_info "Installing Tokyo Night theme for GNOME Terminal..."

    if ! command -v dconf &>/dev/null; then
        log_warn "dconf not found, skipping GNOME Terminal"
        return
    fi

    get_colors

    local profile_id
    profile_id=$(dconf read /org/gnome/terminal/legacy/profiles:/default 2>/dev/null | tr -d "'")

    if [ -z "$profile_id" ]; then
        profile_id=$(uuidgen)
        dconf write /org/gnome/terminal/legacy/profiles:/default "'$profile_id'"
        local profiles_list
        profiles_list=$(dconf read /org/gnome/terminal/legacy/profiles:/list 2>/dev/null)
        if [ -z "$profiles_list" ] || [ "$profiles_list" = "@as []" ]; then
            dconf write /org/gnome/terminal/legacy/profiles:/list "['$profile_id']"
        fi
    fi

    local profile_path="/org/gnome/terminal/legacy/profiles:/:$profile_id/"

    dconf write "${profile_path}visible-name" "'Tokyo Night'"
    dconf write "${profile_path}use-theme-colors" "false"
    dconf write "${profile_path}foreground-color" "'$FG'"
    dconf write "${profile_path}background-color" "'$BG'"
    dconf write "${profile_path}palette" "['#15161e', '$RED', '$GREEN', '$YELLOW', '$BLUE', '$MAGENTA', '$CYAN', '#a9b1d6', '$COMMENT', '$RED', '$GREEN', '$YELLOW', '$BLUE', '$MAGENTA', '$CYAN', '$FG']"

    log_success "GNOME Terminal theme installed"
}


install_i3_theme() {
    log_info "Installing Tokyo Night theme for i3..."

    local i3_config="$HOME/.config/i3/config"
    local theme_file="$HOME/.config/i3/tokyo-night.conf"

    if [ ! -f "$i3_config" ]; then
        i3_config="$HOME/.i3/config"
        theme_file="$HOME/.i3/tokyo-night.conf"
    fi

    mkdir -p "$(dirname "$theme_file")"

    get_colors

    cat > "$theme_file" << I3CONF
set \$bg $BG
set \$fg $FG
set \$inactive $COMMENT
set \$urgent $RED
set \$focused $BLUE
set \$unfocused $SELECTION
set \$indicator $MAGENTA
set \$green $GREEN
set \$yellow $YELLOW
set \$cyan $CYAN

client.focused          \$focused   \$focused   \$bg        \$indicator \$focused
client.focused_inactive \$unfocused \$unfocused \$fg        \$unfocused \$unfocused
client.unfocused        \$bg        \$bg        \$inactive  \$bg        \$bg
client.urgent           \$urgent    \$urgent    \$fg        \$urgent    \$urgent
client.placeholder      \$bg        \$bg        \$fg        \$bg        \$bg
client.background       \$bg

gaps inner 6
gaps outer 2

default_border pixel 2
default_floating_border pixel 2

hide_edge_borders smart

bar {
    status_command i3status
    position top

    colors {
        background \$bg
        statusline \$fg
        separator  \$inactive

        focused_workspace  \$focused  \$focused  \$bg
        active_workspace   \$unfocused \$unfocused \$fg
        inactive_workspace \$bg       \$bg       \$inactive
        urgent_workspace   \$urgent   \$urgent   \$fg
        binding_mode       \$yellow   \$yellow   \$bg
    }
}

font pango:JetBrains Mono 10
I3CONF

    if [ -f "$i3_config" ]; then
        if ! grep -q "tokyo-night.conf" "$i3_config"; then
            echo "" >> "$i3_config"
            echo "# Tokyo Night Theme" >> "$i3_config"
            echo "include tokyo-night.conf" >> "$i3_config"
        fi
    fi

    log_success "i3 theme installed"
}


install_sway_theme() {
    log_info "Installing Tokyo Night theme for Sway..."

    local sway_config="$HOME/.config/sway/config"
    local theme_file="$HOME/.config/sway/tokyo-night.conf"

    mkdir -p "$(dirname "$theme_file")"

    get_colors

    cat > "$theme_file" << SWAYCONF
set \$bg $BG
set \$bg_dark ${BG}dd
set \$fg $FG
set \$inactive $COMMENT
set \$urgent $RED
set \$focused $BLUE
set \$unfocused ${SELECTION}
set \$indicator $MAGENTA
set \$green $GREEN
set \$yellow $YELLOW
set \$cyan $CYAN
set \$magenta $MAGENTA

client.focused          \$focused   \$focused   \$bg        \$indicator \$focused
client.focused_inactive \$unfocused \$unfocused \$fg        \$unfocused \$unfocused
client.unfocused        \$bg        \$bg        \$inactive  \$bg        \$bg
client.urgent           \$urgent    \$urgent    \$fg        \$urgent    \$urgent
client.placeholder      \$bg        \$bg        \$fg        \$bg        \$bg
client.background       \$bg

gaps inner 6
gaps outer 2

default_border pixel 2
default_floating_border pixel 2

bar {
    position top
    status_command i3status

    colors {
        background \$bg
        statusline \$fg
        separator  \$inactive

        focused_workspace  \$focused  \$focused  \$bg
        active_workspace   \$unfocused \$unfocused \$fg
        inactive_workspace \$bg       \$bg       \$inactive
        urgent_workspace   \$urgent   \$urgent   \$fg
        binding_mode       \$yellow   \$yellow   \$bg
    }
}

font pango:JetBrains Mono 10

exec_always {
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}
SWAYCONF

    if [ -f "$sway_config" ]; then
        if ! grep -q "tokyo-night.conf" "$sway_config"; then
            echo "" >> "$sway_config"
            echo "# Tokyo Night Theme" >> "$sway_config"
            echo "include tokyo-night.conf" >> "$sway_config"
        fi
    fi

    log_success "Sway theme installed"
}


install_hyprland_theme() {
    log_info "Installing Tokyo Night theme for Hyprland..."

    local hypr_config="$HOME/.config/hypr/hyprland.conf"
    local theme_file="$HOME/.config/hypr/tokyo-night.conf"

    mkdir -p "$(dirname "$theme_file")"

    get_colors

    local bg_rgb="${BG:1}"
    local fg_rgb="${FG:1}"
    local blue_rgb="${BLUE:1}"
    local red_rgb="${RED:1}"
    local green_rgb="${GREEN:1}"
    local yellow_rgb="${YELLOW:1}"
    local magenta_rgb="${MAGENTA:1}"
    local cyan_rgb="${CYAN:1}"
    local comment_rgb="${COMMENT:1}"
    local selection_rgb="${SELECTION:1}"

    cat > "$theme_file" << HYPRCONF
general {
    gaps_in = 4
    gaps_out = 8
    border_size = 2
    col.active_border = rgb($blue_rgb) rgb(${magenta_rgb}) 45deg
    col.inactive_border = rgb($comment_rgb)
    layout = dwindle
    allow_tearing = false
}

decoration {
    rounding = 8

    blur {
        enabled = true
        size = 8
        passes = 2
        new_optimizations = true
        xray = false
        ignore_opacity = true
    }

    shadow {
        enabled = true
        range = 20
        render_power = 3
        color = rgba(${bg_rgb}ee)
        color_inactive = rgba(${bg_rgb}99)
        offset = 0, 5
        scale = 1.0
    }
}

animations {
    enabled = true

    bezier = overshot, 0.05, 0.9, 0.1, 1.1
    bezier = smoothOut, 0.36, 0, 0.66, -0.56
    bezier = smoothIn, 0.25, 1, 0.5, 1
    bezier = easeInOut, 0.4, 0, 0.2, 1

    animation = windows, 1, 5, overshot, slide
    animation = windowsOut, 1, 4, smoothOut, slide
    animation = windowsMove, 1, 4, smoothIn, slide
    animation = border, 1, 10, default
    animation = borderangle, 1, 100, easeInOut, loop
    animation = fade, 1, 5, smoothIn
    animation = fadeDim, 1, 5, smoothIn
    animation = workspaces, 1, 6, overshot, slidevert
}

group {
    col.border_active = rgb($blue_rgb)
    col.border_inactive = rgb($comment_rgb)
    col.border_locked_active = rgb($green_rgb)
    col.border_locked_inactive = rgb($comment_rgb)

    groupbar {
        enabled = true
        font_family = JetBrains Mono
        font_size = 10
        gradients = true
        height = 20
        priority = 3
        render_titles = true
        scrolling = true
        text_color = rgb($fg_rgb)
        col.active = rgb($blue_rgb)
        col.inactive = rgb($selection_rgb)
        col.locked_active = rgb($green_rgb)
        col.locked_inactive = rgb($comment_rgb)
    }
}

misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    force_default_wallpaper = 0
    col.splash = rgb($blue_rgb)
}
HYPRCONF

    if [ -f "$hypr_config" ]; then
        if ! grep -q "tokyo-night.conf" "$hypr_config"; then
            echo "" >> "$hypr_config"
            echo "# Tokyo Night Theme" >> "$hypr_config"
            echo "source = ~/.config/hypr/tokyo-night.conf" >> "$hypr_config"
        fi
    fi

    log_success "Hyprland theme installed"
}


install_niri_theme() {
    log_info "Installing Tokyo Night theme for Niri..."

    local niri_dir="$HOME/.config/niri"
    local theme_file="$niri_dir/tokyo-night.kdl"
    local niri_config="$niri_dir/config.kdl"

    mkdir -p "$niri_dir"

    get_colors

    cat > "$theme_file" << NIRICONF
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
        active-color "$BLUE"
        inactive-color "$COMMENT"
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
}

hotkey-overlay {
    skip-at-startup
}
NIRICONF

    if [ -f "$niri_config" ]; then
        local backup_file="$niri_config.backup.$(date +%Y%m%d%H%M%S)"
        cp "$niri_config" "$backup_file"
        log_info "Backed up existing config to $backup_file"

        sed -i "s/active-color \"[^\"]*\"/active-color \"$BLUE\"/g" "$niri_config"
        sed -i "s/inactive-color \"[^\"]*\"/inactive-color \"$COMMENT\"/g" "$niri_config"

        if ! grep -q "// tokyo-night" "$niri_config"; then
            echo "" >> "$niri_config"
            echo "// tokyo-night theme applied - ${SELECTED[variant]}" >> "$niri_config"
        fi
    else
        cp "$theme_file" "$niri_config"
    fi

    log_success "Niri theme installed"
}

install_cosmic_theme() {
    log_info "Installing Tokyo Night theme for Fedora Cosmic..."

    get_colors

    # Cosmic uses GTK theming and custom configuration files
    local cosmic_config_dir="$HOME/.config/cosmic"
    local cosmic_comp_dir="$cosmic_config_dir/com.system76.CosmicComp"
    local cosmic_panel_dir="$cosmic_config_dir/com.system76.CosmicPanel"

    mkdir -p "$cosmic_comp_dir" "$cosmic_panel_dir"

    # Configure Cosmic Comp (compositor)
    local cosmic_comp_config="$cosmic_comp_dir/v1.json"
    cat > "$cosmic_comp_config" << COSMICCOMP
{
  "border": {
    "active_color": [${BLUE:1:2}, ${BLUE:3:2}, ${BLUE:5:2}],
    "inactive_color": [${COMMENT:1:2}, ${COMMENT:3:2}, ${COMMENT:5:2}],
    "radius": 8.0,
    "width": 2
  },
  "focus_follows_cursor": false,
  "focus_follows_cursor_delay": 250,
  "active_hint": true,
  "autotiling": true,
  "gaps": {
    "inner": 4,
    "outer": {
      "bottom": 0,
      "left": 0,
      "right": 0,
      "top": 0
    }
  },
  "input_default": {
    "acceleration": "adaptive",
    "click_method": "clickfinger",
    "disable_while_typing": true,
    "scroll_method": "twofinger",
    "tap": true
  },
  "input_touchpad": {
    "acceleration": "adaptive",
    "click_method": "clickfinger",
    "disable_while_typing": true,
    "scroll_method": "twofinger",
    "tap": true
  },
  "workspaces": {
    "workspace_layout": "horizontal"
  },
  "xkb_config": {
    "layout": "us",
    "options": null,
    "repeat_delay": 600,
    "repeat_rate": 25,
    "rules": "",
    "variant": ""
  }
}
COSMICCOMP

    # Configure Cosmic Panel
    local cosmic_panel_config="$cosmic_panel_dir/v1.json"
    cat > "$cosmic_panel_config" << COSMICPANEL
{
  "anchor": "top",
  "anchor_gap": false,
  "background": [${BG:1:2}, ${BG:3:2}, ${BG:5:2}, 0.9],
  "plugins_wings": {
    "center": [
      "workspaces"
    ],
    "end": [
      "network_manager",
      "bluetooth",
      "audio",
      "battery",
      "notifications",
      "clock"
    ],
    "start": [
      "launcher"
    ]
  },
  "size": "m",
  "toplevel_placement": "above_layer_shell"
}
COSMICPANEL

    # Configure GTK theme for Cosmic
    install_gtk_theme

    # Configure icon theme
    if [ "${SELECTED[icons]}" = "yes" ]; then
        install_icons
    fi

    log_success "Fedora Cosmic theme installed"
}


install_pikabar_theme() {
    log_info "Installing Tokyo Night theme for PikaBar..."

    local pikabar_dir="$HOME/.config/pikabar"
    local pikabar_css="$pikabar_dir/style.css"

    mkdir -p "$pikabar_dir"

    get_colors

    cat > "$pikabar_css" << PIKABARCSS
* {
    font-family: "JetBrains Mono", "Fira Code", monospace;
    font-size: 13px;
}

window {
    background-color: $BG;
    color: $FG;
}

.modules-left,
.modules-center,
.modules-right {
    background-color: $BG;
    padding: 0 8px;
}

.workspace-button {
    background-color: transparent;
    color: $COMMENT;
    padding: 4px 12px;
    margin: 4px 2px;
    border-radius: 6px;
    border: none;
}

.workspace-button:hover {
    background-color: $SELECTION;
    color: $FG;
}

.workspace-button.active {
    background-color: $BLUE;
    color: $BG;
}

.workspace-button.urgent {
    background-color: $RED;
    color: $BG;
}

.clock,
.date {
    color: $FG;
    padding: 4px 12px;
}

.battery {
    color: $GREEN;
    padding: 4px 8px;
}

.battery.warning {
    color: $YELLOW;
}

.battery.critical {
    color: $RED;
}

.network {
    color: $CYAN;
    padding: 4px 8px;
}

.volume {
    color: $MAGENTA;
    padding: 4px 8px;
}

.cpu,
.memory {
    color: $ORANGE;
    padding: 4px 8px;
}

.tray {
    padding: 4px 8px;
}

.tray menu {
    background-color: $BG;
    color: $FG;
    border: 1px solid $COMMENT;
    border-radius: 8px;
}

.tray menu menuitem:hover {
    background-color: $SELECTION;
}

tooltip {
    background-color: $BG;
    color: $FG;
    border: 1px solid $BLUE;
    border-radius: 6px;
    padding: 8px;
}

.notification {
    background-color: $BG;
    color: $FG;
    border: 1px solid $BLUE;
    border-radius: 8px;
    padding: 12px;
}

.notification.critical {
    border-color: $RED;
}

.notification.normal {
    border-color: $BLUE;
}

.notification.low {
    border-color: $COMMENT;
}
PIKABARCSS

    local pikabar_config="$pikabar_dir/config.json"
    if [ -f "$pikabar_config" ]; then
        if command -v jq &>/dev/null; then
            local tmp_config=$(mktemp)
            jq --arg icon "TokyoNight-SE" '.icon_theme = $icon' "$pikabar_config" > "$tmp_config" 2>/dev/null && mv "$tmp_config" "$pikabar_config"
        fi
    fi

    log_success "PikaBar theme installed"
}


install_waybar_theme() {
    log_info "Installing Tokyo Night theme for Waybar..."

    local waybar_dir="$HOME/.config/waybar"
    local style_file="$waybar_dir/style.css"
    local colors_file="$waybar_dir/tokyo-night.css"

    mkdir -p "$waybar_dir"

    get_colors

    cat > "$colors_file" << WAYBARCSS
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

    if [ -f "$style_file" ]; then
        if ! grep -q "@import.*tokyo-night" "$style_file"; then
            local backup_file="$style_file.backup.$(date +%Y%m%d%H%M%S)"
            cp "$style_file" "$backup_file"
            log_info "Backed up existing style to $backup_file"
            sed -i '1i @import "tokyo-night.css";' "$style_file"
        fi
    else
        echo '@import "tokyo-night.css";' > "$style_file"
    fi

    log_success "Waybar theme installed"
}


install_gtk_theme() {
    log_info "Installing Tokyo Night GTK configuration..."

    local gtk3_dir="$HOME/.config/gtk-3.0"
    local gtk4_dir="$HOME/.config/gtk-4.0"

    mkdir -p "$gtk3_dir" "$gtk4_dir"

    get_colors

    local gtk_css="
@define-color theme_bg_color $BG;
@define-color theme_fg_color $FG;
@define-color theme_selected_bg_color $BLUE;
@define-color theme_selected_fg_color $BG;
@define-color accent_color $BLUE;
@define-color accent_bg_color $BLUE;
@define-color accent_fg_color $BG;
"

    echo "$gtk_css" > "$gtk3_dir/gtk.css"
    echo "$gtk_css" > "$gtk4_dir/gtk.css"

    log_success "GTK theme configuration installed"
}

install_hyprland_compatibility() {
    # Source the Hyprland compatibility script
    source "$SCRIPT_DIR/lib/hyprland_compat.sh"
    install_hyprland_compatibility "${SELECTED[variant]}"
}


install_icons() {
    log_info "Installing Tokyo Night icons..."

    local icons_dir="$HOME/.local/share/icons"
    mkdir -p "$icons_dir"

    local archive_path="$CACHE_DIR/TokyoNight-SE.tar.bz2"

    if [ ! -f "$archive_path" ]; then
        log_info "Downloading icon pack..."
        wget -q --show-progress -O "$archive_path" "$ICONS_RELEASE"
    fi

    log_info "Extracting icons..."
    tar -xjf "$archive_path" -C "$icons_dir"

    local gtk3_settings="$HOME/.config/gtk-3.0/settings.ini"
    mkdir -p "$(dirname "$gtk3_settings")"

    if [ -f "$gtk3_settings" ]; then
        if grep -q "gtk-icon-theme-name" "$gtk3_settings"; then
            sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=TokyoNight-SE/' "$gtk3_settings"
        else
            echo "gtk-icon-theme-name=TokyoNight-SE" >> "$gtk3_settings"
        fi
    else
        echo "[Settings]" > "$gtk3_settings"
        echo "gtk-icon-theme-name=TokyoNight-SE" >> "$gtk3_settings"
    fi

    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface icon-theme 'TokyoNight-SE' 2>/dev/null || true
    fi

    if command -v xfconf-query &>/dev/null; then
        xfconf-query -c xsettings -p /Net/IconThemeName -s "TokyoNight-SE" 2>/dev/null || true
    fi

    log_success "Icons installed"
}


install_wallpapers() {
    log_info "Installing Tokyo Night wallpapers..."

    local wallpapers_dir="$HOME/.local/share/tokyo-night-wallpapers"

    if [ ! -d "$wallpapers_dir" ]; then
        log_info "Cloning wallpapers repository..."
        git clone --depth 1 "$WALLPAPERS_REPO" "$wallpapers_dir"
    else
        log_info "Updating wallpapers repository..."
        git -C "$wallpapers_dir" pull
    fi

    local variant="${SELECTED[variant]}"
    local wallpaper_folder="$wallpapers_dir/$variant"

    if [ ! -d "$wallpaper_folder" ]; then
        wallpaper_folder="$wallpapers_dir/night"
    fi

    local wallpaper
    wallpaper=$(find "$wallpaper_folder" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | head -1)

    if [ -z "$wallpaper" ]; then
        log_warn "No wallpapers found for variant: $variant"
        return
    fi

    local selected_wallpaper
    if command -v zenity &>/dev/null; then
        local wallpaper_list=""
        while IFS= read -r wp; do
            wallpaper_list+="FALSE $(basename "$wp") $wp "
        done < <(find "$wallpaper_folder" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \))

        selected_wallpaper=$(zenity --list \
            --title="Select Wallpaper" \
            --text="Choose a wallpaper for the $variant variant:" \
            --radiolist \
            --column="Select" --column="Name" --column="Path" \
            $wallpaper_list \
            --width=600 --height=400 \
            --print-column=3 2>/dev/null) || selected_wallpaper="$wallpaper"
    else
        selected_wallpaper="$wallpaper"
    fi

    if [ -n "$selected_wallpaper" ]; then
        set_wallpaper "$selected_wallpaper"
    fi

    log_success "Wallpapers installed"
}


install_neofetch_theme() {
    log_info "Installing Tokyo Night fetch tools configuration..."

    local neofetch_dir="$HOME/.config/neofetch"
    local fastfetch_dir="$HOME/.config/fastfetch"
    local nerdfetch_dir="$HOME/.config/nerdfetch"

    mkdir -p "$neofetch_dir" "$fastfetch_dir" "$nerdfetch_dir"

    get_colors

    local distro_icon="${SELECTED[neofetch_distro]:-auto}"
    if [ "$distro_icon" = "auto" ]; then
        distro_icon="${DETECTED[distro]}"
    fi

    local ascii_art
    ascii_art=$(get_distro_ascii "$distro_icon")

    local ascii_file="$neofetch_dir/ascii_${distro_icon}.txt"
    echo "$ascii_art" > "$ascii_file"

    if [ "${DETECTED[has_neofetch]}" = "true" ]; then
        install_neofetch_config "$ascii_file" "$distro_icon"
    fi

    if [ "${DETECTED[has_fastfetch]}" = "true" ]; then
        install_fastfetch_config "$ascii_file" "$distro_icon"
    fi

    if [ "${DETECTED[has_nerdfetch]}" = "true" ]; then
        install_nerdfetch_config "$distro_icon"
    fi

    create_fetch_aliases "$distro_icon"

    log_success "Fetch tools configuration installed"
}


install_neofetch_config() {
    local ascii_file="$1"
    local distro="$2"
    local neofetch_dir="$HOME/.config/neofetch"

    log_info "Configuring neofetch..."

    cat > "$neofetch_dir/config.conf" << 'NEOFETCHCONF'
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
NEOFETCHCONF

    cat >> "$neofetch_dir/config.conf" << NEOFETCHASCII

colors=(4 6 5 2 1 3)
image_backend="ascii"
image_source="$ascii_file"
ascii_distro="auto"
ascii_colors=(4 6 5 2 1 3)
ascii_bold="on"
gap=2
NEOFETCHASCII

    log_success "Neofetch configured"
}


install_fastfetch_config() {
    local ascii_file="$1"
    local distro="$2"
    local fastfetch_dir="$HOME/.config/fastfetch"
    local logo_type="${SELECTED[fastfetch_logo_type]:-small}"

    log_info "Configuring fastfetch..."

    local logo_config
    case "$logo_type" in
        small)
            logo_config=$(cat << LOGOCONF
    "logo": {
        "source": "$ascii_file",
        "type": "file",
        "padding": {
            "top": 0,
            "left": 1,
            "right": 2
        }
    },
LOGOCONF
)
            ;;
        auto)
            logo_config=$(cat << LOGOCONF
    "logo": {
        "type": "auto",
        "padding": {
            "top": 0,
            "left": 1,
            "right": 2
        }
    },
LOGOCONF
)
            ;;
        none)
            logo_config=$(cat << LOGOCONF
    "logo": {
        "type": "none"
    },
LOGOCONF
)
            ;;
    esac

    cat > "$fastfetch_dir/config.jsonc" << FASTFETCHCONF
{
    "\$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
$logo_config
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
FASTFETCHCONF

    log_success "Fastfetch configured"

    # Apply color scheme if selected
    if [ -n "${SELECTED[fastfetch_color_scheme]}" ]; then
        source "$SCRIPT_DIR/lib/fastfetch_color_schemes.sh"
        configure_fastfetch_color_scheme "${SELECTED[fastfetch_color_scheme]}"
    fi
}


install_nerdfetch_config() {
    local distro="$1"
    local nerdfetch_dir="$HOME/.config/nerdfetch"
    local style="${SELECTED[nerdfetch_style]:-icon}"

    log_info "Configuring nerdfetch..."

    local nerd_icon
    nerd_icon=$(get_nerd_font_icon "$distro")

    cat > "$nerdfetch_dir/config" << NERDFETCHCONF
ICON="$nerd_icon"
STYLE="$style"

COLOR1="\e[38;2;122;162;247m"
COLOR2="\e[38;2;125;207;255m"
COLOR3="\e[38;2;187;154;247m"
COLOR4="\e[38;2;158;206;106m"
COLOR5="\e[38;2;247;118;142m"
COLOR6="\e[38;2;224;175;104m"
RESET="\e[0m"
NERDFETCHCONF

    local nerdfetch_script="$nerdfetch_dir/tokyo-night-nerdfetch"
    cat > "$nerdfetch_script" << 'NERDFETCHSCRIPT'
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

    chmod +x "$nerdfetch_script"

    log_success "Nerdfetch configured"
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


create_fetch_aliases() {
    local distro="$1"
    local alias_file="$HOME/.config/tokyo-night/fetch-aliases.sh"

    mkdir -p "$(dirname "$alias_file")"

    cat > "$alias_file" << 'ALIASCONF'
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

    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$rc" ]; then
            if ! grep -q "tokyo-night/fetch-aliases.sh" "$rc" 2>/dev/null; then
                echo "" >> "$rc"
                echo "# Tokyo Night fetch aliases" >> "$rc"
                echo "[ -f \"$alias_file\" ] && source \"$alias_file\"" >> "$rc"
            fi
        fi
    done

    log_info "Fetch aliases created (use 'fetch' or 'nf' command)"
}


get_distro_ascii() {
    local distro="$1"

    case "$distro" in
        arch|archlinux)
            cat << 'ASCII'
      /\
     /  \
    /    \
   /  ,,  \
  /  |  |  \
 /_-`    `-_\
ASCII
            ;;
        debian)
            cat << 'ASCII'
   ,---._
  /  __  \
 |  /  \  |
 |  \__/  |
  \       /
   `-----'
ASCII
            ;;
        ubuntu)
            cat << 'ASCII'
       _
   ---(_)
 /  ---  \
|    O    |
 \  ---  /
   ---(_)
ASCII
            ;;
        fedora)
            cat << 'ASCII'
    ____
   /    \
  |  f   |
  |  ____|
  |  |
  |__|
ASCII
            ;;
        opensuse|suse)
            cat << 'ASCII'
   .---.
  /     \
  \_.-._/
  /`   `\
  \     /
   `---'
ASCII
            ;;
        gentoo)
            cat << 'ASCII'
   .-----.
  /  O O  \
 |    >    |
  \  ---  /
   `-----'
ASCII
            ;;
        nixos|nix)
            cat << 'ASCII'
  \\ //
 ==\\/==
  //\\
 //  \\
==    ==
ASCII
            ;;
        void|voidlinux)
            cat << 'ASCII'
   ____
  /    \
 |  \/  |
 |  /\  |
  \____/
ASCII
            ;;
        alpine)
            cat << 'ASCII'
   /\\
  /  \\
 / /\ \\
/      \\
ASCII
            ;;
        manjaro)
            cat << 'ASCII'
 ||| |||
 ||| |||
 ||   ||
 || | ||
 || | ||
ASCII
            ;;
        pikaos|pika)
            cat << 'ASCII'
  __  __
 /  \/  \
| o    o |
|   <>   |
 \  --  /
  \____/
ASCII
            ;;
        mint|linuxmint)
            cat << 'ASCII'
 _______
|       |
| | L M |
| |     |
| |_____|
|_______|
ASCII
            ;;
        pop|pop_os|popos)
            cat << 'ASCII'
  ____
 /    \
| P! _ |
 \  (_)
  \___/
ASCII
            ;;
        endeavouros|endeavour)
            cat << 'ASCII'
    /\\
   /  \\
  / /\ \\
 / /__\ \\
/________\\
ASCII
            ;;
        artix|artixlinux)
            cat << 'ASCII'
    /\\
   /  \\
  /,   \\
 /      \\
/`.    .'\\
ASCII
            ;;
        slackware)
            cat << 'ASCII'
  ____
 /    |
 \__  |
 ___| |
|     /
|____/
ASCII
            ;;
        centos)
            cat << 'ASCII'
  ____
 /    \\
|  <>  |
 \____/
  ||||
ASCII
            ;;
        rocky|rockylinux)
            cat << 'ASCII'
   /\\
  /  \\
 / R  \\
/______\\
ASCII
            ;;
        alma|almalinux)
            cat << 'ASCII'
   /\\
  /A \\
 /____\\
 |    |
ASCII
            ;;
        kali)
            cat << 'ASCII'
  _____
 /     \\
< KALI >
 \_____/
ASCII
            ;;
        parrot|parrotos)
            cat << 'ASCII'
   ___
  /   \\
 <  P  >
  \\   /
   ---
ASCII
            ;;
        elementary|elementaryos)
            cat << 'ASCII'
  _____
 /  e  \\
|   O   |
 \\_____/
ASCII
            ;;
        zorin|zorinos)
            cat << 'ASCII'
  _____
 |     |
 |  Z  |
 |_____|
ASCII
            ;;
        garuda)
            cat << 'ASCII'
   ___
  / G \\
 /=====\\
/_______\\
ASCII
            ;;
        cachyos|cachy)
            cat << 'ASCII'
   ___
  / C \\
 |  @  |
  \\___/
ASCII
            ;;
        nobara)
            cat << 'ASCII'
   ___
  / N \\
 |  *  |
  \\___/
ASCII
            ;;
        bazzite)
            cat << 'ASCII'
   ___
  / B \\
 | |>  |
  \\___/
ASCII
            ;;
        raspbian|raspberry)
            cat << 'ASCII'
   sp
  sp sp
 sp  sp
  \\  /
ASCII
            ;;
        redhat|rhel)
            cat << 'ASCII'
   ___
  / R \\
 | H   |
  \\___/
ASCII
            ;;
        nerd)
            cat << 'ASCII'
 
ASCII
            ;;
        tux|linux|*)
            cat << 'ASCII'
  .---.
 /     \\
|  @ @  |
 \\_____/
   | |
ASCII
            ;;
    esac
}


set_wallpaper() {
    local wallpaper="$1"

    echo "[VERBOSE] Starting wallpaper setup for: $wallpaper"
    log_info "Setting wallpaper: $wallpaper"

    if [[ "${DETECTED[distro]}" == "fedora" ]] || [[ "${DETECTED[de]}" == "COSMIC" ]]; then
        echo "[VERBOSE] Detected Fedora/COSMIC system"
        log_info "Detected Fedora/COSMIC, using enhanced wallpaper methods..."

        if command -v cosmic-bg &>/dev/null; then
            echo "[VERBOSE] Found cosmic-bg, attempting to set wallpaper..."
            log_info "Setting wallpaper with cosmic-bg..."
            cosmic-bg "$wallpaper" 2>/dev/null || echo "[VERBOSE] cosmic-bg failed, trying next method..."
        else
            echo "[VERBOSE] cosmic-bg not found, skipping..."
        fi

        if command -v gsettings &>/dev/null; then
            echo "[VERBOSE] Found gsettings, setting GNOME wallpaper..."
            log_info "Setting wallpaper with gsettings (Fedora/COSMIC)..."
            gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper" 2>/dev/null || echo "[VERBOSE] GNOME background URI failed..."
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper" 2>/dev/null || echo "[VERBOSE] GNOME dark background URI failed..."
            gsettings set org.gnome.desktop.background picture-options "zoom" 2>/dev/null || echo "[VERBOSE] GNOME picture options failed..."
            gsettings set org.gnome.desktop.background primary-color "#1a1b26" 2>/dev/null || echo "[VERBOSE] GNOME primary color failed..."
            gsettings set org.gnome.desktop.background secondary-color "#7aa2f7" 2>/dev/null || echo "[VERBOSE] GNOME secondary color failed..."
        else
            echo "[VERBOSE] gsettings not found, skipping GNOME wallpaper setup..."
        fi

        if command -v swaybg &>/dev/null && [ "${DETECTED[session]}" = "wayland" ]; then
            echo "[VERBOSE] Found swaybg, setting Wayland wallpaper..."
            log_info "Setting wallpaper with swaybg (Fedora/COSMIC Wayland)..."
            pkill swaybg 2>/dev/null || true
            swaybg -i "$wallpaper" -m fill &
        else
            echo "[VERBOSE] swaybg not available or not on Wayland, skipping..."
        fi

        if command -v swww &>/dev/null && [ "${DETECTED[session]}" = "wayland" ]; then
            echo "[VERBOSE] Found swww, setting Wayland wallpaper..."
            log_info "Setting wallpaper with swww (Fedora/COSMIC Wayland)..."
            if ! pgrep -x "swww-daemon" &>/dev/null; then
                echo "[VERBOSE] Starting swww daemon..."
                swww-daemon &
                sleep 0.5
            fi
            swww img "$wallpaper" --transition-type none 2>/dev/null || echo "[VERBOSE] swww wallpaper set failed..."

            local swww_script="$HOME/.config/tokyo-night/swww-wallpaper.sh"
            mkdir -p "$(dirname "$swww_script")"
            cat > "$swww_script" << SWWWSCRIPT
#!/bin/bash
if ! pgrep -x "swww-daemon" &>/dev/null; then
    swww-daemon &
    sleep 0.5
fi
swww img "$wallpaper" --transition-type none
SWWWSCRIPT
            chmod +x "$swww_script"
            log_info "Created swww script at $swww_script"
        else
            echo "[VERBOSE] swww not available or not on Wayland, skipping..."
        fi

        if command -v cosmic-wallpaper-manager &>/dev/null; then
            echo "[VERBOSE] Found cosmic-wallpaper-manager, setting wallpaper..."
            log_info "Setting wallpaper with cosmic-wallpaper-manager..."
            cosmic-wallpaper-manager set "$wallpaper" 2>/dev/null || echo "[VERBOSE] cosmic-wallpaper-manager failed..."
        else
            echo "[VERBOSE] cosmic-wallpaper-manager not found, skipping..."
        fi
    else
        echo "[VERBOSE] Not Fedora/COSMIC, using standard wallpaper methods..."
    fi

    if command -v gsettings &>/dev/null; then
        echo "[VERBOSE] Setting standard GNOME wallpaper..."
        gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper" 2>/dev/null || echo "[VERBOSE] Standard GNOME background URI failed..."
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper" 2>/dev/null || echo "[VERBOSE] Standard GNOME dark background URI failed..."
    else
        echo "[VERBOSE] gsettings not found for standard setup..."
    fi

    if command -v pcmanfm &>/dev/null; then
        echo "[VERBOSE] Setting wallpaper with pcmanfm..."
        pcmanfm --set-wallpaper="$wallpaper" 2>/dev/null || echo "[VERBOSE] pcmanfm wallpaper set failed..."
    else
        echo "[VERBOSE] pcmanfm not found, skipping..."
    fi

    if command -v feh &>/dev/null; then
        echo "[VERBOSE] Setting wallpaper with feh..."
        feh --bg-fill "$wallpaper" 2>/dev/null || echo "[VERBOSE] feh wallpaper set failed..."

        local fehbg="$HOME/.fehbg"
        echo "#!/bin/sh" > "$fehbg"
        echo "feh --bg-fill '$wallpaper'" >> "$fehbg"
        chmod +x "$fehbg"
    else
        echo "[VERBOSE] feh not found, skipping..."
    fi

    if command -v nitrogen &>/dev/null; then
        echo "[VERBOSE] Setting wallpaper with nitrogen..."
        nitrogen --set-zoom-fill "$wallpaper" 2>/dev/null || echo "[VERBOSE] nitrogen wallpaper set failed..."
    else
        echo "[VERBOSE] nitrogen not found, skipping..."
    fi

    if command -v swaybg &>/dev/null && [ "${DETECTED[session]}" = "wayland" ]; then
        echo "[VERBOSE] Setting Wayland wallpaper with swaybg..."
        pkill swaybg 2>/dev/null || true
        swaybg -i "$wallpaper" -m fill &
    else
        echo "[VERBOSE] swaybg not available for standard Wayland setup..."
    fi

    if command -v swww &>/dev/null && [ "${DETECTED[session]}" = "wayland" ]; then
        echo "[VERBOSE] Setting Wayland wallpaper with swww..."
        if ! pgrep -x "swww-daemon" &>/dev/null; then
            swww-daemon &
            sleep 0.5
        fi
        swww img "$wallpaper" --transition-type none 2>/dev/null || echo "[VERBOSE] Standard swww wallpaper set failed..."

        local swww_script="$HOME/.config/tokyo-night/swww-wallpaper.sh"
        mkdir -p "$(dirname "$swww_script")"
        cat > "$swww_script" << SWWWSCRIPT
#!/bin/bash
if ! pgrep -x "swww-daemon" &>/dev/null; then
    swww-daemon &
    sleep 0.5
fi
swww img "$wallpaper" --transition-type none
SWWWSCRIPT
        chmod +x "$swww_script"
        log_info "Created swww script at $swww_script"
    else
        echo "[VERBOSE] swww not available for standard Wayland setup..."
    fi

    if command -v hyprctl &>/dev/null; then
        echo "[VERBOSE] Setting wallpaper with hyprctl..."
        hyprctl hyprpaper wallpaper ",$wallpaper" 2>/dev/null || echo "[VERBOSE] hyprctl wallpaper set failed..."
    else
        echo "[VERBOSE] hyprctl not found, skipping..."
    fi

    if command -v xfconf-query &>/dev/null; then
        echo "[VERBOSE] Setting XFCE wallpaper..."
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$wallpaper" 2>/dev/null || echo "[VERBOSE] XFCE wallpaper set failed..."
    else
        echo "[VERBOSE] xfconf-query not found, skipping XFCE setup..."
    fi

    if command -v plasma-apply-wallpaperimage &>/dev/null; then
        echo "[VERBOSE] Setting KDE wallpaper..."
        plasma-apply-wallpaperimage "$wallpaper" 2>/dev/null || echo "[VERBOSE] KDE wallpaper set failed..."
    else
        echo "[VERBOSE] plasma-apply-wallpaperimage not found, skipping KDE setup..."
    fi

    if command -v niri &>/dev/null && [ "${DETECTED[session]}" = "wayland" ]; then
        echo "[VERBOSE] Setting Niri wallpaper..."
        if command -v swww &>/dev/null; then
            log_info "Wallpaper set via swww for Niri"
        elif command -v swaybg &>/dev/null; then
            log_info "Wallpaper set via swaybg for Niri"
        fi
    else
        echo "[VERBOSE] Niri not detected or not on Wayland..."
    fi

    echo "[SUCCESS] Wallpaper setup completed"
    log_success "Wallpaper set"
}


install_shells() {
    for shell in ${SELECTED[shells]}; do
        case "$shell" in
            bash) install_bash_theme ;;
            zsh) install_zsh_theme ;;
            fish) install_fish_theme ;;
        esac
    done
}


install_terminals() {
    for terminal in ${SELECTED[terminals]}; do
        case "$terminal" in
            kitty) install_kitty_theme ;;
            wezterm) install_wezterm_theme ;;
            alacritty) install_alacritty_theme ;;
            foot) install_foot_theme ;;
            gnome-terminal) install_gnome_terminal_theme ;;
        esac
    done
}


install_wms() {
    for wm in ${SELECTED[wms]}; do
        case "$wm" in
            i3) install_i3_theme ;;
            sway) install_sway_theme ;;
            hyprland) install_hyprland_theme ;;
            niri) install_niri_theme ;;
            cosmic) install_cosmic_theme ;;
            pikabar) install_pikabar_theme ;;
            waybar) install_waybar_theme ;;
            hyprland-compat) install_hyprland_compatibility ;;
            gnome|kde|xfce) install_gtk_theme ;;
        esac
    done
}


save_config() {
    local config_file="$CONFIG_DIR/config.sh"

    cat > "$config_file" << CONF
INSTALLED_VARIANT="${SELECTED[variant]}"
INSTALLED_DATE="$(date -Iseconds)"
INSTALLED_SHELLS="${SELECTED[shells]}"
INSTALLED_ZSH_PROMPT="${SELECTED[zsh_prompt]}"
INSTALLED_TERMINALS="${SELECTED[terminals]}"
INSTALLED_WMS="${SELECTED[wms]}"
INSTALLED_ICONS="${SELECTED[icons]}"
INSTALLED_WALLPAPER="${SELECTED[wallpaper]}"
INSTALLED_NEOFETCH="${SELECTED[neofetch]}"
INSTALLED_NEOFETCH_DISTRO="${SELECTED[neofetch_distro]}"
INSTALLED_FASTFETCH_COLOR_SCHEME="${SELECTED[fastfetch_color_scheme]}"
CONF

    log_info "Configuration saved to $config_file"
}


show_summary() {
    local summary="Tokyo Night Theme Installation Complete!

Variant: ${SELECTED[variant]}
Shells: ${SELECTED[shells]:-none}
Terminals: ${SELECTED[terminals]:-none}
WMs/DEs: ${SELECTED[wms]:-none}
Icons: ${SELECTED[icons]}
Wallpapers: ${SELECTED[wallpaper]}

Please restart your applications or log out and back in for all changes to take effect."

    if command -v zenity &>/dev/null; then
        zenity --info --title="Installation Complete" --text="$summary" --width=400 2>/dev/null
    else
        echo ""
        echo "========================================"
        echo "$summary"
        echo "========================================"
    fi
}


main() {
    echo "========================================"
    echo "  Tokyo Night Theme Installer"
    echo "========================================"
    echo ""

    check_dependencies

    log_info "Detecting system configuration..."
    detect_distro
    detect_shell
    detect_terminal
    detect_de_wm
    detect_gtk_qt

    echo ""
    log_info "Launching configuration GUI..."
    show_gui

    echo ""
    log_info "Installing themes..."

    install_shells
    install_terminals
    install_wms
    install_gtk_theme

    if [ "${SELECTED[icons]}" = "yes" ]; then
        install_icons
    fi

    if [ "${SELECTED[wallpaper]}" = "yes" ]; then
        install_wallpapers
    fi

    if [ "${SELECTED[neofetch]}" = "yes" ]; then
        install_neofetch_theme
    fi

    if [ "${DETECTED[has_anifetch]}" = "true" ] || [ -f "$HOME/.config/tokyo-night/anifetch.sh" ]; then
        echo "[VERBOSE] Anifetch detected or previously installed, setting up Tokyo Night theme..."
        source "$SCRIPT_DIR/lib/anifetch.sh"
        install_anifetch
    fi

    save_config

    echo ""
    show_summary

    log_success "Installation complete!"
}


main "$@"
