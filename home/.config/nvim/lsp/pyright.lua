return {
    cmd = {
        "uv", "run", "pyright-langserver", "--stdio",
    },
    filetypes = {
        "python", "py", "pyi", "pyw"
    },
    root_markers = {
        "pyproject.toml"
    },
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
}
