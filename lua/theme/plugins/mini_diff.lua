local M = {}

M.url = "https://github.com/echasnovski/mini.diff"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        MiniDiffOverAdd     = "DiffAdd",
        MiniDiffOverChange  = "DiffText",
        MiniDiffOverContext = "DiffChange",
        MiniDiffOverDelete  = "DiffDelete",
        MiniDiffSignAdd     = { fg = palette.git.add },
        MiniDiffSignChange  = { fg = palette.git.change },
        MiniDiffSignDelete  = { fg = palette.git.delete },
    }
end

return M
