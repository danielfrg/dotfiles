if [[ ${TERM:-} == xterm-ghostty ]] && ! infocmp "$TERM" >/dev/null 2>&1; then
    export TERM=xterm-256color
fi
export EDITOR=nvim
export KUBECONFIG="$HOME/.kube/homelab"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
setopt interactive_comments autocd hist_ignore_dups hist_ignore_space
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
autoload -Uz compinit
compinit -d "$HOME/.cache/zcompdump"
alias ..='cd ..'
alias ls=eza
alias ll='eza -la'
alias g=git
alias k=kubectl
alias vim=nvim
alias cdc='cd "$HOME/code"'
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
