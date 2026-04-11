---@type LazyPluginSpec
return {
	"nvim-mini/mini.hipatterns",
	event = "BufEdit",
	config = function()
		local hipatterns = require("mini.hipatterns")

		local function to_case_pattern(word)
			return word:gsub("%a", function(c)
				return string.format("[%s%s]", c:lower(), c:upper())
			end)
		end

		local highlighters = {}

		local groups = {
			Fixme = { "fix", "fixme" },
			Hack = { "warn", "hack", "warning" },
			Note = { "note", "info" },
			Todo = { "todo" },
		}

		for name, words in pairs(groups) do
			local hl = "MiniHipatterns" .. name

			for _, word in ipairs(words) do
				local pattern = "%f[%w]" .. to_case_pattern(word) .. "%f[%W]" .. ":%s*"

				highlighters["tokens_" .. name .. "_" .. word] = {
					pattern = pattern,
					group = hl,
				}
			end
		end

		hipatterns.setup({
			highlighters = vim.tbl_extend("force", highlighters, {
				hex_color = hipatterns.gen_highlighter.hex_color(),
			}),
		})
	end,
}
