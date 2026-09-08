local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ "https://github.com/Kurama622/llm.nvim" }, { confirm = false })
	local models = require("plugins.qol.llm.models")
	local opts = {
		prompt = "You are a helpful chinese assistant.",
		enable_trace = false,
		spinner = { text = { "󰧞󰧞", "󰧞󰧞", "󰧞󰧞", "󰧞󰧞" }, hl = "Title" },
		prefix = { user = { text = " ", hl = "Title" }, assistant = { text = " ", hl = "Added" } },
		display = {
			diff = {
				layout = "vertical",
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "mini_diff",
			},
		},
		web_search = {
			url = "https://api.tavily.com/search",
			fetch_key = vim.env.TAVILY_TOKEN,
			params = {
				auto_parameters = false,
				topic = "general",
				search_depth = "basic",
				chunks_per_source = 3,
				max_results = 3,
				include_answer = true,
				include_raw_content = true,
				include_images = false,
				include_image_descriptions = false,
				include_favicon = false,
			},
		},
		save_session = true,
		max_history = 15,
		max_history_name_length = 20,
		history_path = vim.fn.stdpath("cache") .. "/llm-history",
		models = { models.OpenRouter },
	}
	for _, name in ipairs({ "ui", "extensions", "keymaps" }) do
		opts = vim.tbl_deep_extend("force", opts, require("plugins.qol.llm." .. name))
	end
	vim.api.nvim_set_hl(0, "LlmCmds", { link = "String" })
	require("llm").setup(opts)
end
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, { once = true, callback = load })
for _, item in ipairs({
	{ "<leader>ac", "LLMSessionToggle", "n" },
	{ "<leader>aa", "LLMAppHandler AttachToChat", { "v", "n" } },
	{ "<leader>ak", "LLMAppHandler Ask", { "v", "n" } },
	{ "<leader>ae", "LLMAppHandler CodeExplain", { "n", "v" } },
	{ "<leader>aw", "LLMAppHandler WordTranslate", { "x", "n" } },
	{ "<leader>at", "LLMAppHandler Translate", "n" },
	{ "<leader>aT", "LLMAppHandler TestCode", "x" },
	{ "<leader>ao", "LLMAppHandler OptimCompare", "x" },
	{ "<leader>ag", "LLMAppHandler CommitMsg", "n" },
	{ "<leader>ad", "LLMAppHandler DocString", "v" },
	{ "<leader>au", "LLMAppHandler UserInfo", "n" },
	{ "<leader>ab", "LLMAppHandler BashRunner", { "v", "n" } },
	{ "<leader>ai", "LLMAppHandler FormulaRecognition", { "v", "n" } },
}) do
	vim.keymap.set(item[3], item[1], function()
		load()
		vim.cmd(item[2])
	end, { desc = item[2] })
end
