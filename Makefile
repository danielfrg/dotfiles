xcode:  ## Install xcode
	xcode-select --install
.PHONY:xcode

install: homebrew ohmyzsh


.PHONY: homebrew
homebrew:  ## Install homebrew
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


.PHONY: brew
brew:  ##
	brew bundle

.PHONY: ohmyzsh
ohmyzsh: ## Download and install oh my zsh
	bash -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";


.PHONY: up
up:  ## Download and install up
	@curl -L https://github.com/akavel/up/releases/download/v0.3/up-darwin -o /usr/local/bin/up
	@chmod +x /usr/local/bin/up


.PHONY: conda
conda:  ##
	@curl -L -o ~/Anaconda3-2019.07-MacOSX-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2019.07-MacOSX-x86_64.sh
	bash ~/Anaconda*.sh -b -p ~/conda


link: fonts zsh git tmux sshrc vscode python jupyter rstudio vim  ## Create symlinks to the all the stuff


.PHONY: fonts
fonts:  ##
	bash install-fonts.sh


.PHONY: zsh
zsh:  ##
	ln -sf $(CURDIR)/.zshrc ~/.zshrc

.PHONY: git
git:  ##
	ln -sf $(CURDIR)/.gitconfig ~/.gitconfig; \
	ln -sf $(CURDIR)/.gitignore_global ~/.gitignore_global


.PHONY: tmux
tmux:  ##
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm ; \
	ln -sf $(CURDIR)/.tmux.conf ~/.tmux.conf


.PHONY: sshrc
sshrc:  ##
	ln -sf $(CURDIR)/.sshrc ~/.sshrc; \
	ln -sf $(CURDIR)/.sshrc.d ~/.sshrc.d


.PHONY: vscode
vscode:  ##
	ln -sf $(CURDIR)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json ; \
	ln -sf $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json ; \
	rm -rf ~/Library/Application\ Support/Code/User/snippets && ln -sf $(CURDIR)/vscode/snippets/ ~/Library/Application\ Support/Code/User


.PHONY: vscode-ext
vscode-ext:  ##
	bash $(CURDIR)/vscode/extensions.sh


.PHONY: python
python:  ##
	mkdir -p ~/.config/pip
	ln -sf $(CURDIR)/.config/pip/pip.conf ~/.config/pip/pip.conf ; \
	ln -sf $(CURDIR)/.pypirc ~/.pypirc ; \
	ln -sf $(CURDIR)/.pylintrc ~/.pylintrc ; \
	ln -sf $(CURDIR)/.condarc ~/.condarc ; \
	mkdir -p ~/Library/Application\ Support/pypoetry/ ; \
	ln -sf $(CURDIR)/poetry/config.toml ~/Library/Application\ Support/pypoetry/config.toml


.PHONY: jupyter
jupyter:
	@mkdir -p ~/.jupyter/
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py && \
	ln -sf $(CURDIR)/.jupyter/jupyter_notebook_config.json ~/.jupyter/jupyter_notebook_config.json


.PHONY: r
r:  ##
	ln -sF $(CURDIR)/.Rprofile ~/.Rprofile


.PHONY: rstudio
rstudio:  ##
	@mkdir -p ~/.R
	ln -sf $(CURDIR)/rstudio ~/.R/rstudio


.PHONY: vi
vim:  ##
	mkdir -p ~/.config/nvim
	ln -sf $(CURDIR)/.config/init.vim ~/.config/nvim/init.vim ; \
	ln -sF $(CURDIR)/.vim ~/.vim ; \
	ln -sf $(CURDIR)/.vimrc ~/.vimrc ; \
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


.PHONY: gpg
gpg:  ##
	@gpg --list-keys
	@ln -sf $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf
	@ln -sf $(CURDIR)/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	@echo "Manually run 'gpg --import <file>' for the public and private keys"


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'
