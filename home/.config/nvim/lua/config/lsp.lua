local lspconfig = require("lspconfig")



if vim.fn.executable("node") == 1 then 
    lspconfig.astro.setup {}
    lspconfig.ts_ls.setup {}
end 

lspconfig.clangd.setup {}
