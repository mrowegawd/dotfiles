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
              options = {
                modes = { n = "?" },
                callback = function()
                  require("which-key").show { global = false }
                end,
                description = "Codecompanion Keymaps",
                hide = true,
              },
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
          ["Translate indo xclip"] = {
            strategy = "chat",
            description = "Translate this from xclip",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "translate_in_bahasa", --->> ini short name nya
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function()
                  -- NOTE: nah klo ini tinggal tambahain aja "in bahasa" atau pake
                  -- bahasa indonesia langsung
                  return string.format(
                    [[Tolong translate ini ke bahasa indonesia, perbaiki maksud jika kalimat nya kurang baku, tanda baca dan juga jelaskan secara singkat tapi mudah dimengerti:

            ```diff
            %s
            ```
            ]],
                    vim.fn.system "xclip -o -sel clip"
                  )
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
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
