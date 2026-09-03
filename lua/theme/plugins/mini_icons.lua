local M = {}

M.url = "https://github.com/echasnovski/mini.icons"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        MiniIconsGrey   = { fg = palette.fg },
        MiniIconsPurple = { fg = palette.purple },
        MiniIconsBlue   = { fg = palette.blue },
        MiniIconsAzure  = { fg = palette.diag.info },
        MiniIconsCyan   = { fg = palette.cyan },
        MiniIconsGreen  = { fg = palette.green },
        MiniIconsYellow = { fg = palette.yellow },
        MiniIconsOrange = { fg = palette.orange },
        MiniIconsRed    = { fg = palette.red },
    }
end

return M
