local PI = math.pi

local pow = math.pow
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local abs = math.abs
local asin = math.asin

local function linear(time, begin, change, duration)
	return change * time / duration + begin
end

---@enum (key) core.animate.easing
local M = {
	linear = linear,
}

return M
