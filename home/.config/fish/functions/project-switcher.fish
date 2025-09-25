# This function finds a project directory or tmuxifier session and switches to it.
# It can be called directly or with a keybinding.

function project-switcher
    # We can define a helper function right inside. It will only be visible here.
    function is_tmuxifier_session
        string match -q "tmuxifier:*" -- "$argv[1]"
    end

    set -l selected
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set -l tmuxifier_sessions ""
        if command -q tmuxifier
            set tmuxifier_sessions (tmuxifier list-sessions 2>/dev/null | sed 's/^/tmuxifier:/')
        end

        set -l base_dirs
        if test -d ~/Documents;                  set -a base_dirs ~/Documents; end
        if test -d ~/Documents/danielfrg;         set -a base_dirs ~/Documents/danielfrg; end
        if test -d ~/Documents/inmatura;          set -a base_dirs ~/Documents/inmatura; end
        if test -d ~/Documents/nvidia;            set -a base_dirs ~/Documents/nvidia; end

        set selected (begin
            echo ~/.dotfiles
            if test (count $base_dirs) -gt 0
              find $base_dirs -mindepth 1 -maxdepth 1 -type d
            end
            echo $tmuxifier_sessions
        end | grep -v '^$' | fzf)
    end

    # Exit if fzf was cancelled (selected is empty)
    if test -z "$selected"
        # Using `return` is more appropriate than `exit` inside a function
        return 0
    end

    if is_tmuxifier_session "$selected"
        set session_name (string replace "tmuxifier:" "" -- "$selected")
        if not set -q TMUX
            tmuxifier load-session "$session_name"
        else
            tmux new-window "tmuxifier load-session $session_name"
        end
        return 0
    end

    set selected_name (basename "$selected" | tr . _)
    set existingSession (tmux list-sessions -F '#S' | grep "^$selected_name\$")

    if not set -q TMUX
        if test -z "$existingSession"
            tmux new-session -s $selected_name -c $selected
        else
            tmux attach -t $selected_name
        end
    else
        if test -z "$existingSession"
            tmux new-session -d -s $selected_name -c $selected
        end
        tmux switch-client -t $selected_name
    end
end
