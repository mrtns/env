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
brew bundle --file="$MACOS_DIR/Brewfile"

# Shell

step "oh-my-zsh"
if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Languages

step "nvm, node"
if [ ! -d ~/.nvm ]; then
  PROFILE=~/.zshrc bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh)"
fi
export NVM_DIR="$HOME/.nvm"
set +u; . "$NVM_DIR/nvm.sh"; set -u
nvm install node

step "pyenv, python $PYTHON_VERSION"
append_once 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zshrc
append_once '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.zshrc
append_once 'eval "$(pyenv init - zsh)"' ~/.zshrc
append_once 'eval "$(pyenv virtualenv-init -)"' ~/.zshrc
pyenv install --skip-existing "$PYTHON_VERSION"
pyenv global "$(pyenv latest "$PYTHON_VERSION")"

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

# Window management

step "yabai, skhd services"
yabai --start-service || yabai --restart-service
if ! ls ~/Library/LaunchAgents/*skhd*.plist >/dev/null 2>&1; then
  skhd --install-service
fi
skhd --start-service || skhd --restart-service
# brew services start borders

# Hostname

step "Hostname: $HOSTNAME_NEW"
if [ "$(scutil --get HostName 2>/dev/null || true)" != "$HOSTNAME_NEW" ]; then
  sudo scutil --set HostName "$HOSTNAME_NEW"
  sudo scutil --set LocalHostName "$HOSTNAME_NEW"
  sudo scutil --set ComputerName "$HOSTNAME_NEW"
  dscacheutil -flushcache
fi

# Defaults

step "defaults"
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
killall Dock

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

step "Done. See macos/README.md for manual steps (yabai scripting addition)."
