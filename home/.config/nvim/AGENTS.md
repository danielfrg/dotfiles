# nvim config

Implement the desired nvim config based on this spec. Add nothing beyond it. 

Check your work lightly:
- Neovim starts without errors: nvim --headless +qa
- New keymaps exist: :verbose map <key>

## Layout

- `init.lua`: enables `vim.loader`, assigns `Utils = require("utils")` (global), then requires in order:
  `config.options`, `config.keymaps`, `config.autocmds`, `config.commands`, `plugins`
- `lua/utils/init.lua`: returns a table of shared helper modules, empty for now.
  Later steps add modules like `utils/editor.lua`.
- `lua/config/`: plain Neovim settings, one file per name above. No plugin code here.
- `lua/plugins/`
  - `init.lua`: installs every plugin in one `vim.pack.add` call, then requires each plugin file
  - One file per plugin (e.g. `oil.lua`), configured with `require("<plugin>").setup({ ... })`.
    Plugin files hold no keymaps.
  - `keymaps.lua`: every keymap that uses a plugin, required last so all plugins are set up first.
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
- Messages: Neovim 0.12's experimental ui2 handles messages. It's turned on at the end of `config/options.lua`.
  - Short messages: corner popup up to 30% of the screen tall, gone after 5 seconds.
  - Long output (errors, `:ls`, `:verbose`, shell commands, progress): a scrollable pager up to half the screen.
  - Search count, search pattern, completion, `:` completion list, and confirm prompts stay in the command line.
  - Output of a command I type goes to the command line too, whatever its kind.
    It expands over the bottom of the screen until the next key. Enter moves it into the pager.

## Autocmds

`lua/config/autocmds.lua`.

- Yanked text flashes briefly.
- Only the active window shows the cursorline.

## Plugins

Use the native nvim.pack to manage them.
In general use one config file per plugin.

## Languages

Per-language settings that differ from the global options live in `after/ftplugin/<filetype>.lua`.

Set them explicitly even when a built-in ftplugin already does the same, so the config is self-documenting.

- Python: 4-space indent (PEP 8).
