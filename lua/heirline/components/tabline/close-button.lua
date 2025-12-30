local colors = Utils.colors()

return {
	provider = function(self)
		local modified = vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
		return modified and "   " or " ✗ "
	end,
	hl = function(self)
		return {
			fg = self.is_active and colors.blue or colors.comment,
			bg = self.is_active and colors.bg or colors.black,
			bold = self.is_active or self.is_visible,
			italic = self.is_active,
		}
	end,
	on_click = {
		callback = function(_, minwid)
			vim.schedule(function()
				local modified = vim.api.nvim_get_option_value("modified", { buf = minwid })
				if modified then
					return
				end
				vim.api.nvim_buf_delete(minwid, { force = false })
				vim.cmd.redrawtabline()
			end)
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_tabline_close_buffer_callback",
	},
}
