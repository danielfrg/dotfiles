# Use the same tracked Starship prompt in Zsh and Nushell.
if (( $+commands[starship] )); then
    _cache_zsh_init starship-zsh-v1 "${commands[starship]}" init zsh
else
    # Minimal fallback for machines where Starship has not been installed yet.
    autoload -U colors && colors
    setopt prompt_subst

    _prompt_user=''
    _prompt_host=''
    _prompt_ssh=''

    if [[ $USER != danielfrg && $USER != danrodriguez ]]; then
        _prompt_user='%F{red}%n%f@'
    fi
    if [[ -n ${SSH_CLIENT:-} || -n ${SSH_TTY:-} ]]; then
        _prompt_host='%F{red}%m%f'
        _prompt_ssh='%F{yellow}[SSH]%f '
    fi

    PROMPT=$'\n'"${_prompt_ssh}${_prompt_user}${_prompt_host} %F{blue}%~%f% "$'\n❯ '
    RPROMPT=''

    unset _prompt_user _prompt_host _prompt_ssh
fi
