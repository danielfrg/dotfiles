#!/bin/bash

is_project_root() {
    if [ -d ".bare" ]; then
        return 0
    else
        echo "Error: Must be run from project root (directory containing .bare/)"
        return 1
    fi

    if [ ! -f ".bare/config" ]; then
        echo "Error: .bare is not a valid Git repository"
        return 1
    fi

    local is_bare=$(git --git-dir=.bare config --bool core.bare)
    if [ "$is_bare" != "true" ]; then
        echo "Error: .bare is not a bare repository"
        return 1
    fi
}


clone_as_worktree() {
    if [ -z "$1" ]; then
        echo "Usage: clone_as_worktree <repository-url> [directory]"
        return 1
    fi

    local repo_url=$1
    local dir_name=${2:-$(basename "$repo_url" .git)}

    # Create directory and clone as bare
    mkdir -p "$dir_name"
    cd "$dir_name"

    echo "Cloning repository as bare..."
    git clone --bare "$repo_url" .bare

    # Set up worktree structure
    echo "Setting up worktree structure..."

    # Configure the bare repository
    cd .bare
    git config --bool core.bare true
    cd ..

    # Create main worktree
    git --git-dir=.bare worktree add main

    echo "Repository cloned with worktree structure in ./$dir_name"
    echo "Project structure created:"
    echo "├── .bare/          # Bare repository"
    echo "└── main/           # Main branch worktree"
}


new_worktree() {
    is_project_root || return 1

    if [ -z "$1" ]; then
        echo "Usage: new_worktree <feature-name> [base-branch]"
        return 1
    fi

    local branch_name=$1
    local base_branch=${2:-main}

    # Ensure base branch exists
    if ! git --git-dir=.bare rev-parse --verify "$base_branch" >/dev/null 2>&1; then
        echo "Error: Base branch '$base_branch' does not exist"
        return 1
    fi

    # Check if worktree directory already exists
    if [ -d "$branch_name" ]; then
        echo "Error: Directory '$branch_name' already exists"
        return 1
    fi

    # Check if branch already exists
    if git --git-dir=.bare show-ref --verify --quiet "refs/heads/$branch_name"; then
        # Branch exists, ask user what to do
        read -p "Branch '$branch_name' already exists. Do you want to (c)reate worktree from existing branch, (n)ew branch with different name, or (q)uit? [c/n/q] " -n 1 -r
        echo
        case $REPLY in
            [Cc]*)
                # Use existing branch
                git --git-dir=.bare worktree add "$branch_name" "$branch_name"
                ;;
            [Nn]*)
                # Ask for new branch name
                read -p "Enter new branch name (without feature/ prefix): " new_name
                new_branch_name="feature/${new_name}"
                git --git-dir=.bare worktree add -b "$new_branch_name" "$branch_name" "$base_branch"
                ;;
            *)
                echo "Operation cancelled"
                return 1
                ;;
        esac
    else
        # Create new branch and worktree
        git --git-dir=.bare worktree add -b "$branch_name" "$branch_name" "$base_branch"
    fi

    echo "Created new worktree for $branch_name in ./$branch_name"
}


main() {
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <command> [arguments...]"
        echo "Commands:"
        echo "  convert_to_worktree            - Convert current repository to use worktrees"
        echo "  new_worktree <name> [base]     - Create new worktree"
        echo "  list_worktrees                 - List all worktrees and their status"
        echo "  cleanup_worktree <name>        - Remove a worktree"
        echo "  clone_as_worktree <url> [dir]  - Clone repository as worktree"
        return 1
    fi

    local command=$1
    shift

    case $command in
        convert_to_worktree)
            convert_to_worktree "$@"
            ;;
        new_worktree)
            new_worktree "$@"
            ;;
        list_worktrees)
            list_worktrees "$@"
            ;;
        cleanup_worktree)
            cleanup_worktree "$@"
            ;;
        clone_as_worktree)
            clone_as_worktree "$@"
            ;;
        *)
            echo "Unknown command: $command"
            return 1
            ;;
    esac
}

main "$@"
