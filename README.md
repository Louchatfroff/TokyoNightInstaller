# Tokyo Night Theme Installer for Linux

A comprehensive installer script that automatically detects your Linux environment and installs the Tokyo Night theme across all your applications.

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
- GNOME
- KDE Plasma
- XFCE
- Budgie
- Cinnamon
- MATE
- LXQt

### Bars
- PikaBar (with icon theme integration)

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
9. Optionally configure neofetch with distro-specific ASCII art

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

## PikaOS Specific

On PikaOS, the installer will:

- Detect and configure PikaBar with Tokyo Night colors
- Set the Tokyo Night icon theme in PikaBar
- Apply appropriate styling for workspaces, tray, and notifications

## Credits

- [Tokyo Night Theme](https://github.com/enkia/tokyo-night-vscode-theme) by enkia
- [Tokyo Night Icons](https://github.com/ljmill/tokyo-night-icons) by ljmill
- [Tokyo Night Wallpapers](https://github.com/tokyo-night/wallpapers)

## License

MIT License
