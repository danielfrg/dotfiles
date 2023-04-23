# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Source files
for file in "${HOME}/.zsh/base.zsh" \
            "${HOME}/.local/bin/imagecat.zsh" \
            "${HOME}/.zsh/languages.zsh" \
            "$HOME/code/dotfiles-personal/entrypoint.sh"
do
    [ -s "${file}" ] && source "${file}"
done

# Init completions first
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zpcompinit

# This include some tab completion so we do it after
if [ -f $HOME/code/dotfiles-personal/entrypoint.sh ]; then
    source $HOME/code/dotfiles-personal/entrypoint.sh
fi

zinit ice silent wait
zinit light zdharma/fast-syntax-highlighting

if type fzf > /dev/null; then
    zinit ice lucid wait
    zinit light Aloxaf/fzf-tab
fi

zinit ice lucid wait:1 atload:_zsh_autosuggest_start
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# zinit ice lucid wait
# zinit light wfxr/forgit
# forgit_diff=gid
# forgit_restore=forgit_restore

# z - autojump
# zinit light agkozak/zsh-z

# ---------------------------------
# Stuff that is not to be committed
touch ~/.zshrc.local
source ~/.zshrc.local
