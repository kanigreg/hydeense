local bothub_api_adapter = require("plugins.codecompanion.bothub_adapter")
local yandex_ai_adapter = require("plugins.codecompanion.yandex_ai_adapter")

return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI chat" },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New AI chat" },
    { "<leader>a", "<cmd>CodeCompanionActions<cr>", mode = "v", desc = "AI menu" },
  },
  opts = {
    interactions = {
      chat = {
        adapter = "bothub_api",
      },
      inline = {
        adapter = "bothub_api",
      },
    },
    adapters = {
      acp = {
        show_defaults = false,
      },
      http = {
        opts = {
          show_defaults = false,
          show_model_choices = true,
        },
        yandex_ai = yandex_ai_adapter,
        bothub_api = bothub_api_adapter,
      },
      deepseek = function()
        return require("codecompanion.adapters").extend("deepseek", {
          url = "https://agent.timeweb.cloud/api/v1/cloud-ai/agents/4b3e3409-5148-43ab-b278-c0ff2c5e4410/v1/chat/completions",
          env = {
            api_key = "cmd:dot-bws timeweb_ai_token",
          },
        })
      end,
    },
  },
}
