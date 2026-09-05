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
---@param foreground string
---@param alpha number|string
---@param background string
---@return string
local function blend(foreground, alpha, background)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) or 0 / 0xff) or alpha
	local bg = rgb(background)
	local fg = rgb(foreground)

	local function channel(i)
		local value = alpha * fg[i] + (1 - alpha) * bg[i]
		return math.floor(math.min(math.max(0, value), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", channel(1), channel(2), channel(3))
end

---Tokyonight 原生 Invert 逻辑
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

	-- =========================================================================
	-- Extended Catppuccin Syntax Accents (标准功能与高亮全色阶)
	-- =========================================================================
	rosewater = "#f2d5cf", -- Winbar 高亮 / 特殊标点
	flamingo = "#eebebe", -- 变量引用 / 弱强调标签
	pink = "#fca7ea", -- 预处理指令 / 宏 / 装饰标签
	mauve = "#ca9ee6", -- 特殊结构体 / 转义字符 / 正则
	purple = "#c099ff", -- 逻辑关键字 (if/return)
	red = "#ff757f", -- 错误 / 破坏性操作 / 声明
	red_dim = "#c53b53", -- 暗红 / 弱化报错
	maroon = "#ea999c", -- 异常捕获 / 强提示
	peach = "#ef9f76", -- 函数参数 / 变量名
	orange = "#ff966c", -- 数字 / 常量 / 布尔值
	yellow = "#ffc777", -- 类名 / 构造函数
	green = "#c3e88d", -- 字符串
	green_dim = "#a6d189", -- 弱高亮绿 / 文档注解代码
	green_bright = "#4fd6be", -- 高亮绿 / 格式化符号
	teal = "#4fd6be", -- 结构体属性 / 成员访问
	sky = "#99d1db", -- 路径 / 模块导入
	sapphire = "#85c1dc", -- 内置类型 / 特殊函数
	blue = "#82aaff", -- 标准蓝色：用于普通函数 / 方法调用
	blue_dim = "#3e68d7", -- 辅助深蓝 / UI装饰
	blue_bright = "#65bcff", -- 超链接 / 强高亮蓝
	lavender = "#babbf1", -- 接口 / 泛型 / 成员变量
	cyan = "#86e1fc", -- 类型声明 / 运算符

	comment = "#636da6",
	terminal_black = "#444a73",

	-- Git Status (其中 change 改为联动基调色)
	git = {
		add = "#b8db87",
		change = "#78a9ff",
		delete = "#e26a75",
	},

	-- Diagnostics (其中 info 改为联动基调色)
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

	-- Diff Controls (其中 change 和 text 改为联动基调色)
	diff = {
		add = blend("#b8db87", 0.18, "#1b1d2b"),
		change = blend("#78a9ff", 0.18, "#1b1d2b"),
		delete = blend("#e26a75", 0.18, "#1b1d2b"),
		text = blend("#78a9ff", 0.35, "#1b1d2b"),
	},
}

---根据 Tokyonight 官方 invert 算法生成 Light 调色盘
---@param base theme.Palette
---@return theme.Palette
local function generate_light(base)
	local colors = vim.deepcopy(base)
	colors = invert(colors)

	-- 根据转置后的主背景与文本颜色重新计算特定叠加层，确保平滑
	colors.bg_dim = blend(colors.bg, 0.9, colors.fg)
	colors.bg_deep = blend(colors.bg_dim, 0.9, colors.fg)

	-- 重新混合带有透明度的背景（防止混合基底错位）
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
