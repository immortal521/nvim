return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      vue = { "eslint" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      markdown = { "eslint" },
    },
    linters = {
      eslint = {
        condition = function(ctx)
          return vim.fs.find(".eslintrc.*", { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
