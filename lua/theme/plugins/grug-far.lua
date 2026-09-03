local M = {}

M.url = "https://github.com/MagicDuck/grug-far.nvim"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        GrugFarHelpHeader             = { fg = palette.comment },
        GrugFarHelpHeaderKey          = { fg = palette.cyan },
        GrugFarInputLabel             = { fg = palette.blue_bright },
        GrugFarInputPlaceholder       = { fg = palette.fg_dark },
        GrugFarResultsChangeIndicator = { fg = palette.git.change },
        GrugFarResultsHeader          = { fg = palette.orange },
        GrugFarResultsLineColumn      = { fg = palette.fg_dark },
        GrugFarResultsLineNo          = { fg = palette.fg_dark },
        GrugFarResultsMatch           = { fg = palette.bg, bg = palette.red },
        GrugFarResultsStats           = { fg = palette.blue },
    }
end

return M
