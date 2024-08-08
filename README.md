# dotfiles

> nvim, tmux, macOS defaults and brew bundle, etc.

New MacOS setup

```
# install Xcode Command Line Tools
xcode-select --install

# copy SSH key into ~/.ssh, then:
chmod 0600 ~/.ssh/id_rsa

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# clone the dotfiles repo
mkdir -p ~/code
git clone https://github.com/danielfrg/dotfiles.git ~/code/dotfiles

# install Brewfile
cd ~/code/dotfiles/macos
brew bundle

# default macos settings
cd ~/code/dotfiles/macos
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
