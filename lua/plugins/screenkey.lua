vim.pack.add({
  { src = "https://github.com/NStefan002/screenkey.nvim", version = "main" },
})

require("screenkey").setup({
  win_opts = {
    anchor = "SW",
  },
})

local keys = {
  { "<leader>uk", "<cmd>lua require('screenkey').toggle()<cr>", desc = "Toggle Screenkey" },
}

Utils.keymap.add(keys)
