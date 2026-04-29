-- Enhance Ctrl-A/X

---@type table<string, string> Map of filetype to dial group
local ft_groups = {
	lua = "lua",
	markdown = "markdown",
}

---@param direction direction
---@param g boolean
local function dial(direction, g)
	local is_visual = vim.fn.mode(true):find("^[vV\22]")
	local mode = (g and "g" or "") .. (is_visual and "visual" or "normal")
	local group = ft_groups[vim.bo.filetype] or "default"

	---@cast mode mode
	return require("dial.map").manipulate(direction, mode, group)
end

---@type zpack.Spec
return {
	"monaqa/dial.nvim",
	opts = function()
		local augend = require("dial.augend")

		return {
			groups = {
				default = {
					augend.integer.alias.decimal_int,
					augend.integer.alias.hex,
					augend.constant.alias.bool,
					augend.constant.alias.Bool,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%m/%d/%Y"],
					augend.date.alias["%Y年%-m月%-d日"],
					augend.date.new({
						pattern = "%Y/%m/%d",
						default_kind = "day",
						only_valid = true,
						word = false,
					}),
					augend.semver.alias.semver,
				},
				lua = {
					augend.constant.new({
						elements = { "and", "or" },
						word = true,
						cyclic = true,
					}),
				},
				markdown = {
					augend.constant.new({
						elements = { "[ ]", "[x]" },
						word = false,
						cyclic = true,
					}),
					augend.misc.alias.markdown_header,
				},
			},
		}
	end,
	config = function(_, opts)
		for name, group in pairs(opts.groups) do
			if name ~= "default" then
				vim.list_extend(group, opts.groups.default)
			end
		end

		require("dial.config").augends:register_group(opts.groups)
	end,
	keys = {
		{
			"<C-a>",
			function()
				return dial("increment", false)
			end,
			desc = "Increment",
			mode = { "n", "v" },
		},
		{
			"<C-x>",
			function()
				return dial("decrement", false)
			end,
			desc = "Decrement",
			mode = { "n", "v" },
		},
		{
			"g<C-a>",
			function()
				return dial("increment", true)
			end,
			desc = "Increment",
			mode = { "n", "x" },
		},
		{
			"g<C-x>",
			function()
				return dial("decrement", true)
			end,
			desc = "Decrement",
			mode = { "n", "x" },
		},
	},
}
