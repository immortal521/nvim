if not LazyVim.is_win() then
  return {}
end

return {
  "immortal521/ime_toggle",
  config = function()
    require("ime_toggle").setup()
  end,
  -- Lazy.nvim 的 opt 选项已经不再使用，直接通过 Lazy 的 setup 函数来进行懒加载控制
  lazy = false,
}
