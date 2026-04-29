-- Auto pairs
---@type LazyPluginSpec
return {
	"nvim-mini/mini.pairs",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	opts = {
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	},
}
