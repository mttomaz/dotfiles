return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  opts = {
    buttons = {
      {
        label = "dotfiles",
        url = "https://github.com/mttomaz/dotfiles",
      },
      {
        label = "wallpapers",
        url = "https://github.com/mttomaz/wallpapers",
      },
    },
  },
}
