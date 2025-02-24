return {
  "nvim-flutter/flutter-tools.nvim",
  ft = "dart",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>fd",
      "<cmd>FlutterDevices<cr>",
      desc = "Select a flutter device to run.",
    },
  },
  config = {
    decorations = {
      statusline = {
        device = true,
        project_config = true,
      },
    },
    dev_log = {
      enabled = false,
      open_cmd = "tabnew",
    },
    lsp = {
      settings = {
        showTodos = true,
        completeFunctionCalls = true,
        renameFilesWithClasses = "prompt",
        enableSnippets = true,
        updateImportsOnRename = true,
      },
    },
  },
}
