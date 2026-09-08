local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({
		"https://github.com/immortal521/auto-save.nvim",
	}, {
		confirm = false,
	})

	local opts = {
		debounce_delay = 1000,
		print_enabled = false,
		trigger_events = { "InsertLeave", "TextChanged" },
		condition = function(buf)
			local fn = vim.fn

			if fn.getbufvar(buf, "&filetype") == "oil" then
				return false
			end

			if fn.getbufvar(buf, "&modifiable") == 1 then
				return fn.mode() == "n"
			end

			return false
		end,
	}

	require("auto-save").setup(opts)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
	once = true,
	callback = load,
})
