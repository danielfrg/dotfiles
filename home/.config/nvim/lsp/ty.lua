local function install(_, declared)
	return declared and "uv sync" or "uv add --dev ty"
end

return vim.tbl_extend("error", {
	filetypes = { "python" },
}, require("utils.lsp").server("ty", {
	tool = "ty",
	markers = { "pyproject.toml" },
	bin = ".venv/bin/ty",
	args = { "server" },
	install = install,
}))
