$env.config.show_banner = false
$env.config.highlight_resolved_externals = true

# Homebrew setup
if ('/opt/homebrew' | path type) == 'dir' {
  $env.HOMEBREW_PREFIX = '/opt/homebrew'
  $env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
  $env.HOMEBREW_REPOSITORY = '/opt/homebrew'
  $env.PATH = $env.PATH? | prepend [
    '/opt/homebrew/bin'
    '/opt/homebrew/sbin'
  ]
  $env.MANPATH = $env.MANPATH? | prepend '/opt/homebrew/share/man'
  $env.INFOPATH = $env.INFOPATH? | prepend '/opt/homebrew/share/info'
}

$env.EDITOR = 'nvim'

# -----------------
# Prompt
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# -----------------
# Abbreviations

let abbreviations = {
    "..": 'cd ..'
    "cd..": 'cd ..'
    g: 'git'
    k: 'kubectl'
    kgp: 'kubectl get pods'
    kgd: 'kubectl get deployments'
    kg: 'kubectl get'
}

$env.config = {
    keybindings: [
      {
        name: abbr_menu
        modifier: none
        keycode: enter
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { send: enter }
        ]
      }
      {
        name: abbr_menu
        modifier: none
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { edit: insertchar value: ' '}
        ]
      }
    ]
    menus: [
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: none
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                let match = $abbreviations | columns | where $it == $buffer
                if ($match | is-empty) {
                    { value: $buffer }
                } else {
                    { value: ($abbreviations | get $match.0) }
                }
            }
        }
    ]
}

# Project session
$env.config.keybindings ++= [{
    name: run_project_session
    modifier: control
    keycode: char_f
    mode: emacs
    event: {
        send: executehostcommand,
        cmd: "bash ~/.local/scripts/project-session.sh"
    }
}]

# Git Worktree
$env.GIT_WT_SCRIPT = $"($env.HOME)/.local/scripts/git-worktree.sh"

def git-find-root [] {
    bash -c $"source ($env.GIT_WT_SCRIPT) && git_find_project_root"
}

def git-wt-clone [...args] {
    bash -c $"source ($env.GIT_WT_SCRIPT) && git-wt-clone \"$@\"" _ $args
}

def git-wt-new [...args] {
    bash -c $"source ($env.GIT_WT_SCRIPT) && git-wt-new \"$@\"" _ ...$args
}

# ---------------------------
# Tools

# Atuin
let atuin_config = $"($env.HOME)/.local/share/atuin/init.nu"
if not ($atuin_config | path exists) {
    atuin init nu --disable-up-arrow | save ~/.local/share/atuin/init.nu
}
source ~/.local/share/atuin/init.nu

# Carapace: completions
let carapace_init = $"($env.HOME)/.cache/carapace/init.nu"
if not ($carapace_init | path exists) {
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
    mkdir ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
}

source ~/.cache/carapace/init.nu

# ---------------------------
# Python

$env.PATH = ($env.PATH | prepend $"($env.HOME)/.cargo/bin")
$env.UV_PYTHON_PREFERENCE = "only-managed"

# ---------------------------
# JAVASCRIPT

# if not ("VOLTA_HOME" in $env) {
#     $env.VOLTA_HOME = $"($env.HOME)/.volta"
# }
# $env.PATH = ($env.PATH | prepend $"($env.VOLTA_HOME)/bin")

# Bun
$env.PATH = ($env.PATH | prepend $"($env.HOME)/.bun/bin")

# Set other environment variables.
$env.ASTRO_TELEMETRY_DISABLED = 1
$env.NEXT_TELEMETRY_DEBUG = 1
$env.DISABLE_OPENCOLLECTIVE = 1
$env.ADBLOCK = 1
$env.VOLTA_FEATURE_PNPM = 1

alias npmreset = rm -rf node_modules

# Kubernetes

def --env ek [
  query?: string
] {
  let kube_dir = ($env.HOME | path join ".kube")
  let search_dirs = [$kube_dir]
  let sep = ":"

  let files = (
    $search_dirs
    | each {|d| rg --max-depth 3 -l '^kind: Config$' $d err> /dev/null }
    | str join (char nl)
    | lines
    | uniq
  )

  if ($files | is-empty) {
    print "No kubeconfig files found."
    return
  }

  let selection = if $query == null {
    let chosen = ($files | str join (char nl) | fzf --multi | lines)
    if ($chosen | is-empty) {
      print "No selection."
      return
    }
    $chosen | str join $sep
  } else {
    let filtered = ($files | where {|x| $x | str contains $query })
    if ($filtered | is-empty) {
      print $"No matches for ($query)."
      return
    }
    $filtered | str join $sep
  }

  print $selection
  $env.KUBECONFIG = $selection
}

# Select and set a Kubernetes namespace
export def --env ekns [] {
  let namespaces = (try { kubectl get ns -o=custom-columns=:.metadata.name | lines } catch { [] })
  if ($namespaces | is-empty) {
    print "No namespaces found."
    return
  }

  let ns = ($namespaces | str join (char nl) | fzf --select-1 --preview 'kubectl --namespace {} get pods' | str trim)
  if ($ns == "") {
    print "No namespace selected."
    return
  }

  $env.KUBE_NAMESPACE = $ns
  kubectl config set-context --current --namespace $ns | ignore
  let cfg = ($env.KUBECONFIG | default "~/.kube/config")
  print $"Set namespace to ($ns) in config: ($cfg)"
}
