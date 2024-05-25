# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

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
# "${HOME}/.zsh/prompt.zsh" \
for file in "${HOME}/.zsh/base.zsh" \
            "${HOME}/.zsh/languages.zsh" \
            "${HOME}/.zsh/ssh.zsh" \
            "${HOME}/code/dotfiles/personal/entrypoint.sh"
do
    [ -s "${file}" ] && source "${file}"
done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------------------------
# Stuff that is not to be committed

touch ~/.zshrc.local
source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/code/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/code/dotfiles/zsh/.p10k.zsh ]] || source ~/code/dotfiles/zsh/.p10k.zsh
