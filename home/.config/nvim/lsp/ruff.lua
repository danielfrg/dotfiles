local function install(_, declared)
	return declared and "uv sync" or "uv add --dev ruff"
end

return vim.tbl_extend("error", {
	filetypes = { "python" },
	settings = {},
}, require("utils.lsp").server("ruff", {
	tool = "ruff",
	markers = { "pyproject.toml" },
	bin = ".venv/bin/ruff",
	args = { "server" },
	install = install,
}))
