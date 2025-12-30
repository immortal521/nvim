local colors = Utils.colors()

return {
	{
		provider = function()
			local enc = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
			local bomb = vim.bo.bomb and "[BOM]" or ""
			return " " .. enc:upper() .. bomb .. " "
		end,
		hl = { fg = colors.fg_gutter },
	},
	{
		provider = "",
		hl = { fg = colors.fg_gutter },
	},
}
