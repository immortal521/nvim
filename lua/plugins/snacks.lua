if true then
  return
end

vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
  picker = {
    enabled = false,
  },
  image = {
    enabled = true,
  },
  bigfile = {
    enabled = true,
    size = 10 * 1024 * 1024,
    line_length = 2000,
  },
  indent = {
    enabled = false,
    animate = {
      enabled = true,
    },
    indent = {
      only_scope = true,
    },
    scope = {
      enabled = true,
      underline = false,
    },
    chunk = {
      enabled = true,
    },
  },
  input = { enabled = true },
  notifier = { enabled = false },
  scope = { enabled = true },
  scroll = { enabled = false },
  words = { enabled = true },
  dashboard = {
    enabled = false,
    preset = {
      header = [[



         ▀████▀▄▄              ▄█
           █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█
  ▄        █          ▀▀▀▀▄  ▄▀
 ▄▀ ▀▄      ▀▄              ▀▄▀
▄▀    █     █▀   ▄█▀▄      ▄█
▀▄     ▀▄  █     ▀██▀     ██▄█
 ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █
  █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀
 █   █  █      ▄▄           ▄▀
]],
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = " ", key = "S", desc = "Select Session", action = ":lua require('persistence').select()" },
        { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 0.5 },
    },
  },
})
