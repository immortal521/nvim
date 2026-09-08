local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.g.no_plugin_maps = true
	vim.pack.add({
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		"https://github.com/nvim-treesitter/nvim-treesitter",
	}, { confirm = false, load = false })
	vim.cmd.packadd("nvim-treesitter")
	vim.cmd.packadd("nvim-treesitter-textobjects")
	local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
	if not ok then
		return
	end
	textobjects.setup({ move = { set_jumps = true }, swap = { enable = true } })
	local repeatable = require("nvim-treesitter-textobjects.repeatable_move")
	local move = require("nvim-treesitter-textobjects.move")
	local swap = require("nvim-treesitter-textobjects.swap")
	local keys = {
		{ ";", repeatable.repeat_last_move_next, { "n", "x", "o" } },
		{ ",", repeatable.repeat_last_move_previous, { "n", "x", "o" } },
		{ "f", repeatable.builtin_f_expr, { "n", "x", "o" }, true },
		{ "F", repeatable.builtin_F_expr, { "n", "x", "o" }, true },
		{ "t", repeatable.builtin_t_expr, { "n", "x", "o" }, true },
		{ "T", repeatable.builtin_T_expr, { "n", "x", "o" }, true },
	}
	local moves = {
		{ "]z", "goto_next_start", "@fold", "folds", "Goto next fold point" },
		{ "]f", "goto_next_start", "@function.outer", "textobjects", "Next function start" },
		{ "]F", "goto_next_end", "@function.outer", "textobjects", "Next function end" },
		{ "[F", "goto_previous_end", "@function.outer", "textobjects", "Previous function end" },
		{ "[f", "goto_previous_start", "@function.outer", "textobjects", "Previous function start" },
		{ "]c", "goto_next_start", "@class.outer", "textobjects", "Next class start" },
		{ "[c", "goto_previous_start", "@class.outer", "textobjects", "Previous class start" },
		{ "]C", "goto_next_end", "@class.outer", "textobjects", "Next class end" },
		{ "[C", "goto_previous_end", "@class.outer", "textobjects", "Previous class end" },
		{ "]a", "goto_next_start", "@parameter.inner", "textobjects", "Next argument start" },
		{ "[a", "goto_previous_start", "@parameter.inner", "textobjects", "Previous argument start" },
		{ "]A", "goto_next_end", "@parameter.inner", "textobjects", "Next argument end" },
		{ "[A", "goto_previous_end", "@parameter.inner", "textobjects", "Previous argument end" },
		{ "]=", "goto_next_start", "@assignment.outer", "textobjects", "Next assignment" },
		{ "[=", "goto_previous_start", "@assignment.outer", "textobjects", "Previous assignment" },
		{ "]r", "goto_next_start", "@return.outer", "textobjects", "Next return" },
		{ "[r", "goto_previous_start", "@return.outer", "textobjects", "Previous return" },
	}
	for _, item in ipairs(moves) do
		table.insert(keys, {
			item[1],
			function()
				move[item[2]](item[3], item[4])
			end,
			{ "n", "x", "o" },
			false,
			item[5],
		})
	end
	for _, item in ipairs({
		{ ">a", "@parameter.inner", "swap_next" },
		{ "<a", "@parameter.inner", "swap_previous" },
		{ ">f", "@function.outer", "swap_next" },
		{ "<f", "@function.outer", "swap_previous" },
	}) do
		table.insert(keys, {
			item[1],
			function()
				swap[item[3]](item[2])
			end,
			"n",
			false,
			"Swap textobject",
		})
	end
	for _, item in ipairs(keys) do
		vim.keymap.set(item[3] or "n", item[1], item[2], { expr = item[4] or false, desc = item[5] })
	end
end

vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufWritePre",
}, {
	once = true,
	callback = load,
})
