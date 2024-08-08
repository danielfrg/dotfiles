# Init
typeset -a precmd_functions
autoload -U colors && colors

# Variables
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}git%{$reset_color%}:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_BRANCH=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]?%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[cyan]%}%{+%G%}"

ZSH_THEME_VIRTUALENV_PREFIX="%{$fg[green]%}  "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"

# Test variables
# USER=asdf
# SSH_CLIENT=1

# This is the basic prompt that is always printed
# It will be enclosed to make it newline
_USER_PROMPT=$(if [[ $USER != "danielfrg" && $USER != "danrodriguez" ]]; then echo ' as %{$fg[magenta]%}%n%{$reset_color%} '; else echo ""; fi)
_HOST_PROMPT=$(if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then echo ' 🌐 %{$fg[red]%}%m%{$reset_color%}'; else echo ""; fi)
_BASE_PROMPT="%{$fg[blue]%}%~%{$reset_color%}% "$_USER_PROMPT$_HOST_PROMPT

_ZSH_ASYNC_PROMPT=0
_ZSH_ASYNC_PROMPT_FN="/tmp/.zsh_tmp_prompt_$$"

function async_prompt() {
  # Run the git var update here instead of in the parent
  precmd_update_git_vars

  echo -n $'\n'$_BASE_PROMPT$' '$(git_super_status)$(virtualenv_prompt_info) > $_ZSH_ASYNC_PROMPT_FN
  if [[ x$_zsh_async_prompt_rv != x0 ]]; then
    echo -n " exited %{$fg[red]%}$_zsh_async_prompt_rv%{$reset_color%}" >> $_ZSH_ASYNC_PROMPT_FN
  fi
  echo -n $'\n❯ ' >> $_ZSH_ASYNC_PROMPT_FN

  # signal parent
  kill -s USR1 $$
}

# --------------
# Internal stuff

# This is the base prompt that is rendered sync. It should be
# fast to render as a result.  The extra whitespace before the
# newine is necessary to avoid some rendering bugs.
PROMPT=$'\n'$_BASE_PROMPT$'\n❯ '
RPROMPT='%*'

# Remove the default git var update from chpwd and precmd to speed
# up the shell prompt.  We will do the precmd_update_git_vars in
# async_prompt() instead
chpwd_functions=("${(@)chpwd_functions:#chpwd_update_git_vars}")
precmd_functions=("${(@)precmd_functions:#precmd_update_git_vars}")

function virtualenv_prompt_info() {
  [[ -n ${VIRTUAL_ENV} ]] || return
  local NAME="${VIRTUAL_ENV:t}"
  if [[ $NAME == "venv" || $NAME == "env" || $NAME == ".venv" ]]; then
    local BASE="${VIRTUAL_ENV:h}"
    NAME="${BASE:t}"
  fi
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${NAME}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

function _zsh_prompt_precmd() {
  _zsh_async_prompt_rv=$?

  # If we still have a prompt async process we kill it to make sure
  # we do not backlog with useless prompt things.  This also makes
  # sure that we do not have prompts interleave in the tempfile.
  if [[ "${_ZSH_ASYNC_PROMPT}" != 0 ]]; then
    kill -s HUP $_ZSH_ASYNC_PROMPT >/dev/null 2>&1 || :
  fi

  # start background computation
  async_prompt &!
  _ZSH_ASYNC_PROMPT=$!
}

# This is the trap for the signal that updates our prompt and
# redraws it.  We intentionally do not delete the tempfile here
# so that we can reuse the last prompt for successive commands
function _zsh_prompt_trapusr1() {
  PROMPT="$(cat $_ZSH_ASYNC_PROMPT_FN)"
  _ZSH_ASYNC_PROMPT=0
  zle && zle reset-prompt
}

# Make sure we clean up our tempfile on exit
function _zsh_prompt_zshexit() {
  /bin/rm -f $_ZSH_ASYNC_PROMPT_FN
}

# Hook our precmd and zshexit functions and USR1 trap
precmd_functions+=(_zsh_prompt_precmd)
zshexit_functions+=(_zsh_prompt_zshexit)
trap '_zsh_prompt_trapusr1' USR1

# Transient prompt
zle-line-init() {
    emulate -L zsh

    [[ $CONTEXT == start ]] || return 0

    while true; do
        zle .recursive-edit
        local -i ret=$?
        [[ $ret == 0 && $KEYS == $'\4' ]] || break
        [[ -o ignore_eof ]] || exit 0
    done

    local saved_prompt=$PROMPT
    local saved_rprompt=$RPROMPT
    # PROMPT='%(?:%{$fg[green]%}❯ :%{$fg_bold[red]%}❯ ) %{$reset_color%}'
    PROMPT='❯ %{$reset_color%}'
    RPROMPT=''
    zle .reset-prompt
    PROMPT=$saved_prompt
    RPROMPT=$saved_rprompt

    if ((ret)); then
        zle .send-break
    else
        zle .accept-line
    fi
    return ret
}

zle -N zle-line-init
