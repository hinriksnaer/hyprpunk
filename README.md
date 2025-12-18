# Hyprpunk

<div align="center">

**A complete Hyprland desktop environment profile for Fedpunk**

*Build your perfect keyboard-driven workspace with live theming, vim-style navigation, and modern development tools*

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Fedora](https://img.shields.io/badge/Fedora-40+-blue.svg)](https://getfedora.org/)

---

## See It In Action

[![Watch the demo](https://i.vimeocdn.com/video/2087154164-42913e946a9b98dc351ec6bb62ab47f5e651606ce934b35e2038324747d7cbfd-d_640)](https://vimeo.com/1140211449)

*Click to watch: Live theme switching, keyboard-driven workflow, and seamless module deployment*

### [**Watch Full Demo on Vimeo**](https://vimeo.com/1140211449)

</div>

---

## What is Hyprpunk?

Hyprpunk is an external profile for [Fedpunk](https://github.com/hinriksnaer/Fedpunk) that provides a complete Hyprland-based desktop environment with theming, development tools, and modern applications.

**This is:**
- ✅ A complete desktop environment profile
- ✅ 12 beautiful pre-configured themes
- ✅ 27 desktop-focused modules
- ✅ Custom plugins for enhanced functionality
- ✅ Multiple modes: desktop, laptop, container

**This is NOT:**
- ❌ A standalone desktop environment (requires Fedpunk core)
- ❌ A replacement for Fedpunk (it's a profile that uses Fedpunk)

---

## Quick Start

### Prerequisites

```bash
# Install Fedpunk core engine
sudo dnf copr enable hinriksnaer/fedpunk
sudo dnf install fedpunk
```

### Desktop Installation

```bash
# Deploy hyprpunk desktop profile
fedpunk profile deploy git@github.com:hinriksnaer/hyprpunk.git --mode desktop
```

### Laptop Installation

```bash
# Deploy hyprpunk laptop profile (no NVIDIA, optimized for battery)
fedpunk profile deploy git@github.com:hinriksnaer/hyprpunk.git --mode laptop
```

### Container Installation

```bash
# Deploy minimal development environment (no GUI)
fedpunk profile deploy git@github.com:hinriksnaer/hyprpunk.git --mode container
```

---

## What's Included

### Desktop Environment
- **Hyprland** - Modern Wayland compositor
- **Kitty** - GPU-accelerated terminal
- **Rofi** - Application launcher
- **Waybar** - Status bar (coming soon)
- **Hyprlock** - Screen locker

### Development Tools
- **Neovim** - Advanced text editor with LSP
- **Tmux** - Terminal multiplexer
- **Lazygit** - Git TUI
- **Yazi** - File manager TUI
- **GitHub CLI** - GitHub integration
- **Claude Code** - AI coding assistant

### Applications
- **Zen Browser** - Privacy-focused browser
- **Bitwarden CLI** - Password manager
- **Spotify** - Music streaming (Flatpak)
- **Discord** - Communication (Flatpak)
- **Slack** - Team collaboration (Flatpak)

### Themes (12 total)

**12 carefully curated themes with instant live-reload:**

| Theme | Style | Best For |
|-------|-------|----------|
| **aetheria** | Ethereal purple/blue gradients | Creative work |
| **ayu-mirage** | Warm desert tones | Extended coding sessions |
| **catppuccin** | Soothing pastel (mocha) | Low-light environments |
| **catppuccin-latte** | Light mode elegance | Bright workspaces |
| **matte-black** | Pure minimalism | Distraction-free focus |
| **nord** | Arctic cool tones | Scandinavian aesthetic |
| **osaka-jade** | Vibrant teal/green | Energizing workflow |
| **ristretto** | Rich espresso browns | Coffee-fueled coding |
| **rose-pine** | Soft rose/pine palette | Gentle on the eyes |
| **rose-pine-dark** | Deep rose/pine | Dark mode variant |
| **tokyo-night** | Deep blues with neon | Cyberpunk vibes |
| **torrentz-hydra** | Bold high contrast | Maximum readability |

#### Theme Previews

**Ayu Mirage** - Warm desert tones for extended coding
![Ayu Mirage Theme](themes/ayu-mirage/theme.png)

**Tokyo Night** - Deep blues with neon accents
![Tokyo Night Theme](themes/tokyo-night/preview.png)

**Torrentz Hydra** - Bold high-contrast scheme
![Torrentz Hydra Theme](themes/torrentz-hydra/preview.png)

#### What Each Theme Includes
- Hyprland colors (borders, gaps, shadows)
- Kitty terminal colors (live reload via SIGUSR1)
- Rofi styling (launcher appearance)
- Btop theme (system monitor colors)
- Mako notifications (live reload via SIGUSR2)
- Neovim colorscheme (live reload via RPC)
- Waybar CSS (status bar theme)
- Custom wallpapers (per-theme backgrounds)

### Theme Management

```bash
# List all themes
hyprpunk-theme-list

# Switch theme
hyprpunk-theme-set catppuccin

# Next/previous theme
hyprpunk-theme-next
hyprpunk-theme-prev

# Cycle wallpapers
hyprpunk-wallpaper-next
```

**Keyboard shortcuts:**
- `Super+T` - Theme selector menu
- `Super+Shift+T` - Next theme
- `Super+Shift+Y` - Previous theme
- `Super+Shift+W` - Next wallpaper

---

## Modes

### Desktop Mode
Full desktop environment with all features:
- Complete Hyprland setup
- All GUI applications
- NVIDIA support (optional)
- Audio and multimedia
- Bluetooth support
- WiFi management

**Modules:** 23 total

### Laptop Mode
Optimized for laptops:
- Same as desktop
- Excludes NVIDIA drivers
- Includes Vertex AI plugin
- Battery optimized

**Modules:** 21 total

### Container Mode
Minimal development environment:
- No GUI components
- Terminal tools only
- Neovim with full LSP
- Development utilities
- Claude Code integration

**Modules:** 9 total

---

## Custom Plugins

Hyprpunk includes several custom plugins:

### theme-manager
Theme switching and wallpaper management
- Live reload across all applications
- Rofi theme selector
- Per-theme wallpaper collections

### neovim-custom
Advanced Neovim configuration
- 40+ plugins
- Full LSP support
- Theme integration
- Custom keybindings

### vertex-ai
Google Vertex AI authentication for Claude Code
- Seamless Claude integration
- Secure credential management

### dev-extras
Additional development tools
- Spotify, Discord, Slack (Flatpak)
- Devcontainer CLI

### fancontrol
Aquacomputer Octo fan control
- Hardware-specific plugin
- Automated fan curves

### lvm-expand
LVM partition expansion utility
- One-time setup script
- Root partition expansion

---

## Architecture

Hyprpunk is built on Fedpunk's modular architecture:

```
hyprpunk/
├── modes/              # Desktop, laptop, container configurations
├── themes/             # 12 complete themes with wallpapers
├── modules/            # 27 desktop-focused modules
└── plugins/            # 6 custom plugins for enhanced functionality
```

**How it works:**
1. Fedpunk core engine handles deployment
2. Hyprpunk provides modules, themes, and plugins
3. Mode selection determines which modules to deploy
4. GNU Stow creates symlinks for instant configuration
5. Lifecycle hooks handle post-installation setup

---

## System Requirements

- **OS:** Fedora Linux 40+
- **Arch:** x86_64
- **RAM:** 8GB minimum, 16GB recommended
- **Storage:** ~2GB for desktop mode, ~500MB for container
- **GPU:** Any (NVIDIA support available)
- **Display:** Wayland-capable for desktop/laptop modes

---

## Customization

### Override Hyprland Configuration

Create custom Hyprland configs in `~/.config/fedpunk/hyprpunk/`:

```bash
mkdir -p ~/.config/fedpunk/hyprpunk/hyprland
vim ~/.config/fedpunk/hyprpunk/hyprland/custom.conf
```

### Create Custom Themes

Copy and modify existing themes:

```bash
# Themes are in the hyprpunk repository after deployment
cd ~/.fedpunk/cache/external/github.com/hinriksnaer/hyprpunk/themes
cp -r nord my-custom-theme
vim my-custom-theme/kitty.conf
hyprpunk-theme-set my-custom-theme
```

### Add Extra Modules

Edit your fedpunk.yaml to add more modules:

```yaml
modules:
  enabled:
    - module: git@github.com:hinriksnaer/hyprpunk.git
      mode: desktop
    - module: https://github.com/user/custom-module.git
```

---

## Keyboard Shortcuts

### Window Management
- `Super+Return` - Terminal
- `Super+Q` - Close window
- `Super+H/J/K/L` - Focus windows (vim-style)
- `Super+Shift+H/L` - Cycle workspaces
- `Super+1-9` - Switch workspace
- `Super+Shift+1-9` - Move window to workspace
- `Super+V` - Toggle floating
- `Super+F` - Toggle fullscreen

### Applications
- `Super+Space` - Application launcher (Rofi)
- `Super+B` - Browser
- `Super+E` - File manager

### Themes
- `Super+T` - Theme selector
- `Super+Shift+T` - Next theme
- `Super+Shift+Y` - Previous theme
- `Super+W` - Wallpaper selector
- `Super+Shift+W` - Next wallpaper

### Screenshots
- `Print` - Selection screenshot
- `Super+Print` - Full screen screenshot

---

## Troubleshooting

### Hyprland Won't Start

```bash
# Check logs
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -1)/hyprland.log

# Verify deployment
fedpunk module list

# Re-deploy
fedpunk profile deploy git@github.com:hinriksnaer/hyprpunk.git --mode desktop
```

### Theme Switching Not Working

```bash
# Verify theme-manager is deployed
fedpunk module info theme-manager

# List available themes
hyprpunk-theme-list

# Check theme symlinks
ls -la ~/.config/hypr/themes/
```

### NVIDIA Issues

```bash
# Check NVIDIA module status
lsmod | grep nvidia

# Re-deploy NVIDIA module
fedpunk module deploy nvidia
```

---

## Contributing

Contributions welcome! Areas for contribution:
- New themes
- Module improvements
- Bug fixes
- Documentation

See [Fedpunk contributing guide](https://github.com/hinriksnaer/Fedpunk/blob/main/CONTRIBUTING.md)

---

## License

MIT License - See [LICENSE](LICENSE) file for details

---

## Acknowledgments

- Built on [Fedpunk](https://github.com/hinriksnaer/Fedpunk)
- Powered by [Hyprland](https://hyprland.org)
- Themes inspired by [Omarchy](https://github.com/edunfelt/omarchy)

---

**Hyprpunk** - *A complete Hyprland desktop for Fedpunk*

**Star this repo** if you find it useful!
