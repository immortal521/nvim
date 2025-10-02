return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    image = {
      enabled = true,
    },
    indent = {
      enabled = true,
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
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
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
        -- stylua: ignore
       ---@type snacks.dashboard.Item[]
       keys = {
         { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
         { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
         { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
         { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
         { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          {icon = " ", key="S", desc="Select Session", action = ":lua require('persistence').select()"},
         { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
         { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
         { icon = " ", key = "q", desc = "Quit", action = ":qa" },
       },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 0.5 },
        { section = "startup" },
      },
    },
  },
}
