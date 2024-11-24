return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>ci",
      "<cmd>ConformInfo<cr>",
      desc = "Show Conform Info",
    },
  },
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
      bash = { "shfmt" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      javascript = { "prettier" },
      json = { "prettier" },
      lua = { "stylua" },
      python = { "ruff_format" },
      yaml = { "prettier" },
      rust = { "rustfmt" },
    },
    formatters = {
      ruff_format = {
        prepend_args = { "--config", "indent-width=2", "--config", "line-length=100" },
      },
      rustfmt = {
        prepend_args = { "--config", "tab_spaces=2", "--config", "max_width=100" },
      },
    },
  },
}
