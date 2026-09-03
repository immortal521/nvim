local M = {}

M.url = "https://github.com/folke/which-key.nvim"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        WhichKey          = { fg = palette.cyan },
        WhichKeyGroup     = { fg = palette.blue },
        WhichKeyDesc      = { fg = palette.purple },
        WhichKeySeparator = { fg = palette.comment },
        WhichKeyNormal    = { bg = palette.bg_dim },
        WhichKeyValue     = { fg = palette.fg_dark },
    }
end

return M
