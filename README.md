# Dotfiles Management with GNU Stow

This repository contains my personal dotfiles organized for easy management using GNU Stow.

# Stow 
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

# Applications that need autostart
- logid (systemctl)

