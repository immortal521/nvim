local utils = require("plugins.heirline.utils")

local colors = utils.get_colors()

local modes = {
  n = { name = "NORMAL", color = colors.blue },
  no = { name = "?", color = colors.blue },
  nov = { name = "?", color = colors.blue },
  noV = { name = "?", color = colors.blue },
  ["no\22"] = { name = "?", color = colors.blue },
  niI = { name = "i", color = colors.blue },
  niR = { name = "r", color = colors.blue },
  niV = { name = "Nv", color = colors.blue },
  nt = { name = "N-TERM", color = colors.blue },
  v = { name = "VISUAL", color = colors.magenta },
  vs = { name = "Vs", color = colors.magenta },
  V = { name = "V-LINE", color = colors.magenta },
  Vs = { name = "Vs", color = colors.magenta },
  ["\22"] = { name = "VBLOCK", color = colors.magenta },
  ["\22s"] = { name = "\\", color = colors.magenta },
  s = { name = "SELECT", color = colors.yellow },
  S = { name = "S-LINE", color = colors.yellow },
  ["\19"] = { name = "^S", color = colors.yellow },
  i = { name = "INSERT", color = colors.green },
  ic = { name = "Ic", color = colors.green },
  ix = { name = "Ix", color = colors.green },
  R = { name = "RPLACE", color = colors.teal },
  Rc = { name = "Rc", color = colors.teal },
  Rx = { name = "Rx", color = colors.teal },
  Rv = { name = "V-RPLC", color = colors.teal },
  Rvc = { name = "Rv", color = colors.teal },
  Rvx = { name = "Rv", color = colors.teal },
  c = { name = "COMMAND", color = colors.red },
  cv = { name = "Ex", color = colors.red },
  r = { name = "...", color = colors.teal },
  rm = { name = "M", color = colors.teal },
  ["r?"] = { name = "?", color = colors.teal },
  ["!"] = { name = "!", color = colors.red },
  t = { name = "TERM", color = colors.green },
}

local M = {}

M.Spacer = {
  provider = " ",
}

M.Fill = {
  provider = "%=",
}

M.get_mode_with_color = function(self)
  local m = vim.fn.mode(1):sub(1, 1)
  local mode = modes[m] or { name = m, color = colors.blue }
  self.mode_name, self.mode_color = mode.name, mode.color
end

M.FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    local icon, hl, _ = require("mini.icons").get("file", "file." .. extension)
    local bt = vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) or nil
    if bt and bt == "terminal" then
      icon = ""
    end
    self.icon = icon
    self.icon_color = string.format("#%06x", vim.api.nvim_get_hl(0, { name = hl })["fg"])
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

return M
