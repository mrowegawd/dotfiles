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
      {
        "<Leader>af",
        "<CMD>CodeCompanionActions<CR>",
        desc = "Codecompanion: select actions",
      },
    },
    opts = function()
      local constants = require("codecompanion.config").config.constants
      return {
        strategies = {
          chat = {
            keymaps = {
              regenerate = {
                modes = {
                  n = "gr",
                },
                index = 3,
                callback = "keymaps.regenerate",
                description = "Regenerate the last response",
              },
              clear = {
                modes = {
                  n = "C",
                },
                index = 6,
                callback = "keymaps.clear",
                description = "Clear Chat",
              },
              --   codeblock = {
              --     modes = {
              --       n = "gc",
              --     },
              --     index = 7,
              --     callback = "keymaps.codeblock",
              --     description = "Insert Codeblock",
              --   },
              --   yank_code = {
              --     modes = {
              --       n = "gy",
              --     },
              --     index = 8,
              --     callback = "keymaps.yank_code",
              --     description = "Yank Code",
              --   },
              --   pin = {
              --     modes = {
              --       n = "gp",
              --     },
              --     index = 9,
              --     callback = "keymaps.pin_reference",
              --     description = "Pin Reference",
              --   },
              --   watch = {
              --     modes = {
              --       n = "gw",
              --     },
              --     index = 10,
              --     callback = "keymaps.toggle_watch",
              --     description = "Watch Buffer",
              --   },
              next_header = {
                modes = {
                  n = "<c-n>",
                },
                index = 13,
                callback = "keymaps.next_header",
                description = "Next Header",
              },
              previous_header = {
                modes = {
                  n = "<c-p>",
                },
                index = 14,
                callback = "keymaps.previous_header",
                description = "Previous Header",
              },
              next_chat = {
                modes = {
                  n = "<a-n>",
                },
                index = 11,
                callback = "keymaps.next_chat",
                description = "Next Chat",
              },
              previous_chat = {
                modes = {
                  n = "<a-p>",
                },
                index = 12,
                callback = "keymaps.previous_chat",
                description = "Previous Chat",
              },
            },
          },
        },
        prompt_library = {
          ["Easy explain"] = {
            strategy = "chat",
            description = "Explain how code in a buffer works, like you're talking to a baby.",
            opts = {
              index = 6,
              is_default = true,
              is_slash_cmd = false,
              modes = { "v" },
              short_name = "jelaskan_dgn_bahasa_bayi",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return string.format(
                    [[Jelaskan dengan bahasa bayi, agar mudah dipahami pada buffer %d:

```%s
%s
```
]],
                    context.bufnr,
                    context.filetype,
                    code
                  )
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
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
          --         role = constants.USER_ROLE,
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
        },
      }
    end,
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
