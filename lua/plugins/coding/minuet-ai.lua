---@type LazyPluginSpec
return {
	"milanglacier/minuet-ai.nvim",
	event = "BufEdit",
	---@type minuet.DuetConfig
	opts = {
		provider = "openai_compatible",

		provider_options = {
			openai_compatible = {
				api_key = function()
					return os.getenv("OPENROUTER_TOKEN")
				end,
				name = "Openrouter",
				end_point = "https://openrouter.ai/api/v1/chat/completions",
				model = "poolside/laguna-xs-2.1:free",
				optional = {
					max_tokens = 256,
					temperature = 0.2,
				},
			},
		},

		blink = {
			enable_auto_complete = true,
		},
		context_window = 1000,
		debounce = 400,
		-- notify = "debug",
		request_timeout = 20,
	},
}
