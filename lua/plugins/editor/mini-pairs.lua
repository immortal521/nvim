-- Auto pairs
---@type LazyPluginSpec
return {
	"nvim-mini/mini.pairs",
	event = "BufEdit",
	opts = {
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	},
}
