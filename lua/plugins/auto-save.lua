return {
  "immortal521/auto-save.nvim",
  event = { "VeryLazy" },
  opts = {
    debounced_dekay = 1000,
    print_enabled = false,
    trigger_events = { "InsertLeave" },
    condition = function(buf)
      local fn = vim.fn

      if fn.getbufvar(buf, "&modifiable") == 1 then
        if fn.mode() ~= "n" then
          return false
        else
          return true
        end
      end

      return false
    end,
  },
}
