local loaded = false
local function buffer_object(kind)
	local first, last = 1, vim.fn.line("$")
	if kind == "i" then
		first, last = vim.fn.nextnonblank(first), vim.fn.prevnonblank(last)
		if first == 0 or last == 0 then
			return { from = { line = 1, col = 1 } }
		end
	end
	local text = vim.fn.getline(last)
	return { from = { line = first, col = 1 }, to = { line = last, col = math.max(#text, 1) } }
end
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/nvim-mini/mini.ai" }, { confirm = false })
	local ai = require("mini.ai")
	require("mini.ai").setup({
		custom_textobjects = {
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			d = { "%f[%d]%d+" },
			e = {
				{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
				"^().*()$",
			},
			g = buffer_object,
			u = ai.gen_spec.function_call(),
			U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
		},
		mappings = {
			around = "a",
			inside = "i",
			around_next = "an",
			inside_next = "in",
			around_last = "al",
			inside_last = "il",
			goto_left = "g[",
			goto_right = "g]",
		},
		n_lines = 50,
		search_method = "cover_or_next",
		silent = false,
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
