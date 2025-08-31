# Dotfiles Management with GNU Stow

This repository contains my personal dotfiles organized for easy management using GNU Stow.

## Structure

```
dotfiles/
├── linux/                 # Linux-specific configurations
│   ├── sway/              # Sway window manager config
│   └── waybar/            # Waybar status bar config
├── mac/                   # macOS-specific configurations
│   └── aerospace/         # AeroSpace window manager config
├── install.sh             # Installation script
├── uninstall.sh          # Uninstallation script
└── README.md             # This file
```

## Prerequisites

Make sure GNU Stow is installed on your system:

### Linux
```bash
# Ubuntu/Debian
sudo apt install stow

# Arch Linux
sudo pacman -S stow

# Fedora
sudo dnf install stow
```

### macOS
```bash
brew install stow
```

## Installation

### Interactive Installation
Run the installation script which will:
1. Auto-detect your OS (with option to override)
2. Show available dotfile packages
3. Let you select which ones to install using checkboxes

```bash
./install.sh
```

### Manual Installation
You can also manually install specific packages:

```bash
# Install sway config on Linux
stow -d linux -t $HOME sway

# Install aerospace config on macOS  
stow -d mac -t $HOME aerospace
```

## Uninstallation

```bash
# Remove sway config
stow -d linux -t $HOME -D sway

# Remove aerospace config
stow -d mac -t $HOME -D aerospace
```

## Adding New Packages
1. Create a new directory under `linux/` or `mac/`
2. Structure the directory as if it were your `$HOME` directory
3. The scripts will automatically detect new packages

### Example: Adding a new Alacritty config for Linux
```bash
mkdir -p linux/alacritty/.config/alacritty
# Add your alacritty.yml file
echo "your config" > linux/alacritty/.config/alacritty/alacritty.yml
```

## How Stow Works

GNU Stow creates symbolic links from the package directories to your home directory. For example:

```
linux/sway/.config/sway/config → ~/.config/sway/config
```

This allows you to:
- Keep all configs in one repository
- Easily enable/disable configurations
- Version control your dotfiles
- Share configurations across multiple machines

## Tips

- Always backup your existing configs before installing
- Use `stow --simulate` to preview changes before applying
- The installation log (`.stow_installed`) helps track what's been installed
- You can mix and match packages from different operating systems if needed
