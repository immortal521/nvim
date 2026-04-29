-- require("vim._core.ui2").enable({})
---@type zpack.Spec
return {
	"rachartier/tiny-cmdline.nvim",
	enabled = false,
	init = function()
		-- vim.o.cmdheight = 0
		-- vim.g.tiny_cmdline = {
		-- 	width = { value = "70%" },
		-- }
	end,
}
