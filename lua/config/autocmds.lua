local function augroup(name)
    return vim.api.nvim_create_augroup("autocmds_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = false
    end,
})
