return {
  "neovim/nvim-lspconfig",
  lazy = true,
  opts = {
    servers = {
      rust_analyzer = {
        enabled = false,
      },
      ruff = {
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
        keys = {
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
        },
      },
    },
  },
}
