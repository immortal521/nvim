---@class builtin.bus.Message
---@field id integer
---@field tag string
---@field level integer
---@field content any
---@field data table
---@field timestamp integer

---@class builtin.bus.SubscriberSpec
---@field exact? string[]
---@field prefix? string[]
---@field min_level? integer
---@field handler fun(message: builtin.bus.Message)

local M = {}
local subscribers = {}
local observers = {}
local next_id = 0
local initialized = false

local function interested(spec, message)
	if spec.min_level and message.level < spec.min_level then
		return false
	end
	if spec.exact then
		for _, tag in ipairs(spec.exact) do
			if tag == message.tag then
				return true
			end
		end
	end
	if spec.prefix then
		for _, prefix in ipairs(spec.prefix) do
			if vim.startswith(message.tag, prefix) then
				return true
			end
		end
	end
	return not spec.exact and not spec.prefix
end

function M.setup()
	initialized = true
end

---@param id string
---@param spec builtin.bus.SubscriberSpec
---@return boolean
function M.register_subscriber(id, spec)
	if subscribers[id] then
		return false
	end
	subscribers[id] = spec
	return true
end

---@param id string
---@param callback fun(message: builtin.bus.Message)
function M.register_observer(id, callback)
	observers[id] = callback
end

---@param id string
function M.unsubscribe(id)
	subscribers[id] = nil
	observers[id] = nil
end

---@param tag string
---@param level integer
---@param content any
---@param data? table
---@return builtin.bus.Message
function M.emit(tag, level, content, data)
	if not initialized then
		M.setup()
	end
	next_id = next_id + 1
	local message = {
		id = next_id,
		tag = tag,
		level = level,
		content = content,
		data = data or {},
		timestamp = vim.uv.now(),
	}
	for _, callback in pairs(observers) do
		callback(message)
	end
	for _, spec in pairs(subscribers) do
		if interested(spec, message) then
			local ok, err = pcall(spec.handler, message)
			if not ok then
				vim.schedule(function()
					vim.api.nvim_err_writeln(("Builtin bus subscriber failed: %s"):format(err))
				end)
			end
		end
	end
	return message
end

return M
