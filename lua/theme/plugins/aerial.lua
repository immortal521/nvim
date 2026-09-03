local M = {}

M.url = "https://github.com/stevearc/aerial.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local ret = {
		AerialNormal = { fg = palette.fg },
		AerialGuide = { fg = palette.fg_gutter },
		AerialLine = { bg = palette.bg_highlight or palette.bg_dim, bold = true },
		AerialLineNC = { bg = palette.bg_dim },
		AerialTreeIcon = { fg = palette.fg_gutter },
	}

	-- 自动将类 LSP Kind 的图标颜色映射到 Aerial%sIcon 高亮组上
	if package.loaded["theme.kinds"] or pcall(require, "theme.kinds") then
		require("theme.kinds").kinds(ret, "Aerial%sIcon")
	end

	return ret
end

return M
