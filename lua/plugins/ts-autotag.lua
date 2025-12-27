vim.pack.add({
  { src = "https://github.com/windwp/nvim-ts-autotag" },
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("nvim-ts-autotag").setup({})
  end,
})
