return {
    cmd = {
        "bunx", "--bun", "typescript-language-server", "--stdio"
    },
    filetypes = {
        "javascript", "typescript", "javascriptreact", "typescriptreact", "js", "jsx", "ts", "tsx",
    },
    root_markers = {
        "bun.lock", "tsconfig.json", "package.json"
    },
}
