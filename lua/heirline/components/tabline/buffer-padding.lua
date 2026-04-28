return {
	provider = function(self)
		return string.rep(" ", self.buffer_padding)
	end,
	hl = function(self)
		return self.is_active and { bg = self.colors.normal.bg }
	end,
}
