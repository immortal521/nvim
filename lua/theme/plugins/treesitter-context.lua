local M = {}

M.url = "https://github.com/nvim-treesitter/nvim-treesitter-context"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        TreesitterContext = { bg = palette.bg_highlight },
    }
end

return M
