vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

local ms = require("mason")
local mr = require("mason-registry")

local ensure_installed = {
  "bacon-ls",
  "bash-language-server",
  "biome",
  "clang-format",
  "clangd",
  "codelldb",
  "codespell",
  "css-lsp",
  "css-variables-language-server",
  "cssmodules-language-server",
  "delve",
  "gofumpt",
  "goimports",
  "golangci-lint",
  "gomodifytags",
  "google-java-format",
  "gopls",
  "html-lsp",
  "impl",
  "java-debug-adapter",
  "java-test",
  "jdtls",
  "js-debug-adapter",
  "json-lsp",
  "kotlin-language-server",
  "ktlint",
  "lua-language-server",
  "prettier",
  "pyright",
  "ruff",
  "rust-analyzer",
  "rustfmt",
  "shellcheck",
  "sqlfluff",
  "stylua",
  "stylelint-lsp",
  "tailwindcss-language-server",
  "tree-sitter-cli",
  "vtsls",
  "vue-language-server",
  "xmlformatter",
  "yaml-language-server",
}

ms.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mr.refresh(function()
  for _, tool in ipairs(ensure_installed) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end)

local keys = {
  { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  {
    "gd",
    "<cmd>lua Snacks.picker.lsp_definitions()<cr>",
    desc = "Goto Definition",
  },
  {
    "gr",
    "<cmd>lua Snacks.picker.lsp_references()<cr>",
    desc = "References",
  },
  { "gI", "<cmd>lua Snacks.picker.lsp_implementations()<cr>", desc = "Goto Implementation" },
  { "gy", "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>", desc = "Goto T[y]pe Definition" },
  { "gD", "<cmd>lua Snacks.picker.lsp_declarations()<cr>", desc = "Goto Declaration" },
  {
    "K",
    function()
      return vim.lsp.buf.hover()
    end,
    desc = "Hover",
  },
  {
    "gK",
    function()
      return vim.lsp.buf.signature_help()
    end,
    desc = "Signature Help",
  },
  {
    "<M-k>",
    function()
      return vim.lsp.buf.signature_help()
    end,
    mode = "i",
    desc = "Signature Help",
  },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
  { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "x" } },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>cR", "<cmd>lua Snacks.rename.rename_file()", desc = "Rename File" },
  {
    "<leader>ld",
    "<cmd>lua Snacks.picker.diagnostics()<cr>",
    desc = "LSP Open Diagnostic",
  },
  {
    "<leader>co",
    function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source.organizeImports" },
          diagnostics = {},
        },
      })
    end,
    desc = "Organize Imports",
  },
  { "gai", "<cmd>lua Snacks.picker.lsp_incoming_calls()<cr>", desc = "C[a]lls Incoming" },
  { "gao", "<cmd>lua Snacks.picker.lsp_outgoing_calls()<cr>", desc = "C[a]lls Outgoing" },
  { "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols()<cr>", desc = "LSP Symbols" },
  { "<leader>sS", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>", desc = "LSP Workspace Symbols" },
}

Utils.keymap.add(keys)
