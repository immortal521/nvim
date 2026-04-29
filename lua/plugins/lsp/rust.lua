---@type zpack.Spec[]
return {
	{
		"saecki/crates.nvim",
		tag = "stable",
		ft = { "rust", "cargo.toml" },
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
}
