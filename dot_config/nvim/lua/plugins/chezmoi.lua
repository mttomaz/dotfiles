-- local telescope = require("telescope")
return {
  "xvzc/chezmoi.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>cz",
      function()
        pcall(require("telescope").extensions.chezmoi.find_files)
      end,
      desc = "Find Chezmoi File",
    },
  },
  config = function()
    local telescope = require("telescope")

    pcall(function()
      telescope.load_extension("chezmoi")
    end)
  end,
}
