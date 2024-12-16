#!/usr/bin/env bash

# Function to check if a string starts with "tmuxifier:"
is_tmuxifier_session() {
    [[ $1 == tmuxifier:* ]]
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Get tmuxifier sessions if available
    if command -v tmuxifier &> /dev/null; then
        tmuxifier_sessions=$(tmuxifier list-sessions 2>/dev/null | sed 's/^/tmuxifier:/')
    else
        tmuxifier_sessions=""
    fi

    # Combine directories and tmuxifier sessions
    if [[ -d ~/code ]]; then
        selected=$( ( echo ~/.dotfiles;
                     find ~/code ~/code/danielfrg ~/code/inmatura ~/code/nvidia -mindepth 1 -maxdepth 1 -type d;
                     echo "$tmuxifier_sessions" ) | grep -v '^$' | fzf )
    else
        selected=$( ( echo ~/.dotfiles;
                     find ~ ! -name ".*" -mindepth 1 -maxdepth 1 -type d;
                     echo "$tmuxifier_sessions" ) | grep -v '^$' | fzf )
    fi
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Handle tmuxifier session
if is_tmuxifier_session "$selected"; then
    session_name=${selected#tmuxifier:}

    if [[ -z $TMUX ]]; then
        # Not in tmux session
        tmuxifier load-session "$session_name"
    else
        # Inside tmux session
        # Create new window and run tmuxifier in it
        tmux new-window "tmuxifier load-session $session_name"
    fi
    exit 0
fi

# Handle directory-based session (original functionality)
selected_name=$(basename "$selected" | tr . _)
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
