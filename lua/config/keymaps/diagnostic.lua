local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end

local keys = {
	{ "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
	{ "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
	{ "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
	{ "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
	{ "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
	{ "]w", diagnostic_goto(true, "WARN"), desc = "Next Warning" },
	{ "[w", diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
}

Utils.keymap.add(keys)
