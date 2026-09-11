---@class LintLinter
---@field condition? fun(ctx: { filename: string, dirname: string }): boolean

---@class ToolSpec
---@field formatter? conform.FormatterConfigOverride Formatter override passed to Conform.
---@field linter? LintLinter Linter override passed to nvim-lint.

local M = {}
local specs_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "toolchain", "tool", "specs")
local tools = {} ---@type table<string, ToolSpec>

for name, kind in vim.fs.dir(specs_dir) do
	if kind == "file" and name:sub(-4) == ".lua" then
		local tool = name:sub(1, -5)
		local ok, definition = pcall(require, "toolchain.tool.specs." .. tool)
		if ok and type(definition) == "table" then
			tools[tool] = definition
		else
			vim.notify(("Invalid tool specification: %s.lua"):format(tool), vim.log.levels.WARN)
		end
	end
end

---@return table<string, conform.FormatterConfigOverride>
function M.get_formatter_configs()
	local result = {}
	for name, definition in pairs(tools) do
		if definition.formatter then
			result[name] = vim.deepcopy(definition.formatter)
		end
	end
	return result
end

---@return table<string, LintLinter>
function M.get_linter_configs()
	local result = {}
	for name, definition in pairs(tools) do
		if definition.linter then
			result[name] = vim.deepcopy(definition.linter)
		end
	end
	return result
end

return M
