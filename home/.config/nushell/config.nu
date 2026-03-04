$env.config.show_banner = false
$env.config.highlight_resolved_externals = true
$env.config.buffer_editor = "nvim"

# Set TERM for compatibility with tools like ghostty when SSH'ing
if ($env.TERM? | default "dumb") == "dumb" {
  $env.TERM = "xterm-256color"
}

# -----------------------------------------------
# macOS specific configurations

if (sys host | get name) == "Darwin" {
  # Reset PATH to a clean state
  $env.PATH = ["/bin" "/sbin" "/usr/bin" "/usr/local/bin"]

  # Set Homebrew environment variables
  $env.HOMEBREW_PREFIX = "/opt/homebrew"
  $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
  $env.HOMEBREW_REPOSITORY = "/opt/homebrew"

  # Add Homebrew paths
  $env.PATH = $env.PATH | prepend [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ]

  # GNU tools from Homebrew
  $env.PATH = $env.PATH | prepend [
    "/opt/homebrew/opt/coreutils/libexec/gnubin"
    "/opt/homebrew/opt/findutils/libexec/gnubin"
    "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
    "/opt/homebrew/opt/grep/libexec/gnubin"
  ]

  # Keg-only brew formulas
  $env.PATH = $env.PATH | prepend [
    "/usr/local/opt/curl/bin"
    "/opt/homebrew/opt/libpq/bin"
  ]

  # Git and GPG config
  $env.GPG_TTY = (try { tty } catch { "" })

  # Disable Homebrew auto updates for speed
  $env.HOMEBREW_NO_AUTO_UPDATE = "1"
  $env.HOMEBREW_NO_INSTALL_CLEANUP = "1"

  $env.MANPATH = ($env.MANPATH? | default "" | prepend "/opt/homebrew/share/man")
  $env.INFOPATH = ($env.INFOPATH? | default "" | prepend "/opt/homebrew/share/info")
}

# -----------------------------------------------
# Environment variables

$env.EDITOR = "nvim"
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"

# -----------------------------------------------
# PATH

$env.PATH = $env.PATH | prepend [
  $"($env.HOME)/.local/bin"
  $"($env.HOME)/.local/scripts"
  $"($env.HOME)/.things/bin"
  $"($env.HOME)/.cargo/bin"
  $"($env.HOME)/.opencode/bin"
]

# -----------------------------------------------
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

# -----------------------------------------------
# Abbreviations

let abbreviations = {
    "..": "cd .."
    "cd..": "cd .."
    g: "git"
    t: "tmux"
    tf: "terraform"
    k: "kubectl"
    kg: "kubectl get"
    kl: "kubectl logs"
    kgp: "kubectl get pods"
    kgn: "kubectl get nodes"
    kgd: "kubectl get deployments"
    krmp: "kubectl delete pod"
    kdp: "kubectl describe pod"
    uek: "hide-env KUBECONFIG"
    uekns: "hide-env KUBE_NAMESPACE"
}

$env.config = ($env.config | merge {
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
})

# -----------------------------------------------
# Keybindings

# Ctrl+F: Project session switcher
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

# -----------------------------------------------
# Aliases

alias vim = nvim

# -----------------------------------------------
# Tools

# Regenerate cached init files for atuin, carapace, and zoxide.
# Run after installing or updating these tools.
def setup-nu-cache [
    --force (-f) # Regenerate all files even if they exist
] {
    let flag = (if $force { ["--force"] } else { [] })
    nu ($nu.default-config-dir | path join "setup.nu") ...$flag
}

# Atuin (Magical Shell History)
source ~/.local/share/atuin/init.nu

# Carapace (Completions)
source ~/.cache/carapace/init.nu

# Zoxide (Smart cd)
source ~/.cache/zoxide/init.nu

# -----------------------------------------------
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

# -----------------------------------------------
# Python

$env.HATCH_CONFIG = $"($env.HOME)/.config/hatch/config.toml"
$env.UV_PYTHON_PREFERENCE = "only-managed"
$env.VIRTUAL_ENV_DISABLE_PROMPT = "1"

$env.PATH = ($env.PATH | prepend $"($env.HOME)/conda/bin")

# Clean Python build artifacts and caches
def pyclean [] {
    glob "**/*.py[co]" | each { |f| rm $f } | ignore
    glob "**/__pycache__" | each { |d| rm -rf $d } | ignore
    glob "**/dist" | each { |d| rm -rf $d } | ignore
    glob "**/.ipynb_checkpoints" | each { |d| rm -rf $d } | ignore
    glob "**/.pytest_cache" | each { |d| rm -rf $d } | ignore
    glob "**/.venv" | each { |d| rm -rf $d } | ignore
    print "Cleaned Python artifacts."
}

# Explicit conda initialization (lazy-load alternative)
def --env condainit [] {
    let conda_bin = $"($env.HOME)/conda/bin/conda"
    if ($conda_bin | path exists) {
        # Delegate to the conda.nu module
        use conda.nu
        print "Conda initialized. Use `conda activate` and `conda deactivate`."
    } else {
        print "Conda not found at ~/conda/bin/conda"
    }
}

# -----------------------------------------------
# Javascript

$env.PATH = ($env.PATH | prepend $"($env.HOME)/.bun/bin")

$env.ASTRO_TELEMETRY_DISABLED = "1"
$env.NEXT_TELEMETRY_DEBUG = "1"
$env.DISABLE_OPENCOLLECTIVE = "1"
$env.ADBLOCK = "1"

alias npmreset = rm -rf node_modules

# -----------------------------------------------
# Docker

def docker-rm-all [] {
    let ids = (docker ps -a -q | lines)
    if ($ids | is-empty) { print "No containers."; return }
    docker rm -f ...$ids
}

def docker-stop-all [] {
    let ids = (docker ps -a -q | lines)
    if ($ids | is-empty) { print "No containers."; return }
    docker stop ...$ids
}

def docker-prune [] {
    docker system prune -f
}

def docker-clean [] {
    docker-stop-all
    docker-prune
}

def docker-rmi-empty [] {
    let ids = (docker images -f "dangling=true" -q | lines)
    if ($ids | is-empty) { print "No dangling images."; return }
    docker rmi ...$ids
}

def docker-rmi-prefix [prefix: string] {
    let images = (docker images --filter $"reference=($prefix)*" --format "{{.Repository}}:{{.Tag}}" | lines)
    if ($images | is-empty) { print "No matching images."; return }
    docker rmi -f ...$images
}

def docker-rmi-all [] {
    let ids = (docker images --format "{{.ID}}" | lines)
    if ($ids | is-empty) { print "No images."; return }
    docker rmi -f ...$ids
}

# -----------------------------------------------
# Kubernetes

if (which kubectl | is-not-empty) {
    # Backup and symlink ~/.kube/config to /dev/null
    let kube_config = $"($env.HOME)/.kube/config"
    if ($kube_config | path exists) and (not ($kube_config | path type | $in == "symlink")) {
        let backup = $"($env.HOME)/.kube/config.backup_(date now | format date '%Y%m%d_%H%M%S')"
        mv $kube_config $backup
        print $"Existing ~/.kube/config backed up to ($backup)."
    }
    if not ($kube_config | path exists) {
        ln -sf /dev/null $kube_config
    }
}

# Alias kubectl to kubecolor if available
if (which kubecolor | is-not-empty) {
    alias kubectl = kubecolor
}

# Export kubeconfig (interactive fzf selector)
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
def --env ekns [] {
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
  let cfg = ($env.KUBECONFIG? | default "~/.kube/config")
  print $"Set namespace to ($ns) in config: ($cfg)"
}

# -----------------------------------------------
# Functions

# Show directory sizes
def dirsize [...paths: string] {
    if ($paths | is-empty) {
        du . | select path apparent physical | first 20
    } else {
        $paths | each { |p| du $p } | flatten | select path apparent physical
    }
}

# Clip a video segment using ffmpeg
def clipvideo [
    input: string    # Input file
    start: string    # Start time (e.g., 00:01:30)
    end_time: string # End time (e.g., 00:02:45)
    output: string   # Output file
] {
    ffmpeg -i $input -ss $start -to $end_time -c:v copy -c:a copy $output
}

# -----------------------------------------------
# Conda

use conda.nu

# -----------------------------------------------

# Source local config for machine-specific settings (optional).
# Create ~/.config.local.nu to add overrides not tracked in the dotfiles repo.
const local_config = (if ("~/.config.local.nu" | path exists) { "~/.config.local.nu" } else { null })
source $local_config
