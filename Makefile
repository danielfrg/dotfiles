install: homebrew ohmyzsh powerline up

xcode: ## Install xcode
	xcode-select --install
.PHONY:xcode

homebrew:  ## Install homebrew
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
.PHONY: homebrew

ohmyzsh: ## Download and install oh my zsh
	bash -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \

powerline:  ## Download and install powerline
	@curl -L https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-darwin-amd64 -o /usr/local/bin/powerline-go
	@chmod +x /usr/local/bin/powerline-go

up:  ## Download and install up
	@curl -L https://github.com/akavel/up/releases/download/v0.3/up-darwin -o /usr/local/bin/up
	@chmod +x /usr/local/bin/up

brew:  ##
	brew bundle
.PHONY: brew

link: zsh git tmux sshrc vscode python jupyter rstudio gpg ## Create symlinks to the all the stuff

zsh:  ##
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
	bash vscode/extensions.sh; \
	ln -sf $(CURDIR)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json ; \
	ln -sf $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json ; \
	ln -sf $(CURDIR)/vscode/snippets/ ~/Library/Application\ Support/Code/User
.PHONY: vscode

python:  ##
	mkdir -p ~/Library/Application\ Support/pypoetry/ ; \
	ln -sF $(CURDIR)/.pylintrc ~/.pylintrc ; \
	ln -sF $(CURDIR)/.condarc ~/.condarc ; \
	ln -sF $(CURDIR)/poetry/auth.toml ~/Library/Application\ Support/pypoetry/auth.toml ; \
	ln -sF $(CURDIR)/poetry/config.toml ~/Library/Application\ Support/pypoetry/config.toml
.PHONY: python

jupyter:
	@mkdir -p ~/.jupyter/
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py && \
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.json ~/.jupyter/jupyter_notebook_config.json
.PHONY: jupyter

rstudio:  ##
	@mkdir -p ~/.R
	ln -sf $(CURDIR)/rstudio ~/.R/rstudio
.PHONY: rstudio

gpg:  ##
	@gpg --list-keys
	@ln -sf $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf
	@ln -sf $(CURDIR)/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	@echo "Manually run 'gpg --import' for the public and private keys"

vi:  ##
	ln -sF $(CURDIR)/.vim ~/.vim; \
	ln -sf $(CURDIR)/.vimrc ~/.vimrc; \
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	vim +PluginInstall +qall
.PHONY: vi

help:
	@grep -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'
