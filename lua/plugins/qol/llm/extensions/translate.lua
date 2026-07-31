local tools = require("llm.tools")

return {
	handler = tools.qa_handler,
	opts = {
		-- args = [[return {url, "-s", "-N", "-X", "POST", "-H", "Content-Type: application/json", "-H", authorization, "-d", vim.fn.json_encode(body)}]],
		component_width = "60%",
		component_height = "50%",
		input_box_opts = {
			size = "15%",
			border = {
				text = { top = " 󰊿 Trans " },
			},
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:Search",
			},
		},
		preview_box_opts = {
			size = "85%",
			win_options = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
			},
		},
	},
}
