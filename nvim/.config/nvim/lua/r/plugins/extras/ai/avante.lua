return {
  -- AVANTE (disabled)
  {
    -- To make it work, run: Copilot Auth
    "yetone/avante.nvim",
    version = false,
    enabled = false,
    build = "make",
    opts = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "ToggleMyPrompt",
        callback = function()
          require("avante.config").override { system_prompt = "MY CUSTOM SYSTEM PROMPT" }
        end,
      })

      vim.keymap.set("n", "<leader>am", function()
        vim.api.nvim_exec_autocmds("User", { pattern = "ToggleMyPrompt" })
      end, { desc = "avante: toggle my prompt" })

      return {
        provider = "copilot",
        file_selector = {
          provider = "fzf", -- Avoid native provider issues
          provider_opts = {},
        },
      }
    end,
    keys = {
      {
        "C",
        "<CMD>AvanteClear<CR>", -- or /clear
        ft = "Avante",
        desc = "Avante: clear history",
      },
      {
        "<Leader>aa",
        function()
          local Utils = require "avante.utils"
          local sel = Utils.get_visual_selection_and_range()
          local q = "Jelaskan code ini"
          local opts = { ask = true, win = {}, selection = sel, floating = false, question = q }

          -- local sidebar = require("avante").get()
          -- if sidebar and sidebar:is_open() and sidebar.code.bufnr ~= vim.api.nvim_get_current_buf() then
          --   sidebar:close { goto_code_win = false }
          -- end
          --
          -- require("avante").open_sidebar(opts)

          -- vim.api.nvim_exec_autocmds("User", { pattern = "AvanteInputSubmitted", data = { request = q } })

          --   local q_parts = {}
          --   local q_ask = nil
          --   for _, arg in ipairs(opts.fargs) do
          --     local value = arg:match "position=(%w+)"
          --     local ask = arg:match "ask=(%w+)"
          --     if ask ~= nil then
          --       q_ask = ask == "true"
          --     elseif value then
          --       args.win.position = value
          --     else
          --       table.insert(q_parts, arg)
          --     end
          --   end
          require("avante.api").ask(opts)
        end,
        mode = { "n", "v" },
        desc = "Avante: toggle",
      },
    },
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        opts = {
          suggestion = {
            enabled = false,
          },
        },
      },
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.icons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = { file_types = { "markdown", "Avante" } },
    ft = { "markdown", "Avante" },
  },
}
