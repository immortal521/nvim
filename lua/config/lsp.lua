local ignored_lsps = {}

Utils.lsp.enable_lsps(ignored_lsps)
local function lsp_config_picker()
	local items = {}

	local configs = {}

	-- nvim 0.11+
	if vim.lsp.config then
		for name, config in pairs(vim.lsp.config) do
			configs[name] = config
		end
	end

	-- runtime lsp configs
	for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		local name = file:match("([^/]+)%.lua$")

		if name then
			configs[name] = configs[name] or {}
		end
	end

	-- active clients
	local clients = {}

	for _, client in ipairs(vim.lsp.get_clients()) do
		clients[client.name] = client
	end

	for name, config in pairs(configs) do
		local client = clients[name]

		local cmd = config.cmd
		if client then
			cmd = client.config.cmd
		end

		local filetypes = table.concat(config.filetypes or {}, ",")

		local status

		if client then
			status = "●"
		elseif cmd then
			status = "○"
		else
			status = "×"
		end

		table.insert(items, {
			name = name,
			status = status,
			config = config,
			client = client,
			text = string.format("%s %-20s %-30s", status, name, filetypes),
		})
	end

	table.sort(items, function(a, b)
		return a.name < b.name
	end)

	local lines = {}

	for _, item in ipairs(items) do
		table.insert(lines, item.text)
	end

	FzfLua.fzf_exec(lines, {
		prompt = "LSP Config> ",

		preview = function(selected)
			local name = selected[1]:match("%s*(%S+)")

			local item

			for _, v in ipairs(items) do
				if v.name == name then
					item = v
					break
				end
			end

			if not item then
				return {}
			end

			local result = {
				"# " .. item.name,
				"",
				"## Config",
				"",
				vim.inspect(item.config),
			}

			if item.client then
				table.insert(result, "")
				table.insert(result, "## Client")
				table.insert(result, "")

				table.insert(result, vim.inspect(item.client.config))
			end

			return result
		end,

		actions = {
			["default"] = function(selected)
				local name = selected[1]:match("%s*(%S+)")

				vim.notify("LSP: " .. name)
			end,
		},
	})
end

local keys = {
	{
		"<leader>cl",
		function()
      lsp_config_picker()
		end,
		desc = "Lsp Info",
	},
}

-- stylua: ignore
local attached_keys = {
	{ "gd", function() FzfLua.lsp_definitions() end, desc = "Goto Definition" },
	{ "gr", function() FzfLua.lsp_references() end, desc = "References" },
	{ "gI", function() FzfLua.lsp_implementations() end, desc = "Goto Implementation" },
	{ "gy", function() FzfLua.lsp_typedefs() end, desc = "Goto T[y]pe Definition" },
	{ "gD", function() FzfLua.lsp_declarations() end, desc = "Goto Declaration" },
	{ "K", function() Utils.lsp.hover() end, desc = "Hover" },
	{ "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "x" }, desc = "Code Action" },
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
	{ "<leader>cR", function()
    local old = vim.api.nvim_buf_get_name(0)
    local new = vim.fn.input("Rename: ", old)

    if new ~= "" then
      vim.cmd("saveas " .. new)
      vim.fn.delete(old)
    end
  end, desc = "Rename File" },
	{ "<leader>ld", function() FzfLua.lsp_document_diagnostics() end, desc = "LSP Open Diagnostic" },
	{ "<leader>co", Utils.lsp.action["source.organizeImports"], desc = "Organize Imports" },
	{ "gai", function() FzfLua.lsp_incoming_calls() end, desc = "Calls Incoming" },
	{ "gao", function() FzfLua.lsp_outgoing_calls() end, desc = "Calls Outgoing" },
	{ "<leader>ss", function() FzfLua.lsp_document_symbols() end, desc = "LSP Symbols" },
	{ "<leader>sS", function() FzfLua.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
}

Utils.keymap.add(keys)

local grp = vim.api.nvim_create_augroup("SetupLSP", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = grp,
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_clients({ id = event.data.client_id })[1]
		if not client then
			return
		end

		Utils.keymap.add(attached_keys)

		-- [signature help]
		if client:supports_method("textDocument/signatureHelp") then
      -- stylua: ignore
			---@diagnostic disable-next-line: call-non-callable
			Utils.keymap({"gK", function() return vim.lsp.buf.signature_help() end, buffer = bufnr, desc = "Signature Help",})
		end

		-- [inlay hint]
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			---@diagnostic disable-next-line: call-non-callable
			Utils.keymap({
				"<leader>uh",
				function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
				end,
				buffer = bufnr,
				desc = "LSP: Toggle Inlay Hints",
			})
		end

		-- [codelens]
		if client:supports_method("textDocument/codeLens") then
			vim.lsp.codelens.enable(true, { bufnr = bufnr })
			---@diagnostic disable-next-line: call-non-callable
			Utils.keymap({
				"<leader>cc",
				function()
					vim.lsp.codelens.run({ bufnr = bufnr })
				end,
				buffer = bufnr,
				desc = "Run Codelens",
			})
		end

		---@diagnostic disable-next-line: call-non-callable
		Utils.keymap({
			"<leader>cA",
			Utils.lsp.action.source,
			desc = "Source Action",
		})

		-- [folding]
		-- if client:supports_method("textDocument/foldingRange") then
		-- 	vim.opt_local.foldmethod = "expr"
		-- 	vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
		-- 	-- 可选：让 foldexpr 生效时更自然
		-- 	vim.opt_local.foldlevel = 99
		-- 	vim.opt_local.foldenable = true
		-- end

		if client:supports_method("textDocument/documentHighlight") then
			local hlg = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = hlg,
				buffer = bufnr,
				callback = function()
					pcall(vim.lsp.buf.document_highlight)
				end,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
				group = hlg,
				buffer = bufnr,
				callback = function()
					pcall(vim.lsp.buf.clear_references)
				end,
			})
		end
	end,
})

vim.diagnostic.config({
	update_in_insert = false,
	underline = true,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
	float = { severity_sort = true },
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarning",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},
})
