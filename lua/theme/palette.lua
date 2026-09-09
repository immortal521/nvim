---@class theme.GitColors
---@field add string
---@field change string
---@field delete string

---@class theme.DiagnosticColors
---@field error string
---@field warn string
---@field info string
---@field hint string
---@field bg_error string
---@field bg_warn string
---@field bg_info string
---@field bg_hint string

---@class theme.DiffColors
---@field add string
---@field change string
---@field delete string
---@field text string

---@class theme.Palette
---@field bg string
---@field bg_dim string
---@field bg_deep string
---@field bg_highlight string
---@field bg_search string
---@field fg string
---@field fg_muted string
---@field fg_gutter string
---@field fg_dark string
---@field border string
---@field border_highlight string
---@field selection string
---@field cursor_line string
---@field float { bg: string, fg: string, border: string }
---@field primary string
---@field primary_dim string
---@field primary_bright string
---@field rosewater string
---@field flamingo string
---@field pink string
---@field mauve string
---@field purple string
---@field red string
---@field red_dim string
---@field maroon string
---@field peach string
---@field orange string
---@field yellow string
---@field green string
---@field green_dim string
---@field green_bright string
---@field teal string
---@field sky string
---@field sapphire string
---@field blue string
---@field blue_dim string
---@field blue_bright string
---@field lavender string
---@field cyan string
---@field comment string
---@field terminal_black string
---@field git theme.GitColors
---@field diag theme.DiagnosticColors
---@field diff theme.DiffColors

---@class theme.Palettes
---@field dark theme.Palette
---@field light theme.Palette

local hsluv = require("theme.hsluv")

local day_brightness = 0.3

---RGB transform
---@param color string
---@return number[]
local function rgb(color)
	color = color:lower()
	return {
		tonumber(color:sub(2, 3), 16),
		tonumber(color:sub(4, 5), 16),
		tonumber(color:sub(6, 7), 16),
	}
end

---RGB (Alpha Blend)
---@param foreground string
---@param alpha number|string
---@param background string
---@return string
local function blend(foreground, alpha, background)
	alpha = type(alpha) == "string" and ((tonumber(alpha, 16) or 0) / 0xff) or alpha
	local bg = rgb(background)
	local fg = rgb(foreground)

	local function channel(i)
		local value = alpha * fg[i] + (1 - alpha) * bg[i]
		return math.floor(math.min(math.max(0, value), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", channel(1), channel(2), channel(3))
end

---Tokyonight Invert logic
---@param color any
---@return any
local function invert(color)
	if type(color) == "table" then
		local res = {}
		for key, value in pairs(color) do
			res[key] = invert(value)
		end
		return res
	elseif type(color) == "string" then
		if color ~= "NONE" and color:sub(1, 1) == "#" then
			local hsl = hsluv.hex_to_hsluv(color)
			hsl[3] = 100 - hsl[3]
			if hsl[3] < 40 then
				hsl[3] = hsl[3] + (100 - hsl[3]) * day_brightness
			end
			return hsluv.hsluv_to_hex(hsl)
		end
	end
	return color
end

---@type theme.Palette
local dark = {
	bg = "#1b1d2b",
	bg_dim = "#141622",
	bg_deep = "#10121a",
	bg_highlight = "#282c44",
	bg_search = "#3d4470",

	fg = "#c8d3f5",
	fg_muted = "#828bb8",
	fg_gutter = "#444a73",
	fg_dark = "#636da6",

	border = "#3b4261",
	border_highlight = "#78a9ff",
	selection = "#363c66",
	cursor_line = "#222538",

	-- Floating Windows
	float = {
		bg = "#141622",
		fg = "#c8d3f5",
		border = "#3b4261",
	},

	primary = "#78a9ff",
	primary_dim = "#436fcd",
	primary_bright = "#a1c2ff",

	rosewater = "#f2d5cf",
	flamingo = "#eebebe",
	pink = "#fca7ea",
	mauve = "#ca9ee6",
	purple = "#c099ff",
	red = "#ff757f",
	red_dim = "#c53b53",
	maroon = "#ea999c",
	peach = "#ef9f76",
	orange = "#ff966c",
	yellow = "#ffc777",
	green = "#c3e88d",
	green_dim = "#a6d189",
	green_bright = "#4fd6be",
	teal = "#4fd6be",
	sky = "#99d1db",
	sapphire = "#85c1dc",
	blue = "#82aaff",
	blue_dim = "#3e68d7",
	blue_bright = "#65bcff",
	lavender = "#babbf1",
	cyan = "#86e1fc",

	comment = "#636da6",
	terminal_black = "#444a73",

	git = {
		add = "#b8db87",
		change = "#78a9ff",
		delete = "#e26a75",
	},

	diag = {
		error = "#ff757f",
		warn = "#ffc777",
		info = "#78a9ff",
		hint = "#4fd6be",
		bg_error = blend("#ff757f", 0.15, "#1b1d2b"),
		bg_warn = blend("#ffc777", 0.15, "#1b1d2b"),
		bg_info = blend("#78a9ff", 0.15, "#1b1d2b"),
		bg_hint = blend("#4fd6be", 0.15, "#1b1d2b"),
	},

	diff = {
		add = blend("#b8db87", 0.18, "#1b1d2b"),
		change = blend("#78a9ff", 0.18, "#1b1d2b"),
		delete = blend("#e26a75", 0.18, "#1b1d2b"),
		text = blend("#78a9ff", 0.35, "#1b1d2b"),
	},
}

---@param base theme.Palette
---@return theme.Palette
local function generate_light(base)
	local colors = vim.deepcopy(base)
	colors = invert(colors)

	-- Recalculate specific overlays based on the transposed primary
	-- background and text colors to ensure smooth blending.
	colors.bg_dim = blend(colors.bg, 0.9, colors.fg)
	colors.bg_deep = blend(colors.bg_dim, 0.9, colors.fg)

	-- Reblend backgrounds with transparency to prevent misalignment of the blending base.
	colors.diag.bg_error = blend(colors.diag.error, 0.15, colors.bg)
	colors.diag.bg_warn = blend(colors.diag.warn, 0.15, colors.bg)
	colors.diag.bg_info = blend(colors.diag.info, 0.15, colors.bg)
	colors.diag.bg_hint = blend(colors.diag.hint, 0.15, colors.bg)

	colors.diff.add = blend(colors.git.add, 0.18, colors.bg)
	colors.diff.change = blend(colors.git.change, 0.18, colors.bg)
	colors.diff.delete = blend(colors.git.delete, 0.18, colors.bg)
	colors.diff.text = blend(colors.git.change, 0.35, colors.bg)

	return colors
end

return {
	dark = dark,
	light = generate_light(dark),
}
