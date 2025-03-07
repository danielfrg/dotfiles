typeset -a precmd_functions
autoload -U colors && colors

# Test variables
# USER=asdf
# SSH_CLIENT=1

# This is the basic prompt that is always printed
# It will be enclosed to make it newline

PROMPT_USER=$(if [[ $USER != "danielfrg" && $USER != "danrodriguez" ]]; then echo '%F{red}%n%f@'; else echo ""; fi)
PROMPT_HOST=$(if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then echo '%F{red}%m%f'; else echo ""; fi)

PROMPT_SSH=$(if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then echo "%F{yellow}[SSH]%f "; else echo ""; fi)
PROMPT_OS=$(if [[ "$(uname)" == "Linux" ]]; then echo "🐧 "; else echo ""; fi)

PROMPT_VIRTUALENV_PREFIX="%F{green} "
PROMPT_VIRTUALENV_SUFFIX="%f"

PROMPT_CONDA_PREFIX="%F{green} "
PROMPT_CONDA_SUFFIX="%f"
PROMPT_CONDA=$PROMPT_CONDA_PREFIX'${CONDA_DEFAULT_ENV:+"%F{green}$CONDA_DEFAULT_ENV%f "}'$PROMPT_CONDA_SUFFIX

PROMPT_BASE=$PROMPT_SSH$PROMPT_USER$PROMPT_HOST" %F{blue}%~%f% "

PROMPT=$'\n'$PROMPT_BASE$'\n❯ '
RPROMPT=''

# Debug variable
# COMPLETED=0

# This is still slow for large repos :(
# source "${0:A:h}/git-status.zsh"

# # Compute new values for the prompt
# update_prompt() {
#     precmd_update_git_vars

#     local -A info
# 	info[pwd]=$PWD
# 	info[git]=$(git_super_status)

# 	[[ -n ${VIRTUAL_ENV} ]] || info[venv]=""
#     local NAME="${VIRTUAL_ENV:t}"
#     if [[ $NAME == "venv" || $NAME == "env" || $NAME == ".venv" ]]; then
#         local BASE="${VIRTUAL_ENV:h}"
#         NAME="${BASE:t}"
#         info[venv]=$NAME
#     fi

#     if [[ -n ${CONDA_DEFAULT_ENV} ]]; then
#         info[conda]=$CONDA_DEFAULT_ENV
#     else
#         info[conda]=""
#     fi

# 	print -r - ${(@kvq)info}
# }


# # This updates the PROMPT based on the output of the async job
# function callback() {
#     local job=$1 code=$2 output=$3 exec_time=$4 next_pending=$6
#     # echo "Callback: $job $output"

#     case $job in
# 		update_prompt)
# 		    local -A info
#            	typeset -gA prompt_pure_vcs_info

#            	# Parse output (z) and unquote as array (Q@).
#            	info=("${(Q@)${(z)output}}")

#             local git_info=""
#             local conda_info=""

#             if [[ -n ${info[git]} ]]; then
#                 git_info="${info[git]}"
#             fi

#             # This is not working because I async call happens on another shell
#             # But this is fast since its just reading an env var
#             # if [[ -n ${info[conda]} ]]; then
#             #     conda_info="${PROMPT_CONDA_PREFIX:=[}${info[conda]}${PROMPT_VIRTUALENV_SUFFIX:=]}"
#             # fi
#             if [[ -n ${CONDA_DEFAULT_ENV} ]]; then
#                 conda_info=$PROMPT_CONDA
#             fi

#            	PROMPT=$'\n'$PROMPT_BASE' '${git_info}${conda_info}$'\n❯ '

#             # COMPLETED=$(( COMPLETED + 1 ))
#             # RPROMPT=${COMPLETED}
#             # RPROMPT="a${info[git]}a"

#             zle && zle reset-prompt;
# 	esac
# }

# # --------------------------------------------------
# # INTERNAL

# # Initialize a new worker (with notify option)
# async_start_worker prompt_worker -u -n
# async_register_callback prompt_worker callback

# function prompt_precmd() {
#     async_worker_eval prompt_worker builtin cd -q $PWD
#     async_job prompt_worker update_prompt
# }

# # Remove git functions from chpwd_functions and precmd_functions
# # We run this on our precmd function
# # chpwd_functions=("${(@)chpwd_functions:#chpwd_update_git_vars}")
# # precmd_functions=("${(@)precmd_functions:#precmd_update_git_vars}")

# # Add our function to precmd_functions
# precmd_functions+=(prompt_precmd)

# # Transient prompt

# zle-line-init() {
#     emulate -L zsh

#     [[ $CONTEXT == start ]] || return 0

#     while true; do
#         zle .recursive-edit
#         local -i ret=$?
#         [[ $ret == 0 && $KEYS == $'\4' ]] || break
#         [[ -o ignore_eof ]] || exit 0
#     done

#     local saved_prompt=$PROMPT
#     local saved_rprompt=$RPROMPT
#     # PROMPT='%(?:%{$fg[green]%}❯ :%{$fg_bold[red]%}❯ ) %{$reset_color%}'
#     PROMPT='❯ %{$reset_color%}'
#     RPROMPT=''
#     zle .reset-prompt
#     PROMPT=$saved_prompt
#     RPROMPT=$saved_rprompt

#     if ((ret)); then
#         zle .send-break
#     else
#         zle .accept-line
#     fi
#     return ret
# }

# zle -N zle-line-init
