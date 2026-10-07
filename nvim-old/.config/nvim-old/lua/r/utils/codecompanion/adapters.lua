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

function M.ollama_qwen2_5_7b_instruct_Q4_K_M()
  return get_ollama "qcwind/qwen2.5-7B-instruct-Q4_K_M:latest"
end

function M.supa_ai_gemma2_9b_sahabatai()
  return get_ollama "Supa-AI/gemma2-9b-cpt-sahabatai-v1-instruct:q3_k_s"
end

function M.ollama_qwen3_8b()
  return get_ollama("qwen3:8b", 32768)
end

function M.llama3_1_8b()
  return get_ollama "maternion/hy-mt2:1.8b"
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
