local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local ChatHelpers = lazy("utils.codecompanion.helpers").chat
local PromptLibrary = lazy "utils.codecompanion.prompt_library"

local M = {}

function M.translate_this(chat, opts)
  local bufnr = opts and opts.bufnr
  local code = opts and opts.code
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return Log.warn "not valid buffer"
  end

  local file = vim.api.nvim_buf_get_name(bufnr)

  local ft = vim.bo[bufnr].filetype ~= "" and vim.bo[bufnr].filetype or "text"

  local contents = string.format(PromptLibrary.prompt "translate_this_line_to_ind", ft, code)

  local adapters = lazy "utils.codecompanion.adapters"
  chat.adapter = adapters.llama3_1_8b()

  ChatHelpers.add_context { file }
  chat:add_buf_message({
    role = "user",
    content = contents,
  }, { type = chat.MESSAGE_TYPES.LLM_MESSAGE })
  chat:add_message {
    role = "user",
    content = contents,
  }
  chat:submit()
end

return M
