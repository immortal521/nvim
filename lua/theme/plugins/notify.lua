local function blend(foreground, alpha, background)
	local function rgb(c)
		c = c:lower()
		return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
	end

	local bg = rgb(background)
	local fg = rgb(foreground)

	local function channel(i)
		local val = alpha * fg[i] + (1 - alpha) * bg[i]
		return math.floor(math.min(math.max(0, val), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", channel(1), channel(2), channel(3))
end

local M = {}

M.url = "https://github.com/rcarriga/nvim-notify"

---@param palette theme.Palette
---@param opts theme.Options
function M.get(palette, opts)
    -- stylua: ignore
    return {
        NotifyBackground  = { fg = palette.fg, bg = opts.transparent and "none" or palette.bg },
        NotifyDEBUGBody   = { fg = palette.fg, bg = opts.transparent and "none" or palette.bg },
        NotifyDEBUGBorder = { fg = blend(palette.comment, 0.3, palette.bg), bg = opts.transparent and "none" or palette.bg },
        NotifyDEBUGIcon   = { fg = palette.comment },
        NotifyDEBUGTitle  = { fg = palette.comment },
        NotifyERRORBody   = { fg = palette.fg, bg = opts.transparent and "none" or palette.bg },
        NotifyERRORBorder = { fg = blend(palette.diag.error, 0.3, palette.bg), bg = opts.transparent and "none" or palette.bg },
        NotifyERRORIcon   = { fg = palette.diag.error },
        NotifyERRORTitle  = { fg = palette.diag.error },
        NotifyINFOBody    = { fg = palette.fg, bg = opts.transparent and "none" or palette.bg },
        NotifyINFOBorder  = { fg = blend(palette.diag.info, 0.3, palette.bg), bg = opts.transparent and "none" or palette.bg },
        NotifyINFOIcon    = { fg = palette.diag.info },
        NotifyINFOTitle   = { fg = palette.diag.info },
        NotifyTRACEBody   = { fg = palette.fg, bg = opts.transparent and "none" or palette.bg },
        NotifyTRACEBorder = { fg = blend(palette.purple, 0.3, palette.bg), bg = opts.transparent and "none" or palette.bg },
        NotifyTRACEIcon   = { fg = palette.purple },
        NotifyTRACETitle  = { fg = palette.purple },
        NotifyWARNBody    = { fg = palette.fg, bg = opts.transparent and "none" or palette.bg },
        NotifyWARNBorder  = { fg = blend(palette.diag.warn, 0.3, palette.bg), bg = opts.transparent and "none" or palette.bg },
        NotifyWARNIcon    = { fg = palette.diag.warn },
        NotifyWARNTitle   = { fg = palette.diag.warn },
    }
end

return M
