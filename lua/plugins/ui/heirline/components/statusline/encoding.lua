local get_enc = function()
	local enc = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
	return enc:upper()
end

return {
	condition = function()
		return get_enc() ~= "UTF-8"
	end,
	provider = function()
		local bomb = vim.bo.bomb and "[BOM]" or ""
		return " " .. get_enc() .. bomb .. " "
	end,
	hl = function(self)
		return { fg = self.palette.fg_muted or self.palette.fg_gutter }
	end,
}
