# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/danrodriguez/.zsh/completions:"* ]]; then export FPATH="/Users/danrodriguez/.zsh/completions:$FPATH"; fi
# Download zinit, if it's not there yet
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Start zinit
source "${ZINIT_HOME}/zinit.zsh"

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Completion
autoload -Uz compinit
compinit

zinit ice wait lucid
zinit load Aloxaf/fzf-tab

zinit ice wait lucid
zinit load zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit load zsh-users/zsh-completions

zinit ice wait lucid
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit load zsh-users/zsh-history-substring-search

# zinit wait lucid for OMZL::git.zsh
# zinit snippet OMZP::git-prompt

# Don't ice this one so we can use zsh-async on prompt.zsh
zinit load mafredri/zsh-async

# Don't ice this one so we can remove the hooks on prompt.zsh
zinit load olivierverdier/zsh-git-prompt

export ZSH_CUSTOM="${HOME}/.zsh"
source "$ZSH_CUSTOM/prompt/prompt.plugin.zsh"
zinit load "$ZSH_CUSTOM/base"

# zinit ice wait lucid
# zinit load "$ZSH_CUSTOM/dev"
source "$ZSH_CUSTOM/dev/dev.plugin.zsh"

# Personal settings
source "${HOME}/.dotfiles/personal/entrypoint.sh"

# -------------------------------------
# For stuff that is not to be committed

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
