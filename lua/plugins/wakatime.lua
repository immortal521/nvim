vim.pack.add({
  { src = "https://github.com/wakatime/vim-wakatime" },
}, {
  load = function(plug_data)
    vim.api.nvim_create_autocmd(Utils.autocmd.BufEdit, {
      once = true,
      callback = function()
        vim.cmd("packadd " .. plug_data.spec.name)
      end,
    })
  end,
})
