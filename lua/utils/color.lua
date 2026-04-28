---@class utils.colors.token
---@field fg utils.colors.rgb|nil
---@field bg utils.colors.rgb|nil

---@alias utils.colors.rgb integer

---@class utils.color.colors
---@field normal utils.colors.token
---@field black utils.colors.token
---@field blue utils.colors.token
---@field comment utils.colors.token
---@field green utils.colors.token
---@field magenta utils.colors.token
---@field red utils.colors.token
---@field yellow utils.colors.token
---@field teal utils.colors.token
---@field error utils.colors.token
---@field gutter utils.colors.token
---@field orange utils.colors.token
---@field cyan utils.colors.token
---@field purple utils.colors.token
---@field pink utils.colors.token
---@field selection utils.colors.token
---@field surface utils.colors.token

---@class utils.color
---@field get_colors fun(): utils.color.colors

---@type utils.color
local M = setmetatable({}, {
	__call = function(m)
		return m.get_colors()
	end,
})

---@return utils.color.colors
M.get_colors = function()
	local function hl(name)
		return vim.api.nvim_get_hl(0, { name = name })
	end

	local todo_fg = hl("Todo").fg
	local sep_fg = hl("WinSeparator").fg
	local label_fg = hl("@label").fg
	local comment_fg = hl("Comment").fg
	local string_fg = hl("String").fg
	local constructor_fg = hl("@constructor").fg
	local module_fg = hl("@module.builtin").fg
	local warn_fg = hl("@comment.warning").fg
	local hint_fg = hl("@comment.hint").fg
	local error_fg = hl("@comment.error").fg
	local whitespace_fg = hl("Whitespace").fg

	local orange_fg = hl("DiagnosticWarn").fg
	local cyan_fg = hl("DiagnosticHint").fg
	local purple_fg = hl("@keyword").fg
	local pink_fg = hl("@string.special").fg

	local selection_bg = hl("Visual").bg
	local surface_bg = hl("NormalFloat").bg

	local function set(name, opts)
		vim.api.nvim_set_hl(0, name, opts)
	end

	local PREFIX = "Utils"

	set(PREFIX .. "NormalFg", { fg = todo_fg })
	set(PREFIX .. "BlackFg", { fg = sep_fg })
	set(PREFIX .. "BlueFg", { fg = label_fg })
	set(PREFIX .. "CommentFg", { fg = comment_fg })
	set(PREFIX .. "GreenFg", { fg = string_fg })
	set(PREFIX .. "MagentaFg", { fg = constructor_fg })
	set(PREFIX .. "RedFg", { fg = module_fg })
	set(PREFIX .. "YellowFg", { fg = warn_fg })
	set(PREFIX .. "TealFg", { fg = hint_fg })
	set(PREFIX .. "ErrorFg", { fg = error_fg })
	set(PREFIX .. "GutterFg", { fg = whitespace_fg })

	set(PREFIX .. "NormalBg", { bg = todo_fg })
	set(PREFIX .. "BlackBg", { bg = sep_fg })
	set(PREFIX .. "BlueBg", { bg = label_fg })
	set(PREFIX .. "CommentBg", { bg = comment_fg })
	set(PREFIX .. "GreenBg", { bg = string_fg })
	set(PREFIX .. "MagentaBg", { bg = constructor_fg })
	set(PREFIX .. "RedBg", { bg = module_fg })
	set(PREFIX .. "YellowBg", { bg = warn_fg })
	set(PREFIX .. "TealBg", { bg = hint_fg })
	set(PREFIX .. "ErrorBg", { bg = error_fg })
	set(PREFIX .. "GutterBg", { bg = whitespace_fg })

	set(PREFIX .. "OrangeFg", { fg = orange_fg })
	set(PREFIX .. "CyanFg", { fg = cyan_fg })
	set(PREFIX .. "PurpleFg", { fg = purple_fg })
	set(PREFIX .. "PinkFg", { fg = pink_fg })

	set(PREFIX .. "SelectionBg", { bg = selection_bg })
	set(PREFIX .. "SurfaceBg", { bg = surface_bg })

	local function token(name)
		local fg_hl = vim.api.nvim_get_hl(0, { name = PREFIX .. name .. "Fg" })
		local bg_hl = vim.api.nvim_get_hl(0, { name = PREFIX .. name .. "Bg" })

		local transparent = vim.g.transparent_enabled == true

		local bg = bg_hl.bg or vim.api.nvim_get_hl(0, { name = "Normal" }).bg

		if transparent and (name == "Normal" or name == "Black") then
			bg = nil
		end

		return {
			fg = fg_hl.fg,
			bg = bg,
		}
	end

	local c = {}

	c.normal = token("Normal")
	c.black = token("Black")
	c.blue = token("Blue")
	c.comment = token("Comment")
	c.green = token("Green")
	c.magenta = token("Magenta")
	c.red = token("Red")
	c.yellow = token("Yellow")
	c.teal = token("Teal")
	c.error = token("Error")
	c.gutter = token("Gutter")

	c.orange = token("Orange")
	c.cyan = token("Cyan")
	c.purple = token("Purple")
	c.pink = token("Pink")
	c.selection = token("Selection")
	c.surface = token("Surface")

	return c
end

return M
