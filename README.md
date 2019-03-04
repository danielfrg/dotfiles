# dotfiles

## Install

Add SSH key to `~/.ssh/id_rsa`

```
# Add ssh key
ssh-add ~/.ssh/id_rsa

# Clone the repo:
mkdir -p ~/workspace
git clone git@github.com:danielfrg/dotfiles.git ~/workspace/dotfiles
```

Docs:
- [Github ssh keys](https://help.github.com/articles/generating-ssh-keys)

### make

```
make xcode
make install
make brew
make link
```

## Manual steps

#### iTerm2

In the iTerm2 preferences point to use a file from `~/workspace/dotfiles/iterm2/preferences`

### VIM

To install using [https://github.com/junegunn/vim-plug](https://github.com/junegunn/vim-plug): Open vim and run `:PlugInstall`.

## Legacy

#### atom

```bash
bash .atom/packages.sh

ln -sf $(pwd)/.atom/projects.cson ~/.atom/projects.cson
ln -sf $(pwd)/.atom/config.cson ~/.atom/config.cson
ln -sf $(pwd)/.atom/init.coffee ~/.atom/init.coffee
ln -sf $(pwd)/.atom/keymap.cson ~/.atom/keymap.cson
ln -sf $(pwd)/.atom/styles.less ~/.atom/styles.less
ln -sf $(pwd)/.atom/snippets.cson ~/.atom/snippets.cson

# My packages:
git clone git@github.com:danielfrg/atom-nbviewer.git ~/workspace/atom-nbviewer
pushd ~/workspace/atom-nbviewer
apm install
popd
ln -sF ~/workspace/atom-nbviewer ~/.atom/packages/nbviewer
```
