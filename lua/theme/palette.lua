---@class theme.GitColors
---@field add string # Git 新增颜色
---@field change string # Git 修改颜色
---@field delete string # Git 删除颜色

---@class theme.DiagnosticColors
---@field error string # 错误主色
---@field warn string # 警告主色
---@field info string # 信息主色
---@field hint string # 提示主色
---@field bg_error string # 错误混合背景
---@field bg_warn string # 警告混合背景
---@field bg_info string # 信息混合背景
---@field bg_hint string # 提示混合背景

---@class theme.DiffColors
---@field add string # Diff 新增高亮
---@field change string # Diff 修改高亮
---@field delete string # Diff 删除高亮
---@field text string # Diff 细粒度修改文字高亮

---@class theme.Palette
---@field bg string # 编辑器主背景
---@field bg_dim string # 稍微偏暗的背景（如侧边栏、NVTree）
---@field bg_deep string # 深沉背景（如 Quickfix、底栏）
---@field bg_highlight string # 行高亮/选中态淡背景
---@field bg_search string # 搜索匹配项背景
---@field fg string # 标准前景色（代码/文本）
---@field fg_muted string # 次要前景色（参数、辅助文本）
---@field fg_gutter string # 行号栏前景色
---@field fg_dark string # 暗浅前景色（如状态栏非激活状态）
---@field border string # 标准边框色
---@field border_highlight string # 焦点/高亮边框色（如浮动窗口）
---@field selection string # 视觉模式选中背景色
---@field cursor_line string # 光标行背景色
---@field float { bg: string, fg: string, border: string } # 浮动窗口专用色
---@field statusline { bg: string, fg: string, active: string, inactive: string } # 状态栏专用色
---@field blue string
---@field blue_dim string
---@field blue_bright string
---@field cyan string
---@field green string
---@field green_bright string
---@field yellow string
---@field orange string
---@field red string
---@field red_dim string
---@field purple string
---@field pink string
---@field comment string # 注释颜色（已校验对比度）
---@field terminal_black string
---@field git theme.GitColors
---@field diag theme.DiagnosticColors
---@field diff theme.DiffColors

---@class theme.Palettes
---@field dark theme.Palette
---@field light theme.Palette

local M = {}

---RGB 辅助转换
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

---RGB 色彩混合 (Alpha Blend)
---@param foreground string # 六位十六进制颜色值 (例如 "#ffffff")
---@param alpha number # 混合透明度 0.0 ~ 1.0
---@param background string # 六位十六进制背景色
---@return string
local function blend(foreground, alpha, background)
	local bg = rgb(background)
	local fg = rgb(foreground)

	local function channel(i)
		local value = alpha * fg[i] + (1 - alpha) * bg[i]
		return math.floor(math.min(math.max(0, value), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", channel(1), channel(2), channel(3))
end

---【深邃极光】Dark 主题定义
---@type theme.Palette
local dark = {
	-- Backgrounds
	bg = "#1b1d2b",
	bg_dim = "#141622",
	bg_deep = "#10121a",
	bg_highlight = "#282c44",
	bg_search = "#3d4470",

	-- Foregrounds
	fg = "#c8d3f5",
	fg_muted = "#828bb8",
	fg_gutter = "#444a73",
	fg_dark = "#636da6",

	-- UI Elements
	border = "#2f334d",
	border_highlight = "#5895fff0",
	selection = "#363c66",
	cursor_line = "#222538",

	-- Floating Windows
	float = {
		bg = "#141622",
		fg = "#c8d3f5",
		border = "#3b4261",
	},

	-- StatusLine
	statusline = {
		bg = "#141622",
		fg = "#828bb8",
		active = "#c8d3f5",
		inactive = "#444a73",
	},

	-- Accent & Syntax Colors
	blue = "#82aaff",
	blue_dim = "#3e68d7",
	blue_bright = "#65bcff",

	cyan = "#86e1fc",

	green = "#c3e88d",
	green_bright = "#4fd6be",

	yellow = "#ffc777",
	orange = "#ff966c",

	red = "#ff757f",
	red_dim = "#c53b53",

	purple = "#c099ff",
	pink = "#fca7ea",

	comment = "#636da6",
	terminal_black = "#444a73",

	-- Git Status
	git = {
		add = "#b8db87",
		change = "#7ca1f2",
		delete = "#e26a75",
	},

	-- Diagnostics (带有自动混合的低饱和背景)
	diag = {
		error = "#ff757f",
		warn = "#ffc777",
		info = "#00bfff",
		hint = "#4fd6be",
		bg_error = blend("#ff757f", 0.15, "#1b1d2b"),
		bg_warn = blend("#ffc777", 0.15, "#1b1d2b"),
		bg_info = blend("#00bfff", 0.15, "#1b1d2b"),
		bg_hint = blend("#4fd6be", 0.15, "#1b1d2b"),
	},

	-- Diff Controls
	diff = {
		add = blend("#b8db87", 0.20, "#1b1d2b"),
		change = blend("#7ca1f2", 0.20, "#1b1d2b"),
		delete = blend("#e26a75", 0.20, "#1b1d2b"),
		text = blend("#7ca1f2", 0.40, "#1b1d2b"),
	},
}

---根据 HSLuv 感知色彩空间生成具有高对比度与舒爽度的 Light 主题
---@param base theme.Palette
---@return theme.Palette
local function generate_light(base)
	local hsluv = require("tokyonight.hsluv")

	---调整 Hex 颜色的 HSLuv 属性
	---@param hex string
	---@param target_l number # 目标明度 (0 - 100)
	---@param chroma_ratio? number # 饱和度缩放系数 (例如 0.8 表示降饱和)
	---@return string
	local function adapt(hex, target_l, chroma_ratio)
		if not hex or hex:sub(1, 1) ~= "#" then
			return hex
		end
		local hsl = hsluv.hex_to_hsluv(hex)
		hsl[3] = target_l
		if chroma_ratio then
			hsl[2] = math.min(100, hsl[2] * chroma_ratio)
		end
		return hsluv.hsluv_to_hex(hsl)
	end

	-- 1. 基础背景与底色（羊膏纸/柔润白基调，非刺眼纯白）
	local bg = "#e1e4ee"
	local bg_dim = "#d5d8e6"
	local bg_deep = "#c8ccde"

	-- 2. 重置语法与强调色（针对白底，将明度压至 L*=32~42，保障 WCAG AA 对比度）
	local light_palette = {
		bg = bg,
		bg_dim = bg_dim,
		bg_deep = bg_deep,
		bg_highlight = "#d0d4e6",
		bg_search = "#a8b5e6",

		fg = "#2e3352",
		fg_muted = "#5c638a",
		fg_gutter = "#9aa0c0",
		fg_dark = "#787fcd",

		border = "#b8be3b",
		border_highlight = "#2b5ce6",
		selection = "#b6c2f0",
		cursor_line = "#d8dcfa",

		float = {
			bg = bg_dim,
			fg = "#2e3352",
			border = "#aab0d0",
		},

		statusline = {
			bg = bg_dim,
			fg = "#5c638a",
			active = "#2e3352",
			inactive = "#9aa0c0",
		},

		-- 语法高亮色调整（在 Light 模式下降低明度）
		blue = adapt(base.blue, 38, 1.1),
		blue_dim = adapt(base.blue_dim, 32),
		blue_bright = adapt(base.blue_bright, 35),
		cyan = adapt(base.cyan, 34, 1.2),
		green = adapt(base.green, 32, 1.2),
		green_bright = adapt(base.green_bright, 30),
		yellow = adapt(base.yellow, 38, 1.4),
		orange = adapt(base.orange, 36, 1.2),
		red = adapt(base.red, 40),
		red_dim = adapt(base.red_dim, 32),
		purple = adapt(base.purple, 38),
		pink = adapt(base.pink, 40),

		comment = "#767c9d",
		terminal_black = "#9aa0c0",

		git = {
			add = adapt(base.git.add, 32, 1.2),
			change = adapt(base.git.change, 38),
			delete = adapt(base.git.delete, 40),
		},

		diag = {
			error = adapt(base.diag.error, 40),
			warn = adapt(base.diag.warn, 38, 1.3),
			info = adapt(base.diag.info, 36),
			hint = adapt(base.diag.hint, 34),
			bg_error = blend(adapt(base.diag.error, 40), 0.12, bg),
			bg_warn = blend(adapt(base.diag.warn, 38), 0.12, bg),
			bg_info = blend(adapt(base.diag.info, 36), 0.12, bg),
			bg_hint = blend(adapt(base.diag.hint, 34), 0.12, bg),
		},

		diff = {
			add = blend("#2e8b57", 0.15, bg),
			change = blend("#2b5ce6", 0.15, bg),
			delete = blend("#dc143c", 0.15, bg),
			text = blend("#2b5ce6", 0.30, bg),
		},
	}

	return light_palette
end

return {
	dark = dark,
	light = generate_light(dark),
}
