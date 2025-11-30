vim.pack.add({
  { src = "https://github.com/goolord/alpha-nvim" },
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local logo = [[



         ▀████▀▄▄              ▄█
           █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█
  ▄        █          ▀▀▀▀▄  ▄▀
 ▄▀ ▀▄      ▀▄              ▀▄▀
▄▀    █     █▀   ▄█▀▄      ▄█
▀▄     ▀▄  █     ▀██▀     ██▄█
 ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █
  █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀
 █   █  █      ▄▄           ▄▀
]]

dashboard.section.header.val = vim.split(logo, "\n")

-- stylua: ignore
dashboard.section.buttons.val = {
  dashboard.button("f", " " .. " Find file",       "<cmd> lua FzfLua.files() <cr>"),
  dashboard.button("g", " " .. " Find Text",       "<cmd> lua FzfLua.live_grep() <cr>"),
  dashboard.button("r", " " .. " Recent files",    "<cmd> lua FzfLua.oldfiles() <cr>"),
  dashboard.button("c", " " .. " Config",          "<cmd> lua FzfLua.files({ cwd = vim.fn.stdpath('config') }) <cr>"),
  dashboard.button("s", " " .. " Select Session",  [[<cmd> lua require("persistence").select() <cr>]]),
  dashboard.button("S", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
  dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
}

for _, button in ipairs(dashboard.section.buttons.val) do
  button.opts.hl = "AlphaButtons"
  button.opts.hl_shortcut = "AlphaShortcut"
end

dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.buttons.opts.hl = "AlphaButtons"
dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.opts.layout[1].val = 2

alpha.setup(dashboard.opts)
