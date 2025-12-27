vim.pack.add({
  { src = "https://github.com/NStefan002/screenkey.nvim", version = "main" },
})

local keys = {
  { "<leader>uk", "<cmd>lua require('screenkey').toggle()<cr>", desc = "Toggle Screenkey" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("screenkey").setup({
      win_opts = {
        anchor = "SW",
      },
    })
    Utils.keymap.add(keys)
  end,
})
