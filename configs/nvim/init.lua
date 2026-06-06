-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.lsp.enable("kotlin_lsp")
vim.lsp.config("kotlin_lsp", {
  single_file_support = false,
})
vim.lsp.config("kotlin_lsp", {
  cmd = { "faketime", "2026-06-04", "kotlin-lsp", "--stdio" },
})
