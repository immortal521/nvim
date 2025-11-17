local wk = require("which-key")

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
})

local keys = {
  { "<leader>sn", group = "noice" },

  {
    "<S-Enter>",
    function()
      require("noice").redirect(vim.fn.getcmdline())
    end,
    mode = "c",
    desc = "Redirect Cmdline",
  },

  {
    "<leader>snl",
    function()
      require("noice").cmd("last")
    end,
    mode = "n",
    desc = "Noice Last Message",
  },

  {
    "<leader>snh",
    function()
      require("noice").cmd("history")
    end,
    mode = "n",
    desc = "Noice History",
  },

  {
    "<leader>sna",
    function()
      require("noice").cmd("all")
    end,
    mode = "n",
    desc = "Noice All",
  },

  {
    "<leader>snd",
    function()
      require("noice").cmd("dismiss")
    end,
    mode = "n",
    desc = "Dismiss All",
  },

  {
    "<leader>snt",
    function()
      require("noice").cmd("pick")
    end,
    mode = "n",
    desc = "Noice Picker (Telescope/FzfLua)",
  },

  {
    "<C-f>",
    function()
      if not require("noice.lsp").scroll(4) then
        return "<C-f>"
      end
    end,
    mode = { "i", "n", "s" },
    silent = true,
    expr = true,
    desc = "Scroll Forward",
  },

  {
    "<C-b>",
    function()
      if not require("noice.lsp").scroll(-4) then
        return "<C-b>"
      end
    end,
    mode = { "i", "n", "s" },
    silent = true,
    expr = true,
    desc = "Scroll Backward",
  },
}

wk.add(keys)
