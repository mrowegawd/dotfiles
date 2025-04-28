return {
  -- CODECOMPANION
  {
    "olimorris/codecompanion.nvim",
    -- enabled = false,
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    keys = {
      {
        "<Leader>aa",
        "<CMD>CodeCompanionChat<CR>",
        desc = "Codecompanion: toggle",
      },
    },
    opts = {
      -- display = {
      --   chat = {
      --     window = {
      --       opts = {
      --         -- cursorline = true,
      --         numberwidth = 4,
      --       },
      --     },
      --   },
      -- },
      -- prompt_library = { -- TEST BAHASA
      --   ["Tolongin gue generate commit dong"] = {
      --     strategy = "chat",
      --     description = "aku sayang kamu",
      --     opts = {
      --       index = 10,
      --       is_default = true,
      --       is_slash_cmd = true,
      --       short_name = "commit_in_bahasa_indonesia", --->> ini short name nya
      --       auto_submit = true,
      --     },
      --     prompts = {
      --       {
      --         role = "user",
      --         content = function()
      --           -- NOTE: nah klo ini tinggal tambahain aja "in bahasa" atau pake
      --           -- bahasa indonesia langsung
      --           return string.format(
      --             [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me in bahasa:
      --
      --  ```diff
      --  %s
      --  ```
      --  ]],
      --             vim.fn.system "git diff --no-ext-diff --staged"
      --           )
      --         end,
      --         opts = {
      --           contains_code = true,
      --         },
      --       },
      --     },
      --   },
      -- },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "zbirenbaum/copilot.lua", opts = { suggestion = { enabled = false } } },
    },
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "markdown", "codecompanion" },
    opts = { file_types = { "markdown", "codecompanion" } },
  },
}
