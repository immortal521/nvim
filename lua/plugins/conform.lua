return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      formatters_by_ft = {
        vue = {  "prettier" },
        javascript = {  "prettier" },
        typescript = {  "prettier" },
        less = { "prettier" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        prettier = {
        condition = function(ctx)
            return vim.fs.find({ ".prettierrc.json" }, { path = ctx.filename, upward = true })[1] ~= nil
        end,
        },
      },
    }
    return opts
  end,
}
