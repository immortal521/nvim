return {
  "stevearc/conform.nvim",
  opts = function()
    local opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettier" },
        go = { "goimports" },
        html = { "prettier" },
        java = { "google-java-format" },
        javascript = { "prettier" },
        json = { "prettier" },
        jsx = { "prettier" },
        lua = { "stylua" },
        less = { "prettier" },
        nu = { "shfmt" },
        python = { "ruff" },
        rust = { "rustfmt", lsp_format = "fallback" },
        scss = { "prettier" },
        svg = { "xmlformatter" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        xml = { "xmlformatter" },
        yml = { "prettier" },
        yaml = { "prettier" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        xmlformatter = {
          args = {
            "--indent",
            "2", -- 指定缩进
            "--infile",
            "$FILENAME", -- 输入文件名
          },
        },
      },
    }
    return opts
  end,
}
