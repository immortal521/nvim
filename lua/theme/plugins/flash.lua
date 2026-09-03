local M = {}

M.url = "https://github.com/folke/flash.nvim"

---@param palette theme.Palette
---@param opts theme.Options
function M.get(palette, opts)
  -- stylua: ignore
  return {
    FlashBackdrop = { fg = palette.fg_muted},
    FlashLabel    = { bg = palette.pink, bold = true, fg = palette.bg},
  }
end

return M
