local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({
		"https://github.com/MagicDuck/grug-far.nvim",
	}, {
		confirm = false,
	})

	---@type grug.far.Options
	local opts = {
		engines = {
			ripgrep = {
				extraArgs = "-U",
			},
		},
	}

	require("grug-far").setup(opts)

	local keys = {
		{
			"<leader>sr",
			function()
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				require("grug-far").open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "x" },
			desc = "Search and Replace",
		},
	}

	for _, key in ipairs(keys) do
		local opts = vim.tbl_extend("force", {}, key)
		local mode = opts.mode or "n"
		opts[1], opts[2], opts.mode = nil, nil, nil
		vim.keymap.set(mode, key[1], key[2], opts)
	end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
	once = true,
	callback = load,
})
