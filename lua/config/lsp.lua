local ignored_lsps = {}

Utils.lsp.enable_lsps(ignored_lsps)

Utils.keymap({
	"<leader>cl",
	function()
		Snacks.picker.lsp_config()
	end,
	desc = "Lsp Info",
})

local grp = vim.api.nvim_create_augroup("SetupLSP", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = grp,
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		-- [inlay hint]
		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			Utils.keymap({
				"<leader>uh",
				function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
				end,
				buffer = bufnr,
				desc = "LSP: Toggle Inlay Hints",
			})
		end

		Utils.keymap({
			"<leader>cA",
			Utils.lsp.action.source,
			desc = "Source Action",
		})

		-- [folding]
		if client:supports_method("textDocument/foldingRange") then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
			-- 可选：让 foldexpr 生效时更自然
			vim.opt_local.foldlevel = 99
			vim.opt_local.foldenable = true
		end

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

		local function find_symbol_containing_line(symbols, line)
			for _, s in ipairs(symbols or {}) do
				local range = s.range or (s.location and s.location.range)
				if range and line >= range.start.line and line <= range["end"].line then
					if s.children then
						local child = find_symbol_containing_line(s.children, line)
						if child then
							return child
						end
					end
					return s
				end
			end
			return nil
		end

		local function jump_to_symbol_edge(which)
			-- which: "start" or "end"
			local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

			-- 若 server 不支持 documentSymbol，直接返回
			if not (client.supports_method and client:supports_method("textDocument/documentSymbol")) then
				return
			end

			local ok, responses = pcall(vim.lsp.buf_request_sync, bufnr, "textDocument/documentSymbol", params, 1000)
			if not ok or type(responses) ~= "table" or vim.tbl_isempty(responses) then
				return
			end

			local pos = vim.api.nvim_win_get_cursor(0)
			local line = pos[1] - 1

			for _, resp in pairs(responses) do
				local result = resp and resp.result
				if result then
					local sym = find_symbol_containing_line(result, line)
					if sym and sym.range then
						if which == "start" then
							vim.api.nvim_win_set_cursor(0, { sym.range.start.line + 1, 0 })
						else
							vim.api.nvim_win_set_cursor(0, { sym.range["end"].line + 1, 0 })
						end
						return
					end
				end
			end
		end

		vim.keymap.set("n", "[f", function()
			jump_to_symbol_edge("start")
		end, { buffer = bufnr, desc = "Jump to start of current function" })
		vim.keymap.set("n", "]f", function()
			jump_to_symbol_edge("end")
		end, { buffer = bufnr, desc = "Jump to end of current function" })
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
