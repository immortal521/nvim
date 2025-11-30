vim.pack.add({
  { src = "https://github.com/rebelot/heirline.nvim" },
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("SetupHeirline", { clear = true }),
  once = true,
  callback = function()
    require("heirline").setup({
      statusline = require("plugins.heirline.statusline"),
      tabline = require("plugins.heirline.tabline"),
    })
  end,
})
