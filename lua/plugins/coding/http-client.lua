---@type LazyPluginSpec
return {
	"heilgar/nvim-http-client",
	event = "VeryLazy",
	ft = { "http", "rest" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local http_client = require("http_client")
		http_client.setup({
			create_keybindings = false,
			default_env_file = "http-client.env.json",
		})

		local function load_buffer_env(buf)
			local path = vim.api.nvim_buf_get_name(buf)
			if path == "" then
				return
			end

			local env_file = vim.fs.find("http-client.env.json", {
				path = vim.fs.dirname(path),
				upward = true,
			})[1]
			if env_file then
				http_client.file_utils.set_project_root(vim.fs.dirname(env_file))
				http_client.environment.set_env_file(env_file)
			end
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("http_client_project_env", { clear = true }),
			pattern = { "*.http", "*.rest" },
			callback = function(args)
				load_buffer_env(args.buf)
			end,
		})
		load_buffer_env(vim.api.nvim_get_current_buf())
	end,
	keys = {
		{ "<leader>R", "", desc = "+Rest" },
		{ "<leader>Rc", "<cmd>HttpCopyCurl<cr>", desc = "Copy as cURL" },
		{ "<leader>Re", "<cmd>HttpEnv<cr>", desc = "Set environment" },
		{ "<leader>Rf", "<cmd>HttpEnvFile<cr>", desc = "Select environment file" },
		{ "<leader>Rp", "<cmd>HttpProfiling<cr>", desc = "Toggle profiling" },
		{ "<leader>Rs", "<cmd>HttpRun<cr>", desc = "Send the request" },
		{ "<leader>RS", "<cmd>HttpDryRun<cr>", desc = "Dry run request" },
		{ "<leader>Rq", "<cmd>HttpStop<cr>", desc = "Stop request" },
	},
}
