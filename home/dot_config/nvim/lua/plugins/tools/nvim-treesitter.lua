return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  opts = {
    ensure_installed = {
      "bash",
      "dockerfile",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "dart",
      "java",
      "query",
      "regex",
      "vim",
      "yaml",
    },
  },
}
