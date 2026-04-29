---@type zpack.Spec
return {
	"immortal521/auto-save.nvim",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {
		debounced_dekay = 1000,
		print_enabled = false,
		trigger_events = { "InsertLeave", "TextChanged" },
		condition = function(buf)
			local fn = vim.fn

			if fn.getbufvar(buf, "&filetype") == "oil" then
				return false
			end

			if fn.getbufvar(buf, "&modifiable") == 1 then
				return fn.mode() == "n"
			end

			return false
		end,
	},
}
