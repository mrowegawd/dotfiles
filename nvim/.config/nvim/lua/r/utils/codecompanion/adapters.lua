local Adapters = require "codecompanion.adapters"
local Extend = Adapters.extend

local M = {}

local GEMINI_API_KEY = "cmd:pass show google/ai/gemini/apikey"

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

  return Extend("ollama", opts)
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

function M.gemini_flash_35()
  return Extend("gemini", {
    name = "gemini_flash_3",
    env = { api_key = GEMINI_API_KEY },
    schema = {
      model = {
        default = "gemini-3.5-flash",
        choices = {
          ["gemini-3.5-flash"] = {
            meta = {
              context_window = 1048576,
            },
          },
        },
      },
      reasoning_effort = { default = "none" },
    },
  })
end

return M
