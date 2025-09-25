# Function to find the project root by searching upwards for a .bare directory
# Outputs the path to the project root directory if found, and returns 0.
# Outputs an error message   to stderr and returns 1 if not found or invalid.
function git-find-project-root
    # In Fish, variables declared in a function are local by default.
    # Get physical current path to avoid symlink issues
    set current_dir (pwd -P)
    set root_found ""

    while test "$current_dir" != "/"
        if test -d "$current_dir/.bare"
            # Found a .bare directory, now validate it
            set is_bare (git --git-dir="$current_dir/.bare" config --bool core.bare 2>/dev/null)
            set git_config_exit_code $status

            if test $git_config_exit_code -ne 0; or test "$is_bare" != "true"
                echo "Error: Found .bare in '$current_dir', but it's not configured as a bare repository." >&2
                return 1
            end

            set root_found "$current_dir"
            break
        end
        # Go up one level
        set current_dir (dirname "$current_dir")
    end

    if test -z "$root_found"
        echo "Error: Could not find project root (.bare directory) in the current directory or any parent directory." >&2
        return 1
    end

    # Output the found root path
    echo "$root_found"
    return 0
end