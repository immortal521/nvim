---@diagnostic disable: await-in-sync
local M = {}

-- 映射表：将简写映射为可读性更高的分类名称
local NERDFONTS_SETS = {
	cod = "Codicons",
	dev = "Devicons",
	fa = "Font Awesome",
	fae = "Font Awesome Extension",
	iec = "IEC Power Symbols",
	linux = "Font Logos",
	logos = "Font Logos",
	oct = "Octicons",
	ple = "Powerline Extra",
	pom = "Pomicons",
	seti = "Seti-UI",
	weather = "Weather Icons",
	md = "Material Design Icons",
}

---自定义 Icon 源辅助函数
---@param source string
---@param url string
---@return table
local function custom_source(source, url)
	return {
		v = 3,
		url = url,
		build = function(data)
			local ret = {}
			for _, info in ipairs(data) do
				ret[#ret + 1] = {
					name = vim.trim(info.name or info[2] or ""),
					icon = vim.trim(info.icon or info[1] or ""),
					category = info.category or "",
					source = source,
				}
			end
			return ret
		end,
	}
end

M.sources = {
	nerd_fonts = {
		priority = 10,
		url = "https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/glyphnames.json",
		v = 4,
		build = function(data)
			local ret = {}
			for name, info in pairs(data) do
				if name ~= "METADATA" then
					local font, icon = name:match("^([%w_]+)%-(.*)$")
					if font then
						ret[#ret + 1] = {
							name = icon,
							icon = info.char,
							source = "nerd fonts",
							category = NERDFONTS_SETS[font] or font,
						}
					end
				end
			end
			return ret
		end,
	},

	emoji = {
		priority = 20,
		url = "https://raw.githubusercontent.com/muan/unicode-emoji-json/refs/heads/main/data-by-emoji.json",
		v = 4,
		build = function(data)
			local ret = {}
			for icon, info in pairs(data) do
				ret[#ret + 1] = {
					name = info.name,
					icon = icon,
					source = "emoji",
					category = info.group,
				}
			end
			return ret
		end,
	},
}

---读取文件内容（结合 uv/fs，防句柄泄露）
---@param path string
---@return string?
local function read_file(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local content = fd:read("*a")
	fd:close()
	return content
end

---写入文件内容
---@param path string
---@param content string
local function write_file(path, content)
	local fd = io.open(path, "w")
	if not fd then
		return
	end
	fd:write(content)
	fd:close()
end

---加载指定来源的 Icon 数据
---@param source_name string
---@return table[]
local function load(source_name)
	local source = M.sources[source_name]
	if not source then
		vim.notify("Unknown icon source: " .. source_name, vim.log.levels.ERROR)
		return {}
	end

	-- 本地文件路径直接读取
	if not source.url:find("^https?://") then
		local content = read_file(source.url)
		if not content then
			vim.notify("Failed to read file: " .. source.url, vim.log.levels.ERROR)
			return {}
		end
		return source.build(vim.json.decode(content))
	end

	-- 本地缓存路径
	local cache_dir = vim.fn.stdpath("cache") .. "/fzf-lua/icons"
	local file = cache_dir .. "/" .. source_name .. ".json"

	vim.fn.mkdir(cache_dir, "p")

	-- 优先读取本地缓存
	if vim.fn.filereadable(file) == 1 then
		local content = read_file(file)
		if content then
			local ok, decoded = pcall(vim.json.decode, content)
			if ok and decoded then
				---@cast decoded table[]
				return decoded
			end
		end
	end

	-- 网络请求下载
	if vim.fn.executable("curl") == 0 then
		vim.notify("curl is required to download icons", vim.log.levels.ERROR)
		return {}
	end

	local obj = vim.system({ "curl", "-s", "-L", source.url }):wait()
	if obj.code ~= 0 then
		vim.notify("Download failed: " .. (obj.stderr ~= "" and obj.stderr or obj.stdout), vim.log.levels.ERROR)
		return {}
	end

	local ok, raw_data = pcall(vim.json.decode, obj.stdout or "")
	if not ok or not raw_data then
		vim.notify("Failed to parse JSON response for " .. source_name, vim.log.levels.ERROR)
		return {}
	end

	local icons = source.build(raw_data)

	local ok_enc, encoded = pcall(vim.json.encode, icons)
	if ok_enc and type(encoded) == "string" then
		write_file(file, encoded)
	end

	---@cast icons table[]
	return icons
end

---使用 fzf-lua 搜索和复制 Icon
---@param opts? { custom_sources?: table<string, string>, icon_sources?: string[] }
function M.fzf_icons(opts)
	opts = opts or {}

	if opts.custom_sources then
		for source, url in pairs(opts.custom_sources) do
			M.sources[source] = custom_source(source, url)
		end
	end

	local sources = opts.icon_sources or vim.tbl_keys(M.sources)

	-- 按优先级对 source 降序排序
	table.sort(sources, function(a, b)
		local sa = M.sources[a] and M.sources[a].priority or 0
		local sb = M.sources[b] and M.sources[b].priority or 0
		return sa > sb
	end)

	local entries = {}
	---@type table<string, table>
	local icon_map = {}

	for _, source_name in ipairs(sources) do
		local icons = load(source_name)

		for _, item in ipairs(icons) do
			-- 组合用于显示与搜索的行，格式更加整洁
			local display = string.format("%s  %-15s %-25s %s", item.icon, item.source, item.category, item.name)
			entries[#entries + 1] = display
			-- 建立映射关系，避免后续正则抽取失败
			icon_map[display] = item
		end
	end

	require("fzf-lua").fzf_exec(entries, {
		prompt = "Icons❯ ",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then
					return
				end

				local item = icon_map[selected[1]]
				if item and item.icon then
					vim.fn.setreg("+", item.icon)
					vim.fn.setreg('"', item.icon)
					vim.notify(
						string.format("Copied [%s] (%s) to clipboard!", item.icon, item.name),
						vim.log.levels.INFO
					)
				end
			end,
		},
	})
end

return M
