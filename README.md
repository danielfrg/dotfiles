# dotfiles

## Install from scratch

```
xcode-select --install
```

Add SSH key to `~/.ssh/id_rsa`

```
# Add ssh key
chmod 600 ~/.ssh/*
ssh-add ~/.ssh/id_rsa

# Clone the repo:
mkdir -p ~/workspace
git clone git@github.com:danielfrg/dotfiles.git ~/workspace/dotfiles --recurse-submodules --remote-submodules
```

## Install config

```
make homebrew
make brew
make ohmyzsh
make up
make fonts
```

```
make link
```

```
make vscode-extensions

## Manual steps

### GPG

Import the gpg keys:

```
gpg --import <file>
```

### iTerm2

In the iTerm2 preferences point to use a file from `~/workspace/dotfiles/iterm2/preferences`
