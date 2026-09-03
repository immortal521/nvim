local M = {}

M.url = "https://github.com/nvim-treesitter/nvim-treesitter-context"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local bg_ctx = opts.transparent and (palette.bg_dim or "NONE") or (palette.bg_highlight or palette.bg_dim)
	return {
		TreesitterContext = { bg = bg_ctx },
		TreesitterContextLineNumber = { fg = palette.fg_muted or palette.comment, bg = bg_ctx },
	}
end

return M
