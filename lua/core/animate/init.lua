---@class core.animate
---@overload fun(from: number, to: number, callback: core.animate.callback, opts?: core.animate.Opts): core.animate.Animation
local M = setmetatable({}, {
	__call = function(t, ...)
		return t.add(...)
	end,
})

---@alias core.animate.easing.Fn fun(time: number, begin: number, change: number, duration: number): number

---@class core.animate.Duration
---@field step? number duration step in ms
---@field total? number total duration in ms

---@class core.animate.Config
---@field duration core.animate.Duration|number
---@field easing? core.animate.easing|core.animate.easing.Fn
local defaults = {
	duration = 20,
	easing = "linear",
	fps = 120,
}

local uv = vim.uv
local _id = 0

local function next_id()
	_id = _id + 1
	return _id
end

---@class core.animate.Ctx
---@field done boolean
---@field animation core.animate.Animation
---@field prev number

---@alias core.animate.callback fun(value: number, ctx: core.animate.Ctx)

---@class core.animate.Opts: core.animate.Config
---@field buf? number
---@field int? boolean 将值平整为整数
---@field id? number|string

---@type table<number|string, core.animate.Animation>
local active = setmetatable({}, { __mode = "v" })

---@class core.animate.Animation
---@field id number|string
---@field easing core.animate.easing.Fn
---@field opts core.animate.Opts
---@field timer? uv.uv_timer_t
---@field steps? number[]
---@field _step? number
local Animation = {}
Animation.__index = Animation

---@param opts? core.animate.Opts
function Animation.new(opts)
	local id = opts and opts.id or next_id()

	if active[id] ~= nil then
		active[id]:stop()
		active[id] = nil
	end

	local self = setmetatable({}, Animation)
	self.id = id

	self.opts = Core.config.get("animate", defaults, opts --[[@as core.animate.Config]])
	local easing = self.opts.easing or "linear"

	easing = type(easing) == "string" and require("core.animate.easing")[easing] or easing
	self.easing = easing
	active[id] = self

	return self
end

---@param from number
---@param to number
---@param callback core.animate.callback
function Animation:start(from, to, callback)
	self:stop()
	if from == to then
		callback(from, { animation = self, prev = from, done = true })
		return self
	end

	local opt_duration = type(self.opts.duration) == "table" and self.opts.duration or { step = self.opts.duration }

	local duration = 0 --[[@as number]]
	if opt_duration.step then
		duration = opt_duration.step * math.abs(to - from)
		duration = math.min(duration, opt_duration.total or duration)
	elseif opt_duration.total then
		duration = opt_duration.total
	end

	duration = duration or 250

	local step_duration = math.max(duration / (to - from), 1000 / self.opts.fps)
	local step_count = math.max(math.floor(duration / step_duration + 0.5), 10)

	local delta = 0 --[[@as number]]
	if (self.opts.easing or "linear") == "linear" and self.opts.int then
		local one_step = math.max(1, math.floor(math.abs(to - from) / step_count + 0.5))
		step_count = math.floor(math.abs(to - from) / one_step + 0.5)
		delta = math.abs(to - from) - one_step * step_count
		step_duration = duration / step_count
	end

	self.steps = {}
	for i = 1, step_count do
		local value = 0 --[[@as number]]
		if i == step_count then
			value = to
		else
			value = self.easing(i, from, to - from - delta, step_count)
		end
		if self.opts.int then
			value = math.floor(value + 0.5)
		end
		table.insert(self.steps, value)
	end

	self._step = 0
	active[self.id] = self
	self.timer = uv.new_timer()
	if self.timer == nil then
		return
	end
	self.timer:start(0, step_count, function()
		vim.schedule(function()
			self:step(callback)
		end)
	end)
	return self
end

function Animation:stop()
	if self.timer then
		if self.timer:is_active() then
			self.timer:stop()
			self.timer:close()
			self.timer = nil
		end
	end
	self.steps, self._step = nil, nil
end

---@param callback core.animate.callback
function Animation:step(callback)
	if not self.steps or not self._step or self._step >= #self.steps then
		return self:stop()
	end
	self._step = self._step + 1
	local value = self.steps[self._step] --[[@as number]]
	local done = self._step >= #self.steps
	local prev = self.steps[self._step - 1] or value
	callback(value, { animation = self, prev = prev, done = done })
end

---@param from number
---@param to number
---@param callback core.animate.callback
---@param opts? core.animate.Opts
function M.add(from, to, callback, opts)
	return Animation.new(opts):start(from, to, callback)
end

return M
