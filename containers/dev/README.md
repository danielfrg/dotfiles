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
