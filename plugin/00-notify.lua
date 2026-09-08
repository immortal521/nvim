local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ "https://github.com/rcarriga/nvim-notify" }, { confirm = false })

	local opts = {
		max_width = 50,
		background_colour = "#000000",
		stages = "slide",
		timeout = 1500,
	}

	vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "NONE" })

	require("notify").setup(opts)
end

load()
