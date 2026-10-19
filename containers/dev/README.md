# Daniel's Linux development image

Build from the dotfiles repository:

```zsh
docker build --platform linux/amd64 -t daniel-dev:test -f containers/dev/Dockerfile containers/dev
python3 -m unittest discover -s containers/dev/tests -v
```

The baseline is Debian, Node 26, pnpm 10, Go 1.25, uv, OpenCode V2, Bun,
Git/Git LFS/GitHub CLI, just, common native build tools, Kubernetes/ArgoCD/Helm,
Terraform, Ansible, pre-commit, Chromium prerequisites, FFmpeg, and a minimal shell.
Tools must be available in noninteractive shells as well as Zsh.

Public binary downloads are SHA-256 pinned in `tools.lock.json`; Node and Go
images are digest pinned. Debian packages and transitive npm/Python dependencies
are resolved during build, so this is not a bit-for-bit reproducible image.
`versions.env` pins direct npm/Python tools. uv resolves current supported managed
Python patch releases for requested minor versions. Additional project dependencies
and toolchains are installed per project, not globally baked into the image.

The account is `danielfrg`, UID/GID 1000:1000. Container-only sudo is available for
missing OS packages; these changes disappear when the container is replaced, so
add lasting dependencies to the Dockerfile. No host socket or privileged runtime
is provided. This image does not provide a Docker daemon or local Compose builds.

No GPU/CUDA, Vite+, Rex server, or SSH server. Do not copy the Mac-oriented dotfiles
home or laptop credentials into the image. The homelab repository owns deployment,
NAS paths, runtime secrets, administrative grants, and backup policy.

## Persistent runtime

`dev-entrypoint bootstrap` initializes only missing configuration, code directories,
and writable user paths. It never overwrites an existing `.zshrc` or OpenCode config.
`serve` requires a nonempty `server-password` file under
`/run/secrets/opencode-runtime`, sets service configuration through OpenCode V2,
then execs `opencode serve --service`. The normal TUI and `opencode pair` discover
this same foreground-managed service. Use `--entrypoint zsh` for a shell-only
container; the default command starts the server, not a shell.

Mount your persistent home at `/home/danielfrg`; verify its UID/GID permissions.
Bind the server port only to localhost for local testing. Kubernetes uses a
ClusterIP plus port-forward, not public exposure. `DEV_PROFILE_DIR` and
`DEV_RUNTIME_SECRET_DIR` allow local profile/secret-directory selection; their
defaults are `/opt/dev/profile` and `/run/secrets/opencode-runtime`.

`OPENCODE_DB` must equal `$HOME/.local/share/opencode/opencode.db`; the launcher
rejects relocation. It never patches SQLite settings or starts a hidden local DB.
One lock-held server uses the home. `health` makes an authenticated HTTP health
request without starting a server or opening its database.

`dev-entrypoint backup` uses SQLite's online backup API inside the same container,
validates integrity, and publishes private timestamped artifacts under
`~/.local/share/opencode/backups`. It retains the newest seven successful artifacts,
preserves unrelated files, and fails without replacing older backups. Schedule and
off-NAS retention belong to deployment operations. Never copy only a live `.db`
file or start another OpenCode server on the same database for a restore check.

Client disconnects do not govern the server's lifetime. Container/pod termination
still interrupts active processes. The local container tests cover authentication,
pairing, graceful SIGTERM, initialization, and backups; they do not prove NFS WAL
safety or guarantee job resumption.

## Git authentication

The helper reads `/etc/dev/credential-map.json`, a JSON array of entries:

```json
[{"host":"github.com","path_prefix":"danielfrg/","username":"x-access-token","token_file":"github-danielfrg"}]
```

`token_file` is a basename under `/run/secrets/opencode-git`. The helper reads it
fresh on each `get`, including Kubernetes secret-volume symlink rotation. It sends
credentials only through Git's private protocol, only for HTTPS and the configured
host/path boundary. Unknown hosts/owners get no credential; unavailable configured
tokens fail without disclosure. `store`/`erase` never write credentials.
`DEV_CREDENTIAL_MAP` and `DEV_GIT_SECRET_DIR` select local test/custom directories.

Bootstrap adds only missing Git identity/credential settings. It never overwrites
your existing identity, signing preferences, or credential helper. New homes use
Daniel Rodriguez <daniel@danielfrg.com>; override per repository when appropriate.
GitHub organization/owner tokens and Forgejo credentials are separate enrollments.
Use HTTPS remotes, not laptop SSH-agent forwarding, for unattended work.

For the GitHub CLI, authenticate through `gh auth login --with-token` with stdin
redirected from the chosen mounted token file, or supply `GH_TOKEN` from that file
for the specific invocation. Do not echo it, put it in a remote URL, or persist it
in shell history. CLI cached authentication does not automatically track secret
rotation; repeat enrollment when rotating it. Signing keys are separate opt-ins.
