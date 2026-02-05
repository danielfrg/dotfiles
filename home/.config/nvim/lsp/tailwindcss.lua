return {
    cmd = {
        "bun", "run", "@tailwindcss/language-server", "--", "--stdio"
    },
    filetypes = {
        "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact",
    },
    root_markers = {
        "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs", "tailwind.config.mjs",
        "postcss.config.js", "postcss.config.ts", "postcss.config.cjs", "postcss.config.mjs",
        "package.json",
    },
    settings = {
        tailwindCSS = {
            classAttributes = { "class", "className", "ngClass", "class:list" },
            validate = true,
        },
    },
}
