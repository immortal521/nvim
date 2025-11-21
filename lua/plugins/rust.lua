require("crates").setup({
  completion = {
    crates = {
      enabled = true,
    },
  },
  lsp = {
    enabled = true,
    actions = true,
    completion = true,
    hover = true,
  },
})

-- require("rustaceanvim").setup({
--   server = {
--     on_attach = function(_, bufnr)
--       vim.keymap.set("n", "<leader>cR", function()
--         vim.cmd.RustLsp("codeAction")
--       end, { desc = "Code Action", buffer = bufnr })
--       vim.keymap.set("n", "<leader>dr", function()
--         vim.cmd.RustLsp("debuggables")
--       end, { desc = "Rust Debuggables", buffer = bufnr })
--     end,
--     default_settings = {
--       -- rust-analyzer language server configuration
--       ["rust-analyzer"] = {
--         cargo = {
--           allFeatures = true,
--           loadOutDirsFromCheck = true,
--           buildScripts = {
--             enable = true,
--           },
--         },
--         procMacro = {
--           enable = true,
--         },
--         files = {
--           exclude = {
--             ".direnv",
--             ".git",
--             ".jj",
--             ".github",
--             ".gitlab",
--             "bin",
--             "node_modules",
--             "target",
--             "venv",
--             ".venv",
--           },
--           -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
--           watcher = "client",
--         },
--       },
--     },
--   },
-- })
