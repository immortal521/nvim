return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_forwad", "fallback" },
      ["<C-j"] = { "select_next", "snippet_forward", "fallback" },
      ["<C-k"] = { "select_prev", "snippet_forward", "fallback" },
    },
    sources = {
      cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
    },
  },
}
