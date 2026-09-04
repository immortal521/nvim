local M = {}

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local border_fg = palette.border_highlight or palette.border or palette.fg_gutter
	return {
		ActiveBorder = { fg = border_fg, bg = float_bg },
	}
end

return M
