local components = require("plugins.heirline.components")
local utils = require("plugins.heirline.utils")
local conditions = require("heirline.conditions")

local colors = utils.get_colors()

local Mode = {
  provider = function(self)
    return " %1(" .. self.mode_name .. "%)"
  end,
  hl = function(self)
    return { fg = colors.fg_gutter, bg = self.mode_color, bold = true }
  end,
}

local GitBranch = {
  {
    provider = "",
    hl = function(self)
      return { fg = self.mode_color, bg = vim.b.minigit_summary ~= nil and colors.fg_gutter or nil }
    end,
  },
  {

    condition = function()
      return vim.b.minigit_summary ~= nil
    end,
    provider = function()
      local summary = vim.b.minigit_summary or {}
      return " 󰘬 " .. (summary.head_name or "") .. " "
    end,
    hl = function(self)
      return { fg = self.mode_color, bg = colors.fg_gutter, bold = true }
    end,
  },
}

local Breadcrumbs = {
  provider = function()
    return require("lspsaga.symbol.winbar").get_bar()
  end,
  update = "CursorMoved",
}

local MacroRecording = {
  condition = conditions.is_active,
  init = function(self)
    self.reg_recording = vim.fn.reg_recording()
  end,
  {
    condition = function(self)
      return self.reg_recording ~= ""
    end,
    {
      provider = "󰻃 ",
      hl = { fg = colors.magenta },
    },
    {
      provider = function(self)
        return self.reg_recording
      end,
      hl = { fg = colors.magenta, italic = false, bold = true },
    },
  },
  update = { "RecordingEnter", "RecordingLeave" },
}

local Profile = {
  {
    provider = function()
      return require("noice").api.status.command.get()
    end,
    hl = { fg = colors.magenta },
  },
  { provider = " " },
  {
    provider = "",
    hl = { fg = colors.fg_gutter },
  },
}

local Ruler = {
  {
    provider = "%P %(%l:%c%) ",
    hl = function(self)
      return { bg = colors.fg_gutter, fg = self.mode_color }
    end,
  },
  {
    provider = "",
    hl = function(self)
      return { fg = self.mode_color, bg = colors.fg_gutter }
    end,
  },
}

local Time = {
  {
    provider = function()
      return " " .. os.date("%H:%M") .. " "
    end,
    hl = function(self)
      return { fg = colors.fg_gutter, bg = self.mode_color, bold = true }
    end,
  },
}

local Statusline = {
  init = components.get_mode_with_color,
  Mode,
  GitBranch,
  Breadcrumbs,
  components.Fill,
  MacroRecording,
  components.Fill,
  Profile,
  Ruler,
  Time,
}

return Statusline
