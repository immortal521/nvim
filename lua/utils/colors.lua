---@class utils.colors
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get_colors(...)
  end,
})

M.get_colors = function()
  return require("tokyonight.colors").setup()
end

return M
