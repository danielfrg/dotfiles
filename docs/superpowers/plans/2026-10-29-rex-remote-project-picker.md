# Rex remote project picker

> **For agentic workers:** Execute inline using superpowers:executing-plans.

**Goal:** Ctrl+F lists projects from the active Rex host and opens sessions there.

**Architecture:** Keep the native palette and existing create/resume logic. Refresh
project discovery when the palette opens. Use Rex's terminal directory API for a
remote context, and save the resulting host-specific snapshot before the existing
configuration reload. Refuse cached project actions invoked on another host.

**Tech stack:** Rex Lua 5.1, LuaJIT tests, existing dotfiles.

**Spec:** User-approved behavior in this chat: local sessions use Mac projects;
remote sessions use server projects; retain the native picker.

## Constraints and review focus

- Preserve existing project roots, labels, and create/resume behavior.
- Remote directory discovery must not use the Mac's HOME or filesystem.
- Missing optional roots are allowed; failed or truncated listings are errors.
- Cached actions must not open a path on another server after switching hosts.
- Preserve labels containing quotes when saving and reloading the snapshot.
- Preserve unrelated dotfiles changes. The user authorized a local commit of
  this work; do not push.

## Task 1: Refresh native project actions from the active host

- [x] Add behavioral tests for remote discovery, local refresh, safe snapshots,
  stale-host rejection, failed listings, and create/resume routing.
- [x] Run `luajit tests/rex-project-picker.lua`; confirm the new behavior fails.
- [x] Add `projects.refresh(home, cache_dir, ctx)` and cached registration in
  `home/.config/rex/projects.lua`; call refresh from `session_palette` before the
  existing session refresh/reload in `init.lua`.
- [x] Run the Lua suite and `rex config check`.
- [x] Check discovery against a real remote terminal, then deploy the reviewed
  Lua files to the active Mac checkout and reload Rex without restarting it.
- [x] Verify local/remote snapshots and directory/session routing.

## Progress

- Baseline: existing Rex configuration validates (2 bindings, 59 actions).
- Clear fixed first: installed Rex's terminfo using Conda's `tic`; both clear
  binaries and Conda's infocmp pass with TERM=xterm-rex.
- Ruling: use a worktree in the user's requested location because the native
  managed-worktree tool cannot select that destination; preserve working-copy
  deployment and leave the final changes uncommitted.
- Unit suite: 9/9 pass. Real remote discovery returns only /home/danielfrg paths.
- Independent review found no actionable bugs and confirmed the installed RPC
  schemas match the routing and directory-listing assumptions.
- Deployed the two Lua files to the active Mac checkout; config reload generation
  10 succeeded without restarting sessions. Native UI confirmation requested.
- Native UI testing exposed an asynchronous reload race: the first palette showed
  stale actions, while a second opening showed the remote projects. The trace
  confirmed the server had registered the correct list before the UI updated.
- Added a detached, client-specific palette opener with a short UI refresh delay.
  Regression tests failed before the fix and now pass: 10 Lua tests plus the
  shell-helper integration test. Temporary diagnostic code was removed.
- User confirmed first-press local/remote palette switching now works.
- Native project selection then exposed a separate connection-scope bug: remote
  creation succeeded, but the queued Go to Session used the Mac connection.
- Added navigation.lua to resolve the app connection on the target server and
  call client.perform there. Local navigation keeps the original queue. Multiple
  remote windows resolve via the focused block's owner; ambiguous navigation
  fails before creating a session.
- Regression suite: 14 Lua tests plus the shell-helper integration test pass.
- Live verification through the real module created a temporary remote session
  with the requested name and working directory, confirmed the app attached to
  it, and resumed the existing remote homelab session. The temporary session was
  removed. Generation 33 contains this navigation fix. The native forwarded
  client.perform completed successfully over Tailscale, and the user confirmed
  the remote picker now switches to homelab without the error.

- User subsequently requested a local commit. Final verification: 14 Lua tests,
  the shell-helper integration test, shell syntax, TOML parsing, and Rex config
  validation pass. Unrelated Pi settings and Brewfile edits are excluded.
