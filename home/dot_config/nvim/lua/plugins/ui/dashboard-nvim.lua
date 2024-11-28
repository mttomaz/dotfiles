return {
  "nvimdev/dashboard-nvim",
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  opts = function()
    local logo = [[
	=================     ===============     ===============   ========  ========
	\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
	||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
	|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
	||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
	|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
	||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
	|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
	||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
	||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
	||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
	||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
	||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
	||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
	||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
	||.=='    _-'                                                     `' |  /==.||
	=='    _-'                        N E O V I M                         \/   `==
	\   _-'                                                                `-_   /
	 `''                                                                      ``' 
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "SPC f f" },
          { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "SPC f r" },
          { action = 'lua LazyVim.pick.config_files()()',              desc = " Config Files",    icon = " ", key = "SPC f c" },
          { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "SPC f n" },
          { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "SPC q s" },
          { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "SPC l" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
