#!/usr/bin/env fish

set fish_greeting ""

function prepend_path
    set -gx PATH $argv[1] $PATH
end

# macOS specific configurations
if test (uname) = "Darwin"
    # Reset PATH to a clean state.
    # Fish handles the PATH as a list of directories, not a single string.
    set -gx PATH /bin /sbin /usr/bin /usr/local/bin

    # Set Homebrew environment variables
    set -gx HOMEBREW_PREFIX "/opt/homebrew"
    set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/opt/homebrew"

    # Add Homebrew paths
    prepend_path "$HOMEBREW_PREFIX/bin"
    prepend_path "$HOMEBREW_PREFIX/sbin"

    # GNU tools from Homebrew
    prepend_path "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    prepend_path "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
    prepend_path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
    prepend_path "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"

    # Keg-only brew formulas
    prepend_path "/usr/local/opt/curl/bin"
    prepend_path "/opt/homebrew/opt/libpq/bin"

    # Git and GPG config
    # `(tty)` is the fish equivalent of zsh's $TTY variable
    set -gx GPG_TTY (tty)

    # Disable Homebrew auto updates for speed
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
    set -gx HOMEBREW_NO_INSTALL_CLEANUP 1
end

# Set default config directory
set -gx XDG_CONFIG_HOME "$HOME/.config"

# Local binaries
set -gx PATH "$HOME/.local/bin" "$HOME/.local/scripts" $PATH

# Cargo binaries
prepend_path "$HOME/.cargo/bin"

# -----------------------------------------------
# Tools

alias vim=nvim

if command -q fzf
    fzf --fish | source
end

if command -q zoxide
    zoxide init fish | source
end

# Atuin (Magical Shell History)
if command -q atuin
    atuin init fish --disable-up-arrow | source
end

# direnv (Environment Switcher)
if command -q direnv
    direnv hook fish | source
end

# Project Switcher
bind \cf 'project-switcher'

# -----------------------------------------------
# Python

# Set config paths and preferences
set -gx HATCH_CONFIG "$HOME/.config/hatch/config.toml"
set -gx UV_PYTHON_PREFERENCE only-managed

# Function to clean Python build artifacts and caches
function pyclean
    find . -type f -name '*.py[co]' -delete
    find . -type d -name __pycache__ -exec rm -rf {} +
    find . -type d -name dist -exec rm -rf {} +
    find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
    find . -type d -name .pytest_cache -exec rm -rf {} +
    find . -type d -name .venv -exec rm -rf {} +
end

# Disables virtualenv's prompt modification
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# -----------------------------------------------
# Javascript

# Bun
prepend_path "$HOME/.bun/bin"

# Simple alias for removing node_modules
alias npmreset "rm -rf node_modules"

# Disable telemetry for various tools
set -gx ASTRO_TELEMETRY_DISABLED 1
set -gx NEXT_TELEMETRY_DEBUG 1.
set -gx DISABLE_OPENCOLLECTIVE 1
set -gx ADBLOCK 1

# -----------------------------------------------
# Docker

# In Fish, aliases with logic (like command substitution) should be functions.
function docker-rm-all;     docker rm -f (docker ps -a -q);                  end
function docker-stop-all;   docker stop (docker ps -a -q);                   end
function docker-prune;      docker system prune -f;                          end
function docker-clean;      docker-stop-all; and docker-prune;               end
function docker-rmi-empty;  docker rmi (docker images -f "dangling=true" -q);end
function docker-rmi-prefix; docker rmi -f (docker images --filter=reference='prefix*' --format '{{.Repository}}:{{.Tag}}'); end
function docker-rmi-all;    docker rmi -f (docker images --format '{{.ID}}'); end

# -----------------------------------------------
# Kubernetes

if command -q kubectl
    # Source kubectl completions for Fish
    kubectl completion fish | source

    # Aliases and Abbreviations
    alias kubectl "kubecolor"
    abbr -a k 'kubectl'
    abbr -a kg 'kubectl get'
    abbr -a kl 'kubectl logs'
    abbr -a kgp 'kubectl get po'
    abbr -a kgn 'kubectl get no'
    abbr -a kgd 'kubectl get deploy'
    abbr -a krmp 'kubectl delete po'
    abbr -a kdp 'kubectl describe po'

    # Abbreviations for unsetting variables. `set -e` is Fish's `unset`.
    abbr -a uek 'set -e KUBECONFIG'
    abbr -a uekns 'set -e KUBE_NAMESPACE'

    # Backup and remove/symlink ~/.kube/config
    if test -f ~/.kube/config; and not test -L ~/.kube/config
        mv ~/.kube/config ~/.kube/config.backup_(date +%Y%m%d_%H%M%S)
        echo "Existing ~/.kube/config backed up."
    end

    # Remove default kubeconfig
    ln -sf /dev/null ~/.kube/config
end

# Export kubeconfig
function ek
    set -l CONFIG
    if set -q argv[1]
        set CONFIG (rg --max-depth 3 -l '^kind: Config$' "$HOME/.kube/" 2>/dev/null | grep "$argv[1]")
    else
        # Use `string join` instead of `tr` for safety and clarity
        set CONFIG (rg --max-depth 3 -l '^kind: Config$' "$HOME/.kube/" "$PWD" 2>/dev/null | fzf --multi | string join ':')
    end

    # Use `string trim` to safely remove a trailing colon
    set -l final_config (string trim -r -c ':' -- "$CONFIG")
    echo "$final_config"
    set -gx KUBECONFIG "$final_config"
end

# Helper for setting a namespace
function ekns
    # Capture list of namespaces into a Fish list
    set -l namespaces (kubectl get ns -o=custom-columns=:.metadata.name | tail -n +2)

    # Use the list with fzf
    set -l selected_ns (echo $namespaces | fzf --select-1 --preview "kubectl --namespace {} get pods")

    # Proceed only if a namespace was selected (fzf output is not empty)
    if test -n "$selected_ns"
      set -gx KUBE_NAMESPACE $selected_ns
      kubectl config set-context --current --namespace="$KUBE_NAMESPACE"
      echo "Set namespace to $KUBE_NAMESPACE in current kubeconfig context."
    else
      echo "No namespace selected."
    end
end

# -----------------------------------------------
# Functions

function dirsize
    # In Fish, variables in functions are local by default.
    set -l arg

    # Check if `du` supports the -b flag (for GNU `du`)
    # `&>/dev/null` is Fish's shorthand for redirecting both stdout and stderr.
    if command du -b /dev/null &>/dev/null
        set arg -sbh
    else
        # For BSD/macOS `du`
        set arg -sh
    end

    # `count $argv` is the Fish equivalent of zsh's `$#`.
    if count $argv > 0
        # `$argv` expands to all arguments safely.
        command du $arg -- $argv
    else
        # If no arguments, run on the current directory.
        # This glob pattern works in Fish to include dotfiles but exclude . and ..
        command du $arg .[^.]* *
    end
end

function clipvideo
    # Check if the number of arguments is not equal to 4
    if test (count $argv) -ne 4
        echo "Usage: clipvideo <input> <start> <end> <output>" >&2
        return 1
    else
        # `$argv[1]`, `$argv[2]`, etc., are the positional arguments
        ffmpeg -i "$argv[1]" -ss "$argv[2]" -to "$argv[3]" -c:v copy -c:a copy "$argv[4]"
    end
end

# -----------------------------------------------
# Prompt

if command -q starship
    starship init fish | source
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/danrodriguez/.lmstudio/bin
# End of LM Studio CLI section

