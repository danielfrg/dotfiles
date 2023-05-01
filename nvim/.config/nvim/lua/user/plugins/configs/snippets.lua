local status_ok, snippets = pcall(require, "luasnip.loaders.from_vscode")
if not status_ok then return end

snippets.lazy_load()
