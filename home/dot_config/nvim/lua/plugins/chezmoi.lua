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
  opts = {
    edit = {
      watch = true,
      force = false,
    },
  },
  config = function()
    local telescope = require("telescope")

    pcall(function()
      telescope.load_extension("chezmoi")
    end)
  end,
  init = function()
    -- run chezmoi edit on file enter
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
      callback = function()
        vim.schedule(require("chezmoi.commands.__edit").watch)
      end,
    })
  end,
}
