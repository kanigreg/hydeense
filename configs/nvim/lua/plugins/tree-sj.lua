return {
  "Wansmer/treesj",
  keys = {
    { "<leader>m", "<Cmd>TSJToggle<CR>", desc = "Toggle block (tree-sj)" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("treesj").setup({ use_default_keymaps = false })
  end,
}
