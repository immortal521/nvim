local M = {}

M.url = "https://github.com/folke/lazy.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local primary = palette.primary or palette.blue
	local border_fg = palette.border_highlight or palette.fg_gutter

	return {
		-- 主窗口与边框
		LazyNormal = { fg = palette.fg, bg = float_bg },
		LazyBorder = { fg = border_fg, bg = float_bg },
		LazyTitle = { fg = primary, bg = float_bg, bold = true },

		-- 进度条组件
		LazyProgressDone = { fg = primary or palette.purple, bold = true },
		LazyProgressTodo = { fg = palette.fg_gutter or palette.fg_dark, bold = true },

		-- 按钮与按键交互提示
		LazyButton = { fg = palette.fg, bg = palette.bg_highlight },
		LazyButtonActive = { fg = palette.bg, bg = primary, bold = true },
		LazySpecial = { fg = palette.teal or palette.cyan },

		-- 属性与状态详情
		LazyH1 = { fg = palette.bg, bg = primary, bold = true },
		LazyH2 = { fg = primary, bold = true },
		LazyProp = { fg = palette.fg_muted or palette.comment },
		LazyValue = { fg = palette.green or palette.teal },
		LazyComment = { fg = palette.fg_muted or palette.comment, italic = true },

		-- Commit Hash 与 Git 变更
		LazyCommit = { fg = palette.purple or palette.blue },
		LazyCommitIssue = { fg = palette.pink or palette.red },
		LazyReasonPlugin = { fg = palette.orange or palette.yellow },
		LazyReasonSource = { fg = palette.cyan },
		LazyReasonStart = { fg = palette.green },
	}
end

return M
