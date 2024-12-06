return {
  -- Add kanagawa
  { "MatheusTT/kanagawa.nvim" },

  -- Configure LazyVim to load kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
      style = "dragon",
    },
  },
}
