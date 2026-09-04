---@class yanky.Highlights
local M = {}

---@param palette theme.Palette
---@param opts? table
---@return table<string, vim.api.keyset.highlight|string>
function M.get(palette, opts)
	local ret = {
		YankyYanked = { fg = palette.bg, bg = palette.primary, bold = true },
		YankyPut = { fg = palette.bg, bg = palette.primary_bright, bold = true },
	}

	return ret
end

return M
