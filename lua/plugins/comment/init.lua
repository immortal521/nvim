vim.pack.add({
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/danymat/neogen" },
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("plugins.comment.ts-comments")
    require("plugins.comment.todo-comments")
    require("plugins.comment.neogen")
  end,
})
