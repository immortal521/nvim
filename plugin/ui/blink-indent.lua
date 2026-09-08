local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ "https://github.com/saghen/blink.indent" }, { confirm = false })

	local opts = {
		static = {
			enabled = true,
			char = "│",
		},
		scope = {
			enabled = true,
			char = "│",
			highlights = {
				"BlinkIndentOrange",
				"BlinkIndentViolet",
				"BlinkIndentBlue",
				"BlinkIndentRed",
				"BlinkIndentCyan",
				"BlinkIndentYellow",
				"BlinkIndentGreen",
			},
		},
	}

	require("blink.indent").setup(opts)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
	once = true,
	callback = load,
})
