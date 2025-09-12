-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- buffers
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- No more navigation using arrow keys
for _, mode in ipairs { "n", "v" } do
  for _, key in ipairs { "<Up>", "<Down>", "<Left>", "<Right>" } do
    map(mode, key, "<nop>")
  end
end

-- Remove spaces at the end of any line
map("n", "<leader>rs", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd [[%s/\s\+$//e]]
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  vim.cmd "nohlsearch"
end, { desc = "Remove trailing spaces" })
