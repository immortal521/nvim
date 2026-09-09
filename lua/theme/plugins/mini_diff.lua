local M = {}

M.url = "https://github.com/echasnovski/mini.diff"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local git = palette.git or {}

	return {
		MiniDiffSignAdd = { fg = git.add or palette.green },
		MiniDiffSignChange = { fg = git.change or palette.yellow or palette.orange },
		MiniDiffSignDelete = { fg = git.delete or palette.red },

		MiniDiffOverAdd = "DiffAdd",
		MiniDiffOverChange = "DiffText",
		MiniDiffOverContext = "DiffChange",
		MiniDiffOverDelete = "DiffDelete",
	}
end

return M
