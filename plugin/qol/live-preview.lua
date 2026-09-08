local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/brianhuster/live-preview.nvim" }, { confirm = false })
	require("livepreview.config").set()
end
for _, item in ipairs({
	{ "<leader>cps", "LivePreview start", "Live Preview Start" },
	{ "<leader>cpc", "LivePreview close", "Live Preview Stop" },
	{ "<leader>cpp", "LivePreview pick", "Live Preview Select" },
}) do
	vim.keymap.set("n", item[1], function()
		load()
		vim.cmd(item[2])
	end, { desc = item[3] })
end
