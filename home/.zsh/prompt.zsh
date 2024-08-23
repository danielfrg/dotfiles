typeset -a precmd_functions
autoload -U colors && colors

# Test variables
# USER=asdf
# SSH_CLIENT=1

PROMPT_BASE="%{$fg[blue]%}%~%{$reset_color%}% "$PROMPT_USER$PROMPT_HOST

PROMPT_VIRTUALENV_PREFIX="%{$fg[green]%}  "
PROMPT_CONDA_PREFIX="%{$fg[green]%}  "
PROMPT_VIRTUALENV_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}git%{$reset_color%}:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_BRANCH=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]?%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[cyan]%}%{+%G%}"

# This is the basic prompt that is always printed
# It will be enclosed to make it newline
PROMPT_USER=$(if [[ $USER != "danielfrg" && $USER != "danrodriguez" ]]; then echo ' as %{$fg[magenta]%}%n%{$reset_color%} '; else echo ""; fi)
PROMPT_HOST=$(if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then echo '@%{$fg[red]%}%m%{$reset_color%}'; else echo ""; fi)

PROMPT=$'\n'$PROMPT_BASE$'\n❯ '
RPROMPT=''

COMPLETED=0  # This is a test variable

# Compute new values for the prompt
update_prompt() {
    precmd_update_git_vars

    local -A info
	info[pwd]=$PWD
	info[git]=$(git_super_status)

	[[ -n ${VIRTUAL_ENV} ]] || info[venv]=""
    local NAME="${VIRTUAL_ENV:t}"
    if [[ $NAME == "venv" || $NAME == "env" || $NAME == ".venv" ]]; then
        local BASE="${VIRTUAL_ENV:h}"
        NAME="${BASE:t}"
        info[venv]=$NAME
    fi

    if [[ -n ${CONDA_DEFAULT_ENV} ]]; then
        info[conda]=$CONDA_DEFAULT_ENV
    else
        info[conda]=""
    fi

	print -r - ${(@kvq)info}
}


# This updates the PROMPT based on the output of the async job
function callback() {
    local job=$1 code=$2 output=$3 exec_time=$4 next_pending=$6
    # echo "Callback: $job $output"

    case $job in
		update_prompt)
		    local -A info
           	typeset -gA prompt_pure_vcs_info

           	# Parse output (z) and unquote as array (Q@).
           	info=("${(Q@)${(z)output}}")

           	git_info=$info[git]

           	if [[ -n ${info[conda]} ]]; then
                    conda_info="${PROMPT_CONDA_PREFIX:=[}${info[conda]}${PROMPT_VIRTUALENV_SUFFIX:=]}"
                else
                    conda_info=""
                fi
           	conda_info="${PROMPT_CONDA_PREFIX:=[}${info[conda]}${PROMPT_VIRTUALENV_SUFFIX:=]}"

           	PROMPT=$'\n'$PROMPT_BASE' '$git_info$conda_info$'\n❯ '

            # COMPLETED=$(( COMPLETED + 1 ))
            # RPROMPT=${COMPLETED}
            # RPROMPT=${info}

            zle && zle reset-prompt
			;;
	esac
}

# --------------------------------------------------
# INTERNAL

# Initialize a new worker (with notify option)
async_start_worker prompt_worker -u -n
async_register_callback prompt_worker callback

function prompt_precmd() {
    async_worker_eval prompt_worker builtin cd -q $PWD
    async_job prompt_worker update_prompt
}

# Remove git functions from chpwd_functions and precmd_functions
# We run this on our precmd function
chpwd_functions=("${(@)chpwd_functions:#chpwd_update_git_vars}")
precmd_functions=("${(@)precmd_functions:#precmd_update_git_vars}")

# Add our function to precmd_functions
precmd_functions+=(prompt_precmd)

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
