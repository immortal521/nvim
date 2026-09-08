local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ "https://github.com/gbprod/yanky.nvim" }, { confirm = false })

	local opts = {
		system_clipboard = {
			sync_with_ring = not vim.env.SSH_CONNECTION,
		},
		highlight = { timer = 150 },
	}

	require("yanky").setup(opts)

	local keys = {
		{
			"<leader>v",
			"<cmd>YankyRingHistory<cr>",
			mode = { "n", "x" },
			desc = "Open Yank History",
		},
		{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
		{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
		{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
		{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
		{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
		{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
		{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
		{ ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
		{ "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
		{ ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
		{ "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
		{ "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
		{ "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
	}

	for _, key in ipairs(keys) do
		local opts = vim.tbl_extend("force", {}, key)
		local mode = opts.mode or "n"
		opts[1], opts[2], opts.mode = nil, nil, nil
		vim.keymap.set(mode, key[1], key[2], opts)
	end
end

vim.schedule(load)
