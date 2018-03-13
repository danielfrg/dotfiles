install: xcode homebrew

xcode:
	xcode-select --install
.PHONY:xcode

homebrew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
.PHONY: homebrew

link: brew python zsh git tmux sshrc vscode

brew:  ## brew
	brew bundle
.PHONY: brew

python:  ## python
	ln -sF $(CURDIR)/.pylintrc ~/.pylintrc; \
	ln -sF $(CURDIR)/.condarc ~/.condarc
.PHONY: python

zsh:  ## zsh
	bash -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
	ln -sf $(CURDIR)/.zshrc ~/.zshrc
.PHONY: zsh

git:  ## git
	ln -sf $(CURDIR)/.gitconfig ~/.gitconfig; \
	ln -sf $(CURDIR)/.gitignore_global ~/.gitignore_global
.PHONY: zsh

tmux:  ## tmux
	ln -sf $(CURDIR)/.tmux.conf ~/.tmux.conf
.PHONY: tmux

sshrc:  ## sshrc
	ln -sf $(CURDIR)/.sshrc ~/.sshrc \
	ln -sf $(CURDIR)/.sshrc.d ~/.sshrc.d
.PHONY: sshrc

vscode:  ## vscode
	bash vscode/extensions.sh
	ln -sf $(CURDIR)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -sf $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -sf $(CURDIR)/vscode/snippets/ ~/Library/Application\ Support/Code/User/snippets
.PHONY: vscode


vi:  ## vi
	ln -sF $(CURDIR)/.vim ~/.vim; \
	ln -sf $(CURDIR)/.vimrc ~/.vimrc; \
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	vim +PluginInstall +qall
.PHONY: vi

gpg:  # gpg
	ln -sF ~/Google Drive/apps/gnupg ~/.gnupg

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
