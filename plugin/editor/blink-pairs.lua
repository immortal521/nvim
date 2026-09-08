local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add(
		{ "https://github.com/saghen/blink.pairs", "https://github.com/saghen/blink.lib" },
		{ confirm = false }
	)
	pcall(function()
		require("blink.pairs").download():pwait(60000)
	end)
	require("blink.pairs").setup({
		mappings = {
			enabled = true,
			cmdline = true,
			disabled_filetypes = {},
			pairs = {},
			wrap = { ["<C-b>"] = "motion", ["<C-S-b>"] = "motion_reverse" },
		},
		highlights = {
			enabled = true,
			cmdline = true,
			groups = {
				"BlinkPairsRed",
				"BlinkPairsYellow",
				"BlinkPairsBlue",
				"BlinkPairsOrange",
				"BlinkPairsGreen",
				"BlinkPairsPurple",
				"BlinkPairsCyan",
			},
			unmatched_group = "BlinkPairsUnmatched",
			matchparen = {
				enabled = true,
				cmdline = false,
				include_surrounding = false,
				group = "BlinkPairsMatchParen",
				priority = 250,
			},
		},
		debug = false,
	})
end

vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}, {
	once = true,
	callback = load,
})
