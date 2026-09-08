local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" }, { confirm = false })
	require("kulala").setup({})
end

local keys = {
	{ "<leader>Rb", "scratchpad", "Open scratchpad" },
	{ "<leader>Rc", "copy", "Copy as cURL" },
	{ "<leader>RC", "from_curl", "Paste from curl" },
	{ "<leader>Re", "set_selected_env", "Set environment" },
	{ "<leader>Rg", "download_graphql_schema", "Download GraphQL schema" },
	{ "<leader>Ri", "inspect", "Inspect current request" },
	{ "<leader>Rn", "jump_next", "Jump to next request" },
	{ "<leader>Rp", "jump_prev", "Jump to previous request" },
	{ "<leader>Rq", "close", "Close window" },
	{ "<leader>Rr", "replay", "Replay the last request" },
	{ "<leader>Rs", "run", "Send the request" },
	{ "<leader>RS", "show_stats", "Show stats" },
	{ "<leader>Rt", "toggle_view", "Toggle headers/body" },
}

for _, item in ipairs(keys) do
	vim.keymap.set("n", item[1], function()
		load()
		require("kulala")[item[2]]()
	end, { desc = item[3] })
end
