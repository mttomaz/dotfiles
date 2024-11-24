return {
  "neovim/nvim-lspconfig",
  lazy = true,
  opts = {
    servers = {
      bashls = {},
      cssls = {},
      lua_ls = {},
      yamlls = {},
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
