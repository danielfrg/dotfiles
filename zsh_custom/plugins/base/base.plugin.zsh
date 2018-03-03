# Color scheme
BASE16_SHELL="$HOME/workspace/dotfiles/iterm2/base16-tomorrow.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export PATH=/usr/local/sbin:$PATH
# export PATH=$(brew --prefix coreutils)/libexec/bin:$PATH    # Slow
export PATH=/usr/local/opt/coreutils/libexec/bin:$PATH        # Fast
# export PATH=$(brew --prefix moreutils)/libexec/bin:$PATH    # Slow
export PATH=/usr/local/opt/moreutils/libexec/bin:$PATH        # Fast

bindkey '[C' forward-word
bindkey '[D' backward-word
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '\e\e[C' forward-word
bindkey '\e\e[D' backward-word
