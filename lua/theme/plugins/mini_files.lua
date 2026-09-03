local M = {}

M.url = "https://github.com/echasnovski/mini.files"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        MiniFilesBorder         = "FloatBorder",
        MiniFilesBorderModified = "DiagnosticFloatingWarn",
        MiniFilesCursorLine     = "CursorLine",
        MiniFilesDirectory      = "Directory",
        MiniFilesFile           = { fg = palette.float.fg },
        MiniFilesNormal         = "NormalFloat",
        MiniFilesTitle          = "FloatTitle",
        MiniFilesTitleFocused   = { fg = palette.border_highlight, bg = palette.float.bg, bold = true },
    }
end

return M
