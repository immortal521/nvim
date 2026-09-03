local M = {}

M.url = "https://github.com/echasnovski/mini.hipatterns"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local diag = palette.diag or {}

	return {
		MiniHipatternsFixme = { fg = palette.bg, bg = diag.error or palette.red, bold = true },
		MiniHipatternsHack = { fg = palette.bg, bg = diag.warn or palette.yellow or palette.orange, bold = true },
		MiniHipatternsNote = { fg = palette.bg, bg = diag.hint or palette.cyan or palette.teal, bold = true },
		MiniHipatternsTodo = { fg = palette.bg, bg = diag.info or palette.blue or palette.primary, bold = true },
	}
end

return M
