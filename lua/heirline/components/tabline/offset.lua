local icons = require("config.icons")

return {
	static = {
		separator = icons.bufferline.separator,
	},
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]

		---@cast win integer
		self.winid = win
		local config = vim.api.nvim_win_get_config(win)
		return config.zindex ~= nil and not vim.api.nvim_win_is_valid(vim.api.nvim_get_current_win())
	end,
	provider = function(self)
		return string.rep(" ", vim.api.nvim_win_get_width(self.winid)) .. self.separator
	end,
	hl = function(self)
		return { fg = self.colors.gutter.fg }
	end,
}
