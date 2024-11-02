return {
  "neovim/nvim-lspconfig",
  lazy = true,
  opts = {
    setup = {
      rust_analyzer = function()
        return true
      end,
    },
    servers = {
      bashls = {},
      cssls = {},
      lua_ls = {},
      ruff = {},
      yamlls = {},
    },
  },
}
