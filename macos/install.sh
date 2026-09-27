#!/usr/bin/env bash
# Initialize a fresh macOS install. Safe to re-run: each step skips what's already done.
#
# Usage: macos/install.sh <hostname>

set -euo pipefail

HOSTNAME_NEW="${1:?usage: $0 <hostname>}"
MACOS_DIR="$(cd "$(dirname "$0")" && pwd)"
NVM_VERSION="v0.40.8"
PYTHON_VERSION="3.12"

step() { printf '\n==> %s\n' "$*"; }

append_once() {
  grep -qxF "$1" "$2" 2>/dev/null || echo "$1" >> "$2"
}

# Rosetta

step "Rosetta"
if ! /usr/bin/pgrep -q oahd; then
  softwareupdate --install-rosetta --agree-to-license
fi

# Homebrew

step "Homebrew"
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
append_once 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile

step "Brewfile"
# Homebrew refuses to load formulae from third-party taps until they're trusted.
for t in $(sed -n 's/^tap "\(.*\)".*/\1/p' "$MACOS_DIR/Brewfile"); do
  brew tap "$t"
  brew trust "$t"
done
if ! brew bundle --file="$MACOS_DIR/Brewfile"; then
  echo "WARNING: some Brewfile entries failed to install (see above); continuing."
fi

# Fonts

step "Fonts"
for f in "$MACOS_DIR"/../fonts/*.ttf; do
  [ -e ~/Library/Fonts/"$(basename "$f")" ] || cp "$f" ~/Library/Fonts/
done

# Shell

step "oh-my-zsh"
if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="dpoggi"/' ~/.zshrc
append_once 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc

# Languages

step "nvm, node"
if [ ! -d ~/.nvm ]; then
  PROFILE=~/.zshrc bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh)"
fi
export NVM_DIR="$HOME/.nvm"
set +u; . "$NVM_DIR/nvm.sh"; set -u
nvm install node

step "npm global packages"
npm install -g difit

step "pyenv, python $PYTHON_VERSION"
append_once 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zshrc
append_once '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.zshrc
append_once 'eval "$(pyenv init - zsh)"' ~/.zshrc
append_once 'eval "$(pyenv virtualenv-init -)"' ~/.zshrc
if pyenv install --skip-existing "$PYTHON_VERSION"; then
  pyenv global "$(pyenv latest "$PYTHON_VERSION")"
else
  echo "WARNING: Python $PYTHON_VERSION failed to build (see above); continuing. Re-run once fixed."
fi

# Dotfiles

step "Dotfiles"
for f in .common_profile .skhdrc .yabairc; do
  if [ -f ~/"$f" ] && ! cmp -s "$MACOS_DIR/dotfiles/$f" ~/"$f"; then
    cp ~/"$f" ~/"$f.bak"
    echo "Backed up existing ~/$f to ~/$f.bak"
  fi
  cp "$MACOS_DIR/dotfiles/$f" ~/"$f"
done
append_once '[ -f ~/.common_profile ] && . ~/.common_profile' ~/.zshrc

step "iTerm2 profile"
ITERM_PROFILES=~/Library/Application\ Support/iTerm2/DynamicProfiles
mkdir -p "$ITERM_PROFILES"
cp "$MACOS_DIR/iterm2/Martin.json" "$ITERM_PROFILES/"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "8E3B6C2A-5D41-4F7E-9A0B-3C6D2E1F4A57"

# Window management

step "yabai, skhd services"
yabai --start-service || yabai --restart-service
skhd --install-service
skhd --start-service || skhd --restart-service

# Hostname

step "Hostname: $HOSTNAME_NEW"
for name in HostName LocalHostName ComputerName; do
  if [ "$(scutil --get "$name" 2>/dev/null || true)" != "$HOSTNAME_NEW" ]; then
    sudo scutil --set "$name" "$HOSTNAME_NEW"
    HOSTNAME_CHANGED=1
  fi
done
if [ -n "${HOSTNAME_CHANGED:-}" ]; then
  dscacheutil -flushcache
fi

# Defaults

step "defaults"
# Appearance, scrolling, keyboard
defaults write -g AppleInterfaceStyle -string Dark
defaults write -g com.apple.swipescrolldirection -bool false
defaults write -g com.apple.keyboard.fnState -bool true
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# Trackpad (built-in and Bluetooth): fast tracking, tap to click, three-finger
# drag, light click, four-finger swipe between spaces
defaults write -g com.apple.trackpad.scaling -float 2.5
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
for d in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  defaults write "$d" Clicking -bool true
  defaults write "$d" TrackpadThreeFingerDrag -bool true
  defaults write "$d" TrackpadThreeFingerHorizSwipeGesture -int 0
  defaults write "$d" TrackpadFourFingerHorizSwipeGesture -int 2
done
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

# Dock, spaces
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -float 16
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-animation-duration -float 0

# Finder, desktop
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager HideDesktop -bool true

killall Dock
killall Finder

# GitHub

step "GitHub CLI"
if ! gh auth status >/dev/null 2>&1; then
  read -rp "Copy a GitHub personal access token to the clipboard, then press Enter. "
  pbpaste | gh auth login --with-token
  pbcopy < /dev/null
fi
gh auth setup-git

# Claude Code

step "Claude Code"
if ! command -v claude >/dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

step "Done. See macos/README.md for manual steps (apps, yabai scripting addition, SpaceId)."
