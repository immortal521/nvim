---@class core
---@field win core.win
---@field lazygit core.lazygit
---@field terminal core.terminal
---@field buf core.buf
---@field animate core.animate
---@field scroll core.scroll
local M = {}

setmetatable(M, {
	__index = function(t, k)
		t[k] = require("core." .. k)
		return rawget(t, k)
	end,
})

---@type core
_G.Core = M

---@class core.Config
---@field lazygit? core.lazygit.Config|{}
---@field terminal? core.terminal.Config|{}
---@field win? core.win.Config|{}
---@field scroll? core.scroll.Config|{}
local config = {}

---@class core.Config
M.config = setmetatable({}, {
	__index = function(_, k)
		config[k] = config[k] or {}
		return config[k]
	end,
	__newindex = function(_, k, v)
		config[k] = v
	end,
})

local is_dict_like = function(v) -- has string and number keys
	return type(v) == "table" and (vim.tbl_isempty(v) or not vim.islist(v))
end

local is_dict = function(v) -- has only string keys
	return type(v) == "table" and (vim.tbl_isempty(v) or not v[1])
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type
---@generic T
---@param ... T
---@return T
function M.config.merge(...)
	local ret = select(1, ...)
	for i = 2, select("#", ...) do
		local value = select(i, ...)
		if is_dict_like(ret) and is_dict(value) then
			for k, v in pairs(value) do
				ret[k] = M.config.merge(ret[k], v)
			end
		elseif value ~= nil then
			ret = value
		end
	end
	return ret
end

---@generic T: table
---@param snack string
---@param defaults T
---@param ... (T|table)?
---@return T
function M.config.get(snack, defaults, ...)
	local merge = { vim.deepcopy(defaults) }

	if type(config[snack]) == "table" then
		table.insert(merge, vim.deepcopy(config[snack]))
	end

	local vararg_count = select("#", ...)
	for i = 1, vararg_count do
		local v = select(i, ...)
		if type(v) == "table" then
			table.insert(merge, vim.deepcopy(v))
		end
	end

	local unpack_fn = table.unpack or unpack
	local ret = M.config.merge(unpack_fn(merge))

	if type(ret.config) == "function" then
		ret.config(ret, defaults)
	end

	return ret
end

function M.setup(opts)
	opts = opts or {}
	for k in pairs(opts) do
		opts[k].enabled = opts[k].enabled == nil or opts[k].enabled
	end
	config = vim.tbl_deep_extend("force", config, opts or {})

	local events = {
		UIEnter = { "scroll" },
	}

	---@param event string
	---@param ev? vim.api.keyset.create_autocmd.callback_args
	local function load(event, ev)
		local todo = events[event] or {}
		events[event] = nil
		for _, module in ipairs(todo) do
			if M.config[module] and M.config[module].enabled then
				if M[module].setup then
					M[module].setup(ev)
				elseif M[module].enable then
					M[module].enable()
				end
			end
		end
	end

	if vim.v.vim_did_enter == 1 then
		load("UIEnter")
	end

	local group = vim.api.nvim_create_augroup("core", { clear = true })
	vim.api.nvim_create_autocmd(vim.tbl_keys(events --[[@as table]]), {
		group = group,
		once = true,
		nested = true,
		callback = function(ev)
			load(ev.event, ev)
		end,
	})
end

return M
