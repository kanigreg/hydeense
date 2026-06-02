return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
  },
}
