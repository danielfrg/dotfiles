#!/bin/bash

# Function to find the project root by searching upwards for a .bare directory
# Outputs the path to the project root directory if found, and returns 0.
# Outputs an error message to stderr and returns 1 if not found or invalid.
git_find_project_root() {
    local current_dir
    # Get physical current path to avoid symlink issues
    current_dir=$(pwd -P)
    local root_found=""

    while [ "$current_dir" != "/" ] && [ -n "$current_dir" ]; do
        if [ -d "$current_dir/.bare" ]; then
            # Found a .bare directory, now validate it
            local is_bare
            is_bare=$(git --git-dir="$current_dir/.bare" config --bool core.bare 2>/dev/null)
            local git_config_exit_code=$?

            if [ $git_config_exit_code -ne 0 ] || [ "$is_bare" != "true" ]; then
                echo "Error: Found .bare in '$current_dir', but it's not configured as a bare repository." >&2
                return 1
            fi

            root_found="$current_dir"
            break
        fi
        # Go up one level
        current_dir=$(dirname "$current_dir")
    done

    if [ -z "$root_found" ]; then
        echo "Error: Could not find project root (.bare directory) in the current directory or any parent directory." >&2
        return 1
    fi

    # Output the found root path
    echo "$root_found"
    return 0
}

# Clone a repository as a worktree structure
# Usage: git-wt-clone <repository-url> [directory]
git-wt-clone() {
    if [ -z "$1" ]; then
        echo "Usage: git-wt-clone <repository-url> [directory]"
        return 1
    fi

    local repo_url=$1
    local dir_name=${2:-$(basename "$repo_url" .git)}
    local target_dir="./$dir_name"

    # Check if target directory already exists
    if [ -e "$target_dir" ]; then
        echo "Error: Target directory '$target_dir' already exists."
        return 1
    fi

    # Create directory and navigate into it
    mkdir -p "$target_dir" || {
        echo "Error: Failed to create directory '$target_dir'."
        return 1
    }
    cd "$target_dir" || return 1

    echo "Cloning repository as bare into '$PWD/.bare'..."
    # Clone directly into .bare subdirectory
    git clone --bare "$repo_url" .bare || {
        echo "Error: Failed to clone repository."
        cd ..
        rm -rf "$dir_name"
        return 1
    }

    # Set up worktree structure
    echo "Setting up worktree structure..."

    # Determine the default branch from the bare repository
    local default_branch
    default_branch=$(git --git-dir=.bare symbolic-ref --short HEAD)

    # Create main worktree from the default branch
    git --git-dir=.bare worktree add "$default_branch" || {
        echo "Error: Failed to create main worktree."
        cd ..
        rm -rf "$dir_name"
        return 1
    }

    # Navigate into the main worktree to set the upstream branch
    cd "$default_branch" || {
        echo "Error: Could not enter the main worktree directory."
        cd ../..
        rm -rf "$dir_name"
        return 1
    }

    echo "Configuring the main branch to track origin..."
    # Set the upstream for the main branch
    git branch --set-upstream-to="origin/$default_branch" "$default_branch" || {
        echo "Warning: Failed to set the upstream branch for the main worktree."
        # Not a fatal error, so we continue
    }

    # Go back to the project root
    cd ..

    echo "Repository cloned with worktree structure in '$PWD'"
    echo "Project structure created:"
    echo "├── .bare/          # Bare repository"
    echo "└── $default_branch/           # Main branch worktree"

    cd ../$dir_name/$default_branch
}

# Create a new worktree in an existing worktree project
# Usage: git-wt-new <feature-name> [base-branch]
git-wt-new() {
    # Save original directory to return to in case of errors
    local original_pwd="$(pwd)"

    # Check if feature name is provided
    if [ -z "$1" ]; then
        echo "Usage: git-wt-new <feature-name> [base-branch]"
        return 1
    fi

    # Find the project root
    local project_root
    project_root=$(git_find_project_root) || return 1

    local git_dir="${project_root}/.bare"

    # This will also be the directory name for the worktree
    local branch_name="$1"
    local base_branch="${2:-main}"
    local worktree_path="${project_root}/${branch_name}"

    # Ensure base branch exists in the bare repo
    if ! git --git-dir="$git_dir" rev-parse --verify "$base_branch" >/dev/null 2>&1; then
        echo "Error: Base branch '$base_branch' does not exist in repository at '$git_dir'"
        return 1
    fi

    # Check if worktree directory already exists (relative to project root)
    if [ -d "$worktree_path" ]; then
        echo "Error: Directory '$worktree_path' already exists."
        return 1
    fi

    # Change to project root to ensure git worktree paths are relative to it
    cd "$project_root" || return 1

    # Variables for worktree creation - set defaults (normal new branch creation)
    local dir_name="$branch_name"
    local git_branch="$branch_name"
    local base_ref="$base_branch"
    local create_branch=true

    # Check if branch already exists in the bare repo
    if git --git-dir="$git_dir" show-ref --verify --quiet "refs/heads/$branch_name"; then
        # Branch exists, ask user what to do
        echo "Branch '$branch_name' already exists."
        echo "Options:"
        echo "  c: Create worktree from existing branch"
        echo "  n: Create new branch with different name"
        echo "  q: Quit"
        echo -n "What would you like to do? [c/n/q] "
        read REPLY
        echo

        case $REPLY in
            [Cc]*)
                # Use existing branch, don't create a new one
                dir_name="$branch_name"
                git_branch="$branch_name"
                base_ref="$branch_name" # Base is the existing branch
                create_branch=false
                ;;

            [Nn]*)
                # Ask for new directory name
                echo -n "Enter new directory name for worktree: "
                read new_dir_name

                # Validate directory name
                if [ -z "$new_dir_name" ]; then
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: New name cannot be empty."
                    return 1
                fi

                if [ -d "$new_dir_name" ]; then
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: Directory '$new_dir_name' already exists."
                    return 1
                fi

                # Ask for new branch name
                echo -n "Enter new branch name (will be created from '$base_branch'): "
                read new_branch_name

                # Validate branch name
                if [ -z "$new_branch_name" ]; then
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: New branch name cannot be empty."
                    return 1
                fi

                if git --git-dir="$git_dir" show-ref --verify --quiet "refs/heads/$new_branch_name"; then
                    cd "$original_pwd" 2>/dev/null
                    echo "Error: Branch '$new_branch_name' already exists."
                    return 1
                fi

                # Update branch and worktree paths
                dir_name="$new_dir_name"
                git_branch="$new_branch_name"
                base_ref="$base_branch"
                create_branch=true

                # Update these for the final cd command
                branch_name="$new_dir_name"
                worktree_path="${project_root}/${branch_name}"
                ;;

            *)
                echo "Operation cancelled"
                cd "$original_pwd" 2>/dev/null
                return 1
                ;;
        esac
    fi

    # Execute the worktree creation
    if [ "$create_branch" = true ]; then
        if ! git --git-dir="$git_dir" worktree add -b "$git_branch" "$dir_name" "$base_ref"; then
            cd "$original_pwd" 2>/dev/null
            echo "Error: Failed to create worktree for branch '$git_branch'."
            return 1
        fi
    else
        if ! git --git-dir="$git_dir" worktree add "$dir_name" "$base_ref"; then
            cd "$original_pwd" 2>/dev/null
            echo "Error: Failed to create worktree for branch '$git_branch'."
            return 1
        fi
    fi

    echo "Created new worktree for branch '$git_branch' in ${worktree_path}"

    # Note that changing to the new directory won't work in a git alias (subshell)
    cd ${worktree_path}
}
