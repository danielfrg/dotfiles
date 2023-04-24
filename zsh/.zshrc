# Install Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Source files
for file in "${HOME}/.zsh/base.zsh" \
            "${HOME}/.local/bin/imagecat.zsh" \
            "${HOME}/.zsh/languages.zsh" \
            "${HOME}/.zsh/ssh.zsh" \
            "$HOME/code/dotfiles/personal/entrypoint.sh"
do
    [ -s "${file}" ] && source "${file}"
done

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

if type fzf > /dev/null; then
    zinit ice lucid wait'1'
    zinit light Aloxaf/fzf-tab
fi

zinit ice lucid wait'1'
zinit light joshskidmore/zsh-fzf-history-search

# ---------------------------------
# Stuff that is not to be committed
touch ~/.zshrc.local
source ~/.zshrc.local
