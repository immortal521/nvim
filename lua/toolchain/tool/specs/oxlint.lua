local configs = { ".oxlintrc.json" }

---@type ToolSpec
return {
	linter = {
		condition = function(ctx)
			return #vim.fs.find(configs, {
				path = ctx.dirname,
				upward = true,
				stop = vim.uv.os_homedir(),
			}) > 0
		end,
	},
}
