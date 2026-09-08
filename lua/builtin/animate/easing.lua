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

local function in_quad(time, begin, change, duration)
	local t = time / duration
	return change * t * t + begin
end

local function out_quad(time, begin, change, duration)
	local t = time / duration
	return -change * t * (t - 2) + begin
end

local function in_out_quad(time, begin, change, duration)
	local t = time / duration * 2
	if t < 1 then
		return change / 2 * t * t + begin
	end
	t = t - 1
	return -change / 2 * (t * (t - 2) - 1) + begin
end

local function out_cubic(time, begin, change, duration)
	local t = time / duration - 1
	return change * (t * t * t + 1) + begin
end

local function in_cubic(time, begin, change, duration)
	local t = time / duration
	return change * t * t * t + begin
end

local function out_sine(time, begin, change, duration)
	return change * sin(time / duration * (PI / 2)) + begin
end

local function in_sine(time, begin, change, duration)
	return -change * cos(time / duration * (PI / 2)) + change + begin
end

local function out_back(time, begin, change, duration, overshoot)
	local s = overshoot or 1.70158
	local t = time / duration - 1
	return change * (t * t * ((s + 1) * t + s) + 1) + begin
end

local function in_back(time, begin, change, duration, overshoot)
	local s = overshoot or 1.70158
	local t = time / duration
	return change * t * t * ((s + 1) * t - s) + begin
end

---@enum (key) builtin.animate.easing
local M = {
	linear = linear,
	inQuad = in_quad,
	outQuad = out_quad,
	inOutQuad = in_out_quad,
	inCubic = in_cubic,
	outCubic = out_cubic,
	inSine = in_sine,
	outSine = out_sine,
	inBack = in_back,
	outBack = out_back,
}

return M
