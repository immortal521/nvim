return {
	provider = function(self)
		return string.rep(" ", self.buffer_padding or 0)
	end,
	hl = function(self)
		return {
			bg = self.is_active and self.palette.bg or self.palette.bg_dim,
		}
	end,
}
