local Adapters = require "codecompanion.adapters"

local M = {}

---@param model string
local function get_ollama(model)
  return Adapters.extend("ollama", {
    schema = { model = { default = model } },
  })
end

function M.ollama_qwen25_7b()
  return get_ollama "qwen2.5-coder:7b"
end

function M.ollama_qwen25_14b()
  return get_ollama "qwen2.5-coder:14b"
end

return M
