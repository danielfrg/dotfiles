-- local status_ok, ufo = pcall(require, "ufo")
-- if not status_ok then
--     return
-- end

-- ufo.setup({
--     -- Use treesitter
--     provider_selector = function(bufnr, filetype, buftype)
--         return { 'treesitter', 'indent' }
--     end,
-- }
-- )

-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.foldcolumn = '1'    -- '0' is not bad
-- vim.o.foldlevel = 10      -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = 10 -- Dont font initially
-- vim.o.foldenable = true
