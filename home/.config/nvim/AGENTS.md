# nvim config

Implement the desired nvim config based on this spec. Add nothing beyond it. 

Check your work lightly:
- Neovim starts without errors: nvim --headless +qa
- New keymaps exist: :verbose map <key>

## Layout

- `init.lua`: enables `vim.loader`, assigns `Utils = require("utils")` (global), then requires in order:
  `config.options`, `config.keymaps`, `config.autocmds`, `config.commands`, `config.lsp`, `plugins`
- `lua/utils/init.lua`: returns a table of shared helper modules (`statusline`, `lsp`).
- `lua/config/`: plain Neovim settings, one file per name above. No plugin code here.
- `lua/plugins/`
  - `init.lua`: installs every plugin in one `vim.pack.add` call, then requires each plugin file
  - One file per plugin (e.g. `oil.lua`), configured with `require("<plugin>").setup({ ... })`.
    Plugin files hold no keymaps.
  - `keymaps.lua`: every keymap that uses a plugin, required last so all plugins are set up first.
- `lsp/<name>.lua`: one native `vim.lsp.config` per language server (see LSP).
- `.gitignore` lists `nvim-pack-lock.json`.
- Lua files are indented with tabs, formatted by stylua with its defaults.

## Options

Only set what differs from Neovim defaults

- Leader and local leader are Space.
- Indent is 2 spaces: tabstop, shiftwidth, softtabstop 2; expandtab, smartindent, breakindent on
- Look of the buffer:
  - Hybrid line numbers (number + relativenumber).
  - cursorline on, highlighting the line and the number.
  - signcolumn always on, so text doesn't jump when git or diagnostic marks appear.
  - scrolloff 10, sidescrolloff 10.
  - colorcolumn at 80.
  - Diagonal `╱` fill in empty diff areas.
  - showmode off (the statusline shows the mode). No intro screen.
  - Rounded borders on every float (winborder). Popup menu at most 10 rows.
- Search:
  - ignorecase + smartcase.
  - inccommand split: preview substitutions in a split.
  - path adds `**`, so `:find` searches subfolders.
  - wildignore skips `*/node_modules/*`, `*.o`, `*.obj`, `*.pyc`, `*.class`, `*.DS_Store`, `*/.git/*`.
- Files: swapfile off, persistent undo on (default undodir).
- Timing: updatetime 250, timeoutlen 300.
- New splits open below and to the right.
- Folds come from Treesitter, foldlevel 99 so everything starts unfolded.
- Completion: Neovim's built-in, no plugin.
  - The menu opens as you type (`autocomplete`).
  - Sources: the LSP first (`complete` starts with `o`, the LSP omnifunc), then buffer words.
  - `completeopt`: menuone, noselect, popup (shows item docs), fuzzy.
  - Autocomplete never preselects an item (Neovim forces `noselect`), so `<C-y>` with nothing
    selected accepts the first item. `<C-n>` / `<C-p>` move, `<C-e>` cancels.
- Statusline: my own, no plugin, in `utils/statusline.lua` (exposed as `Utils.statusline`).
  - Left: mode block (`NOR`, `INS`, `VIS`, `COM`, ...) colored by mode: normal blue, insert green,
    visual purple, command yellow (`StatusMode*` groups, set in `plugins/onedark.lua`).
  - Then the file path relative to cwd, with help/preview/modified/readonly flags.
  - Right: attached LSP clients as `[name1, name2]`, then `line:column`.
- Messages: Neovim 0.12's experimental ui2 handles messages. It's turned on at the end of `config/options.lua`.
  - Short messages: corner popup up to 30% of the screen tall, gone after 5 seconds.
  - Long output (errors, `:ls`, `:verbose`, shell commands, progress): a scrollable pager up to half the screen.
  - Search count, search pattern, completion, `:` completion list, and confirm prompts stay in the command line.
  - Output of a command I type goes to the command line too, whatever its kind.
    It expands over the bottom of the screen until the next key. Enter moves it into the pager.

## Autocmds

- Yanked text flashes briefly.
- Only the active window shows the cursorline.

## Keymaps

core keymaps that don't use a plugin.

| Keys | Action |
|---|---|
| Arrow keys (normal, insert) | Disabled, echo a hint to use hjkl |
| `<Esc>` | Clears search highlight |
| `n` / `N` | Next/previous match, centered and unfolded |
| `<leader>rr` | Substitute the word under the cursor across the file |
| `<C-d>` / `<C-u>` | Half-page scroll, cursor centered |
| `>` / `<` (visual) | Indent and stay in visual mode |
| `J` / `K` (visual) | Move selected lines down/up |
| `<C-y>` (insert) | Accept completion; the first item when none is selected |
| `<leader>o` / `<leader>O` | Open a line below/above without continuing a comment (`o<Esc>^Da`) |
| `<leader>y` (visual) | Yank to the system clipboard |
| `<leader>p` | Paste from the system clipboard |
| `<leader>d` (visual) | Delete without touching the yank register |
| `<leader>n` | New empty buffer |
| `<leader>z` | Close buffer |
| `<S-h>` / `<S-l>` | Previous/next buffer |
| `<leader>bd` | Close every hidden buffer, except unsaved ones |
| `<leader>\|` / `<leader>-` | Vertical/horizontal split |
| `<C-Arrows>` | Resize window |
| `<leader>q` | Diagnostics to the location list |
| `<C-f>` | Rex project picker (`~/.local/scripts/project-session-rex.sh --palette`) |

## Commands

- Typo commands: `:W` saves, `:Wq` / `:WQ` save and quit, `:Q` quits without saving.
- `:LspInfo` runs `:checkhealth vim.lsp`.

## LSP

No Mason and no global installs. Each project declares and installs the language servers it needs;
Neovim only starts a server when the project has it.

- `config/lsp.lua` enables the servers, configures diagnostics and LSP keymaps, and turns on
  `vim.lsp.completion` on attach so accepting an item applies its extras (auto-imports, snippets).
- `lsp/<name>.lua` defines each server with native `vim.lsp.config`, using `utils/lsp.lua` to find it in the project.
- How a server is found (`utils/lsp.lua`):
  - The project root is the nearest marker file (`pyproject.toml`, `package.json`, `go.mod`, ...).
  - The binary is the project's own: walk up from the file to the first `node_modules/.bin/<bin>` or
    `.venv/bin/<bin>` (so pnpm monorepos work when the tool is in the workspace root).
    That directory becomes the LSP root and the server's cwd. Go runs `go tool gopls` when `go.mod` has a `tool` line for it.
  - Some servers are only expected when the project uses them (e.g. tailwind only if `package.json` mentions `tailwindcss`).
- Missing servers: when the project expects a server but it isn't installed, show one notice listing them with the fix
  (`pnpm install` / `uv sync` if declared, otherwise `pnpm add -D ...` / `uv add --dev ...` / `go get -tool ...`).
  - On startup for the project in cwd, and when opening a file in another project.
  - Once per tool and project, grouped into a single notice.

| Server | Filetypes | Project needs | Expected when |
|---|---|---|---|
| `ruff` | python | `.venv/bin/ruff` (`uv add --dev ruff`) | `pyproject.toml` |
| `ty` | python | `.venv/bin/ty` (`uv add --dev ty`) | `pyproject.toml` |
| `ts_ls` | js, jsx, ts, tsx | `typescript-language-server` devDep | `package.json` mentions `typescript`, or `tsconfig.json` exists |
| `svelte` | svelte | `svelte-language-server` devDep | `package.json` mentions `svelte` |
| `astro` | astro | `@astrojs/language-server` devDep (uses the project's TypeScript) | `package.json` mentions `astro` |
| `tailwindcss` | html, css, scss, js, jsx, ts, tsx, svelte, astro | `@tailwindcss/language-server` devDep | `package.json` mentions `tailwindcss` |
| `gopls` | go, gomod, gowork, gotmpl | `tool golang.org/x/tools/gopls` in `go.mod` | `go.mod` |

Diagnostics:
- Virtual text, underline, not updated while typing, sorted by severity.
- Floats show the source.
- Gutter icons: error `󰅚`, warn `󰀪`, info `󰋽`, hint `󰌶`. Errors and warnings also color the line number.

Keymaps (buffer-local on LspAttach), on top of Neovim's defaults (`K`, `grn`, `gra`, `grr`, `gri`, `grt`, `gO`, `<C-s>`, `[d`, `]d`):

| Keys | Action |
|---|---|
| `gl` | Diagnostic float |
| `gD` | Go to definition |
| `<leader>lr` | Rename |

Info: `:LspInfo` (`:checkhealth vim.lsp`), `:lsp restart` / `:lsp stop`, attached servers in the statusline.

## Plugins

Use the native nvim.pack to manage them.
In general use one config file per plugin.

### Colorscheme

Active: onedark.nvim (`navarasu/onedark.nvim`), `dark` style, loaded in `plugins/onedark.lua`.

Syntax colors follow Zed's built-in One Dark (`assets/themes/one/one.json` in the Zed repo),
so both editors look the same.
### Icons

mini.icons, also mocking nvim-web-devicons, so every plugin uses one icon source.

### File explorer

oil.nvim, not the default file explorer (netrw stays).

- Columns: icon. Shows hidden files. Deletes go to the trash.
- Opens as a float with 10 padding.
- Inside oil: `<C-h>` unmapped, `<M-h>` opens in a split.

### Treesitter

nvim-treesitter, main branch.

- Ensures parsers: python, ninja, c, cpp, astro, html, css, javascript, typescript, tsx,
  vim, vimdoc, lua, query, bash, just, markdown, markdown_inline, rst, toml, terraform, yaml.
- A FileType autocmd starts highlighting and Treesitter indent whenever a parser exists.
- `:TSUpdate` runs on the PackChanged event, so parsers stay in sync with the plugin version.

### Editing

- mini.pairs with defaults.
- mini.surround with defaults: `sa` add, `sd` delete, `sr` replace (e.g. `saiw)`, `sd"`, `sr)"`).

### Git

gitsigns.nvim with defaults.

### Jumping

flash.nvim with defaults.

### Fuzzy finder

telescope.nvim (with plenary.nvim), plus two extensions:
- telescope-fzf-native: native fzf sorter, smart case. Built with `make` on the PackChanged event.
- telescope-ui-select: `vim.ui.select` (code actions, etc.) uses telescope's dropdown.

Settings:
- Ignores `.git/` and `node_modules`. Find files includes hidden files.
- Grep uses ripgrep, following symlinks, smart case.
- In normal mode inside a picker: `d` deletes the buffer (buffers picker), `q` closes.

### Undo tree

Neovim 0.12's built-in undotree (`packadd nvim.undotree`), no plugin. Loaded in `plugins/undotree.lua`.

### Formatting

conform.nvim, format on save (1000 ms timeout).

- JS/TS, svelte, json, css, scss, html, markdown, yaml: the first one the project has of oxfmt, biome, prettier.
  Only from the project's `node_modules/.bin`, never a global install.
  oxfmt (the standard for my projects) doesn't format `.svelte` / `.astro` files yet; it passes them through unchanged.
- Python formats through ruff's LSP and Go through gopls. No other LSP formats.
- Projects without a formatter save as-is, with no notice. `:ConformInfo` shows what's available.

### Keymap hints

which-key.nvim with defaults. Groups: `<leader>b` Buffers, `<leader>g` Git, `<leader>l` LSP, `<leader>s` Search.

### Plugin keymaps

`lua/plugins/keymaps.lua`.

| Keys | Action |
|---|---|
| `-` | Toggles oil as a float |
| `<CR>` (normal, visual, operator-pending) | Flash jump. In quickfix and the command-line window `<CR>` keeps its default (open the entry) |
| `<leader><leader>` / `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep the word under the cursor |
| `<leader>sb` | Buffers, most recently used first |
| `<leader>s.` | Recent files |
| `<leader>sr` | Resume the last picker |
| `<leader>sd` | Diagnostics |
| `<leader>sh` / `<leader>sk` / `<leader>ss` | Help / keymaps / list of pickers |
| `<leader>/` | Fuzzy search in the current buffer (dropdown, no preview) |
| `<leader>gc` / `<leader>gs` | Git commits / git status |
| `<leader>u` | Toggles the built-in undo tree |
| `<leader>lf` | Format (conform) |

## Languages

Per-language settings that differ from the global options live in `after/ftplugin/<filetype>.lua`.

Set them explicitly even when a built-in ftplugin already does the same, so the config is self-documenting.

- Python: 4-space indent (PEP 8).
