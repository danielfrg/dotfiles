# Daniel's Linux workspace

Code lives under ~/code/danielfrg, ~/code/inmatura, and ~/code/nvidia.
Clone independent checkouts on demand. Use separate worktrees for concurrent edits.
Use Zsh for shell commands, and project lockfiles for dependencies.
No Vite+, GPU tools, Docker daemon, Rex server, or SSH server are provided.
All persistent data, including SQLite, is on the home volume. NFS/SQLite is an
accepted experiment: report locking/integrity failures instead of changing storage.
Never log credentials or embed them in Git remote URLs.
Broad permissions are not blanket authorization for unrelated or destructive work.
When present, also read /etc/dev/AGENTS.md for homelab-specific instructions.
