export PROFILING_MODE=${PROFILING_MODE:-0}

# SSH forwards Ghostty's TERM value, but older remote hosts often do not have
# its terminfo entry. Fall back before plugins or tools try to use the terminal.
if [[ ${TERM:-} == xterm-ghostty ]] && \
   { (( ! $+commands[infocmp] )) || ! command infocmp "$TERM" >/dev/null 2>&1; }; then
    export TERM=xterm-256color
fi

if (( PROFILING_MODE )); then
    zmodload zsh/zprof
fi

# -----------------------------------------------
# Plugin bootstrap and completion

source "$HOME/.zsh/plugins.zsh"

# Keep completion search paths identical in login shells and tmux's
# non-login shells. OrbStack otherwise adds its completions only via .zprofile,
# causing both shell modes to continuously invalidate the same compdump.
typeset -gU fpath FPATH
if [[ -d "$HOME/.orbstack/shell/completions/zsh" ]]; then
    fpath+=("$HOME/.orbstack/shell/completions/zsh")
fi

ZSH_COMPLETIONS_PATH="$ZSH_PLUGINS_DIR/zsh-completions"
if [[ -d "$ZSH_COMPLETIONS_PATH/src" ]]; then
    fpath=("$ZSH_COMPLETIONS_PATH/src" $fpath)
fi

# System and Homebrew Zsh 5.9 have different built-in fpath values, so they
# must not share a completion dump merely because their version matches.
case "${ZSH_ARGZERO:A}" in
    /opt/homebrew/*|/usr/local/Cellar/*|*/.linuxbrew/*|*/linuxbrew/*)
        _zsh_compdump_flavor=homebrew
        ;;
    *)
        _zsh_compdump_flavor=system
        ;;
esac

if [[ ! -d "$ZSH_COMPLETION_CACHE_DIR" ]]; then
    command mkdir -p "$ZSH_COMPLETION_CACHE_DIR"
fi
ZSH_COMPDUMP="$ZSH_COMPLETION_CACHE_DIR/zcompdump-${ZSH_VERSION}-${_zsh_compdump_flavor}"
unset _zsh_compdump_flavor

# A missing cache receives the full validation/build. Existing caches use the
# fast path and are explicitly invalidated after plugin updates.
autoload -Uz compinit
if [[ -s "$ZSH_COMPDUMP" ]]; then
    compinit -C -i -d "$ZSH_COMPDUMP"
else
    compinit -i -d "$ZSH_COMPDUMP"
fi

refresh-zsh-completions() {
    clear_zsh_completion_cache
    print 'Completion caches cleared. Start a new Zsh to rebuild them.'
}

_source_zsh_plugin() {
    local name=$1 file=$2
    if [[ -f $file ]]; then
        source "$file"
    else
        print -u2 "Warning: $name is not installed. Run 'install_zsh_plugins'."
    fi
}

# fzf-tab must load after compinit.
_source_zsh_plugin 'fzf-tab' "$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.zsh"
_source_zsh_plugin 'zsh-autosuggestions' "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
_source_zsh_plugin 'zsh-history-substring-search' "$ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"

# -----------------------------------------------
# Main configuration

source "$HOME/.zsh/config.zsh"
source "$HOME/.zsh/prompt.zsh"

# Machine-specific settings and secrets. This intentionally loads after all
# tracked configuration so local values can override defaults.
if [[ -f "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
fi

# Keep syntax highlighting last so it can wrap every ZLE widget defined above.
_source_zsh_plugin 'zsh-syntax-highlighting' "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unfunction _source_zsh_plugin

if (( PROFILING_MODE )); then
    zprof
fi
