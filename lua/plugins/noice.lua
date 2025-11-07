local map = require("utils").map

vim.pack.add({
  { src = "https://github.com/folke/noice.nvim" },
})

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

-- 分组描述（如果你用了 which-key 会自动识别）
map("n", "<leader>sn", "", { desc = "+noice" })

map("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

map("n", "<leader>snl", function()
  require("noice").cmd("last")
end, { desc = "Noice Last Message" })

map("n", "<leader>snh", function()
  require("noice").cmd("history")
end, { desc = "Noice History" })

map("n", "<leader>sna", function()
  require("noice").cmd("all")
end, { desc = "Noice All" })

map("n", "<leader>snd", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })

map("n", "<leader>snt", function()
  require("noice").cmd("pick")
end, { desc = "Noice Picker (Telescope/FzfLua)" })

map({ "i", "n", "s" }, "<C-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<C-f>"
  end
end, { silent = true, expr = true, desc = "Scroll Forward" })

map({ "i", "n", "s" }, "<C-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<C-b>"
  end
end, { silent = true, expr = true, desc = "Scroll Backward" })
