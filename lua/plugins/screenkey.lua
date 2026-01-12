vim.pack.add({
  { src = "https://github.com/NStefan002/screenkey.nvim", version = "main" },
})

local keys = {
  { "<leader>uk", "<cmd>lua require('screenkey').toggle()<cr>", desc = "Toggle Screenkey" },
}

require("screenkey").setup({
  win_opts = {
    relative = "editor",
    row = vim.o.lines - 1,
    col = vim.o.columns - 32,
    height = 3,
    width = 20,
    border = "rounded",
    title = "",
  },
})
Utils.keymap.add(keys)
