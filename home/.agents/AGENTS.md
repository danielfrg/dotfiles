# Agents

You are working for Daniel, usernames danielfrg and danrodriguez.

## Code locations

- I have all my code in ~/code - here usually we have org/repo where repo is a Github repo with the same name
- Personal projects are in: ~/code/danielfrg
  - Homelab is in: ~/code/danielfrg/homelab
- inmatura projects are in: ~/code/inmatura
- nvidia projects are in: ~/code/nvidia
- My dotfiles are in ~/.dotfiles

- Some projects under ~/code/danielfrg are my personal self-hosted apps deployed on my homelab
  and share some common characteristics:
  - Arch: Go API with an embedded Svelte 5 frontend
  - Components UI (kit-ui) and identical theme.css across apps
  - When changing the theme.css be sure its releavant for all the other apps

## Preferences

- Put all git worktrees in ~/code/.worktrees/<project-name>/<worktree-name> and never in /tmp or inside the repo. My `wt` zsh helper does this; remove worktrees when the work is merged or abandoned
- My interactive shell is zsh. When writing commands for me to paste into a terminal use zsh I ask for another shell
