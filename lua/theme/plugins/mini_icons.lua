local M = {}

M.url = "https://github.com/echasnovski/mini.icons"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local diag = palette.diag or {}

	return {
		MiniIconsGrey = { fg = palette.fg_muted or palette.comment },
		MiniIconsPurple = { fg = palette.purple },
		MiniIconsBlue = { fg = palette.blue },
		MiniIconsAzure = { fg = diag.info or palette.teal or palette.blue },
		MiniIconsCyan = { fg = palette.cyan },
		MiniIconsGreen = { fg = palette.green },
		MiniIconsYellow = { fg = palette.yellow },
		MiniIconsOrange = { fg = palette.orange },
		MiniIconsRed = { fg = palette.red },
	}
end

return M
