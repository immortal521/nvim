-- Highlight TODO comments and can search them
---@type LazyPluginSpec
return {
	"folke/todo-comments.nvim",
	event = "BufEdit",

	---@type TodoOptions
	opts = {},
}
