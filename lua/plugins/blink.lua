return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    keymap = {
      preset = "none",
      -- ["<C-e>"] = { "hide" },
      -- stylua: ignore start
      ['<S-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<cr>'] = { 'accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_forward', 'fallback' },
      ['<Tab>'] = { 'select_next', 'snippet_backward', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-e>'] = { 'snippet_forward', 'fallback' },
      ['<C-u>'] = { 'snippet_backward', 'fallback' },
      -- stylua: ignore start
    },
    completion = {
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
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      -- INFO: 临时禁用, 以解决选择补全时在 neovide 中光标移动到左上角再返回的 BUG
      accept = {
        dot_repeat = false,
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
