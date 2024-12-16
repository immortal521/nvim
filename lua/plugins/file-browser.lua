if true then
  return {}
end

return {
  "nvim-telescope/telescope-file-browser.nvim",
  keys = {
    {
      "<leader>sB",
      ":Telescope file_browser path=%:p:h=%:p:h<cr>",
      desc = "Browser Files",
    },
  },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
}
