#!/bin/zsh

# One Rex session per project. --palette opens native UI; --popup opens fzf.
setopt errexit pipefail

# A directly spawned Rex block may not inherit interactive-shell Homebrew paths.
path+=(/opt/homebrew/bin /usr/local/bin)

if [[ ${1:-} == --layer ]]; then
    shift
    # Keep failures visible instead of immediately dismissing the popup.
    trap 'picker_result=$?; if (( picker_result != 0 )); then print -u2 "Press any key to close."; read -k 1; fi' EXIT
fi

rex_bin=${commands[rex]:-}
if [[ -z $rex_bin && -x '/Applications/Rex Beta.app/Contents/Helpers/Rex Server.app/Contents/MacOS/rex' ]]; then
    rex_bin='/Applications/Rex Beta.app/Contents/Helpers/Rex Server.app/Contents/MacOS/rex'
fi
[[ -n $rex_bin ]] || { print -u2 'Rex CLI not found. Install Rex first.'; exit 1; }
if [[ ${1:-} == --palette ]]; then
    exec "$rex_bin" do session_palette
fi
for dependency in jq fzf; do
    command -v "$dependency" >/dev/null || { print -u2 "Required command not found: $dependency"; exit 1; }
done

if [[ ${1:-} == --popup ]]; then
    exec "$rex_bin" do project_picker
fi

project_label() {
    if [[ $1 == "$HOME/.dotfiles" ]]; then
        print -r -- dotfiles
    elif [[ $1 == "$HOME/code/"* ]]; then
        print -r -- "${1#"$HOME/code/"}"
    else
        print -r -- "$1"
    fi
}

selected_dir=''
session_id=''
if (( $# )); then
    [[ -d $1 ]] || { print -u2 "Project directory not found: $1"; exit 1; }
    selected_dir=${1:a}
fi
sessions=$("$rex_bin" ls --json)

if [[ -z $selected_dir ]]; then
    typeset -a projects rows
    typeset -A project_labels
    [[ -d "$HOME/.dotfiles" ]] && projects+=("$HOME/.dotfiles")
    for root in "$HOME/code" "$HOME/code/danielfrg" "$HOME/code/inmatura" "$HOME/code/nvidia"; do
        [[ -d $root ]] || continue
        for directory in "$root"/*(N/); do
            # These are search roots, rather than projects themselves.
            [[ $directory == "$HOME/code/danielfrg" || $directory == "$HOME/code/inmatura" || $directory == "$HOME/code/nvidia" ]] && continue
            projects+=("$directory")
        done
    done
    for directory in "${(@ou)projects}"; do
        label=$(project_label "$directory")
        project_labels[${(L)label}]=1
        count=$(jq --arg label "$label" '[.sessions[] | select((.label // "" | ascii_downcase) == ($label | ascii_downcase))] | length' <<< "$sessions")
        marker=new
        (( count > 0 )) && marker=running
        (( count > 1 )) && marker=ambiguous
        rows+=("project"$'\t'"$label"$'\t'"$directory"$'\t-'$'\t'"$marker")
    done
    while IFS=$'\t' read -r id label; do
        [[ -n $id ]] || continue
        [[ -n ${project_labels[${(L)label}]:-} ]] && continue
        rows+=("session"$'\t'"$label"$'\t-'$'\t'"$id"$'\t'"running")
    done < <(jq -r '.sessions[] | [.session_id, (.label // .session_id)] | @tsv' <<< "$sessions")
    (( ${#rows} )) || { print -u2 'No projects or Rex sessions found.'; exit 1; }
    # Ignore global fzf defaults such as multi-select or custom accept bindings.
    selected=$(printf '%s\n' "${rows[@]}" | FZF_DEFAULT_OPTS='' FZF_DEFAULT_OPTS_FILE='' fzf \
        --delimiter=$'\t' --with-nth=2,5 --no-multi --layout=reverse \
        --prompt='Rex project > ' --header='Enter: create/resume session · Esc: cancel') || {
        picker_result=$?
        (( picker_result == 1 || picker_result == 130 )) && exit 0
        exit "$picker_result"
    }
    [[ -n $selected ]] || exit 0
    IFS=$'\t' read -r kind label directory id marker <<< "$selected"
    if [[ $kind == session ]]; then
        session_id=$id
    else
        selected_dir=$directory
    fi
fi

if [[ -n $selected_dir ]]; then
    label=$(project_label "$selected_dir")
    # Refresh after the picker to avoid using a stale session list.
    sessions=$("$rex_bin" ls --json)
    matches=$(jq --arg label "$label" '[.sessions[] | select((.label // "" | ascii_downcase) == ($label | ascii_downcase))]' <<< "$sessions")
    count=$(jq 'length' <<< "$matches")
    (( count <= 1 )) || { print -u2 "Multiple Rex sessions named '$label'; rename one before retrying."; exit 1; }
    if (( count == 1 )); then
        session_id=$(jq -r '.[0].session_id' <<< "$matches")
    else
        created=$("$rex_bin" new "$label" --cwd "$selected_dir" --json)
        session_id=$(jq -er '.session_id' <<< "$created")
    fi
fi

client_args=()
[[ -n ${REX_CLIENT:-} ]] && client_args=(-C "$REX_CLIENT")
"$rex_bin" "${client_args[@]}" do session.select "session_id=$session_id"
