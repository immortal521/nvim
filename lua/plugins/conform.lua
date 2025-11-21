local wk = require("which-key")

local function has_prettier_config(ctx)
  vim.fn.system({ "prettier", "--find-config-path", ctx.filename })
  return vim.v.shell_error == 0
end

local function has_prettier_parser(ctx)
  local ret = vim.fn.system({ "prettier", "--file-info", ctx.filename })
  local ok, info = pcall(vim.fn.json_decode, ret)
  return ok and info.inferredParser and info.inferredParser ~= vim.NIL
end

require("conform").setup({
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
  },
  notify_on_error = true,
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang-format" },
    python = { "yapf", "isort" },
    sh = { "shfmt" },
    snakemake = { "snakefmt" },
    typst = { "typstyle" },
    nix = { "nixfmt" },
    toml = { "taplo" },
    tex = { "tex-fmt" },
    go = { "goimports", "gofumpt" },
    css = { "prettier" },
    graphql = { "prettier" },
    rust = { "rustfmt" },
    handlebars = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    less = { "prettier" },
    markdown = { "prettier" },
    ["markdown.mdx"] = { "prettier" },
    scss = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    yaml = { "prettier" },
  },
  formatters = {
    cbfmt = { command = "cbfmt", args = { "-w", "--config", vim.fn.expand("~") .. "/.config/cbfmt.toml", "$FILENAME" } },
    taplo = { command = "taplo", args = { "fmt", "--option", "indent_tables=false", "-" } },
    ruff_fix = {
      command = "ruff",
      args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
      stdin = true,
    },
    lcg_clang_format = { command = "lcg-clang-format-8.0.0", args = { "$FILENAME" } },
    prettier = {
      condition = function(_, ctx)
        return has_prettier_parser(ctx) and has_prettier_config(ctx)
      end,
    },
    injected = { options = { ignore_errors = true } },
  },
})

wk.add({
  {
    "<leader>cf",
    function()
      require("conform").format({
        async = true,
        lsp_fallback = true,
      })
    end,
    desc = "Format",
  },
})
