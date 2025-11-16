local wk = require("which-key")
local utils = require("utils")

vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
  picker = {
    enabled = true,
  },
  image = {
    enabled = true,
  },
  indent = {
    enabled = true,
    animate = {
      enabled = true,
    },
    indent = {
      only_scope = true,
    },
    scope = {
      enabled = true,
      underline = false,
    },
    chunk = {
      enabled = true,
    },
  },
  input = { enabled = true },
  notifier = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  words = { enabled = true },
  dashboard = {
    -- enabled = false,
    preset = {
      header = [[



         ▀████▀▄▄              ▄█
           █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█
  ▄        █          ▀▀▀▀▄  ▄▀
 ▄▀ ▀▄      ▀▄              ▀▄▀
▄▀    █     █▀   ▄█▀▄      ▄█
▀▄     ▀▄  █     ▀██▀     ██▄█
 ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █
  █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀
 █   █  █      ▄▄           ▄▀
]],
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = " ", key = "S", desc = "Select Session", action = ":lua require('persistence').select()" },
        { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 0.5 },
    },
  },
})

-- stylua: ignore
local keys = {
  { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
  { "<leader>/", function() Snacks.picker.grep({cwd = utils.get_project_root()}) end, desc = "Grep" },
  { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
  { "<leader><space>", function() Snacks.picker.files({cwd = utils.get_project_root()}) end, desc = "Find Files" },
  { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
  -- find
  { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
  { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
  {
    "<leader>fc",
    function() Snacks.picker.pick("files", { cwd = vim.fn.stdpath("config") }) end,
    desc = "Find Config File"
  },
  { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
  { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
  { "<leader>fr", function() Snacks.picker.pick("oldfiles") end, desc = "Recent" },
  { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
  { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
  -- git
  { "<leader>gd", function() Snacks.picker.git_diff({cwd = utils.get_git_root()}) end, desc = "Git Diff (hunks)" },
  { "<leader>gD", function() Snacks.picker.git_diff({ base = "origin", group = true,cwd = utils.get_git_root() }) end, desc = "Git Diff (origin)" },
  { "<leader>gs", function() Snacks.picker.git_status({cwd = utils.get_git_root()}) end, desc = "Git Status" },
  { "<leader>gS", function() Snacks.picker.git_stash({cwd = utils.get_git_root()}) end, desc = "Git Stash" },
  { "<leader>gi", function() Snacks.picker.gh_issue({cwd = utils.get_git_root()}) end, desc = "GitHub Issues (open)" },
  { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all", cwd = utils.get_git_root() }) end, desc = "GitHub Issues (all)" },
  { "<leader>gp", function() Snacks.picker.gh_pr({cwd = utils.get_git_root()}) end, desc = "GitHub Pull Requests (open)" },
  { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all", cwd = utils.get_git_root() }) end, desc = "GitHub Pull Requests (all)" },
  -- Grep
  { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
  { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
  { "<leader>sg", function() Snacks.picker.pick("live_grep", {cwd = utils.get_project_root()}) end, desc = "Grep" },
  { "<leader>sG", function() Snacks.picker.pick("live_grep", { root = false }) end, desc = "Grep (Root Dir)" },
  {
    "<leader>sw",
    function() Snacks.picker.pick("grep_word", {cwd = utils.get_project_root()}) end,
    desc = "Visual selection or word",
    mode = { "n", "x" }
  },
  {
    "<leader>sW",
    function() Snacks.picker.pick("grep_word", { root = false }) end,
    desc = "Visual selection or word (Root Dir)",
    mode = { "n", "x" }
  },
  -- search
  { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
  { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
  { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
  { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
  { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
  { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
  { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
  { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
  { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
  { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
  { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
  { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
  { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
  { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
  { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
  { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
  { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
  { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
  -- ui
  { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
}

wk.add(keys)
