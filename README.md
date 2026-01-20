# Tokyo Night Theme Installer for Linux

A comprehensive installer script that automatically detects your Linux environment and installs the Tokyo Night theme across all your applications.
> **DISCLAIMER:** Ai-Generated readme and repetitive color files for praticity purposes. Scripts that are repeated but only with different loggin or directories also were.
## Features

- Automatic detection of Linux distribution (including PikaOS)
- Shell detection and theming (Bash, Zsh, Fish)
- Terminal emulator theming (Kitty, WezTerm, Alacritty, Foot, GNOME Terminal)
- Window Manager/Desktop Environment theming (i3, Sway, Hyprland, Niri, GNOME, KDE, XFCE)
- PikaBar theming with icon integration
- GTK 3/4 configuration
- Tokyo Night icon pack installation
- Wallpaper installation with swww support (single wallpaper mode)
- Customizable neofetch/fastfetch with distro-specific ASCII art

## Supported Components

### Distributions
- Arch Linux and derivatives
- Debian and derivatives
- Ubuntu and derivatives
- Fedora
- openSUSE
- Gentoo
- NixOS
- Void Linux
- Alpine Linux
- Manjaro
- PikaOS
- Linux Mint
- Pop!_OS
- EndeavourOS
- Artix Linux
- Slackware
- And more...

### Shells
- Bash
- Zsh
- Fish

### Terminal Emulators
- Kitty
- WezTerm
- Alacritty
- Foot
- GNOME Terminal
- Konsole (partial)
- XFCE Terminal (partial)

### Window Managers / Desktop Environments
- i3
- Sway
- Hyprland
- Niri (with focus ring and border colors)
- Fedora Cosmic (with compositor and panel theming)
- GNOME
- KDE Plasma
- XFCE
- Budgie
- Cinnamon
- MATE
- LXQt

### Bars
- PikaBar (with icon theme integration)
- Waybar (with Hyprland compatibility)
- Hyprland-specific Waybar enhancements

### Wallpaper Tools
- feh
- nitrogen
- swaybg
- swww (single wallpaper, no transition)
- hyprpaper
- GNOME/KDE/XFCE native

### System Info Tools
- neofetch (with custom distro ASCII art)
- fastfetch
- anifetch (anime-themed fetch tool)
- nerdfetch (nerd font icon-based fetch tool)

### Theme Variants
- **Night** - The classic dark blue Tokyo Night theme
- **Storm** - A darker variant with deeper blues
- **Light** - A light theme for daytime use

## Requirements

- `git`
- `curl` or `wget`
- `tar`
- `zenity` or `yad` (for GUI)

### Optional Dependencies
- `dconf` (for GNOME Terminal)
- `feh` or `nitrogen` (for X11 wallpaper)
- `swaybg` or `swww` (for Wayland wallpaper)
- `jq` (for PikaBar config)

## Installation

```bash
git clone https://github.com/louchatfroff/TokyoNightInstaller.git
cd TokyoNightInstaller
chmod +x install.sh
./install.sh
```

## Usage

Run the installer:

```bash
./install.sh
```

The script will:

1. Detect your system configuration
2. Show a GUI to select theme variant and components
3. Install themes for selected shells
4. Install themes for detected terminal emulators
5. Configure window managers and desktop environments
6. Configure PikaBar if detected (PikaOS)
7. Optionally install the Tokyo Night icon pack
8. Optionally download and set Tokyo Night wallpapers (via swww on Wayland)
9. Optionally configure neofetch/fastfetch/anifetch/nerdfetch with distro-specific ASCII art
10. Optionally fetch and apply themes from external repositories (neofetch-themes, NeoCat, FastCat, dotfiles-fastfetch)

## Neofetch Configuration

The installer creates compact neofetch configurations with:

- Distro-specific ASCII art (auto-detected or manually selected)
- Tokyo Night color scheme
- Compact info display (8 lines max to match icon height)
- Support for 17+ distro icons

Available distro icons:
- arch, debian, ubuntu, fedora, opensuse
- gentoo, nixos, void, alpine, manjaro
- pikaos, mint, pop, endeavouros, artix
- slackware, tux (generic)

## Anifetch Configuration

The installer now supports anifetch, an anime-themed system information tool with:

- Tokyo Night color scheme integration
- Anime-themed ASCII art (catgirl, fox, wolf, dragon, etc.)
- Compact info display with anime aesthetic
- Customizable anime themes

## Nerdfetch Configuration

The installer now supports nerdfetch, a nerd font icon-based system information tool with:

- Tokyo Night color scheme integration
- Nerd font icon support for 20+ distributions
- Multiple display styles (icon, minimal, full)
- Compact info display with nerd font icons

## External Theme Selection

The installer now includes theme selection from external repositories:

- **neofetch-themes** - Collection of neofetch themes
- **NeoCat** - Neofetch themes with catgirl aesthetic
- **FastCat** - Fastfetch themes with catgirl aesthetic
- **dotfiles-fastfetch** - Fastfetch configuration collection

During installation, you can choose to fetch and apply themes from these repositories to any of the supported fetch tools (neofetch, fastfetch, anifetch, nerdfetch).

## Tokyo Night Recoloring

All external themes can be automatically recolored with Tokyo Night colors:

- **Automatic recoloring**: When applying themes from external repositories, you can choose to recolor them with Tokyo Night color scheme
- **Variant support**: Recoloring respects the selected theme variant (night, storm, light)
- **Tool-specific recoloring**: Each fetch tool gets appropriate Tokyo Night colors applied to its configuration

The recoloring feature ensures that all themes maintain a consistent Tokyo Night aesthetic while preserving the original theme structure and layout.


## Manual Installation

If you prefer to install components manually, theme files are generated in:

- `~/.config/tokyo-night/` - Shell themes
- `~/.config/kitty/tokyo-night.conf` - Kitty theme
- `~/.config/wezterm/tokyo-night.lua` - WezTerm theme
- `~/.config/alacritty/tokyo-night.toml` - Alacritty theme
- `~/.config/foot/tokyo-night.ini` - Foot theme
- `~/.config/i3/tokyo-night.conf` - i3 theme
- `~/.config/sway/tokyo-night.conf` - Sway theme
- `~/.config/hypr/tokyo-night.conf` - Hyprland theme
- `~/.config/niri/tokyo-night.kdl` - Niri theme
- `~/.config/pikabar/style.css` - PikaBar theme
- `~/.config/neofetch/config.conf` - Neofetch config
- `~/.config/fastfetch/config.jsonc` - Fastfetch config

## Uninstallation

Run the uninstall script:

```bash
./uninstall.sh
```

Or manually remove:

1. Theme include lines from your configs
2. Generated theme files from `~/.config/`
3. Icons from `~/.local/share/icons/TokyoNight-SE`
4. Wallpapers from `~/.local/share/tokyo-night-wallpapers`

## Color Palette

### Night / Storm

| Color   | Hex       |
|---------|-----------|
| BG      | `#1a1b26` |
| FG      | `#c0caf5` |
| Red     | `#f7768e` |
| Orange  | `#ff9e64` |
| Yellow  | `#e0af68` |
| Green   | `#9ece6a` |
| Cyan    | `#7dcfff` |
| Blue    | `#7aa2f7` |
| Magenta | `#bb9af7` |

### Light

| Color   | Hex       |
|---------|-----------|
| BG      | `#d5d6db` |
| FG      | `#343b58` |
| Red     | `#8c4351` |
| Orange  | `#965027` |
| Yellow  | `#8f5e15` |
| Green   | `#33635c` |
| Cyan    | `#0f4b6e` |
| Blue    | `#34548a` |
| Magenta | `#5a4a78` |

## Hyprland Compatibility

The installer now includes enhanced Hyprland compatibility with JaKooLit's Hyprland-Dots style configurations:

### Hyprland-Specific Features

- **Enhanced Waybar Configuration**: Hyprland-specific modules including:
  - Active workspace indicator
  - Submap indicator
  - Window title display
  - Keyboard layout indicator
  - Enhanced tooltips and styling

- **Hyprland-Optimized Fastfetch**: Custom Fastfetch configuration with:
  - Hyprland version detection
  - Waybar version detection
  - swww wallpaper daemon info
  - Tokyo Night color scheme integration
  - Additional system modules (GPU, disk, battery, temperature, etc.)

- **Startup Scripts**: Automatic management of:
  - Waybar launcher with proper restart handling
  - Fastfetch with Tokyo Night theme
  - Wallpaper setup via swww
  - GTK theme application

- **Hyprland Configuration Snippet**: Ready-to-use Hyprland config with:
  - Tokyo Night color scheme variables
  - Window rules for system tools
  - Keybindings for Tokyo Night applications
  - Startup applications (Waybar, Mako, swww, etc.)

### Usage

To use Hyprland compatibility:

1. Select "hyprland-compat" in the WM/DE selection menu
2. The installer will create:
   - Enhanced Waybar config at `~/.config/waybar/`
   - Hyprland Fastfetch config at `~/.config/fastfetch/`
   - Startup scripts at `~/.config/tokyo-night/hyprland/`
   - Hyprland config snippet at `~/.config/hypr/tokyo-night-snippet.conf`

3. Add this to your Hyprland config:
```conf
source = ~/.config/hypr/tokyo-night-snippet.conf
exec-once = $HOME/.config/tokyo-night/hyprland/hyprland-startup.sh
```

### Keybindings

The Hyprland snippet includes useful keybindings:
- `Super+F1`: Launch Fastfetch with Tokyo Night theme
- `Super+F12`: Restart Waybar
- `Super+Shift+R`: Reload Hyprland config

## PikaOS Specific

On PikaOS, the installer will:

- Detect and configure PikaBar with Tokyo Night colors
- Set the Tokyo Night icon theme in PikaBar
- Apply appropriate styling for workspaces, tray, and notifications

## Credits

- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme) by enkia
- [Tokyo Night Icons](https://github.com/ljmill/tokyo-night-icons) by ljmill
- [Tokyo Night Wallpapers](https://github.com/tokyo-night/wallpapers)
- [neofetch-themes](https://github.com/Chick2D/neofetch-themes) by Chick2D
- [NeoCat](https://github.com/m3tozz/NeoCat) by m3tozz
- [FastCat](https://github.com/m3tozz/FastCat) by m3tozz
- [dotfiles-fastfetch](https://github.com/sofijacom/dotfiles-fastfetch) by sofijacom

## License

MIT License
