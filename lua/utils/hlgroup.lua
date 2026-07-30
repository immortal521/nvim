---@class utils.hlgroup
local M = {}

---@alias utils.hlgroup.hl table<string, string|vim.api.keyset.highlight>

local hl_groups = {} ---@type table<string, vim.api.keyset.highlight>

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("util_hl", { clear = true }),
	callback = function()
		for hl_group, hl in pairs(hl_groups) do
			vim.api.nvim_set_hl(0, hl_group, hl)
		end
	end,
})

--- Ensures the hl groups are always set, even after a colorscheme change.
---@param groups utils.hlgroup.hl
---@param opts? { prefix?:string, default?:boolean, managed?:boolean }
function M.set_hl(groups, opts)
	opts = opts or {}
	for hl_group, hl in pairs(groups) do
		hl_group = opts.prefix and opts.prefix .. hl_group or hl_group
		hl = type(hl) == "string" and { link = hl } or hl --[[@as vim.api.keyset.highlight]]
		hl.default = opts.default
		if opts.managed ~= false then
			hl_groups[hl_group] = hl
		end
		vim.api.nvim_set_hl(0, hl_group, hl)
	end
end

---@param group string|string[] hl group to get color from
---@param prop? string property to get. Defaults to "fg"
function M.color(group, prop)
	prop = prop or "fg"
	group = type(group) == "table" and group or { group }
	---@cast group string[]
	for _, g in ipairs(group) do
		local hl = vim.api.nvim_get_hl(0, { name = g, link = false, create = false })
		if hl[prop] then
			return string.format("#%06x", hl[prop])
		end
	end
end

---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(fg, bg, alpha)
	local bg_rgb = { tonumber(bg:sub(2, 3), 16), tonumber(bg:sub(4, 5), 16), tonumber(bg:sub(6, 7), 16) }
	local fg_rgb = { tonumber(fg:sub(2, 3), 16), tonumber(fg:sub(4, 5), 16), tonumber(fg:sub(6, 7), 16) }
	local blend = function(i)
		local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end
	return string.format("#%02x%02x%02x", blend(1), blend(2), blend(3))
end

local transparent ---@type boolean?
--- Check if the colorscheme is transparent.
function M.is_transparent()
	if transparent == nil then
		transparent = M.color("Normal", "bg") == nil
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("utils_transparent", { clear = true }),
			callback = function()
				transparent = nil
			end,
		})
	end
	return transparent
end

return M
