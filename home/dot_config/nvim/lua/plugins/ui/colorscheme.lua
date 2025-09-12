return {
  -- Add kanagawa
  {
    "mttomaz/kanagawa.nvim",
    opts = {
      transparent = true,
    },
  },

  -- Configure LazyVim to load kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
      style = "dragon",
    },
  },
}
