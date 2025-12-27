vim.pack.add({
  { src = "https://github.com/wakatime/vim-wakatime" },
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("wakatime")
  end,
})
