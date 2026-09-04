local M = {}

M.url = "https://github.com/stevearc/aerial.nvim"

---@param palette theme.Palette
---@param _ theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, _)
	local ret = {
		AerialNormal = { fg = palette.fg },
		AerialGuide = { fg = palette.fg_gutter },
		AerialTreeIcon = { fg = palette.fg_gutter },

		AerialLine = { bg = palette.cursor_line, bold = true },
		AerialLineNC = { bg = palette.bg_dim },

		AerialClass = { fg = palette.orange, bold = true },
		AerialFunction = { fg = palette.blue },
		AerialMethod = { fg = palette.blue },

		AerialWinTree = { fg = palette.primary },

		AerialIcon = { fg = palette.purple },
	}

	if package.loaded["theme.kinds"] or pcall(require, "theme.kinds") then
		require("theme.kinds").kinds(ret, "Aerial%sIcon")
	end

	return ret
end

return M
