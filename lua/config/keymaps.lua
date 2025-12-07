local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

-- Normal / Visual
vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gO")

-- Insert
vim.keymap.del("i", "<C-s>")

-- Visual / Operator-pending（文本对象）
vim.keymap.del({ "x", "o" }, "an")
vim.keymap.del({ "x", "o" }, "in")

local keys = {
  -- better up/down
  { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Down", expr = true, silent = true },
  { "<Down>", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Down", expr = true, silent = true },
  { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Up", expr = true, silent = true },
  { "<Up>", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Up", expr = true, silent = true },

  -- window move
  { "<C-h>", "<C-w>h", desc = "Go to Left Window", remap = true },
  { "<C-j>", "<C-w>j", desc = "Go to Lower Window", remap = true },
  { "<C-k>", "<C-w>k", desc = "Go to Upper Window", remap = true },
  { "<C-l>", "<C-w>l", desc = "Go to Right Window", remap = true },

  -- resize window
  { "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase Window Height" },
  { "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease Window Height" },
  { "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease Window Width" },
  { "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase Window Width" },

  -- move lines
  { "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", desc = "Move Down" },
  { "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", desc = "Move Up" },
  { "<A-j>", "<esc><cmd>m .+1<cr>==gi", mode = "i", desc = "Move Down" },
  { "<A-k>", "<esc><cmd>m .-2<cr>==gi", mode = "i", desc = "Move Up" },
  { "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", mode = "v", desc = "Move Down" },
  { "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", mode = "v", desc = "Move Up" },

  -- esc clear highlight
  {
    "<esc>",
    function()
      vim.cmd("noh")
      return "<esc>"
    end,
    mode = { "i", "n", "s" },
    expr = true,
    desc = "Escape and Clear hlsearch",
  },

  -- buffers
  { "<S-h>", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
  { "<S-l>", "<cmd>bnext<cr>", desc = "Next Buffer" },
  { "[b", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
  { "]b", "<cmd>bnext<cr>", desc = "Next Buffer" },
  { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },
  { "<leader>`", "<cmd>e #<cr>", desc = "Switch to Other Buffer" },
  { "<leader>bD", "<cmd>:bd<cr>", desc = "Delete Buffer and Window" },

  -- clear search / diff / redraw
  {
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",

    desc = "Redraw / Clear hlsearch / Diff Update",
  },

  -- saner n/N
  { "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search Result" },
  { "n", "'Nn'[v:searchforward]", mode = "x", expr = true, desc = "Next Search Result" },
  { "n", "'Nn'[v:searchforward]", mode = "o", expr = true, desc = "Next Search Result" },
  { "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Prev Search Result" },
  { "N", "'nN'[v:searchforward]", mode = "x", expr = true, desc = "Prev Search Result" },
  { "N", "'nN'[v:searchforward]", mode = "o", expr = true, desc = "Prev Search Result" },

  -- undo breakpoints
  { ",", ",<c-g>u", mode = "i" },
  { ".", ".<c-g>u", mode = "i" },
  { ";", ";<c-g>u", mode = "i" },

  -- save file
  { "<C-s>", "<cmd>w<cr><esc>", mode = { "i", "x", "n", "s" }, desc = "Save File" },

  -- keywordprg
  { "<leader>K", "<cmd>norm! K<cr>", desc = "Keywordprg" },

  -- indenting
  { "<", "<gv", mode = "x" },
  { ">", ">gv", mode = "x" },

  -- commenting
  { "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Below" },
  { "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", desc = "Add Comment Above" },

  -- new file
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },

  -- location list
  {
    "<leader>xl",
    function()
      local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
      if not success and err then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,

    desc = "Location List",
  },

  -- quickfix list
  {
    "<leader>xq",
    function()
      local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
      if not success and err then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,

    desc = "Quickfix List",
  },

  { "[q", vim.cmd.cprev, desc = "Previous Quickfix" },
  { "]q", vim.cmd.cnext, desc = "Next Quickfix" },

  -- diagnostic
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
  { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
  { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
  { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
  { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
  { "]w", diagnostic_goto(true, "WARN"), desc = "Next Warning" },
  { "[w", diagnostic_goto(false, "WARN"), desc = "Prev Warning" },

  -- quit
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit All" },

  -- inspect
  { "<leader>ui", vim.show_pos, desc = "Inspect Pos" },
  {
    "<leader>uI",
    function()
      vim.treesitter.inspect_tree()
      vim.api.nvim_input("I")
    end,

    desc = "Inspect Tree",
  },

  -- windows
  { "<leader>-", "<C-W>s", desc = "Split Window Below", remap = true },
  { "<leader>|", "<C-W>v", desc = "Split Window Right", remap = true },
  { "<leader>wd", "<C-W>c", desc = "Delete Window", remap = true },

  -- tabs
  { "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last Tab" },
  { "<leader><tab>o", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
  { "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First Tab" },
  { "<leader><tab><tab>", "<cmd>tabnew<cr>", desc = "New Tab" },
  { "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next Tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close Tab" },
  { "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Previous Tab" },
}

Utils.keymap.add(keys)

_G.Config.leader_group_clues = {
  { keys = "<leader>a", mode = "n", desc = "+ai" },
  { keys = "<leader>b", mode = "n", desc = "+buffer" },
  { keys = "<leader>c", mode = "n", desc = "+code" },
  { keys = "<leader>d", mode = "n", desc = "+debug" },
  { keys = "<leader>f", mode = "n", desc = "+find" },
  { keys = "<leader>g", mode = "n", desc = "+git" },
  { keys = "<leader>l", mode = "n", desc = "+lsp" },
  { keys = "<leader>o", mode = "n", desc = "+overseer" },
  { keys = "<leader>q", mode = "n", desc = "+session" },
  { keys = "<leader>s", mode = "n", desc = "+search" },
  { keys = "<leader>t", mode = "n", desc = "+terminal" },
  { keys = "<leader>u", mode = "n", desc = "+ui" },
  { keys = "<leader>w", mode = "n", desc = "+window" },
  { keys = "<leader>x", mode = "n", desc = "+other" },
}

local term_normal = {
  "jk",
  function()
    vim.cmd("stopinsert")
  end,
  mode = "t",
  expr = false,
  desc = "Single escape to normal mode",
}

local win = {
  position = "float",
  border = "rounded",
  keys = {
    term_normal = term_normal,
  },
}

local self_keys = {
  {
    "<leader>bd",
    function()
      require("snacks").bufdelete()
    end,
    desc = "Delete Buffer",
  },
  {
    "<leader>bo",
    function()
      require("snacks").bufdelete.other()
    end,
    desc = "Delete Other Buffers",
  },
  {
    "<leader>gg",
    function()
      require("snacks").lazygit()
    end,
    desc = "Lazygit",
  },
  {
    "<leader>tf",
    function()
      require("snacks").terminal(nil, { win = win })
    end,

    desc = "Terminal Float",
  },
  {
    "<leader>tm",
    function()
      require("snacks").terminal("rmpc", { win = win })
    end,
    desc = "Music Player",
    silent = true,
    noremap = true,
  },
  {
    "<leader>mpu",
    function()
      vim.pack.update()
    end,
    desc = "Update Plugins",
  },

  { "jk", "<esc>", mode = "i" },
}

Utils.keymap.add(self_keys)
