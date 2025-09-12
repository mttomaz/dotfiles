return {
  "mason-org/mason.nvim",
  lazy = true,
  opts = {
    ensure_installed = {
      "stylua", -- lua
      "lua-language-server", -- lua
      "shellcheck", -- sh, bash
      "bash-language-server", -- bash
      "pyright", -- python
      "ruff", -- python
      "yaml-language-server", -- yaml
      "jdtls", -- java
      "typescript-language-server", -- typescript, javascript
      "hadolint", -- docker
      "css-lsp", -- css
      "prettier", -- html, css, javascript, json
    },
  },
}
