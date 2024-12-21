-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.wo.relativenumber = true
vim.opt.wrap = true
vim.g.autoformat = false
vim.g.lazyvim_picker = "telescope"
vim.g.snacks_animate = false

vim.opt.spell = false
vim.opt.spelllang = { "en_us", "pt_br" }
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "ruff"
vim.g.lazyvim_python_ruff = "ruff"
