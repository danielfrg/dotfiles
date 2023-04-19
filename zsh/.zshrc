# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Source files
for file in "${HOME}/.zsh/base.zsh" \
            "${HOME}/.local/bin/imagecat.zsh" \
            "${HOME}/.zsh/languages.zsh" \
            "$HOME/code/dotfiles/personal/entrypoint.sh"
do
    [ -s "${file}" ] && source "${file}"
done

# Base plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# z - autojump
zinit light agkozak/zsh-z

# Tab complete
zinit light Aloxaf/fzf-tab

zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions

# ---------------------------------
# Stuff that is not to be committed
touch ~/.zshrc.local
source ~/.zshrc.local
