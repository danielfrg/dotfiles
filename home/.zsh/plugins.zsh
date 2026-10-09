# Zsh plugin locations and bootstrap command. This file is safe to source from
# non-interactive shells, so plugin installation does not load prompt/ZLE hooks.

ZSH_PLUGINS_DIR="$HOME/.local/share/zsh_plugins"
ZSH_COMPLETION_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

clear_zsh_completion_cache() {
    local -a cache_files
    cache_files=("$ZSH_COMPLETION_CACHE_DIR"/zcompdump-*(N))
    (( ${#cache_files} )) && /bin/rm -f -- "${cache_files[@]}"
}

_zsh_plugins_list=(
    'Aloxaf/fzf-tab'
    'zsh-users/zsh-autosuggestions'
    'zsh-users/zsh-completions'
    'zsh-users/zsh-history-substring-search'
    'zsh-users/zsh-syntax-highlighting'
)

install_zsh_plugins() {
    if ! (( $+commands[git] )); then
        print -u2 'Error: git is required to install Zsh plugins.'
        return 1
    fi

    mkdir -p "$ZSH_PLUGINS_DIR" || return 1

    local plugin_src repo_name plugin_path
    for plugin_src in "${_zsh_plugins_list[@]}"; do
        repo_name=${plugin_src##*/}
        plugin_path="$ZSH_PLUGINS_DIR/$repo_name"

        if [[ ! -d "$plugin_path/.git" ]]; then
            print "Installing $repo_name from $plugin_src..."
            git clone --depth 1 "https://github.com/$plugin_src.git" "$plugin_path" || return 1
        else
            print "Updating $repo_name..."
            git -C "$plugin_path" pull --ff-only || return 1
        fi
    done

    clear_zsh_completion_cache
    print 'Zsh plugin installation/update complete. Completion caches cleared; restart Zsh.'
}
