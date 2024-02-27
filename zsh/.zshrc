# Install/init znap
ZNAP_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/znap/znap.zsh"
[[ -r $ZNAP_HOME ]] ||
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git $ZNAP_HOME
source $ZNAP_HOME/znap.zsh

znap source olivierverdier/zsh-git-prompt

# Source files
for file in "${HOME}/.zsh/base.zsh" \
            "${HOME}/.zsh/prompt.zsh" \
            "${HOME}/.local/bin/imagecat.zsh" \
            "${HOME}/.zsh/languages.zsh" \
            "${HOME}/.zsh/ssh.zsh" \
            "$HOME/code/dotfiles/personal/entrypoint.sh"
do
    [ -s "${file}" ] && source "${file}"
done

znap prompt

znap source zsh-users/zsh-completions
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source ajeetdsouza/zoxide
znap source Aloxaf/fzf-tab

if ! type atuin > /dev/null; then
    znap source joshskidmore/zsh-fzf-history-search
fi

# ---------------------------------
# Stuff that is not to be committed

touch ~/.zshrc.local
source ~/.zshrc.local
