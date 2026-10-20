#!/bin/sh
set -eu
umask 077

mkdir -p "$HOME/code/danielfrg" "$HOME/code/inmatura" "$HOME/code/nvidia" \
    "$HOME/.config/opencode" "$HOME/.local/share/opencode" "$HOME/.cache" "$HOME/.kube"

cp -n /opt/dev/profile/.zshrc "$HOME/.zshrc"
cp -n /opt/dev/profile/.gitconfig "$HOME/.gitconfig"
cp -n /opt/dev/profile/starship.toml "$HOME/.config/starship.toml"
cp -n /opt/dev/profile/AGENTS.md "$HOME/.config/opencode/AGENTS.md"
if [ ! -e "$HOME/.config/opencode/opencode.json" ] && [ ! -e "$HOME/.config/opencode/opencode.jsonc" ]; then
    cp /opt/dev/profile/opencode.json "$HOME/.config/opencode/opencode.json"
fi
if [ -f /etc/dev/kubeconfig ]; then
    cp -n /etc/dev/kubeconfig "$HOME/.kube/homelab"
fi

if [ "${1:-}" = opencode ] && [ "${2:-}" = serve ]; then
    : "${OPENCODE_PASSWORD:?Set OPENCODE_PASSWORD before starting the server}"
fi
exec "$@"
