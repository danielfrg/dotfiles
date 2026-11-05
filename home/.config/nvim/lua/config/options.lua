-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indent
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.breakindent = true

-- Look of the buffer
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "line,number"
vim.o.signcolumn = "yes"
vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.o.colorcolumn = "80"
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars:append({ diff = "╱" })
vim.o.showmode = false
vim.opt.shortmess:append("I")
vim.o.winborder = "rounded"
vim.o.pumheight = 10

-- Completion: built-in autocomplete as you type, LSP (omnifunc) first, then buffer words
vim.o.autocomplete = true
vim.opt.complete:prepend("o")
vim.o.completeopt = "menuone,noselect,popup,fuzzy"
vim.o.statusline = "%{%v:lua.Utils.statusline.render()%}"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.opt.path:append("**")
vim.opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.DS_Store", "*/.git/*" })

-- Files and undo
vim.o.swapfile = false
vim.o.undofile = true

-- Timing
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Folds
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99

-- Messages: experimental ui2
require("vim._core.ui2").enable({
	msg = {
		-- Short messages go to the corner popup
		target = "msg",
		-- Trigger takes precedence over kind
		targets = {
			-- Output of a command I type stays in the command line, whatever its kind
			typed_cmd = "cmd",
			-- Long output goes to the pager
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_out = "pager",
			shell_err = "pager",
			shell_ret = "pager",
			progress = "pager",
			-- These stay in the command line
			search_cmd = "cmd",
			search_count = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
		},
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
