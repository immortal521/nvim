vim.pack.add({
  { src = "https://github.com/immortal521/auto-save.nvim" },
})

vim.api.nvim_create_autocmd(Utils.autocmd.BufEdit, {
  once = true,
  callback = function()
    require("auto-save").setup({
      debounced_dekay = 1000,
      print_enabled = false,
      trigger_events = { "InsertLeave", "TextChanged" },
      condition = function(buf)
        local fn = vim.fn

        if fn.getbufvar(buf, "&modifiable") == 1 then
          return fn.mode() == "n"
        end

        return false
      end,
    })
  end,
})
