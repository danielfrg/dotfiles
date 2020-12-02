SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

PWD := $(shell pwd)


.PHONY: help
help:  ## Show this help menu
	@grep -E '^[0-9a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'


# ------------------------------------------------------------------------------


homebrew:  ## Install homebrew
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew:  ##
	brew bundle


ohmyzsh: ## Download and install oh my zsh
	bash -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";


up:  ## Download and install up
	@curl -L https://github.com/akavel/up/releases/download/v0.3/up-darwin -o /usr/local/bin/up
	@chmod +x /usr/local/bin/up


fonts:  ##
	./install-fonts.sh

# ------------------------------------------------------------------------------


link: zsh git tmux sshrc vscode python jupyter r rstudio vim  gpg ## Create symlinks to the all the stuff


zsh:  ##
	ln -sf $(CURDIR)/.zshrc ~/.zshrc
	ln -sf $(CURDIR)/.p10k.zsh ~/.p10k.zsh


git:  ##
	ln -sf $(CURDIR)/.gitconfig ~/.gitconfig; \
	ln -sf $(CURDIR)/.gitignore_global ~/.gitignore_global


tmux:  ##
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm ; \
	ln -sf $(CURDIR)/.tmux.conf ~/.tmux.conf


# sshrc:  ##
# 	ln -sf $(CURDIR)/.sshrc ~/.sshrc; \
# 	ln -sf $(CURDIR)/.sshrc.d ~/.sshrc.d


vscode:  ##
	ln -sf $(CURDIR)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json ; \
	ln -sf $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json ; \
	rm -rf ~/Library/Application\ Support/Code/User/snippets && ln -sf $(CURDIR)/vscode/snippets/ ~/Library/Application\ Support/Code/User


vscode-ext:  ##
	bash $(CURDIR)/vscode/extensions.sh


python:  ##
	mkdir -p ~/.config/pip
	ln -sf $(CURDIR)/.config/pip/pip.conf ~/.config/pip/pip.conf ; \
	ln -sf $(CURDIR)/.pypirc ~/.pypirc ; \
	ln -sf $(CURDIR)/.pylintrc ~/.pylintrc ; \
	ln -sf $(CURDIR)/.condarc ~/.condarc ; \
	mkdir -p ~/Library/Application\ Support/pypoetry/ ; \
	ln -sf $(CURDIR)/poetry/config.toml ~/Library/Application\ Support/pypoetry/config.toml


jupyter:
	@mkdir -p ~/.jupyter/
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py && \
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.json ~/.jupyter/jupyter_notebook_config.json


r:  ##
	ln -sF $(CURDIR)/.Rprofile ~/.Rprofile


rstudio:  ##
	@mkdir -p ~/.R
	ln -sf $(CURDIR)/rstudio ~/.R/rstudio


vim:  ##
	mkdir -p ~/.config/nvim
	ln -sf $(CURDIR)/.config/init.vim ~/.config/nvim/init.vim ; \
	ln -sF $(CURDIR)/.vim ~/.vim ; \
	ln -sf $(CURDIR)/.vimrc ~/.vimrc ; \
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


gpg:  ##
	@gpg --list-keys
	@ln -sf $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf
	@ln -sf $(CURDIR)/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	@echo "Manually run 'gpg --import <file>' for the public and private keys"
