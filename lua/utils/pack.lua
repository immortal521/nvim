---@class utils.pack
local M = {}

---@param src string
M.gh = function(src)
  if src:find("https") then
    return src
  else
    return "https://github.com/" .. src
  end
end

---@class utils.pack.spec
---@field [1]? string
---@field src? string
---@field dir? string
---@field version? string|vim.VersionRange
---@field opt? table
---@field config? fun(opt)
---@field event? string|string[]
---@field keys? utils.keymap.config[]
---@field ft? string|string[]
---@field name? string
---@field enabled? boolean

---@param spec utils.pack.spec
local normalize_source = function(spec)
  if spec[1] then
    return "https://github.com/" .. spec[1]
  elseif spec.src then
    return spec.src
  elseif spec.dir then
    return vim.fn.expand(spec.dir)
  else
    return nil, "spec must provide one of: [1], src, dir"
  end
end

---@param spec utils.pack.spec
---@return string
local get_source_url = function(spec)
  local src, err = normalize_source(spec)
  if not src then
    Utils.log(err, vim.log.levels.ERROR)
    error(err)
  end
  return src
end

return M
