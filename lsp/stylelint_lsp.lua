---@brief
---
--- https://github.com/bmatcuk/stylelint-lsp
---
--- `stylelint-lsp` can be installed via `npm`:
---
--- ```sh
--- npm i -g stylelint-lsp
--- ```
---
--- Can be configured by passing a `settings.stylelintplus` object to vim.lsp.config('stylelint_lsp'):
---
--- ```lua
--- vim.lsp.config('stylelint_lsp', {
---   settings = {
---     stylelintplus = {
---       -- see available options in stylelint-lsp documentation
---     }
---   }
--- })
--- ```

local root_file = {
	".stylelintrc",
	".stylelintrc.mjs",
	".stylelintrc.cjs",
	".stylelintrc.js",
	".stylelintrc.json",
	".stylelintrc.yaml",
	".stylelintrc.yml",
	"stylelint.config.mjs",
	"stylelint.config.cjs",
	"stylelint.config.js",
}

function root_markers_with_field(root_files, new_names, field, fname)
	local path = vim.fn.fnamemodify(fname, ":h")
	local found = vim.fs.find(new_names, { path = path, upward = true, type = "file" })

	for _, f in ipairs(found or {}) do
		-- Match the given `field`.
		for line in io.lines(f) do
			if line:find(field) then
				root_files[#root_files + 1] = vim.fs.basename(f)
				break
			end
		end
	end

	return root_files
end

function insert_package_json(root_files, field, fname)
	return root_markers_with_field(root_files, { "package.json", "package.json5" }, field, fname)
end

root_file = insert_package_json(root_file, "stylelint")

---@type vim.lsp.Config
return {
	cmd = { "stylelint-lsp", "--stdio" },
	filetypes = {
		"astro",
		"css",
		"html",
		"less",
		"scss",
		"sugarss",
		"vue",
		"wxss",
	},
	root_markers = root_file,
	settings = {},
}
