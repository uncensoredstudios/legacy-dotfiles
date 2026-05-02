#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║          LEGACY DOTFILES — Installer                         ║
# ║          Arch / EndeavourOS · Hyprland · Gruvbox             ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────
YEL='\033[38;2;215;153;33m'; ORG='\033[38;2;254;128;25m'
GRN='\033[38;2;184;187;38m'; RED='\033[38;2;251;73;52m'
GRY='\033[38;2;146;131;116m'; FG='\033[38;2;235;219;178m'
BOLD='\033[1m'; RST='\033[0m'

info()    { echo -e "${YEL}  ${FG}$*${RST}"; }
success() { echo -e "${GRN}  ✓ ${FG}$*${RST}"; }
warn()    { echo -e "${ORG}  ⚠ $*${RST}"; }
error()   { echo -e "${RED}  ✗ $*${RST}"; }
section() { echo -e "\n${YEL}${BOLD}━━━  $*  ━━━${RST}"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Banner ───────────────────────────────────────────────────────
clear
echo -e "${YEL}${BOLD}"
cat << 'EOF'
  ██╗     ███████╗ ██████╗  █████╗  ██████╗██╗   ██╗
  ██║     ██╔════╝██╔════╝ ██╔══██╗██╔════╝╚██╗ ██╔╝
  ██║     █████╗  ██║  ███╗███████║██║      ╚████╔╝ 
  ██║     ██╔══╝  ██║   ██║██╔══██║██║       ╚██╔╝  
  ███████╗███████╗╚██████╔╝██║  ██║╚██████╗   ██║   
  ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝   ╚═╝  
EOF
echo -e "${GRY}                        made in Legacy${RST}"
echo -e "${GRY}  Arch/EndeavourOS · Hyprland · Gruvbox Dark${RST}\n"

# ── Check prerequisites ──────────────────────────────────────────
section "System Check"

if ! command -v pacman &>/dev/null; then
    error "Requires Arch-based system (pacman not found)"
    exit 1
fi
success "Arch Linux detected"

if [[ "$EUID" -eq 0 ]]; then
    error "Don't run as root. The script will sudo when needed."
    exit 1
fi
success "Running as user: $USER"

# ── AUR helper ───────────────────────────────────────────────────
section "AUR Helper"

if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    info "Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-install
    cd /tmp/yay-install && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    success "yay installed"
else
    success "AUR helper found"
fi

AUR="yay"
command -v paru &>/dev/null && AUR="paru"

# ── Packages ─────────────────────────────────────────────────────
section "Installing Packages"

OFFICIAL_PKGS=(
    # Wayland / Hyprland
    hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
    hypridle hyprlock wayland-utils wlroots
    # Waybar
    waybar
    # Notifications
    dunst libnotify
    # Terminal
    kitty
    # Fonts
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    # Shell
    zsh starship zsh-autosuggestions zsh-syntax-highlighting
    # Media
    pipewire pipewire-pulse wireplumber playerctl pavucontrol
    # Screenshot / wallpaper
    grim slurp swww
    # Clipboard
    wl-clipboard cliphist
    # Files
    thunar
    # Apps
    rofi-wayland
    # Network
    networkmanager nm-connection-editor network-manager-applet
    # System
    btop fastfetch brightnessctl
    # Gaming
    gamemode mangohud lib32-mangohud
    # Themes
    papirus-icon-theme xcursor-bibata
    # Misc
    polkit-kde-agent xdotool jq
    # Audio effects / sounds
    libcanberra
)

AUR_PKGS=(
    # Rofi Wayland fork (lbonn)
    # (now in official repos as rofi-wayland)
    # Gruvbox GTK theme
    gruvbox-dark-gtk
    # Hyprshot
    hyprshot
    # Timeshift for snapshots
    timeshift
    # XDG settings
    xsettingsd
)

info "Installing official packages..."
sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}" 2>&1 | tail -5

info "Installing AUR packages..."
$AUR -S --needed --noconfirm "${AUR_PKGS[@]}" 2>&1 | tail -5

success "All packages installed"

# ── Backup existing configs ──────────────────────────────────────
section "Backing Up Existing Configs"

BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

for dir in hypr waybar rofi kitty dunst hyprlock MangoHud; do
    if [[ -d "$HOME/.config/$dir" ]]; then
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/" 2>/dev/null || true
        info "Backed up: ~/.config/$dir → $BACKUP_DIR/$dir"
    fi
done
success "Backup done → $BACKUP_DIR"

# ── Install dotfiles ─────────────────────────────────────────────
section "Deploying Dotfiles"

install_config() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    cp -rf "$src" "$dst"
    success "Installed: $dst"
}

# Hyprland
mkdir -p "$HOME/.config/hypr/scripts"
install_config "$DOTFILES_DIR/hyprland/hyprland.conf"  "$HOME/.config/hypr/hyprland.conf"
install_config "$DOTFILES_DIR/hyprland/hypridle.conf"  "$HOME/.config/hypr/hypridle.conf"

# Scripts
for script in "$DOTFILES_DIR/scripts/"*.sh; do
    install_config "$script" "$HOME/.config/hypr/scripts/$(basename "$script")"
    chmod +x "$HOME/.config/hypr/scripts/$(basename "$script")"
done

# Waybar
mkdir -p "$HOME/.config/waybar/scripts"
install_config "$DOTFILES_DIR/waybar/config.jsonc"  "$HOME/.config/waybar/config.jsonc"
install_config "$DOTFILES_DIR/waybar/style.css"     "$HOME/.config/waybar/style.css"
install_config "$DOTFILES_DIR/waybar/gruvbox.css"   "$HOME/.config/waybar/gruvbox.css"
for script in "$DOTFILES_DIR/waybar/scripts/"*.sh; do
    install_config "$script" "$HOME/.config/waybar/scripts/$(basename "$script")"
    chmod +x "$HOME/.config/waybar/scripts/$(basename "$script")"
done

# Kitty
mkdir -p "$HOME/.config/kitty"
install_config "$DOTFILES_DIR/kitty/kitty.conf"       "$HOME/.config/kitty/kitty.conf"
install_config "$DOTFILES_DIR/kitty/startup.session"  "$HOME/.config/kitty/startup.session"
install_config "$DOTFILES_DIR/kitty/welcome.sh"       "$HOME/.config/kitty/welcome.sh"
chmod +x "$HOME/.config/kitty/welcome.sh"

# Dunst
mkdir -p "$HOME/.config/dunst"
install_config "$DOTFILES_DIR/dunst/dunstrc"  "$HOME/.config/dunst/dunstrc"

# Hyprlock
mkdir -p "$HOME/.config/hypr"
install_config "$DOTFILES_DIR/hyprlock/hyprlock.conf"  "$HOME/.config/hypr/hyprlock.conf"

# Rofi
mkdir -p "$HOME/.config/rofi"
install_config "$DOTFILES_DIR/rofi/config.rasi"   "$HOME/.config/rofi/config.rasi"
install_config "$DOTFILES_DIR/rofi/gruvbox.rasi"  "$HOME/.config/rofi/gruvbox.rasi"

# MangoHud
mkdir -p "$HOME/.config/MangoHud"
install_config "$DOTFILES_DIR/config/MangoHud/MangoHud.conf"  "$HOME/.config/MangoHud/MangoHud.conf"

# GTK theme
mkdir -p "$HOME/.config/gtk-3.0"
install_config "$DOTFILES_DIR/config/gtk-3.0/settings.ini"  "$HOME/.config/gtk-3.0/settings.ini"

# ── Shell: Zsh + Starship ────────────────────────────────────────
section "Shell Setup"

# Set zsh as default
if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" "$USER"
    success "zsh set as default shell"
fi

# Starship Gruvbox config
mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" << 'STARSHIP'
format = """
[╭─](bold #d79921)\
$os\
$username\
$directory\
$git_branch\
$git_status\
$python\
$nodejs\
$rust\
$cmd_duration\
$line_break\
[╰─](bold #d79921)$character"""

[os]
disabled = false
style = "bold #d79921"

[username]
show_always = true
style_user  = "bold #fabd2f"
style_root  = "bold #fb4934"
format      = "[$user]($style)[@](bold #928374)"

[directory]
style            = "bold #83a598"
format           = "[$path]($style)[$read_only]($read_only_style) "
truncation_length = 4
truncate_to_repo  = true

[git_branch]
style  = "bold #b8bb26"
symbol = " "

[git_status]
style  = "bold #fb4934"

[character]
success_symbol = "[❯](bold #d79921)"
error_symbol   = "[❯](bold #fb4934)"

[cmd_duration]
format = "[ $duration]($style) "
style  = "#928374"
min_time = 500
STARSHIP

# .zshrc
cat > "$HOME/.zshrc" << 'ZSHRC'
# ─── Legacy Dotfiles — ZSH Config ─────────────────────

# Starship prompt
eval "$(starship init zsh)"

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -la'
alias grep='grep --color=auto'
alias cat='bat --color=always --style=plain'
alias top='btop'
alias fetch='fastfetch'
alias update='sudo pacman -Syu && yay -Syu'
alias hyprconf='$EDITOR ~/.config/hypr/hyprland.conf'
alias waybconf='$EDITOR ~/.config/waybar/config.jsonc'
alias dots='cd ~/.dotfiles'
alias snap='~/.config/hypr/scripts/system-snapshot.sh'

# Environment
export EDITOR=nvim
export BROWSER=firefox
export TERMINAL=kitty
export MANGOHUD=1  # auto FPS overlay for games

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Wayland / Qt
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1
ZSHRC

success "ZSH + Starship configured"

# ── Services ─────────────────────────────────────────────────────
section "Enabling Services"

systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
sudo systemctl enable --now NetworkManager 2>/dev/null || true
success "Services enabled"

# ── Wallpaper placeholder ────────────────────────────────────────
section "Wallpaper"

if [[ ! -f "$HOME/.config/hypr/wallpaper.jpg" ]]; then
    # Create a warm Gruvbox gradient wallpaper with imagemagick if available
    if command -v magick &>/dev/null || command -v convert &>/dev/null; then
        CMD=$(command -v magick 2>/dev/null || command -v convert)
        "$CMD" -size 1920x1080 gradient:"#1d2021-#282828" \
            -fill "#d79921" -draw "roundrectangle 880,520 1040,560 8,8" \
            "$HOME/.config/hypr/wallpaper.jpg" 2>/dev/null || true
        success "Default wallpaper created"
    else
        warn "Place your wallpaper at ~/.config/hypr/wallpaper.jpg"
    fi
fi

# ── Done ─────────────────────────────────────────────────────────
section "Installation Complete"

echo -e "${GRN}${BOLD}"
echo "  ✓ All dotfiles installed successfully!"
echo ""
echo -e "${FG}  Hyprland config: ${YEL}~/.config/hypr/hyprland.conf"
echo -e "${FG}  Waybar config:   ${YEL}~/.config/waybar/"
echo -e "${FG}  Kitty config:    ${YEL}~/.config/kitty/"
echo -e "${FG}  Backup:          ${YEL}$BACKUP_DIR"
echo ""
echo -e "${ORG}  → Log out and select Hyprland in your display manager"
echo -e "  → Or run: ${BOLD}Hyprland${RST}${ORG} from a TTY"
echo ""
echo -e "${GRY}                    made in Legacy${RST}"
echo ""
