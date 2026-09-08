local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/monaqa/dial.nvim" }, { confirm = false })
	local augend = require("dial.augend")
	local groups = {
		default = {
			augend.integer.alias.decimal_int,
			augend.integer.alias.hex,
			augend.constant.alias.bool,
			augend.constant.alias.Bool,
			augend.date.alias["%Y/%m/%d"],
			augend.date.alias["%m/%d/%Y"],
			augend.semver.alias.semver,
		},
		lua = { augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }) },
		markdown = {
			augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
			augend.misc.alias.markdown_header,
		},
	}
	for name, group in pairs(groups) do
		if name ~= "default" then
			vim.list_extend(group, groups.default)
		end
	end
	require("dial.config").augends:register_group(groups)
end
local function dial(direction, g)
	load()
	local visual = vim.fn.mode(true):find("^[vV\22]")
	return require("dial.map").manipulate(
		direction,
		(g and "g" or "") .. (visual and "visual" or "normal"),
		vim.bo.filetype == "lua" and "lua" or vim.bo.filetype == "markdown" and "markdown" or "default"
	)
end

for _, item in ipairs({
	{ "<C-a>", "increment", false },
	{ "<C-x>", "decrement", false },
	{ "g<C-a>", "increment", true },
	{ "g<C-x>", "decrement", true },
}) do
	vim.keymap.set({ "n", "x" }, item[1], function()
		return dial(item[2], item[3])
	end, { expr = true, desc = item[2] == "increment" and "Increment" or "Decrement" })
end
