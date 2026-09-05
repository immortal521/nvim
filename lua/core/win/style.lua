---@class core.win.Style
---@overload fun(name: string): core.win.Config
local M = setmetatable({}, {
	__call = function(t, ...)
		return t.get(...)
	end,
})

M.__index = M

---@class table<string, core.win.Config>
local styles = {}

---@param name string
---@param defaults core.win.Config|{}
---@return string
function M.add(name, defaults)
	styles[name] = vim.tbl_deep_extend("force", vim.deepcopy(defaults), styles[name] or {})
	return name
end

---@param name string
---@return core.win.Config
function M.get(name)
	return styles[name]
end

return M
