return {
  -- AVANTE
  {
    -- To make it work, run: Copilot Auth
    "yetone/avante.nvim",
    -- event = "VeryLazy",
    -- enabled = false,
    version = false,
    opts = {
      provider = "copilot",
      file_selector = {
        provider = "fzf", -- Avoid native provider issues
        provider_opts = {},
      },
    },
    build = "make",
    keys = {
      {
        "C",
        "<CMD>AvanteClear<CR>", -- or /clear
        ft = "Avante",
        desc = "Avante: clear history",
      },
      -- {
      --   "<Leader>aa",
      --   function()
      --     require("avante.api").ask { ask = false }
      --   end,
      --   desc = "Avante: chat",
      -- },
      {
        "<Leader>aa",
        function()
          local args = { question = nil, win = {} }
          local q_parts = {}
          local q_ask = nil
          for _, arg in ipairs(opts.fargs) do
            local value = arg:match "position=(%w+)"
            local ask = arg:match "ask=(%w+)"
            if ask ~= nil then
              q_ask = ask == "true"
            elseif value then
              args.win.position = value
            else
              table.insert(q_parts, arg)
            end
          end
          require("avante.api").ask(
            vim.tbl_deep_extend(
              "force",
              args,
              { ask = q_ask, question = #q_parts > 0 and table.concat(q_parts, " ") or nil }
            )
          )
        end,
        desc = "Avante: toggle",
      },
    },
    dependencies = {
      { "zbirenbaum/copilot.lua", config = true },
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.icons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
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
