local Adapters = require "codecompanion.adapters"

local M = {}

---@param model string
local function get_ollama(model, num_ctx)
  num_ctx = num_ctx or nil

  local opts = {
    schema = {
      model = { default = model },
      num_predict = {},
    },
  }

  if num_ctx then
    vim.tbl_deep_extend("force", opts, {
      schema = {
        model = { default = model },
        num_predict = {
          default = num_ctx,
        },
      },
    })
  end

  return Adapters.extend("ollama", {})
end

function M.ollama_qwen25_7b()
  return get_ollama "qwen2.5-coder:7b"
end

function M.ollama_qwen25_14b()
  return get_ollama "qwen2.5-coder:14b"
end

function M.ollama_qwen3_8b()
  return get_ollama("qwen3:8b", 32768)
end

return M
