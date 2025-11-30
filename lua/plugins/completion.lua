vim.pack.add({
  { src = "https://github.com/Exafunction/windsurf.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range(">=1.0.0 <2.0.0") },
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range(">=2.0.0 <3.0.0") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("luasnip").setup({
  history = true,
  delete_check_events = "TextChanged",
  update_events = { "TextChanged", "TextChangedI" },
  enable_autosnippets = true,
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { " <- Choice ", "NonTest" } },
      },
    },
  },
})

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

require("codeium").setup({
  enable_cmp_source = false,
})

require("blink.cmp").setup({
  appearance = {
    nerd_font_variant = "mono",
  },

  keymap = {
    preset = "none",
      -- stylua: ignore start
      ['<S-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-h>'] = { 'hide', 'show' },
      ['<cr>'] = { 'accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
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
  },
  cmdline = {
    enabled = true,
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      -- Commands
      if type == ":" or type == "@" then
        return { "cmdline" }
      end
      return {}
    end,
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  signature = {
    window = { show_documentation = false },
  },
  completion = {
    menu = {
      scrollbar = false,
      border = "rounded",
      winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder",
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr ~= "" then
                  icon = color_item.abbr
                end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              -- default highlight group
              local highlight = "BlinkCmpKind" .. ctx.kind
              -- if LSP source, check for color derived from documentation
              if ctx.item.source_name == "LSP" then
                local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr_hl_group then
                  highlight = color_item.abbr_hl_group
                end
              end
              return highlight
            end,
          },
        },
      },
    },
    keyword = {
      range = "full",
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    documentation = {
      window = { border = "rounded" },
    },
    trigger = {
      prefetch_on_insert = true,
      show_on_blocked_trigger_characters = {},
    },
    -- INFO: 临时禁用, 以解决选择补全时在 neovide 中光标移动到左上角再返回的 BUG
    accept = {
      dot_repeat = false,
      auto_brackets = {
        enabled = true,
      },
    },
  },
  snippets = { preset = "luasnip" },
  sources = {
    default = function()
      if vim.bo.filetype == "oil" then
        return {}
      else
        return { "lsp", "path", "codeium", "buffer", "snippets" }
      end
    end,
    providers = {
      codeium = { name = "Codeium", module = "codeium.blink", async = true },
      -- css_vars = {
      --   name = "css-vars",
      --   module = "css-vars.blink",
      --   opts = {
      --     search_extensions = { ".js", ".ts", ".jsx", ".tsx", ".vue" },
      --   },
      -- },
    },
  },
})
