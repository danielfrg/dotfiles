export PROFILING_MODE=0
if [ $PROFILING_MODE -ne 0 ]; then
    zmodload zsh/zprof
fi

# -------------------------------------
# Plugin manager

ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh_plugins"

# List of plugins to install from GitHub: owner/repo
_zsh_plugins_list=(
    "Aloxaf/fzf-tab"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-completions"
    "zsh-users/zsh-history-substring-search"
    "zsh-users/zsh-syntax-highlighting"
)

# Function to install/update plugins
install_zsh_plugins() {
    if ! command -v git >/dev/null; then
        echo "Error: git command not found. Cannot install or update plugins." >&2
        return 1
    fi

    if [ ! -d "$ZSH_PLUGINS_DIR" ]; then
        echo "Creating plugin directory: $ZSH_PLUGINS_DIR"
        mkdir -p "$ZSH_PLUGINS_DIR"
    fi

    for plugin_src in "${_zsh_plugins_list[@]}"; do
        local repo_owner_name="${plugin_src%%/*}"
        local repo_name="${plugin_src##*/}"
        local plugin_path="$ZSH_PLUGINS_DIR/$repo_name"

        if [ ! -d "$plugin_path/.git" ]; then
            echo "Installing $repo_name (from $plugin_src)..."
            if git clone --depth 1 "https://github.com/$plugin_src.git" "$plugin_path"; then
                echo "$repo_name installed successfully."
            else
                echo "Failed to clone $repo_name. Please check the path and network." >&2
            fi
        else
            echo "Updating $repo_name (in $plugin_path)..."
            echo "Note: If you have local changes in $plugin_path, 'git pull' might fail."
            echo "Commit or stash your changes before updating if needed."
            if (cd "$plugin_path" && git pull); then # Subshell to keep `pwd` clean
                echo "$repo_name updated successfully."
            else
                echo "Failed to update $repo_name. Please check $plugin_path manually." >&2
            fi
        fi
    done
    echo ""
    echo "Plugin installation/update check complete. Restart Zsh."
}

# -------------------------------------
# FPATH and Completions

# Add zsh-completions to fpath if installed
ZSH_COMPLETIONS_PATH="$ZSH_PLUGINS_DIR/zsh-completions"
if [ -d "$ZSH_COMPLETIONS_PATH/src" ]; then
    fpath=("$ZSH_COMPLETIONS_PATH/src" $fpath)
fi

# Initialize completions (ensure this runs after fpath is set up)
# -C: Check if .zcompdump is up-to-date, if so, do nothing.
# -i: Ignore insecure directories for initial dump file creation.
# -d <dumpfile>: Specify a custom dump file location.
if (( ${+functions[compinit]} )); then
  # If compinit is already a function, check if it needs to be run
  compinit -C -i -d "${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}"
else
  # If compinit is not yet loaded, load and run it
  autoload -Uz compinit
  compinit -i -d "${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}"
fi

# -------------------------------------
# Load Plugins

# Aloxaf/fzf-tab
_fzf_tab_plugin_file="$ZSH_PLUGINS_DIR/fzf-tab/fzf-tab.zsh"
if [ -f "$_fzf_tab_plugin_file" ]; then
    source "$_fzf_tab_plugin_file"
else
    echo "Warning: zsh-syntax-highlighting plugin not found. Run 'install_zsh_plugins'." >&2
fi

# zsh-users/zsh-autosuggestions
_autosuggestions_plugin_file="$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [ -f "$_autosuggestions_plugin_file" ]; then
    source "$_autosuggestions_plugin_file"
else
    echo "Warning: zsh-syntax-highlighting plugin not found. Run 'install_zsh_plugins'." >&2
fi

# zsh-users/zsh-history-substring-search
_history_substring_search_plugin_file="$ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
if [ -f "$_history_substring_search_plugin_file" ]; then
    source "$_history_substring_search_plugin_file"
else
    echo "Warning: zsh-syntax-highlighting plugin not found. Run 'install_zsh_plugins'." >&2
fi

# zsh-users/zsh-syntax-highlighting (KEEP THIS THE LAST)
_syntax_highlighting_plugin_file="$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ -f "$_syntax_highlighting_plugin_file" ]; then
    source "$_syntax_highlighting_plugin_file"
else
    echo "Warning: zsh-syntax-highlighting plugin not found. Run 'install_zsh_plugins'." >&2
fi

# -------------------------------------
# My config

source ~/.zsh/config.zsh
source ~/.zsh/prompt.zsh

if [ $PROFILING_MODE -ne 0 ]; then
    zprof
fi

# -------------------------------------
# For stuff that is not to be committed

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# bun completions
[ -s "/Users/danrodriguez/.bun/_bun" ] && source "/Users/danrodriguez/.bun/_bun"
export PATH="/Users/danrodriguez/.pixi/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/danrodriguez/.lmstudio/bin"
# End of LM Studio CLI section


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/danielfrg/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/danielfrg/conda/etc/profile.d/conda.sh" ]; then
        . "/home/danielfrg/conda/etc/profile.d/conda.sh"
    else
        export PATH="/home/danielfrg/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/danielfrg/conda/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/danielfrg/conda';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
export PATH="/Users/danrodriguez/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/danrodriguez/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
