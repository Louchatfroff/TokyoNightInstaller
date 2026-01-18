#!/bin/bash

set -e


log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;32m[OK]\033[0m $1"
}

log_warn() {
    echo -e "\033[1;33m[WARN]\033[0m $1"
}


confirm() {
    local prompt="$1"
    local response
    
    if command -v zenity &>/dev/null; then
        zenity --question --text="$prompt" --width=300 2>/dev/null && return 0 || return 1
    else
        read -p "$prompt [y/N] " response
        [[ "$response" =~ ^[Yy]$ ]]
    fi
}


remove_shell_themes() {
    log_info "Removing shell themes..."
    
    rm -f "$HOME/.config/tokyo-night/bash-theme.sh"
    rm -f "$HOME/.config/tokyo-night/zsh-theme.zsh"
    rm -f "$HOME/.config/tokyo-night/p10k-colors.zsh"
    rm -f "$HOME/.config/tokyo-night/pure-colors.zsh"
    rm -f "$HOME/.config/fish/conf.d/tokyo-night.fish"
    rm -f "$HOME/.config/starship.toml"
    
    local omz_theme="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/tokyonight.zsh-theme"
    rm -f "$omz_theme"
    
    if [ -f "$HOME/.bashrc" ]; then
        sed -i '/# Tokyo Night Theme/d' "$HOME/.bashrc"
        sed -i '/tokyo-night\/bash-theme.sh/d' "$HOME/.bashrc"
    fi
    
    if [ -f "$HOME/.zshrc" ]; then
        sed -i '/# Tokyo Night Theme/d' "$HOME/.zshrc"
        sed -i '/# Tokyo Night P10k Colors/d' "$HOME/.zshrc"
        sed -i '/# Tokyo Night Pure Colors/d' "$HOME/.zshrc"
        sed -i '/# Starship prompt/d' "$HOME/.zshrc"
        sed -i '/tokyo-night\/zsh-theme.zsh/d' "$HOME/.zshrc"
        sed -i '/tokyo-night\/p10k-colors.zsh/d' "$HOME/.zshrc"
        sed -i '/tokyo-night\/pure-colors.zsh/d' "$HOME/.zshrc"
        sed -i '/eval "\$(starship init zsh)"/d' "$HOME/.zshrc"
    fi
    
    rmdir "$HOME/.config/tokyo-night" 2>/dev/null || true
    
    log_success "Shell themes removed"
}


remove_terminal_themes() {
    log_info "Removing terminal themes..."
    
    rm -f "$HOME/.config/kitty/tokyo-night.conf"
    if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
        sed -i '/include tokyo-night.conf/d' "$HOME/.config/kitty/kitty.conf"
    fi
    
    rm -f "$HOME/.config/wezterm/tokyo-night.lua"
    
    rm -f "$HOME/.config/alacritty/tokyo-night.toml"
    if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
        sed -i '/tokyo-night.toml/d' "$HOME/.config/alacritty/alacritty.toml"
    fi
    
    rm -f "$HOME/.config/foot/tokyo-night.ini"
    if [ -f "$HOME/.config/foot/foot.ini" ]; then
        sed -i '/include=tokyo-night.ini/d' "$HOME/.config/foot/foot.ini"
    fi
    
    log_success "Terminal themes removed"
}


remove_wm_themes() {
    log_info "Removing WM/DE themes..."
    
    rm -f "$HOME/.config/i3/tokyo-night.conf"
    rm -f "$HOME/.i3/tokyo-night.conf"
    if [ -f "$HOME/.config/i3/config" ]; then
        sed -i '/include tokyo-night.conf/d' "$HOME/.config/i3/config"
        sed -i '/# Tokyo Night Theme/d' "$HOME/.config/i3/config"
    fi
    if [ -f "$HOME/.i3/config" ]; then
        sed -i '/include tokyo-night.conf/d' "$HOME/.i3/config"
        sed -i '/# Tokyo Night Theme/d' "$HOME/.i3/config"
    fi
    
    rm -f "$HOME/.config/sway/tokyo-night.conf"
    if [ -f "$HOME/.config/sway/config" ]; then
        sed -i '/include tokyo-night.conf/d' "$HOME/.config/sway/config"
        sed -i '/# Tokyo Night Theme/d' "$HOME/.config/sway/config"
    fi
    
    rm -f "$HOME/.config/hypr/tokyo-night.conf"
    if [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
        sed -i '/source.*tokyo-night.conf/d' "$HOME/.config/hypr/hyprland.conf"
        sed -i '/# Tokyo Night Theme/d' "$HOME/.config/hypr/hyprland.conf"
    fi
    
    rm -f "$HOME/.config/niri/tokyo-night.kdl"
    if [ -f "$HOME/.config/niri/config.kdl" ]; then
        sed -i '/tokyo-night/d' "$HOME/.config/niri/config.kdl"
    fi
    
    rm -f "$HOME/.config/pikabar/style.css"
    
    rm -f "$HOME/.config/waybar/tokyo-night.css"
    if [ -f "$HOME/.config/waybar/style.css" ]; then
        sed -i '/@import.*tokyo-night/d' "$HOME/.config/waybar/style.css"
    fi
    
    log_success "WM/DE themes removed"
}


remove_gtk_themes() {
    log_info "Removing GTK themes..."
    
    rm -f "$HOME/.config/gtk-3.0/gtk.css"
    rm -f "$HOME/.config/gtk-4.0/gtk.css"
    
    log_success "GTK themes removed"
}


remove_neofetch_themes() {
    log_info "Removing neofetch/fastfetch/nerdfetch themes..."
    
    rm -f "$HOME/.config/neofetch/config.conf"
    rm -f "$HOME/.config/neofetch/ascii_"*.txt
    rm -f "$HOME/.config/fastfetch/config.jsonc"
    rm -rf "$HOME/.config/nerdfetch"
    rm -f "$HOME/.config/tokyo-night/fetch-aliases.sh"
    
    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [ -f "$rc" ]; then
            sed -i '/Tokyo Night fetch aliases/d' "$rc"
            sed -i '/tokyo-night\/fetch-aliases.sh/d' "$rc"
        fi
    done
    
    log_success "Fetch tool themes removed"
}


remove_swww_config() {
    log_info "Removing swww configuration..."
    
    rm -f "$HOME/.config/tokyo-night/swww-wallpaper.sh"
    
    log_success "swww configuration removed"
}


remove_icons() {
    log_info "Removing Tokyo Night icons..."
    
    rm -rf "$HOME/.local/share/icons/TokyoNight-SE"
    
    if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
        sed -i 's/gtk-icon-theme-name=TokyoNight-SE/gtk-icon-theme-name=Adwaita/' "$HOME/.config/gtk-3.0/settings.ini"
    fi
    
    if command -v gsettings &>/dev/null; then
        gsettings reset org.gnome.desktop.interface icon-theme 2>/dev/null || true
    fi
    
    log_success "Icons removed"
}


remove_wallpapers() {
    log_info "Removing Tokyo Night wallpapers..."
    
    rm -rf "$HOME/.local/share/tokyo-night-wallpapers"
    
    log_success "Wallpapers removed"
}


remove_cache() {
    log_info "Removing cache..."
    
    rm -rf "$HOME/.cache/tokyo-night-installer"
    rm -rf "$HOME/.config/tokyo-night-installer"
    
    log_success "Cache removed"
}


main() {
    echo "========================================"
    echo "  Tokyo Night Theme Uninstaller"
    echo "========================================"
    echo ""
    
    if ! confirm "This will remove all Tokyo Night theme configurations. Continue?"; then
        log_info "Uninstallation cancelled"
        exit 0
    fi
    
    remove_shell_themes
    remove_terminal_themes
    remove_wm_themes
    remove_gtk_themes
    remove_neofetch_themes
    remove_swww_config
    
    if confirm "Remove Tokyo Night icons?"; then
        remove_icons
    fi
    
    if confirm "Remove Tokyo Night wallpapers?"; then
        remove_wallpapers
    fi
    
    if confirm "Remove installer cache and configuration?"; then
        remove_cache
    fi
    
    echo ""
    log_success "Tokyo Night theme has been uninstalled"
    log_info "Please restart your applications or log out for changes to take effect"
}


main "$@"
