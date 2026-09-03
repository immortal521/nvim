local M = {}

M.url = "https://github.com/folke/lazy.nvim"

---@param palette theme.Palette
function M.get(palette)
    -- stylua: ignore
    return {
        LazyProgressDone = { bold = true, fg = palette.purple },
        LazyProgressTodo = { bold = true, fg = palette.fg_gutter },
    }
end

return M
