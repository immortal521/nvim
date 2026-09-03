local M = {}

M.url = "https://github.com/goolord/alpha-nvim"

---@param palette theme.Palette
---@param opts theme.Options
function M.get(palette, opts)
  -- stylua: ignore
  return {
    AlphaShortcut    = { fg = palette.orange },
    AlphaHeader      = { fg = palette.blue },
    AlphaHeaderLabel = { fg = palette.orange },
    AlphaFooter      = { fg = palette.blue },
    AlphaButtons     = { fg = palette.cyan },
  }
end

return M
