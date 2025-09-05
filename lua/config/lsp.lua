local icons = VoidVim.config.icons

vim.lsp.enable("lua_ls")
vim.lsp.enable("vue_ls")
vim.lsp.enable("vtsls")
vim.lsp.enable("gopls")

local vue_language_server_path = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}
vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "<leader>cl", function()
      require("snacks").picker.lsp_config()
    end, { buffer = event.buf, desc = "Lsp Info" })

    vim.keymap.set("n", "gd", function()
      require("snacks").picker.lsp_definitions()
    end, { buffer = event.buf, desc = "Goto Definition" })

    vim.keymap.set("n", "gD", function()
      require("snacks").picker.lsp_declarations()
    end, { buffer = event.buf, desc = "Goto Declaration" })

    vim.keymap.set("n", "gr", function()
      -- require('telescope.builtin').lsp_references()
      require("snacks").picker.lsp_references()
    end, { buffer = event.buf, desc = "Goto References" })

    vim.keymap.set("n", "gI", function()
      require("snacks").picker.lsp_implementations()
    end, { buffer = event.buf, desc = "Goto Implementation" })

    vim.keymap.set("n", "gy", function()
      require("snacks").picker.lsp_type_definitions()
    end, { buffer = event.buf, desc = "Goto T[y]pe Definition" })

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "Code Action" })

    vim.keymap.set("n", "<leader>cA", function()
      setmetatable({}, {
        __index = function(_, action)
          return function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { action },
                diagnostics = {},
              },
            })
          end
        end,
      }).source()
    end)

    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = event.buf, desc = "Rename" })

    vim.keymap.set("n", "<leader>cd", function()
      vim.diagnostic.open_float({ source = true })
    end, { buffer = event.buf, desc = "Show Diagnostic" })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
        client
        and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
        and vim.bo.filetype ~= "bigfile"
    then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
          -- vim.cmd 'setl foldexpr <'
        end,
      })
    end

    -- if client and client:supports_method("textDocument/foldingRange") then
    --     local win = vim.api.nvim_get
    -- end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, { buffer = event.buf, desc = "Toggle Inlay Hints" })
    end
  end,
})

-- diagnostic UI touches
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  -- virtual_lines = { current_line = true },
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  float = { severity_sort = true },
  severity_sort = true,
  signs = {
    text = {
      -- [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
    },
    -- numhl = {
    --     [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
    --     [vim.diagnostic.severity.WARN] = 'DiagnosticWarning',
    --     [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    --     [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    -- },
  },
})

local api, lsp = vim.api, vim.lsp

api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("tabnew %s", lsp.get_log_path()))
end, {
  desc = "Opens the Nvim LSP client log.",
})

local complete_client = function(arg)
  return vim.iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
end

api.nvim_create_user_command("LspRestart", function(info)
  for _, name in ipairs(info.fargs) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(info.args))
    else
      vim.lsp.enable(name, false)
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    for _, name in ipairs(info.fargs) do
      vim.schedule_wrap(function(x)
        vim.lsp.enable(x)
      end)(name)
    end
  end)
end, {
  desc = "Restart the given client(s)",
  nargs = "+",
  complete = complete_client,
})
