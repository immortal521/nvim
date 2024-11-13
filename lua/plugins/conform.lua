return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      formatters_by_ft = {
        css = { "prettier" },
        go = { "goimports" },
        html = { "prettier" },
        java = { "google-java-format" },
        javascript = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        less = { "prettier" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        rust = { "rustfmt", lsp_format = "fallback" },
        scss = { "prettier " },
        typescript = { "prettier" },
        vue = { "prettier" },
        yml = { "prettier" },
        yaml = { "prettier" },

        ["*"] = { "codespell", "prettier" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- prettier = {

        -- condition = function(ctx)
        -- return vim.fs.find(
        -- { ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.yaml", ".prettierrc.yml" },
        -- { path = ctx.filename, upward = true }
        -- )[1] ~= nil
        -- end,
        -- },
      },
    }
    return opts
  end,
}
