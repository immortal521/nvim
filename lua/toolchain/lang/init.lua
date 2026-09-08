---@class LanguageSpec
---@field filetypes string[] 文件类型
---@field formatters? string[] 格式化器名称
---@field linters? string[] lint 名称
---@field lint_filetypes? string[] 实际启用 lint 的文件类型
---@field lsp? string[] LSP 配置名称
---@field treesitter? string[] Treesitter 语言名称

---@class LanguageSourceItem
---@field name string 语言规格文件名
---@field file string 语言规格文件路径
---@field filetypes string 用于展示的文件类型
---@field formatters string 用于展示的 formatter
---@field linters string 用于展示的 linter
---@field lsp string 用于展示的 LSP

local M = {}
local specs_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "toolchain", "lang", "specs")

local languages = {} ---@type table<string, LanguageSpec>
local lsp_enabled = {} ---@type table<string, boolean>

local spec_names = {}

local function add_unique(list, value)
	if not vim.tbl_contains(list, value) then
		list[#list + 1] = value
	end
end

local function extend_unique(list, values)
	for _, value in ipairs(values) do
		add_unique(list, value)
	end
end

---@param definition LanguageSpec
---@param callback fun(filetype: string)
local function each_filetype(definition, callback)
	for _, filetype in ipairs(definition.filetypes) do
		callback(filetype)
	end
end

---@param field string
---@param filetypes_field? string
---@return table<string, string[]>
local function collect_by_filetype(field, filetypes_field)
	local result = {}

	for _, definition in pairs(languages) do
		local values = definition[field]
		if not values then
			goto continue
		end

		local filetypes = definition[filetypes_field] or definition.filetypes

		for _, filetype in ipairs(filetypes) do
			result[filetype] = result[filetype] or {}
			extend_unique(result[filetype], values)
		end

		::continue::
	end

	return result
end

for name, kind in vim.fs.dir(specs_dir) do
	if kind == "file" and name:sub(-4) == ".lua" then
		spec_names[#spec_names + 1] = name:sub(1, -5)
	end
end

table.sort(spec_names)

for _, name in ipairs(spec_names) do
	local ok, definition = pcall(require, "toolchain.lang.specs." .. name)
	if ok and type(definition) == "table" and vim.islist(definition.filetypes) and #definition.filetypes > 0 then
		languages[name] = definition
	else
		vim.notify(("Invalid language specification: %s.lua"):format(name), vim.log.levels.WARN)
	end
end

---@return table<string, LanguageSpec>
function M.get()
	return vim.deepcopy(languages)
end

---@return table<string, string[]>
function M.get_formatters()
	local result = collect_by_filetype("formatters")

	vim.tbl_extend("force", result, {
		graphql = { "prettier", "biome", "oxfmt" },
		handlebars = { "prettier", "biome", "oxfmt" },
		luau = { "stylua" },
	})

	return result
end

---@return table<string, string[]>
function M.get_linters()
	return collect_by_filetype("linters", "lint_filetypes")
end

---@return { parsers: string[], filetypes: string[] }
function M.get_treesitter()
	local result = {
		parsers = {},
		filetypes = {},
	}
	for _, definition in pairs(languages) do
		if not definition.treesitter then
			goto continue
		end
		extend_unique(result.parsers, definition.treesitter)
		each_filetype(definition, function(filetype)
			add_unique(result.filetypes, filetype)
		end)
		::continue::
	end
	return result
end

---仅在打开对应文件类型时启用该语言声明的 LSP。
---@param filetype string
function M.enable_lsp(filetype)
	local definition = M.get_by_filetype(filetype)
	if not definition or not definition.lsp then
		return
	end
	for _, name in ipairs(definition.lsp) do
		if not lsp_enabled[name] then
			vim.lsp.enable(name)
			lsp_enabled[name] = true
		end
	end
end

---注册按文件类型延迟启用 LSP 的入口。
function M.setup()
	local group = vim.api.nvim_create_augroup("LanguageLsp", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(event)
			M.enable_lsp(vim.bo[event.buf].filetype)
		end,
	})
	M.enable_lsp(vim.bo.filetype)
end

---@param filetype string
---@return LanguageSpec?
function M.get_by_filetype(filetype)
	local result
	for _, definition in pairs(languages) do
		if not vim.tbl_contains(definition.filetypes, filetype) then
			goto continue
		end
		result = result or {
			filetypes = {},
		}
		extend_unique(result.filetypes, definition.filetypes)

		for _, field in ipairs({
			"formatters",
			"linters",
			"lsp",
			"treesitter",
		}) do
			if definition[field] then
				result[field] = result[field] or {}
				extend_unique(result[field], definition[field])
			end
		end
		::continue::
	end
	return result
end

---@return LanguageSourceItem[]
function M.source_items()
	local items = {}
	for name, definition in pairs(languages) do
		items[#items + 1] = {
			name = name,
			file = vim.fs.joinpath(specs_dir, name .. ".lua"),
			filetypes = table.concat(definition.filetypes, ", "),
			formatters = table.concat(definition.formatters or {}, ", "),
			linters = table.concat(definition.linters or {}, ", "),
			lsp = table.concat(definition.lsp or {}, ", "),
		}
	end
	table.sort(items, function(a, b)
		return a.name < b.name
	end)
	return items
end

return M
