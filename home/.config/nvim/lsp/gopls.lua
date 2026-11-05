return vim.tbl_extend("error", {
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
}, require("utils.lsp").server("gopls", {
	tool = "gopls",
	markers = { "go.mod" },
	go_tool = "golang.org/x/tools/gopls",
	install = function()
		return "go get -tool golang.org/x/tools/gopls"
	end,
}))
