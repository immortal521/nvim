local M = {}

M.url = "https://github.com/echasnovski/mini.surround"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        MiniSurround = { bg = palette.orange, fg = palette.bg },
    }
end

return M
