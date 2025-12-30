---@type LazyPluginSpec
return {
	"nvim-mini/mini.hipatterns",
	event = "BufEdit",
	config = function()
		local hipatterns = require("mini.hipatterns")
		local opts = {
			hex_color = hipatterns.gen_highlighter.hex_color(),
		}
		hipatterns.setup(opts)
	end,
}
