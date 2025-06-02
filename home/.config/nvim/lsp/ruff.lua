return {
    cmd = {
        "uv", "run", "ruff", "server",
    },
    filetypes = {
        "python", "py", "pyi", "pyw"
    },
    root_markers = {
        "pyproject.toml"
    },
    settings = {
        -- Ruff language server settings go here
    },
}
