return {
  "xvzc/chezmoi.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>cz",
      function()
        require("snacks.picker").files({
          cwd = os.getenv("HOME") .. "/.local/share/chezmoi",
          title = "Chezmoi Files",
        })
      end,
      desc = "Find Chezmoi File",
    },
  },
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
