local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/nvim-mini/mini.hipatterns" }, { confirm = false })
	local hipatterns = require("mini.hipatterns")
	local function pattern(word)
		return "%f[%w]"
			.. word:gsub("%a", function(c)
				return string.format("[%s%s]", c:lower(), c:upper())
			end)
			.. "%f[%W]:%s*"
	end
	local highlighters = {}
	for name, words in pairs({
		Fixme = { "fix", "fixme" },
		Hack = { "warn", "hack", "warning" },
		Note = { "note", "info" },
		Todo = { "todo" },
	}) do
		for _, word in ipairs(words) do
			highlighters["tokens_" .. name .. "_" .. word] =
				{ pattern = pattern(word), group = "MiniHipatterns" .. name }
		end
	end
	hipatterns.setup({
		highlighters = vim.tbl_extend("force", highlighters, { hex_color = hipatterns.gen_highlighter.hex_color() }),
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
