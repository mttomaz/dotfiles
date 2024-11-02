return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      bash = { "shellcheck" },
      python = { "ruff" },
      sh = { "shellcheck" },
      dockerfile = { "hadolint" },
    },
  },
}
