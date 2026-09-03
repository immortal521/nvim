local M = {}

M.url = "https://github.com/folke/noice.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local primary = palette.primary or palette.blue
	local border_fg = palette.border_highlight or palette.fg_gutter

	local ret = {
		-- 基础弹窗与边框
		NoiceCmdline = { fg = palette.fg, bg = float_bg },
		NoiceCmdlinePrompt = { fg = primary, bold = true },
		NoiceCmdlinePopup = { fg = palette.fg, bg = float_bg },
		NoiceCmdlinePopupBorder = { fg = border_fg, bg = float_bg },
		NoiceCmdlinePopupTitle = { fg = primary, bg = float_bg, bold = true },

		-- Cmdline 模式特定高亮: Default / Primary
		NoiceCmdlineIcon = { fg = primary },
		NoiceCmdlinePopupBorderCmdline = { fg = border_fg, bg = float_bg },
		NoiceCmdlinePopupTitleCmdline = { fg = primary, bg = float_bg, bold = true },

		-- Cmdline 模式特定高亮: Lua
		NoiceCmdlineIconLua = { fg = palette.blue_bright or primary },
		NoiceCmdlinePopupBorderLua = { fg = palette.blue_bright or primary, bg = float_bg },
		NoiceCmdlinePopupTitleLua = { fg = palette.blue_bright or primary, bg = float_bg, bold = true },

		-- Cmdline 模式特定高亮: Input / Filter
		NoiceCmdlineIconInput = { fg = palette.yellow or palette.orange },
		NoiceCmdlinePopupBorderInput = { fg = palette.yellow or palette.orange, bg = float_bg },
		NoiceCmdlinePopupTitleInput = { fg = palette.yellow or palette.orange, bg = float_bg, bold = true },
		NoiceCmdlineIconFilter = { fg = palette.green },
		NoiceCmdlinePopupBorderFilter = { fg = palette.green, bg = float_bg },

		-- Cmdline 模式特定高亮: Search / Help
		NoiceCmdlineIconSearch = { fg = palette.teal or palette.cyan },
		NoiceCmdlineIconHelp = { fg = palette.purple },

		-- LSP Progress / Notifications
		NoiceLspProgressTitle = { fg = primary, bold = true },
		NoiceLspProgressClient = { fg = palette.fg_muted or palette.comment },
		NoiceFormatProgressDone = { fg = primary, bg = float_bg },
		NoiceFormatProgressTodo = { fg = palette.fg_gutter, bg = float_bg },

		-- 补全菜单默认 Kind 高亮
		NoiceCompletionItemKindDefault = { fg = palette.fg_muted or palette.comment, bg = "NONE" },
	}

	if package.loaded["theme.kinds"] or pcall(require, "theme.kinds") then
		require("theme.kinds").kinds(ret, "NoiceCompletionItemKind%s")
	end

	return ret
end

return M
