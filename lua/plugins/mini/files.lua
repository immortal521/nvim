local MiniFiles = require("mini.files")

MiniFiles.setup({
  options = {
    use_as_default_explorer = false,
  },
  windows = {
    -- Maximum number of windows to show side by side
    max_number = 3,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 20,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 50,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    require("snacks").rename.on_rename_file(event.data.from, event.data.to)
  end,
})

local keys = {
  { "<leader>e", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>" },
}

Utils.keymap.add(keys)
