vim.pack.add({
  { src = "https://github.com/immortal521/toggleterm.nvim" },
})

require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = "horizontal" or "vertical" or "window" or "float",
  close_on_exit = true,
  float_opts = {
    border = "rounded",
  },
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm#*",
  callback = function()
    local opts = { buffer = true, silent = true, noremap = true }

    -- 检查是否是浮动窗口
    local win_config = vim.api.nvim_win_get_config(0)
    local is_float = win_config.relative ~= ""

    if is_float then
      -- q 关闭浮动窗口
      vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(0, true)
      end, opts)
    end
  end,
})

local keys = {
  {
    "jk",
    function()
      vim.cmd("stopinsert")
    end,
    mode = "t",
    expr = false,
    desc = "Single escape to normal mode",
  },
  {
    "<leader>t",
    "",
    desc = "Terminal",
  },
  {
    "<leader>tf",
    function()
      local count = vim.v.count1
      require("toggleterm").toggle(count, 0, Utils.get_project_root(), "float")
    end,
    desc = "ToggleTerm (float root_dir)",
  },
  {
    "<leader>th",
    function()
      local count = vim.v.count1
      require("toggleterm").toggle(count, 15, Utils.get_project_root(), "horizontal")
    end,
    desc = "ToggleTerm (horizontal root_dir)",
  },
  {
    "<leader>tv",
    function()
      local count = vim.v.count1
      require("toggleterm").toggle(count, vim.o.columns * 0.4, Utils.get_project_root(), "vertical")
    end,
    desc = "ToggleTerm (vertical root_dir)",
  },
  {
    "<leader>tn",
    "<cmd>ToggleTermSetName<cr>",
    desc = "Set term name",
  },
  {
    "<leader>ts",
    "<cmd>TermSelect<cr>",
    desc = "Select term",
  },
  {
    "<leader>tt",
    function()
      require("toggleterm").toggle(1, 100, Utils.get_project_root(), "tab")
    end,
    desc = "ToggleTerm (tab root_dir)",
  },
  {
    "<leader>tT",
    function()
      require("toggleterm").toggle(1, 100, vim.loop.cwd(), "tab")
    end,
    desc = "ToggleTerm (tab cwd_dir)",
  },
}

Utils.keymap.add(keys)
