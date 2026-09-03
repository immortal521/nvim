local M = {}

M.url = "https://github.com/ibhagwan/fzf-lua"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        FzfLuaBorder        = { fg = palette.border_highlight, bg = palette.float.bg },
        FzfLuaCursor        = "IncSearch",
        FzfLuaDirPart       = { fg = palette.fg_dark },
        FzfLuaFilePart      = "FzfLuaFzfNormal",
        FzfLuaFzfCursorLine = "Visual",
        FzfLuaFzfNormal     = { fg = palette.fg },
        FzfLuaFzfPointer    = { fg = palette.purple },
        FzfLuaFzfSeparator  = { fg = palette.orange, bg = palette.float.bg },
        FzfLuaHeaderBind    = "@punctuation.special",
        FzfLuaHeaderText    = "Title",
        FzfLuaNormal        = { fg = palette.fg, bg = palette.float.bg },
        FzfLuaPath          = "Directory",
        FzfLuaPreviewTitle  = { fg = palette.border_highlight, bg = palette.float.bg },
        FzfLuaTitle         = { fg = palette.orange, bg = palette.float.bg },
    }
end

return M
