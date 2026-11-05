#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    if [[ -d ~/code ]]; then
        base_dirs+=(~/code)
    fi

    if [[ -d ~/code/danielfrg ]]; then
        base_dirs+=(~/code/danielfrg)
    fi

    if [[ -d ~/code/inmatura ]]; then
        base_dirs+=(~/code/inmatura)
    fi

    if [[ -d ~/code/nvidia ]]; then
        base_dirs+=(~/code/nvidia)
    fi

    selected=$(
        {
            echo ~/.dotfiles
            find "${base_dirs[@]}" -mindepth 1 -maxdepth 1 -type d
        } | grep -v '^$' | fzf
    )
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
if tmux has-session -t "=$selected_name" 2>/dev/null; then
    session_exists=1
else
    session_exists=0
fi

if [[ -z $TMUX ]]; then
    # not in tmux session
    if (( session_exists == 0 )); then
        # session does not exist
        tmux new-session -s "$selected_name" -c "$selected"
    else
        # session exists... attach to it
        tmux attach -t "=$selected_name"
    fi
else
    # inside tmux session
    if (( session_exists == 0 )); then
        # session does not exist... create it
        tmux new-session -d -s "$selected_name" -c "$selected" || exit
    fi

    # switch to the session
    tmux switch-client -t "=$selected_name"
fi
