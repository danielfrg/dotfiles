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