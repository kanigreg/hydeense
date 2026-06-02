-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>bo", Snacks.bufdelete.other, { desc = "Close other buffers" })

map("n", "<leader>fd", function()
  local filename = os.date("%B/%d-%a")
  local path = "~/Documents/neonotes/daily/" .. filename .. ".md"
  vim.cmd("e " .. path)
end, { desc = "Go to daily file" })

map("n", "<leader>fD", function()
  local filename = os.date("%B/%d-%a")
  local root_dir = require("lazyvim.util").root()
  local path = root_dir .. "/.local/daily/" .. filename .. ".md"
  vim.cmd("e " .. path)
end, { desc = "Go to local daily file" })
