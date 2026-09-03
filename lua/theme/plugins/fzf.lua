local M = {}

M.url = "https://github.com/ibhagwan/fzf-lua"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	opts = opts or {}
	local float_bg = opts.transparent and "NONE" or (palette.float and palette.float.bg or palette.bg_dim)
	local primary = palette.primary or palette.blue
	local border_fg = palette.border_highlight or palette.fg_gutter

	return {
		-- 基础窗口与边框
		FzfLuaNormal = { fg = palette.fg, bg = float_bg },
		FzfLuaBorder = { fg = border_fg, bg = float_bg },
		FzfLuaTitle = { fg = primary, bg = float_bg, bold = true },
		FzfLuaPreviewTitle = { fg = border_fg, bg = float_bg, bold = true },

		-- 输入框与指针
		FzfLuaCursor = "IncSearch",
		FzfLuaFzfCursorLine = { bg = palette.bg_highlight, bold = true },
		FzfLuaFzfPointer = { fg = primary, bold = true },
		FzfLuaFzfSeparator = { fg = palette.orange or palette.yellow, bg = float_bg },

		-- 路径与文件名文本分类
		FzfLuaFzfNormal = { fg = palette.fg },
		FzfLuaFilePart = { fg = palette.fg },
		FzfLuaDirPart = { fg = palette.fg_muted or palette.comment },
		FzfLuaPath = { fg = palette.fg_muted or palette.comment },

		-- 搜索模糊匹配字符高亮 (Match)
		FzfLuaFzfMatch = { fg = primary, bold = true },

		-- 快捷键与 Header 提示
		FzfLuaHeaderBind = { fg = palette.purple or primary, bold = true },
		FzfLuaHeaderText = { fg = palette.fg_muted or palette.comment },
	}
end

return M
