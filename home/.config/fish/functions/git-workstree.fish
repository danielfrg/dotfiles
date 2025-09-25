# ------------------------------------------------------------------------------
# Fish functions for managing git worktrees with a .bare repository structure.
# ------------------------------------------------------------------------------

# Function to find the project root by searching upwards for a .bare directory
# Outputs the path to the project root directory if found, and returns 0.
# Outputs an error message   to stderr and returns 1 if not found or invalid.
function git_find_project_root
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


# Clone a repository as a worktree structure
# Usage: git-wt-clone <repository-url> [directory]
function git-wt-clone
    if not set -q argv[1]
        echo "Usage: git-wt-clone <repository-url> [directory]"
        return 1
    end

    set repo_url $argv[1]

    # Fish doesn't have Bash's ${2:-default} syntax, so we use an if/else block.
    set dir_name
    if set -q argv[2]
        set dir_name $argv[2]
    else
        set dir_name (basename "$repo_url" .git)
    end
    set target_dir "./$dir_name"

    # Check if target directory already exists
    if test -e "$target_dir"
        echo "Error: Target directory '$target_dir' already exists." >&2
        return 1
    end

    # Create directory and navigate into it
    mkdir -p "$target_dir"; or begin
        echo "Error: Failed to create directory '$target_dir'." >&2
        return 1
    end
    cd "$target_dir"; or return 1

    echo "Cloning repository as bare into '$PWD/.bare'..."
    # Clone directly into .bare subdirectory
    git clone --bare "$repo_url" .bare; or begin
        echo "Error: Failed to clone repository." >&2
        cd ..
        rm -rf "$dir_name"
        return 1
    end

    # Set up worktree structure
    echo "Setting up worktree structure..."

    # Determine the default branch from the bare repository
    set default_branch (git --git-dir=.bare symbolic-ref --short HEAD)

    # Create main worktree from the default branch
    git --git-dir=.bare worktree add "$default_branch"; or begin
        echo "Error: Failed to create main worktree." >&2
        cd ..
        rm -rf "$dir_name"
        return 1
    end

    # Navigate into the main worktree to set the upstream branch
    cd "$default_branch"; or begin
        echo "Error: Could not enter the main worktree directory." >&2
        cd ../..
        rm -rf "$dir_name"
        return 1
    end

    echo "Configuring the main branch to track origin..."
    # Set the upstream for the main branch
    git branch --set-upstream-to="origin/$default_branch" "$default_branch"; or begin
        echo "Warning: Failed to set the upstream branch for the main worktree." >&2
        # Not a fatal error, so we continue
    end

    # Go back to the project root
    cd ..

    echo "Repository cloned with worktree structure in '$PWD'"
    echo "Project structure created:"
    echo "├── .bare/          # Bare repository"
    echo "└── $default_branch/           # Main branch worktree"

    cd ../$dir_name/$default_branch
end


# Create a new worktree in an existing worktree project
# Usage: git-wt-new <feature-name> [base-branch]
function git-wt-new
    # Save original directory to return to in case of errors
    set original_pwd (pwd)

    # Check if feature name is provided
    if not set -q argv[1]
        echo "Usage: git-wt-new <feature-name> [base-branch]" >&2
        return 1
    end

    # Find the project root
    set project_root (git_find_project_root); or return 1

    set git_dir "$project_root/.bare"

    # This will also be the directory name for the worktree
    set branch_name $argv[1]

    # Set default for base_branch
    set base_branch "main"
    if set -q argv[2]
        set base_branch $argv[2]
    end

    set worktree_path "$project_root/$branch_name"

    # Ensure base branch exists in the bare repo (note the `not` keyword)
    if not git --git-dir="$git_dir" rev-parse --verify "$base_branch" >/dev/null 2>&1
        echo "Error: Base branch '$base_branch' does not exist in repository at '$git_dir'" >&2
        return 1
    end

    # Check if worktree directory already exists (relative to project root)
    if test -d "$worktree_path"
        echo "Error: Directory '$worktree_path' already exists." >&2
        return 1
    end

    # Change to project root to ensure git worktree paths are relative to it
    cd "$project_root"; or return 1

    # Variables for worktree creation
    set dir_name "$branch_name"
    set git_branch "$branch_name"
    set base_ref "$base_branch"
    set create_branch true

    # Check if branch already exists in the bare repo
    if git --git-dir="$git_dir" show-ref --verify --quiet "refs/heads/$branch_name"
        # Branch exists, ask user what to do
        echo "Branch '$branch_name' already exists."
        echo "Options:"
        echo "  c: Create worktree from existing branch"
        echo "  n: Create new branch with different name"
        echo "  q: Quit"

        # Use `read` with a prompt
        read -P "What would you like to do? [c/n/q] " REPLY
        echo

        # Use Fish's `switch` statement instead of `case`
        switch $REPLY
            case C c
                # Use existing branch, don't create a new one
                set dir_name "$branch_name"
                set git_branch "$branch_name"
                set base_ref "$branch_name" # Base is the existing branch
                set create_branch false

            case N n
                # Ask for new directory name
                read -P "Enter new directory name for worktree: " new_dir_name

                # Validate directory name
                if test -z "$new_dir_name"
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: New name cannot be empty." >&2
                    return 1
                end

                if test -d "$new_dir_name"
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: Directory '$new_dir_name' already exists." >&2
                    return 1
                end

                # Ask for new branch name
                read -P "Enter new branch name (will be created from '$base_branch'): " new_branch_name

                # Validate branch name
                if test -z "$new_branch_name"
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: New branch name cannot be empty." >&2
                    return 1
                end

                if git --git-dir="$git_dir" show-ref --verify --quiet "refs/heads/$new_branch_name"
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: Branch '$new_branch_name' already exists." >&2
                    return 1
                end

                # Update branch and worktree paths
                set dir_name "$new_dir_name"
                set git_branch "$new_branch_name"
                set base_ref "$base_branch"
                set create_branch true

                # Update these for the final cd command
                set branch_name "$new_dir_name"
                set worktree_path "$project_root/$branch_name"

            case '*' # Default case
                echo "Operation cancelled"
                cd "$original_pwd" 2>/dev/null
                return 1
        end
    end

    # Execute the worktree creation
    if test "$create_branch" = "true"
        git --git-dir="$git_dir" worktree add -b "$git_branch" "$dir_name" "$base_ref"; or begin
            cd "$original_pwd" 2>/dev/null
            echo "Error: Failed to create worktree for branch '$git_branch'." >&2
            return 1
        end
    else
        git --git-dir="$git_dir" worktree add "$dir_name" "$base_ref"; or begin
            cd "$original_pwd" 2>/dev/null
            echo "Error: Failed to create worktree for branch '$git_branch'." >&2
            return 1
        end
    end

    echo "Created new worktree for branch '$git_branch' in $worktree_path"

    # This cd command will change the directory of the interactive shell
    # because the function is being sourced.
    cd $worktree_path
end
