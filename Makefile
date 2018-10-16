install: xcode homebrew powerline

xcode: ## Install xcode
	xcode-select --install
.PHONY:xcode

homebrew:  ## Install homebrew
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
.PHONY: homebrew

powerline:  ##
	@curl https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-darwin-amd64 -o /usr/local/bin/powerline-go -L
	@chmod +x /usr/local/bin/powerline-go

brew:  ##
	brew bundle
.PHONY: brew

link: python zsh git tmux sshrc vscode jupyter  ## Create symlinks to the all the stuff

python:  ##
	ln -sF $(CURDIR)/.pylintrc ~/.pylintrc; \
	ln -sF $(CURDIR)/.condarc ~/.condarc
.PHONY: python

jupyter:
	@mkdir -p ~/.jupyter/
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py
.PHONY: jupyter


zsh:  ##
	bash -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
	ln -sf $(CURDIR)/.zshrc ~/.zshrc
.PHONY: zsh

git:  ##
	ln -sf $(CURDIR)/.gitconfig ~/.gitconfig; \
	ln -sf $(CURDIR)/.gitignore_global ~/.gitignore_global
.PHONY: zsh

tmux:  ##
	ln -sf $(CURDIR)/.tmux.conf ~/.tmux.conf
.PHONY: tmux

sshrc:  ##
	ln -sf $(CURDIR)/.sshrc ~/.sshrc; \
	ln -sf $(CURDIR)/.sshrc.d ~/.sshrc.d
.PHONY: sshrc

vscode:  ##
	bash vscode/extensions.sh
	ln -sf $(CURDIR)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -sf $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	ln -sf $(CURDIR)/vscode/snippets/ ~/Library/Application\ Support/Code/User/snippets
.PHONY: vscode

vi:  ##
	ln -sF $(CURDIR)/.vim ~/.vim; \
	ln -sf $(CURDIR)/.vimrc ~/.vimrc; \
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	vim +PluginInstall +qall
.PHONY: vi

gpg:  ##
	ln -sF ~/Google\ Drive/apps/.gnupg/ ~/.gnupg

help:
	@grep -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'
