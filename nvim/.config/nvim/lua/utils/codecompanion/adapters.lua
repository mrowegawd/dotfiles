local lazy = require("utils.plugin").require_lazy

local Adapters = lazy "codecompanion.adapters"
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

function M.webai()
  local cfg = lazy "utils.codecompanion.webai.config"

  return Extend("openai", {
    name = "webai",
    env = { api_key = "sk-dummy" },
    -- url = ("http://%s:%d/v1/chat/completions"):format(cfg.host, cfg.port),
    url = ("http://%s:%d/v1/chat/completions"):format("127.0.0.1", 8787),
    schema = {
      model = { default = "web-ai" },
      temperature = { default = 0.7 },
      max_tokens = { default = 4096 },
      stream = { default = false },
    },
    headers = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = "Bearer sk-dummy",
    },
    handlers = {
      chat_output = function(_, data)
        if not data or not data.choices or #data.choices == 0 then
          return nil
        end
        local c = data.choices[1]
        if c.message and c.message.content then
          return { content = c.message.content }
        end
        return nil
      end,
      stream_output = function(_, data)
        if not data then
          return nil
        end
        for _, line in ipairs(data) do
          if line:sub(1, 6) == "data: " then
            local payload = line:sub(7)
            if payload == "[DONE]" then
              return { event = "done" }
            end
            local ok, ev = pcall(vim.json.decode, payload)
            if not ok or not ev then
              goto continue
            end

            -- Chat Completions delta
            if ev.choices and ev.choices[1] and ev.choices[1].delta and ev.choices[1].delta.content then
              return { content = ev.choices[1].delta.content }
            end
            -- Responses delta
            if ev.type == "response.output_text.delta" and ev.delta then
              return { content = ev.delta }
            end
            if ev.type == "response.completed" then
              return { event = "done" }
            end
          end
          ::continue::
        end
        return nil
      end,
    },
  })
end

return M
