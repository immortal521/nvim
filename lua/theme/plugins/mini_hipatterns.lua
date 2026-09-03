local M = {}

M.url = "https://github.com/echasnovski/mini.hipatterns"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        MiniHipatternsFixme = { fg = palette.bg, bg = palette.diag.error, bold = true },
        MiniHipatternsHack  = { fg = palette.bg, bg = palette.diag.warn, bold = true },
        MiniHipatternsNote  = { fg = palette.bg, bg = palette.diag.hint, bold = true },
        MiniHipatternsTodo  = { fg = palette.bg, bg = palette.diag.info, bold = true },
    }
end

return M
