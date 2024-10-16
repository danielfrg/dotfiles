#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    if [ -d "~/code" ]; then
        selected=$( ( echo ~/.dotfiles; find ~/code ~/code/danielfrg ~/code/inmatura ~/code/nvidia -mindepth 1 -maxdepth 1 -type d ) | fzf )
    else
        selected=$( ( echo ~/.dotfiles; find ~/ ! -name ".*" -mindepth 1 -maxdepth 1 -type d ) | fzf )
    fi
fi


if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

# check if a session with the same name already exists
existingSession=$(tmux list-sessions -F '#S' | grep "^$selected_name$")

if [[ -z $TMUX ]]; then
    # not in tmux session
    if [[ -z $existingSession ]]; then
        # session does not exist
        tmux new-session -s $selected_name -c $selected
    else
        # session exists... attach to it
        tmux attach -t $selected_name
    fi
else
    # inside tmux session
    if [[ -z $existingSession ]]; then
        # session does not exist... create it
        tmux new-session -d -s $selected_name -c $selected
    fi
        # switch to the session
        tmux switch-client -t $selected_name
fi
