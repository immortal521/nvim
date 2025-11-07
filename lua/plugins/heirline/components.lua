local M = {}

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
