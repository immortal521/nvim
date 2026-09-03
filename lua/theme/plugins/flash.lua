local M = {}

M.url = "https://github.com/folke/flash.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local primary = palette.primary or palette.blue
	local label_bg = palette.pink or palette.red

	return {
		-- 跳转时被暗化的背景文本
		FlashBackdrop = { fg = palette.fg_gutter or palette.comment },
		-- 标签字符（即按键提示字符，如 'a', 's', 'd'）
		FlashLabel = { fg = palette.bg, bg = label_bg, bold = true },
		-- 搜索匹配到的文本高亮
		FlashMatch = { fg = palette.fg, bg = palette.bg_highlight },
		-- 当前光标所在的匹配位置
		FlashCurrent = { fg = palette.bg, bg = primary, bold = true },
		-- 提示信息/提示框文本
		FlashPrompt = { fg = palette.fg, bg = opts.transparent and "NONE" or palette.bg_dim },
		-- 提示框的边框/光标
		FlashPromptIcon = { fg = primary, bold = true },
	}
end

return M
