---@type LazyPluginSpec
return {
	name = "builtin",
	dir = vim.fn.stdpath("config"),
	lazy = false,
	priority = 1000,
	main = "builtin",
	---@type builtin.Config
	opts = {
		-- 是否启用消息总线。[可选值：true、false]
		bus = {
			enabled = true,
		},
		notify = {
			-- 是否在 UIEnter 阶段接管 vim.notify。[可选值：true、false]
			enabled = true,
			-- 通知停留时间，单位为毫秒。[可选值：正整数、0、false]
			timeout = 2000,
			-- 默认堆叠位置。[可选值："NE"（右上）、"SE"（右下）]
			anchor = "NE",
			-- 内容与边框之间的水平空白列数。[可选值：大于或等于 0 的整数]
			padding = 1,
			-- 浮动窗口边框样式。[可选值："rounded"、"single"、"double"、"solid"、false]
			border = "rounded",
			-- 未单独指定进入或退出动画时使用的动画。[可选值："fade"、"slide"、"fade_slide"、"none"]
			animation = "slide",
			-- 进入动画。[可选值："fade"、"slide"、"fade_slide"、"none"]
			-- enter_animation = "slide",
			-- 退出动画。[可选值："fade"、"slide"、"fade_slide"、"none"]
			-- leave_animation = "slide",
			-- 进入动画时间，单位为毫秒。[可选值：正整数]
			enter_duration = 150,
			-- 退出动画时间，单位为毫秒。[可选值：正整数]
			leave_duration = 150,
			-- 动画曲线。[可选值："linear"、"inQuad"、"outQuad"、"inOutQuad"、"inCubic"、"outCubic"、"inSine"、"outSine"、"inBack"、"outBack"]
			easing = "outQuad",
			-- 堆叠重排动画。[可选值："slide"、"none"]
			-- 多个通知时由 notify 自动立即重排，避免窗口短暂重叠。
			reflow_animation = "slide",
			-- 堆叠重排时间，单位为毫秒。[可选值：正整数]
			reflow_duration = 180,
			-- 堆叠重排曲线。[可选值：同 easing]
			reflow_easing = "outQuad",
			-- 不同 backend 的开关和默认堆叠位置。[可选值：enabled 为 true/false，anchor 为 "NE"/"SE"]
			backends = {
				notify = {
					enabled = true,
					anchor = "NE",
					-- notify 的固定宽度配置只作用于 notify backend。
					width = 50,
					max_width = 0.45,
				},
				fidget = {
					enabled = true,
					anchor = "SE",
					-- fidget 只显示透明文本；需要时可设置 icon 字符。
					border = false,
					title = false,
					icon = false,
					padding = 1,
					markdown = true,
					width = 999,
					max_width = 0.95,
				},
			},
			-- 各通知级别的类型栏和边框高亮组名称。[可选值：任意已定义的高亮组名]
			border_hl = {
				error = "BuiltinNotifyErrorBorder",
				warn = "BuiltinNotifyWarnBorder",
				info = "BuiltinNotifyInfoBorder",
				debug = "BuiltinNotifyDebugBorder",
				trace = "BuiltinNotifyTraceBorder",
				success = "BuiltinNotifySuccessBorder",
			},
			-- 是否启用 Markdown 语法高亮。[可选值：true、false]
			markdown = true,
		},
		-- 是否启用平滑滚动。[可选值：true、false]
		scroll = {
			enabled = true,
		},
	},
}
