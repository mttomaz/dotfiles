return {
  "williamboman/mason.nvim",
  lazy = true,
  opts = {
    ensure_installed = {
      "stylua", -- lua
      "lua-language-server", -- lua
      "shellcheck", -- sh, bash
      "bash-language-server", -- bash
      "ruff", -- python
      "rust-analyzer", -- rust
      "yaml-language-server", -- yaml
      "jdtls", -- java
      "hadolint", -- docker
      "css-lsp", -- css
      "prettier", -- html, css, javascript, json
    },
  },
}
