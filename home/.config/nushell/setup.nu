# Generate cached init files for tools (atuin, carapace, zoxide).
# Re-run after updating any of these tools.
#
# Usage:
#   nu ~/.config/nushell/setup.nu          # only create missing files
#   nu ~/.config/nushell/setup.nu --force  # regenerate all files

def main [
    --force (-f) # Regenerate all init files, even if they already exist
] {
    # Atuin
    let atuin_init = $"($env.HOME)/.local/share/atuin/init.nu"
    if $force or not ($atuin_init | path exists) {
        print "Configuring atuin..."
        mkdir ($atuin_init | path dirname)
        atuin init nu --disable-up-arrow | save --force $atuin_init
        print $"  Saved to ($atuin_init)"
    } else {
        print $"Atuin: already cached at ($atuin_init)"
    }

    # Carapace: completions
    let carapace_init = $"($env.HOME)/.cache/carapace/init.nu"
    if $force or not ($carapace_init | path exists) {
        print "Configuring carapace..."
        $env.CARAPACE_BRIDGES = 'zsh,bash,inshellisense'
        mkdir ($carapace_init | path dirname)
        carapace _carapace nushell | save --force $carapace_init
        print $"  Saved to ($carapace_init)"
    } else {
        print $"Carapace: already cached at ($carapace_init)"
    }

    # Zoxide: smart cd
    let zoxide_init = $"($env.HOME)/.cache/zoxide/init.nu"
    if $force or not ($zoxide_init | path exists) {
        print "Configuring zoxide..."
        mkdir ($zoxide_init | path dirname)
        zoxide init nushell | save --force $zoxide_init
        print $"  Saved to ($zoxide_init)"
    } else {
        print $"Zoxide: already cached at ($zoxide_init)"
    }

    print "Setup complete."
}
