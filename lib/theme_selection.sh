#!/bin/bash

NEOFETCH_THEMES_REPO="https://github.com/Chick2D/neofetch-themes"
NEOCAT_REPO="https://github.com/m3tozz/NeoCat"
FASTCAT_REPO="https://github.com/m3tozz/FastCat"
DOTFILES_FASTFETCH_REPO="https://github.com/sofijacom/dotfiles-fastfetch"

CACHE_DIR="$HOME/.cache/tokyo-night-themes"
CONFIG_DIR="$HOME/.config/tokyo-night-themes"

mkdir -p "$CACHE_DIR" "$CONFIG_DIR"

fetch_external_themes() {
    local repo_type="$1"
    local repo_url="$2"
    local cache_dir="$CACHE_DIR/$repo_type"
    local config_dir="$CONFIG_DIR/$repo_type"

    mkdir -p "$cache_dir" "$config_dir"

    log_info "Fetching themes from $repo_type repository..."

    if [ ! -d "$cache_dir/.git" ]; then
        log_info "Cloning $repo_type repository..."
        git clone --depth 1 "$repo_url" "$cache_dir"
    else
        log_info "Updating $repo_type repository..."
        git -C "$cache_dir" pull
    fi

    case "$repo_type" in
        neofetch-themes)
            if [ -d "$cache_dir/themes" ]; then
                cp -r "$cache_dir/themes"/* "$config_dir/"
            fi
            ;;
        neocat)
            if [ -d "$cache_dir/themes" ]; then
                cp -r "$cache_dir/themes"/* "$config_dir/"
            fi
            ;;
        fastcat)
            if [ -d "$cache_dir/themes" ]; then
                cp -r "$cache_dir/themes"/* "$config_dir/"
            fi
            ;;
        dotfiles-fastfetch)
            if [ -d "$cache_dir/themes" ]; then
                cp -r "$cache_dir/themes"/* "$config_dir/"
            fi
            ;;
    esac

    echo "$config_dir"
}

list_available_themes() {
    local repo_type="$1"
    local themes_dir="$CONFIG_DIR/$repo_type"

    if [ ! -d "$themes_dir" ]; then
        echo "No themes available for $repo_type"
        return 1
    fi

    local theme_list=""
    local count=0

    while IFS= read -r theme_file; do
        if [ -f "$theme_file" ]; then
            local theme_name=$(basename "$theme_file")
            theme_list+="$theme_name "
            ((count++))
        fi
    done < <(find "$themes_dir" -type f -name "*.conf" -o -name "*.jsonc" -o -name "*.txt" | sort)

    if [ $count -eq 0 ]; then
        echo "No themes found in $repo_type"
        return 1
    fi

    echo "$theme_list"
    return 0
}

apply_theme() {
    local repo_type="$1"
    local theme_name="$2"
    local target_tool="$3"
    local recolor="${4:-yes}"

    local theme_file=""
    local themes_dir="$CONFIG_DIR/$repo_type"

    if [ -f "$themes_dir/$theme_name" ]; then
        theme_file="$themes_dir/$theme_name"
    else
        theme_file=$(find "$themes_dir" -name "$theme_name" -type f | head -1)
    fi

    if [ -z "$theme_file" ] || [ ! -f "$theme_file" ]; then
        log_error "Theme $theme_name not found in $repo_type"
        return 1
    fi

    log_info "Applying theme $theme_name from $repo_type to $target_tool..."

    if [ "$recolor" = "yes" ]; then
        recolor_theme_file "$theme_file" "$target_tool"
    fi

    case "$target_tool" in
        neofetch)
            local neofetch_dir="$HOME/.config/neofetch"
            mkdir -p "$neofetch_dir"

            cp "$theme_file" "$neofetch_dir/"

            local config_file="$neofetch_dir/config.conf"
            if [ ! -f "$config_file" ]; then
                cat > "$config_file" << NEOFETCHCONF
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
NEOFETCHCONF
            fi

            local theme_basename=$(basename "$theme_file")
            sed -i 's|^image_source=.*|image_source="'$theme_basename'"|' "$config_file"
            sed -i 's|^ascii_distro=.*|ascii_distro="auto"|' "$config_file"

            log_success "Applied $theme_name to neofetch"
            ;;
        fastfetch)
            local fastfetch_dir="$HOME/.config/fastfetch"
            mkdir -p "$fastfetch_dir"

            cp "$theme_file" "$fastfetch_dir/"

            local config_file="$fastfetch_dir/config.jsonc"
            if [ ! -f "$config_file" ]; then
                cat > "$config_file" << FASTFETCHCONF
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
    }
}
FASTFETCHCONF
            fi

            local theme_basename=$(basename "$theme_file")
            jq '.logo.source = "'$theme_basename'"' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            jq '.logo.type = "file"' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"

            log_success "Applied $theme_name to fastfetch"
            ;;
        anifetch)
            local anifetch_dir="$HOME/.config/anifetch"
            mkdir -p "$anifetch_dir"

            cp "$theme_file" "$anifetch_dir/"

            local config_file="$anifetch_dir/config.jsonc"
            if [ ! -f "$config_file" ]; then
                cat > "$config_file" << ANIFETCHCONF
{
    "theme": {
        "background": "#1a1b26",
        "foreground": "#c0caf5",
        "accent": "#7aa2f7",
        "secondary": "#bb9af7",
        "text": "#7dcfff"
    },
    "logo": {
        "type": "distro",
        "distro": "auto",
        "size": "medium",
        "color": "#7aa2f7"
    }
}
ANIFETCHCONF
            fi

            local theme_basename=$(basename "$theme_file")
            jq '.logo.source = "'$theme_basename'"' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
            jq '.logo.type = "file"' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"

            log_success "Applied $theme_name to anifetch"
            ;;
        nerdfetch)
            local nerdfetch_dir="$HOME/.config/nerdfetch"
            mkdir -p "$nerdfetch_dir"

            cp "$theme_file" "$nerdfetch_dir/"

            local config_file="$nerdfetch_dir/config"
            if [ ! -f "$config_file" ]; then
                cat > "$config_file" << NERDFETCHCONF
ICON=""
STYLE="icon"
COLOR1="#7aa2f7"
COLOR2="#7dcfff"
COLOR3="#bb9af7"
COLOR4="#9ece6a"
COLOR5="#f7768e"
COLOR6="#e0af68"
RESET="\e[0m"
NERDFETCHCONF
            fi

            local theme_basename=$(basename "$theme_file")
            sed -i 's|^ICON=.*|ICON="'$theme_basename'"|' "$config_file"

            log_success "Applied $theme_name to nerdfetch"
            ;;
        *)
            log_error "Unknown target tool: $target_tool"
            return 1
            ;;
    esac
}

recolor_theme_file() {
    local theme_file="$1"
    local target_tool="$2"

    if [ ! -f "$theme_file" ]; then
        return 1
    fi

    local variant="${SELECTED[variant]:-night}"
    local bg_color, fg_color, accent_color, secondary_color, text_color
    local red_color, orange_color, yellow_color, green_color, cyan_color, blue_color, magenta_color

    case "$variant" in
        night|storm)
            bg_color="#1a1b26"
            fg_color="#c0caf5"
            accent_color="#7aa2f7"
            secondary_color="#bb9af7"
            text_color="#7dcfff"
            red_color="#f7768e"
            orange_color="#ff9e64"
            yellow_color="#e0af68"
            green_color="#9ece6a"
            cyan_color="#7dcfff"
            blue_color="#7aa2f7"
            magenta_color="#bb9af7"
            ;;
        light)
            bg_color="#d5d6db"
            fg_color="#343b58"
            accent_color="#34548a"
            secondary_color="#5a4a78"
            text_color="#0f4b6e"
            red_color="#8c4351"
            orange_color="#965027"
            yellow_color="#8f5e15"
            green_color="#33635c"
            cyan_color="#0f4b6e"
            blue_color="#34548a"
            magenta_color="#5a4a78"
            ;;
        *)
            bg_color="#1a1b26"
            fg_color="#c0caf5"
            accent_color="#7aa2f7"
            secondary_color="#bb9af7"
            text_color="#7dcfff"
            red_color="#f7768e"
            orange_color="#ff9e64"
            yellow_color="#e0af68"
            green_color="#9ece6a"
            cyan_color="#7dcfff"
            blue_color="#7aa2f7"
            magenta_color="#bb9af7"
            ;;
    esac

    case "$target_tool" in
        neofetch)
            sed -i 's/colors=(.*/colors=(4 6 5 2 1 3)/' "$theme_file"
            sed -i 's/ascii_colors=(.*/ascii_colors=(4 6 5 2 1 3)/' "$theme_file"
            ;;
        fastfetch)
            if command -v jq &>/dev/null; then
                jq '.display.color = {"keys": "blue", "title": "magenta", "separator": "cyan"}' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
            fi
            ;;
        anifetch)
            if command -v jq &>/dev/null; then
                jq '.theme.background = "'$bg_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.theme.foreground = "'$fg_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.theme.accent = "'$accent_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.theme.secondary = "'$secondary_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.theme.text = "'$text_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.logo.color = "'$accent_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.info.color = "'$fg_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.info.key_color = "'$accent_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.ascii.color = "'$accent_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
                jq '.ascii.secondary_color = "'$secondary_color'"' "$theme_file" > "${theme_file}.tmp" && mv "${theme_file}.tmp" "$theme_file"
            fi
            ;;
        nerdfetch)
            sed -i 's/COLOR1=.*/COLOR1="\e[38;2;122;162;247m"/' "$theme_file"
            sed -i 's/COLOR2=.*/COLOR2="\e[38;2;125;207;255m"/' "$theme_file"
            sed -i 's/COLOR3=.*/COLOR3="\e[38;2;187;154;247m"/' "$theme_file"
            sed -i 's/COLOR4=.*/COLOR4="\e[38;2;158;206;106m"/' "$theme_file"
            sed -i 's/COLOR5=.*/COLOR5="\e[38;2;247;118;142m"/' "$theme_file"
            sed -i 's/COLOR6=.*/COLOR6="\e[38;2;224;175;104m"/' "$theme_file"
            ;;
    esac
}

show_theme_selection_menu() {
    local target_tool="$1"

    local repos=(
        "neofetch-themes:$NEOFETCH_THEMES_REPO"
        "neocat:$NEOCAT_REPO"
        "fastcat:$FASTCAT_REPO"
        "dotfiles-fastfetch:$DOTFILES_FASTFETCH_REPO"
    )

    for repo in "${repos[@]}"; do
        local repo_type="${repo%%:*}"
        local repo_url="${repo#*:}"
        fetch_external_themes "$repo_type" "$repo_url"
    done

    local all_themes=""
    local theme_count=0

    for repo in "${repos[@]}"; do
        local repo_type="${repo%%:*}"
        local themes=$(list_available_themes "$repo_type")
        if [ -n "$themes" ]; then
            for theme in $themes; do
                all_themes+="$repo_type:$theme "
                ((theme_count++))
            done
        fi
    done

    if [ $theme_count -eq 0 ]; then
        log_error "No themes found in any repository"
        return 1
    fi

    if command -v zenity &>/dev/null; then
        local theme_list=""
        for theme in $all_themes; do
            local repo_type="${theme%%:*}"
            local theme_name="${theme#*:}"
            theme_list+="FALSE $repo_type:$theme_name $theme_name "
        done

        local selected_theme=$(zenity --list \
            --title="Select Theme" \
            --text="Choose a theme for $target_tool:" \
            --checklist \
            --column="Select" --column="Theme" --column="Name" \
            $theme_list \
            --width=600 --height=400 \
            --print-column=2 2>/dev/null)

        if [ -n "$selected_theme" ]; then
            local repo_type="${selected_theme%%:*}"
            local theme_name="${selected_theme#*:}"

            local recolor_option=$(zenity --question \
                --title="Recolor Theme" \
                --text="Recolor this theme with Tokyo Night colors?" \
                --width=300 2>/dev/null && echo "yes" || echo "no")

            apply_theme "$repo_type" "$theme_name" "$target_tool" "$recolor_option"
        fi
    else
        echo "Available themes:"
        echo "$all_themes"
        echo ""
        echo "Please select a theme by running:"
        echo "apply_theme <repo_type> <theme_name> $target_tool [recolor]"
    fi
}

log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;32m[OK]\033[0m $1"
}

log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

main() {
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <target_tool> [theme_repo:theme_name] [recolor]"
        echo "Target tools: neofetch, fastfetch, anifetch, nerdfetch"
        echo "Recolor: yes/no (default: yes)"
        exit 1
    fi

    local target_tool="$1"
    local theme_spec="$2"
    local recolor="${3:-yes}"

    if [ -n "$theme_spec" ]; then
        local repo_type="${theme_spec%%:*}"
        local theme_name="${theme_spec#*:}"
        apply_theme "$repo_type" "$theme_name" "$target_tool" "$recolor"
    else
        show_theme_selection_menu "$target_tool"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
