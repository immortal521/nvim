---@class DiffColors
---@field add string
---@field change string
---@field delete string
---@field text string

---@class GitColors
---@field add string
---@field change string
---@field delete string
---@field ignore string

---@class TerminalColors
---@field black string
---@field black_bright string
---@field blue string
---@field blue_bright string
---@field cyan string
---@field cyan_bright string
---@field green string
---@field green_bright string
---@field magenta string
---@field magenta_bright string
---@field red string
---@field red_bright string
---@field white string
---@field white_bright string
---@field yellow string
---@field yellow_bright string

---@class Colors
---@field bg string
---@field bg_dark string
---@field bg_dark1 string
---@field bg_float string
---@field bg_highlight string
---@field bg_popup string
---@field bg_search string
---@field bg_sidebar string
---@field bg_statusline string
---@field bg_visual string
---@field black string
---@field blue string
---@field blue0 string
---@field blue1 string
---@field blue2 string
---@field blue5 string
---@field blue6 string
---@field blue7 string
---@field border string
---@field border_highlight string
---@field comment string
---@field cyan string
---@field dark3 string
---@field dark5 string
---@field diff DiffColors
---@field error string
---@field fg string
---@field fg_dark string
---@field fg_float string
---@field fg_gutter string
---@field fg_sidebar string
---@field git GitColors
---@field green string
---@field green1 string
---@field green2 string
---@field hint string
---@field info string
---@field magenta string
---@field magenta2 string
---@field none string
---@field orange string
---@field purple string
---@field rainbow string[]
---@field red string
---@field red1 string
---@field teal string
---@field terminal TerminalColors
---@field terminal_black string
---@field todo string
---@field warning string
---@field yellow string
local colors = require("tokyonight.colors").setup()

local M = {}

M.get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

M.get_colors = function()
  return colors
end

return M
