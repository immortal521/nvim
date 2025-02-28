local function local_llm_streaming_handler(chunk, line, assistant_output, bufnr, winid, F)
  if not chunk then
    return assistant_output
  end
  local tail = chunk:sub(-1, -1)
  if tail:sub(1, 1) ~= "}" then
    line = line .. chunk
  else
    line = line .. chunk
    local status, data = pcall(vim.fn.json_decode, line)
    if not status or not data.message.content then
      return assistant_output
    end
    assistant_output = assistant_output .. data.message.content
    local content = data.message.content
    if data.message.content == "<think>" or data.message.content == "</think>" then
      content = ""
    end
    F.WriteContent(bufnr, winid, content)
    line = ""
  end
  return assistant_output
end

local function local_llm_parse_handler(chunk)
  local assistant_output = chunk.message.content
  return assistant_output
end

return {
  "Kurama622/llm.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  cmd = { "LLMSesionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
  config = function()
    local tools = require("llm.common.tools")
    require("llm").setup({
      url = "http://localhost:11434/api/chat",
      model = "qwen2.5-coder",
      fetch_key = function()
        return "NONE"
      end,
      prefix = {
        user = { text = " ", hl = "Title" },
        assistant = { text = " ", hl = "Added" },
      },
      save_session = true,
      max_history = 15,
      max_hiastory_name_length = 20,
      history_path = vim.fn.stdpath("cache") .. "/history",

      streaming_handler = local_llm_streaming_handler,
      parse_handler = local_llm_parse_handler,

      app_handler = {
        OptimizeCode = {
          handler = tools.side_by_side_handler,
        },
        TestCode = {
          handler = tools.side_by_side_handler,
          prompt = [[ Write some test cases for the following code, only return the test cases.
                        Give the code content directly, do not use code blocks or other tags to wrap it. Reply with Chinese ]],
          opts = {
            right = {
              title = " Test Cases ",
            },
          },
        },
        Translate = {
          handler = tools.qa_handler,
          prompt = "Please translate the content after the newline character to Chinese, if it's already in Chinese, translate it to English. Only return the translated content.\n",
        },
        OptimCompare = {
          handler = tools.action_handler,
          opts = {
            language = "Chinese",
          },
        },
        WordTranslate = {
          handler = tools.flexi_handler,
          prompt = "Please translate the content after the newline character to Chinese, if it's already in Chinese, translate it to English. Only return the translated content.\n",
          opts = {
            exit_on_move = true,
            enter_flexible_window = false,
          },
        },
        CodeExplain = {
          handler = tools.flexi_handler,
          prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
          opts = {
            enter_flexible_window = true,
          },
        },
      },

      keys = {
        -- The keyboard mapping for the input window.
        ["Input:Submit"] = { mode = { "i", "n" }, key = "<C-g>" },
        ["Input:Cancel"] = { mode = { "i", "n" }, key = "<C-c>" },
        ["Input:Resend"] = { mode = { "i", "n" }, key = "<C-r>" },

        -- only works when "save_session = true"
        ["Input:HistoryNext"] = { mode = { "i", "n" }, key = "<C-j>" },
        ["Input:HistoryPrev"] = { mode = { "i", "n" }, key = "<C-k>" },

        -- The keyboard mapping for the output window in "split" style.
        ["Output:Ask"] = { mode = "n", key = "i" },
        ["Output:Cancel"] = { mode = "n", key = "<C-c>" },
        ["Output:Resend"] = { mode = "n", key = "<C-r>" },

        -- The keyboard mapping for the output and input windows in "float" style.
        ["Session:Toggle"] = { mode = "n", key = "<leader>ac" },
        ["Session:Close"] = { mode = "n", key = "<esc>" },
      },
    })
  end,
  keys = {
    { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>", desc = "Start Chat" },
    -- { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>", desc = "Code Explain" },
    { "<leader>at", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>", desc = "Translate" },
    { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>", desc = "Translation Window" },
    -- { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimizeCode<cr>", desc = "Optimize" },
    { "<leader>tc", mode = "x", "<cmd>LLMAppHandler TestCode<cr>", desc = "Generate Test Code" },
    { "<leader>ao", mode = "x", "<cmd>LLMAppHandler OptimCompare<cr>", desc = "Optimize Code" },
    { "<leader>ae", mode = "v", "<cmd>LLMSelectedTextHandler 请解释下面这段代码<cr>", desc = "Code Explain" },
    -- { "<leader>at", mode = "x", "<cmd>LLMSelectedTextHandler 英译汉<cr>", desc = "Translate" },
  },
}
