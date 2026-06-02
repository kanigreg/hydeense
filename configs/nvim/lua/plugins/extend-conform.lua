return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      ruby = { "rubocop", command = "bundle exec rubocop" },
      json = { "jq" },
      yaml = { "yq" },
      toml = { "taplo" },
      xml = { "xmlformatter" },
      html = { "prettier" },
      css = { "prettier" },
    },
  },
}
