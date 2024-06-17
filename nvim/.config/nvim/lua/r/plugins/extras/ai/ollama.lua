return {
  -- GEN.NVIM (disabled)
  {
    "David-Kunz/gen.nvim",
    enabled = false,
    cmd = { "Gen" },
    -- enabled = false,
    config = function()
      local gen = require "gen"
      gen.setup {
        model = "zephyr", -- The default model to use.
        display_mode = "split", -- The display mode. Can be "float" or "split".
        show_prompt = false, -- Shows the Prompt submitted to Ollama.
        show_model = false, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        ---@diagnostic disable-next-line: unused-local
        init = function(options)
          pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
        end,
        -- Function to initialize Ollama
        command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
        -- The command for the Olama service can take placeholders: $prompt,
        -- $model, and $body (escaped if needed). This can also be a Lua
        -- function returning a command string with an options input parameter.
        -- The executed command should return a JSON object containing:
        -- {"response", context} (the context property is optional).
        debug = false,
      }
    end,
  },
}
