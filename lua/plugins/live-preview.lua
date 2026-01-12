vim.pack.add({
  { src = "https://github.com/brianhuster/live-preview.nvim" },
})

local keys = {
  { "<leader>cps", "<cmd>LivePreview start<cr>", desc = "Live Preview Start" },
  { "<leader>cpc", "<cmd>LivePreview close<cr>", desc = "Live Preview Stop" },
  { "<leader>cpp", "<cmd>LivePreview pick<cr>", desc = "Live Preview Select" },
}

require("livepreview").setup({})

Utils.keymap.add(keys)
