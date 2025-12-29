-- ~/.config/nvim/lua/blink-cmp-config.lua
local M = {}

-- 外观配置
M.appearance = {
  nerd_font_variant = "mono",
}

-- 键位映射
M.keymap = {
  preset = "none",
  -- stylua: ignore start
  ['<S-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  ['<C-h>'] = { 'hide', 'show' },
  ['<cr>'] = { 'accept', 'fallback' },
  ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
  ['<Tab>'] = {'select_next', 'snippet_forward', 'fallback'},
  ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
  ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
  ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
  ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
  ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
  ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
  ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
  ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
  ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
  ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
  ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
  ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
  -- stylua: ignore start
}

-- 命令行配置
M.cmdline = {
  enabled = true,
  sources = function()
    local type = vim.fn.getcmdtype()
    if type == "/" or type == "?" then
      return { "buffer" }
    end
    if type == ":" or type == "@" then
      return { "cmdline" }
    end
    return {}
  end,
  completion = {
    menu = { auto_show = true },
    list = { selection = { preselect = false, auto_insert = true } },
  },
}

-- 签名配置
M.signature = {
  enabled = true,
  trigger = { show_on_insert = true },
  window = { border = "rounded", treesitter_highlighting = true, show_documentation = true },
}

-- 完成配置
M.completion = {
  menu = {
    scrollbar = false,
    border = "rounded",
    winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder",
    draw = {
      treesitter = { "lsp" },
      columns = {
        { "kind_icon", gap = 1 },
        { "label", gap = 1, "label_description" },
        { "kind", gap = 1 },
        { "source_name", gap = 1 },
      },
      components = require("plugins.completion.blink-cmp.components"),
    },
  },
  keyword = { range = "full" },
  list = { selection = { preselect = false, auto_insert = true } },
  documentation = { auto_show = true, auto_show_delay_ms = 500, window = { border = "rounded" } },
  trigger = { prefetch_on_insert = true, show_on_blocked_trigger_characters = {} },
  accept = { dot_repeat = true, auto_brackets = { enabled = true } },
}

-- 来源配置
M.sources = {
  default = function()
    return { "lsp", "path", "codeium", "ripgrep", "snippets", "buffer" }
  end,
  providers = {
    buffer = { max_items = 3 },
    codeium = { name = "codeium", module = "codeium.blink", async = true, max_items = 3 },
    copilot = { name = "copilot", module = "blink-copilot", async = true },
    ripgrep = {
      name = "Ripgrep",
      module = "blink-cmp-rg",
      opts = {
        prefix_min_len = 3,
        get_command = function(_, prefix)
          return {
            "rg",
            "--no-config",
            "--json",
            "--word-regexp",
            "--ignore-case",
            "--",
            prefix .. "[\\w_-]+",
            vim.fs.root(0, ".git") or vim.fn.getcwd(),
          }
        end,
        get_prefix = function(context)
          return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
        end,
      },
      max_items = 3,
      score_offset = -20,
    },
  },
}

return M
