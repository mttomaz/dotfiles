-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.wo.relativenumber = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.g.autoformat = false
vim.g.lazyvim_picker = "snacks"
vim.g.snacks_animate = false
vim.wo.colorcolumn = "100"

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
