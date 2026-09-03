local M = {}

M.url = "https://github.com/stevearc/aerial.nvim"

---@param palette theme.Palette
---@param opts theme.Options
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	-- stylua: ignore
	local ret = {
		AerialNormal = { fg = palette.fg },
		AerialGuide  = { fg = palette.fg_gutter },
		AerialLine   = "LspInlayHint",
	}

	require("theme.kinds").kinds(ret, "Aerial%sIcon")

	return ret
end

return M
