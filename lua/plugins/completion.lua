vim.pack.add({
  { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
  { src = "https://github.com/Exafunction/windsurf.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range(">=1.0.0 <2.0.0") },
  { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range(">=2.0.0 <3.0.0") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/niuiic/blink-cmp-rg.nvim" },
})

require("colorful-menu").setup({})

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

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true }),
  once = true,
  callback = function()
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
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_insert = true,
        },
        window = {
          border = "rounded",
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      completion = {
        menu = {
          scrollbar = false,
          border = "rounded",
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", gap = 1 }, -- 类型图标列
              { "label", gap = 1, "label_description" }, -- 标签和描述列
              { "kind", gap = 1 }, -- 来源名称列
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  -- 如果是 LSP，并且文档中包含颜色信息，则用颜色块代替图标
                  if ctx.item.source_name == "LSP" then
                    local color_item =
                      require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= "" then
                      icon = color_item.abbr
                    end
                  end
                  return icon .. (ctx.icon_gap or "")
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  -- 如果是 LSP 并且颜色插件提供了 highlight，覆盖默认 hl
                  if ctx.item.source_name == "LSP" then
                    local color_item =
                      require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      hl = color_item.abbr_hl_group
                    end
                  end
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, mini_hl = require("mini.icons").get_icon(ctx.item.data.type, ctx.label)
                    if mini_icon then
                      return mini_hl
                    end
                  end
                  return ctx.kind_hl
                end,
              },

              -- 标签显示组件
              label = {
                width = { fill = true, max = 30 }, -- 宽度配置：填充且最大60
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
              -- 标签描述组件
              label_description = {
                width = { max = 30 }, -- 最大宽度30
                text = function(ctx)
                  return ctx.label_description -- 返回标签描述
                end,
                highlight = "BlinkCmpLabelDescription", -- 使用标签描述高亮组
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
            return { "lsp", "path", "codeium", "ripgrep", "buffer", "snippets" }
          end
        end,
        providers = {
          codeium = { name = "Codeium", module = "codeium.blink", async = true },
          ripgrep = {
            name = "Ripgrep",
            module = "blink-cmp-rg",
            opts = {
              prefix_min_len = 3,
              get_command = function(context, prefix)
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
          },
        },
      },
    })
  end,
})
