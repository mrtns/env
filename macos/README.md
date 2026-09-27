# macos

Initializing a fresh macOS install on Apple Silicon.

# Install

* Install the Xcode command line tools (for `git`):
  ```bash
  xcode-select --install
  ```

* Clone this repo:
  ```bash
  git clone https://github.com/mrtns/env.git ~/env
  ```

* Run the install script with the machine's hostname:
  ```bash
  ~/env/macos/install.sh <hostname>
  ```

The script is safe to re-run. It installs:

* Rosetta, Homebrew, and everything in [Brewfile](Brewfile)
* oh-my-zsh
* nvm and the latest node
* pyenv and Python 3.12
* yabai and skhd, started as services

It also copies the files in [dotfiles/](dotfiles) to your home folder (backing up any that differ to `.bak`), sets the hostname and Dock and VS Code defaults, and logs in to GitHub with a token from the clipboard.

To apply edits to the dotfiles, re-run the script, or copy them by hand:

```bash
cp ~/env/macos/dotfiles/.skhdrc ~/env/macos/dotfiles/.yabairc ~/env/macos/dotfiles/.common_profile ~/
skhd --restart-service
yabai --restart-service
```

# Packages

Add or remove packages in [Brewfile](Brewfile), then:

```bash
brew bundle --file=~/env/macos/Brewfile
```

To list what's installed but not in the Brewfile:

```bash
brew bundle cleanup --file=~/env/macos/Brewfile
```

# Manual steps

## yabai scripting addition

Needed for yabai features like moving windows between spaces. Requires partially disabling System Integrity Protection, which can't be scripted.

* Check SIP:
  ```bash
  csrutil status
  ```

* Boot into Recovery (hold the power button), open Terminal and run:
  ```bash
  csrutil enable --without fs --without debug --without nvram
  ```

* Reboot, then enable the arm64e ABI and reboot again:
  ```bash
  sudo nvram boot-args=-arm64e_preview_abi
  ```

* Allow loading the scripting addition without a password:
  ```bash
  echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
  ```

* Load it:
  ```bash
  sudo yabai --load-sa
  ```

* References
  * [yabai: Disabling System Integrity Protection](https://github.com/asmvik/yabai/wiki/Disabling-System-Integrity-Protection)
  * [yabai: Configuring the scripting addition](https://github.com/asmvik/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition)

The sudoers entry pins yabai's hash, so re-run that step after upgrading yabai.

## SpaceId

Shows the current space number in the menu bar. Its Homebrew cask was disabled because the app is unsigned and fails Gatekeeper.

* Download and install:
  ```bash
  curl -fsSL -o /tmp/SpaceId.app.zip https://github.com/dshnkao/SpaceId/releases/download/v1.4/SpaceId.app.zip
  unzip -q /tmp/SpaceId.app.zip -d /Applications
  xattr -dr com.apple.quarantine /Applications/SpaceId.app
  ```

* Open it and allow it to start at login.

* References
  * [dshnkao/SpaceId](https://github.com/dshnkao/SpaceId)
