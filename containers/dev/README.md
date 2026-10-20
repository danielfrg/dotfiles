# Daniel's Linux development image

Build from the dotfiles repository:

```zsh
docker build --platform linux/amd64 -t daniel-dev:test -f containers/dev/Dockerfile containers/dev
```

The baseline is Debian, Node 26, pnpm 10, Go 1.25, uv, OpenCode V2, Bun,
Git/Git LFS/GitHub CLI, just, common native build tools, Kubernetes/ArgoCD/Helm,
Terraform, Ansible, pre-commit, Chromium prerequisites, FFmpeg, and a minimal shell.
Tools must be available in noninteractive shells as well as Zsh.

The account is `danielfrg`, UID/GID 1000:1000.
Container-only sudo is available for missing OS packages; those changes disappear
when the container is replaced.

## Persistent runtime

Mount your persistent home at `/home/danielfrg`; verify its UID/GID permissions.

OpenCode runs directly in the foreground. `startup.sh` creates the code directories
and copies missing shell/Git/OpenCode configuration. The default database path is
`$HOME/.local/share/opencode/opencode.db`. There is no backup or lifecycle manager.

Set `OPENCODE_PASSWORD` to start the server. Pass `GIT_AUTHOR_NAME`,
`GIT_AUTHOR_EMAIL`, `GIT_COMMITTER_NAME`, and `GIT_COMMITTER_EMAIL` for commits.
Homelab supplies these from Vault; no identity is written into `.gitconfig`.

Connect through the web UI or `opencode --server http://127.0.0.1:4096`.
Don't start another OpenCode service against the same home.

## Git authentication

The helper reads `/etc/dev/credential-map.json`, a JSON array of entries:

```json
[
  {
    "host": "github.com",
    "path_prefix": "danielfrg/",
    "username": "x-access-token",
    "token_file": "github-danielfrg"
  }
]
```
