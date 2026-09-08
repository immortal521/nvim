local M = {}

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local float = palette.float or {}
	local float_bg = opts.transparent and "NONE" or (float.bg or palette.bg_dim)
	local diag = palette.diag or {}

	local notify_error = diag.error or palette.red
	local notify_warn = diag.warn or palette.yellow
	local notify_info = diag.info or palette.primary
	local notify_debug = diag.hint or palette.green
	local notify_trace = palette.purple
	local notify_success = palette.green_bright or palette.green
	local border = palette.border_highlight or palette.border or palette.fg_gutter

	return {
		-- Builtin 窗口组件的基础语义组。
		BuiltinNormal = "NormalFloat",
		BuiltinNormalNC = "NormalFloat",
		BuiltinTitle = "FloatTitle",
		BuiltinFooter = "FloatFooter",
		BuiltinFooterDesc = "DiagnosticInfo",
		BuiltinFooterKey = "DiagnosticVirtualTextInfo",
		BuiltinWinBar = "Title",
		BuiltinWinBarNC = "Title",
		BuiltinWinKey = "Keyword",
		BuiltinWinKeySep = "NonText",
		BuiltinWinKeyDesc = "Function",
		BuiltinWinSeparator = "WinSeparator",
		BuiltinActiveBorder = { fg = border, bg = float_bg },

		-- 通知的边框、标题和分隔线共用同一语义色。
		BuiltinNotifyErrorBorder = { fg = notify_error, bg = float_bg, bold = true },
		BuiltinNotifyWarnBorder = { fg = notify_warn, bg = float_bg, bold = true },
		BuiltinNotifyInfoBorder = { fg = notify_info, bg = float_bg, bold = true },
		BuiltinNotifyDebugBorder = { fg = notify_debug, bg = float_bg, bold = true },
		BuiltinNotifyTraceBorder = { fg = notify_trace, bg = float_bg, bold = true },
		BuiltinNotifySuccessBorder = { fg = notify_success, bg = float_bg, bold = true },
	}
end

return M
