return {
  "saghen/blink.cmp",
  dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
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
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
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
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
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
      default = { "lsp", "path", "buffer", "snippets" },
    },
  },
  opts_extend = { "sources.default" },
}
