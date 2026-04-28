return {
	provider = function(self)
		local modified = vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
		return modified and "   " or " ✗ "
	end,
	hl = function(self)
		return {
			fg = self.is_active and self.colors.blue.fg or self.colors.comment.fg,
			bg = self.is_active and self.colors.normal.bg or self.colors.black.bg,
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
