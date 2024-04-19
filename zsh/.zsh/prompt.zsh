# Start precmd functions
typeset -a precmd_functions
autoload -U colors && colors

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

# This is the basic prompt that is always printed.  It will be
# enclosed to make it newline.
# USER=asdf
# SSH_CLIENT=1
_USER_PROMPT=$(if [[ $USER != "danielfrg" && $USER != "danrodriguez" ]]; then echo ' as %{$fg[magenta]%}%n%{$reset_color%} '; else echo ""; fi)
_HOST_PROMPT=$(if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then echo ' 🌐 %{$fg[red]%}%m%{$reset_color%}'; else echo ""; fi)
_BASE_PROMPT='%{$fg[blue]%}%~%{$reset_color%}% '$_USER_PROMPT$_HOST_PROMPT

# This is the base prompt that is rendered sync.  It should be
# fast to render as a result.  The extra whitespace before the
# newline is necessary to avoid some rendering bugs.
PROMPT=$'\n'$_BASE_PROMPT$'\n$ '
RPROMPT='%*'

_ZSH_ASYNC_PROMPT=0
_ZSH_ASYNC_PROMPT_FN="/tmp/.zsh_tmp_prompt_$$"

# Remove the default git var update from chpwd and precmd to speed
# up the shell prompt.  We will do the precmd_update_git_vars in
# the async prompt instead
chpwd_functions=("${(@)chpwd_functions:#chpwd_update_git_vars}")
precmd_functions=("${(@)precmd_functions:#precmd_update_git_vars}")

function _zsh_prompt_precmd() {
  _zsh_async_prompt_rv=$?

  function async_prompt() {
    # Run the git var update here instead of in the parent
    precmd_update_git_vars

    echo -n $'\n'$_BASE_PROMPT$' '$(git_super_status)$(virtualenv_prompt_info) > $_ZSH_ASYNC_PROMPT_FN
    if [[ x$_zsh_async_prompt_rv != x0 ]]; then
      echo -n " exited %{$fg[red]%}$_zsh_async_prompt_rv%{$reset_color%}" >> $_ZSH_ASYNC_PROMPT_FN
    fi
    echo -n $'\n$ ' >> $_ZSH_ASYNC_PROMPT_FN

    # signal parent
    kill -s USR1 $$
  }

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
# -----------------
