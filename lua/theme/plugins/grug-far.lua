local M = {}

M.url = "https://github.com/MagicDuck/grug-far.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local primary = palette.primary or palette.blue
	local git = palette.git or {}

	return {
		-- 帮助信息 Header
		GrugFarHelpHeader = { fg = palette.fg_muted or palette.comment },
		GrugFarHelpHeaderKey = { fg = primary, bold = true },

		-- 输入框与标签
		GrugFarInputLabel = { fg = primary, bold = true },
		GrugFarInputPlaceholder = { fg = palette.fg_gutter or palette.fg_dark },

		-- 搜索结果统计与标题
		GrugFarResultsHeader = { fg = palette.yellow or palette.orange, bold = true },
		GrugFarResultsStats = { fg = primary },
		GrugFarResultsLineNo = { fg = palette.fg_gutter or palette.fg_dark },
		GrugFarResultsLineColumn = { fg = palette.fg_gutter or palette.fg_dark },
		GrugFarResultsPath = { fg = palette.fg, bold = true },

		-- 状态与修改指示器
		GrugFarResultsChangeIndicator = { fg = git.change or palette.yellow },

		-- 搜索到的匹配文本 (Match)
		GrugFarResultsMatch = { fg = palette.bg, bg = palette.pink or palette.red, bold = true },
		GrugFarResultsMatchAdded = { fg = palette.bg, bg = git.add or palette.green, bold = true },
		GrugFarResultsMatchRemoved = { fg = palette.bg, bg = git.delete or palette.red, bold = true },
	}
end

return M
