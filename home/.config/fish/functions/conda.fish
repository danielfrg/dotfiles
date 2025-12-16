# Conda is very slow to load
# So we have this function to not load it on startup
# But it gets loaded when the first conda command is executed

function conda
    # Erase this function so it's not called again in this session
    functions --erase conda

    # Original conda initialization logic
    if test -f ~/conda/bin/conda
        eval ~/conda/bin/conda "shell.fish" "hook" $argv | source
    else
        if test -f "~/conda/etc/fish/conf.d/conda.fish"
            . ~/conda/etc/fish/conf.d/conda.fish
        else
            set -x PATH "~/conda/bin" $PATH
        end
    end

    # Execute the actual conda command with the original arguments
    command conda $argv
end
