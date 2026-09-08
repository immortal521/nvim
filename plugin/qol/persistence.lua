local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/folke/persistence.nvim" }, { confirm = false })
	vim.api.nvim_create_autocmd("User", {
		pattern = "PersistenceLoadPost",
		callback = function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[buf].filetype == "oil" or vim.api.nvim_buf_get_name(buf):match("oil") then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end,
	})
	require("persistence").setup({ need = 1, branch = true })
end

-- Dashboard buttons call persistence directly. Load it when Alpha is ready so
-- those actions remain usable without making Persistence eager for every start.
vim.api.nvim_create_autocmd("User", {
	pattern = "AlphaReady",
	once = true,
	callback = load,
})

local keys = {
	{
		"<leader>qs",
		function()
			load()
			require("persistence").load()
		end,
		"Restore Session",
	},
	{
		"<leader>qS",
		function()
			load()
			require("persistence").select()
		end,
		"Select Session",
	},
	{
		"<leader>ql",
		function()
			load()
			require("persistence").load({ last = true })
		end,
		"Restore Last Session",
	},
	{
		"<leader>qd",
		function()
			load()
			require("persistence").stop()
		end,
		"Don't Save Current Session",
	},
}
for _, item in ipairs(keys) do
	vim.keymap.set("n", item[1], item[2], { desc = item[3] })
end
