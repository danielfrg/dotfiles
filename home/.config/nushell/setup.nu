# Atuin
let atuin_config = $"($env.HOME)/.local/share/atuin/init.nu"
if not ($atuin_config | path exists) {
    atuin init nu --disable-up-arrow | save ~/.local/share/atuin/init.nu

    echo "Configuring atuin"
}

# Carapace: completions
let carapace_init = $"($env.HOME)/.cache/carapace/init.nu"
if not ($carapace_init | path exists) {
    echo "Installing carapace"
    $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
    mkdir ~/.cache/carapace
    carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

    echo "Configuring carapace"
}

