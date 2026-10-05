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
just stow

# or

stow -t $HOME home
```

## Global agent instructions

Shared instructions live in `~/.agents/AGENTS.md`. Stow links that file to each agent's supported global instructions path:

| Agent | Global instructions path |
| --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` |
| Codex | `~/.codex/AGENTS.md` |
| Pi | `~/.pi/agent/AGENTS.md` |
| OpenCode | `~/.config/opencode/AGENTS.md` |

Edit only `home/.agents/AGENTS.md`, then restart the agent (or reload its context, when supported). Pi intentionally uses `AGENTS.md`; its `SYSTEM.md` would replace Pi's built-in system prompt rather than augment it.

Fonts:

```terminal
just fonts
```
