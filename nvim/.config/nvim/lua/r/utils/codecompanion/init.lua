---@class r.utils.codecompanion
local M = {}

local adapters = require "r.utils.codecompanion.adapters"
local mappings = require "r.utils.codecompanion.keymaps"
local extensions = require "r.utils.codecompanion.extensions"
local cli = require "r.utils.codecompanion.cli"
local rules = require "r.utils.codecompanion.rules"
local tools = require "r.utils.codecompanion.tools"
local slash_commands = require "r.utils.codecompanion.slash_commands"
local prompt_library = require "r.utils.codecompanion.prompt_library"
local ui = require "r.utils.codecompanion.ui"

local function setup_plugin()
  return {
    -- Adapters
    adapters = {
      http = {
        opts = {
          show_presets = false,
          show_model_choices = true,
        },

        ollama_qwen25_14b = adapters.ollama_qwen25_14b(),
        ollama_qwen25_7b = adapters.ollama_qwen25_7b(),
        ollama_qwen3_8b = adapters.ollama_qwen3_8b(),
        -- openai_gpt_55 = adapters.openai_gpt_55,
        -- openai_gpt_54_nano = adapters.openai_gpt_54_nano,
        -- openai_gpt_54_nano_legacy = adapters.openai_gpt_54_nano_legacy,
        gemini_flash_35 = adapters.gemini_flash_35,
        -- ollama_qwen35_08b = adapters.ollama_qwen35_08b,
        -- tavily = adapters.tavily,
      },
      acp = {
        opts = {
          show_presets = false,
          show_model_choices = false,
        },
        -- claude_code = adapters.claude_code,
        -- codex = adapters.codex,
      },
    },
    -- Display
    display = {
      chat = ui.chat_display(),
      action_palette = {
        prompt = "> ",
        opts = {
          show_preset_actions = true,
          show_preset_prompts = false,
        },
      },
      diff = {
        layout = "vertical",
        threshold_for_chat = 15,
      },
    },
    -- Interactions
    interactions = {
      -- Chat
      chat = {
        adapter = "ollama_qwen25_7b",
        roles = {
          user = "Me",
          llm = ui.llm_role,
        },
        action_palette = {
          prompt = "> ",
          opts = {
            show_preset_actions = true,
            show_preset_prompts = false,
          },
        },
        opts = {
          context_management = {
            enabled = false,
          },
          -- system_prompt = function(ctx)
          --   if ctx.adapter and ctx.adapter.type == "acp" then
          --     return ""
          --   end
          --   return prompt_library.prompt "helpful_assistant"
          -- end,
          prompt_decorator = function(message)
            return message
          end,
          goto_file_action = function(fname)
            vim.cmd.wincmd "h"
            vim.cmd.edit(fname)
          end,
        },
        keymaps = vim.tbl_extend("force", mappings.chat_keymaps(), rules.chat_keymaps()),

        -- Slash commands
        slash_commands = slash_commands.build(),
        -- Tools
        tools = tools.build(),
        -- Editor context (variables)
        editor_context = {
          ["buffer"] = {
            opts = {
              default_params = "diff",
            },
          },
        },
      },
      -- CLI
      cli = cli.build(),
      -- Inline
      inline = {
        adapter = "ollama_qwen25_7b",
      },
      shared = {
        keymaps = mappings.shared_keymaps(),
      },
    },
    -- Prompt library
    prompt_library = prompt_library.build(),
    -- -- MCP
    -- mcp = mcp.build(),
    -- -- Rules
    rules = rules.build(),
    -- Extensions
    extensions = extensions.build(),
  }
end

function M.setup()
  require("codecompanion").setup(setup_plugin())
  ui.setup()

  local setup_group = "CodeCompanion"
  mappings.setup(setup_group)
end

return M
