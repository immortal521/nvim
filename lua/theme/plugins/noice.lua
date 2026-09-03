local M = {}

M.url = "https://github.com/folke/noice.nvim"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        NoiceCmdlineIconInput          = { fg = palette.yellow },
        NoiceCmdlineIconLua            = { fg = palette.blue_bright },
        NoiceCmdlinePopupBorderInput   = { fg = palette.yellow },
        NoiceCmdlinePopupBorderLua     = { fg = palette.blue_bright },
        NoiceCmdlinePopupTitleInput    = { fg = palette.yellow },
        NoiceCmdlinePopupTitleLua      = { fg = palette.blue_bright },
        NoiceCompletionItemKindDefault = { fg = palette.fg_dark, bg = "NONE" },
    }
end

return M
