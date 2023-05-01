local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  return
end

wk.setup({
  icons = {
    group = "", -- remove the symbol prepended to a group
  },
  window = {
    border = "single"
  }
})

-- Group names
wk.register({
  f = { name = "󰍉 Find" },
  l = { name = " LSP" },
  x = { name = " Trouble" },
}, { prefix = "<leader>" })
