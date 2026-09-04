local icons = require("config.icons")

return {
	static = {
		separator = (icons.bufferline and icons.bufferline.separator) or "│",
	},
	condition = function(self)
		local wins = vim.api.nvim_tabpage_list_wins(0)
		if #wins == 0 then
			return false
		end
		local win = wins[1]
		self.winid = win
		local config = vim.api.nvim_win_get_config(win or 0)
		return config.zindex ~= nil and not vim.api.nvim_win_is_valid(vim.api.nvim_get_current_win())
	end,
	provider = function(self)
		local width = vim.api.nvim_win_get_width(self.winid or 0)
		return string.rep(" ", width) .. self.separator
	end,
	hl = function(self)
		return { fg = self.palette.fg_gutter, bg = self.palette.bg_dim }
	end,
}
