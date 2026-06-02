return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local cc_spinner = require("plugins.codecompanion.lualine_spinner")

      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      table.insert(opts.sections.lualine_x, cc_spinner)
    end,
  },
}
