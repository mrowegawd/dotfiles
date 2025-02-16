return {
  -- COPILOT
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    config = true,
  },
  -- AVANTE
  {
    -- To make it work, run: Copilot Auth
    "yetone/avante.nvim",
    event = "VeryLazy",
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
    },
    dependencies = {
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
