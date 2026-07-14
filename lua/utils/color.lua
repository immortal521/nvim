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
---@field get_colors fun(): utils.colors.token

---@type utils.color
local M = setmetatable({}, {
	__call = function(m)
		return m.get_colors()
	end,
})

local PREFIX = "Utils"
local nvim_get_hl = vim.api.nvim_get_hl
local nvim_set_hl = vim.api.nvim_set_hl

---@param name string
---@return utils.colors.rgb?
local function fg(name)
	return nvim_get_hl(0, { name = name }).fg
end

---@param name string
---@return utils.colors.rgb?
local function bg(name)
	return nvim_get_hl(0, { name = name }).bg
end

---@return utils.color.colors
local function build_colors()
	local todo_fg = fg("Todo")
	local sep_fg = fg("WinSeparator")
	local label_fg = fg("@label")
	local comment_fg = fg("Comment")
	local string_fg = fg("String")
	local constructor_fg = fg("@constructor")
	local module_fg = fg("@module.builtin")
	local warn_fg = fg("@comment.warning")
	local hint_fg = fg("@comment.hint")
	local error_fg = fg("@comment.error")
	local whitespace_fg = fg("Whitespace")

	local orange_fg = fg("DiagnosticWarn")
	local cyan_fg = fg("DiagnosticHint")
	local purple_fg = fg("@keyword")
	local pink_fg = fg("@string.special")

	local selection_bg = bg("Visual")
	local surface_bg = bg("NormalFloat")
	local normal_bg = bg("Normal")

	local transparent = vim.g.transparent_enabled == true

	local set = nvim_set_hl
	set(0, PREFIX .. "NormalFg", { fg = todo_fg })
	set(0, PREFIX .. "BlackFg", { fg = sep_fg })
	set(0, PREFIX .. "BlueFg", { fg = label_fg })
	set(0, PREFIX .. "CommentFg", { fg = comment_fg })
	set(0, PREFIX .. "GreenFg", { fg = string_fg })
	set(0, PREFIX .. "MagentaFg", { fg = constructor_fg })
	set(0, PREFIX .. "RedFg", { fg = module_fg })
	set(0, PREFIX .. "YellowFg", { fg = warn_fg })
	set(0, PREFIX .. "TealFg", { fg = hint_fg })
	set(0, PREFIX .. "ErrorFg", { fg = error_fg })
	set(0, PREFIX .. "GutterFg", { fg = whitespace_fg })

	set(0, PREFIX .. "NormalBg", { bg = todo_fg })
	set(0, PREFIX .. "BlackBg", { bg = sep_fg })
	set(0, PREFIX .. "BlueBg", { bg = label_fg })
	set(0, PREFIX .. "CommentBg", { bg = comment_fg })
	set(0, PREFIX .. "GreenBg", { bg = string_fg })
	set(0, PREFIX .. "MagentaBg", { bg = constructor_fg })
	set(0, PREFIX .. "RedBg", { bg = module_fg })
	set(0, PREFIX .. "YellowBg", { bg = warn_fg })
	set(0, PREFIX .. "TealBg", { bg = hint_fg })
	set(0, PREFIX .. "ErrorBg", { bg = error_fg })
	set(0, PREFIX .. "GutterBg", { bg = whitespace_fg })

	set(0, PREFIX .. "OrangeFg", { fg = orange_fg })
	set(0, PREFIX .. "CyanFg", { fg = cyan_fg })
	set(0, PREFIX .. "PurpleFg", { fg = purple_fg })
	set(0, PREFIX .. "PinkFg", { fg = pink_fg })

	set(0, PREFIX .. "SelectionBg", { bg = selection_bg })
	set(0, PREFIX .. "SurfaceBg", { bg = surface_bg })

	---@param fg_val utils.colors.rgb?
	---@param bg_val utils.colors.rgb?
	---@param name? string
	---@return utils.colors.token
	local function token(fg_val, bg_val, name)
		local bg_color = bg_val or normal_bg
		if transparent and (name == "Normal" or name == "Black") then
			bg_color = nil
		end
		return { fg = fg_val, bg = bg_color }
	end

	return {
		normal = token(todo_fg, todo_fg, "Normal"),
		black = token(sep_fg, sep_fg, "Black"),
		blue = token(label_fg, label_fg),
		comment = token(comment_fg, comment_fg),
		green = token(string_fg, string_fg),
		magenta = token(constructor_fg, constructor_fg),
		red = token(module_fg, module_fg),
		yellow = token(warn_fg, warn_fg),
		teal = token(hint_fg, hint_fg),
		error = token(error_fg, error_fg),
		gutter = token(whitespace_fg, whitespace_fg),
		orange = token(orange_fg, orange_fg),
		cyan = token(cyan_fg, cyan_fg),
		purple = token(purple_fg, purple_fg),
		pink = token(pink_fg, pink_fg),
		selection = token(nil, selection_bg),
		surface = token(nil, surface_bg),
	}
end

--- 每次调用都重新构建颜色，确保 colorscheme 切换后立即生效
---@return utils.color.colors
M.get_colors = function()
	return build_colors()
end

return M
