#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$( ( echo ~/.dotfiles; find ~/code ~/code/danielfrg ~/code/inmatura ~/code/nvidia -mindepth 1 -maxdepth 1 -type d ) | fzf )
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

# Check if Zellij is running
if ! zellij list-sessions &>/dev/null; then
    # Zellij is not running, start a new session
    zellij --session $selected_name --default-cwd $selected
else
    # Zellij is running, check if the session exists
    existing_session=$(zellij list-sessions | grep "^$selected_name")

    if [[ -z $existing_session ]]; then
        # Session doesn't exist, create a new one
        zellij --session $selected_name --default-cwd $selected
    else
        # Session exists, attach to it
        zellij attach $selected_name
    fi
fi
