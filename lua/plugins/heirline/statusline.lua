local components = require("plugins.heirline.components")
local utils = require("plugins.heirline.utils")
local conditions = require("heirline.conditions")
local MiniIcons = require("mini.icons")

local colors = utils.get_colors()

local has_branch = function()
  return vim.b.minigit_summary ~= nil
end

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
      return { fg = self.mode_color, bg = has_branch() and colors.fg_gutter or nil }
    end,
  },
  {
    condition = has_branch,
    provider = function()
      local summary = vim.b.minigit_summary or {}
      return " 󰘬 " .. (summary.head_name or "") .. " "
    end,
    hl = function(self)
      return { fg = self.mode_color, bg = colors.fg_gutter, bold = true }
    end,
  },
}

local Filename = {
  {
    provider = "",
    condition = has_branch,
    hl = { fg = colors.fg_gutter },
  },
  {
    init = function(self)
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.fnamemodify(filename, ":e")
      local icon, hl, _ = MiniIcons.get("file", "file." .. extension)
      if vim.bo.buftype == "terminal" then
        icon = ""
      end
      self.icon = icon
      self.icon_color = string.format("#%06x", vim.api.nvim_get_hl(0, { name = hl })["fg"])
      self.filename = filename
    end,
    { provider = " " },
    {
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return {
          fg = self.icon_color,
        }
      end,
    },
    {
      provider = function(self)
        return self.filename
      end,
      hl = { italic = true },
    },
  },
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
}

local FileEncoding = {
  {
    provider = function()
      return " " .. (vim.bo.fileencoding or "none") .. " "
    end,
  },
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
  Filename,
  components.Fill,
  MacroRecording,
  components.Fill,
  Profile,
  FileEncoding,
  Ruler,
  Time,
}

return Statusline
