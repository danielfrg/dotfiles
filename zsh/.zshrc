# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light olivierverdier/zsh-git-prompt

# Load completions
autoload -Uz compinit && compinit

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# Source my config
for file in "${HOME}/.zsh/base.zsh" \
            "${HOME}/.zsh/languages.zsh" \
            "${HOME}/.zsh/ssh.zsh" \
            "${HOME}/code/dotfiles/personal/entrypoint.sh" \
            "${HOME}/.zsh/prompt.zsh"
do
    [ -s "${file}" ] && source "${file}"
done

# ---------------------------------
# Stuff that is not to be committed

touch ~/.zshrc.local
source ~/.zshrc.local

