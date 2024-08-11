# dotfiles

> nvim, tmux, macOS defaults and brew bundle, etc.

New MacOS setup

```
# install Xcode Command Line Tools
xcode-select --install

# copy SSH key into ~/.ssh, then:
chmod 0600 ~/.ssh/id_ed25519
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# clone the dotfiles repo
git clone git@github.com:danielfrg/dotfiles.git ~/.dotfiles --recurse-submodules --remote-submodules

# install Brewfile
cd ~/.dotfiles/macos
brew bundle

# default macos settings
cd ~/.dotfiles/macos
./macos-defaults.sh

# reboot
sudo reboot
```

Link/stow files:

```terminal
just link

# or

stow -t $HOME home
```

Fonts:

```terminal
just fonts
```
