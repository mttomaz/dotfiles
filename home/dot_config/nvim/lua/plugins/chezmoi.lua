return {
  "xvzc/chezmoi.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>cz",
      function()
        require("snacks.picker").files {
          cwd = os.getenv "HOME" .. "/.local/share/chezmoi",
          title = "Chezmoi Files",
          hidden = true,
        }
      end,
      desc = "Find Chezmoi File",
    },
  },
  init = function()
    -- run chezmoi edit on file enter
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { os.getenv "HOME" .. "/.local/share/chezmoi/home/*" },
      callback = function(args)
        local filepath = args.file

        -- ignore files inside ".chezmoiscripts/"
        if filepath:find "/%.chezmoiscripts/" then
          return
        end

        -- ignore files inside ".ssh/"
        if filepath:find "/%.ssh/" then
          return
        end

        vim.schedule(require("chezmoi.commands.__edit").watch)
      end,
    })
  end,
}
