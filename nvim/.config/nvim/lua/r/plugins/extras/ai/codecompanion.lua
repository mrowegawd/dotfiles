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
        desc = "Codecompanion: toggle open",
      },
      {
        "<Leader>aF",
        "<CMD>CodeCompanionActions<CR>",
        desc = "Codecompanion: select actions",
      },
      {
        "<Leader>af",
        function()
          local git_ft_stuff = { "fugitive" }
          local prompt_cmds = {
            translate_id = { cmd = "CodeCompanion /translate_in_bahasa", ft = {} },
            git_commit = { cmd = "CodeCompanion /commit", ft = git_ft_stuff },
            note_fix_this_string = { cmd = "CodeCompanion /fix_this_line_notes", ft = {} },
            explain_to_me_like_baby = { cmd = "CodeCompanion /jelaskan_dgn_bahasa_bayi", ft = {} },
            note_fix_this_todo = { cmd = "CodeCompanion /fix_this_line_todo", ft = {} },
            explain_to_me = { cmd = "CodeCompanion /jelaskan_dgn_bahasa_bayi", ft = {} },

            exract_func = { cmd = "CodeCompanion /commit", ft = {} },
            exract_variable = { cmd = "CodeCompanion /commit", ft = {} },
            suggest_readable_variable = { cmd = "CodeCompanion /commit", ft = {} },
            generate_boilerplate_test_code = { cmd = "CodeCompanion /commit", ft = {} },
            generate_docs = { cmd = "CodeCompanion /commit", ft = {} },
            git_check_or_rewrote_commit = { cmd = "CodeCompanion /commit", ft = {} },
            sugest_or_fix_the_code = { cmd = "CodeCompanion /commit", ft = {} },
            format_todo_text = { cmd = "CodeCompanion /commit", ft = {} },
            generate_some_funcs = { cmd = "CodeCompanion /commit", ft = {} },
          }

          local function is_tables_are_equal(t1, t2)
            if type(t1) ~= "table" or type(t2) ~= "table" then
              return t1 == t2
            end

            -- Periksa jumlah elemen
            local t1Length, t2Length = 0, 0
            for _ in pairs(t1) do
              t1Length = t1Length + 1
            end
            for _ in pairs(t2) do
              t2Length = t2Length + 1
            end
            if t1Length ~= t2Length then
              return false
            end

            -- Bandingkan setiap elemen
            for key, value in pairs(t1) do
              if not is_tables_are_equal(value, t2[key]) then
                return false
              end
            end

            return true
          end

          local sel_prompts = function()
            local sel_prompts = {}
            for i, x in pairs(prompt_cmds) do
              if vim.tbl_contains(git_ft_stuff, vim.bo.filetype) then
                if is_tables_are_equal(git_ft_stuff, x.ft) then
                  sel_prompts[#sel_prompts + 1] = i
                end
              else
                sel_prompts[#sel_prompts + 1] = i
              end
            end

            return sel_prompts
          end

          local function is_get_lines()
            local line = RUtils.cmd.get_visual_selection()
            if line and line.selection then
              vim.fn.setreg("+", line.selection)
            end
          end

          local opts = {
            winopts = {
              title = RUtils.fzflua.format_title(
                "Select Custom Prompt Ai [CodeCompanion]",
                RUtils.config.icons.misc.ai
              ),
              relative = "cursor",
              width = 0.25,
              height = 0.30,
              row = 1,
              col = 2,
            },

            actions = {
              ["default"] = function(selected)
                local sel = selected[1]
                local prompt = prompt_cmds[sel]

                is_get_lines()
                vim.cmd(prompt.cmd)
              end,
            },
          }
          require("fzf-lua").fzf_exec(sel_prompts(), opts)
        end,
        mode = { "n", "v" },
        desc = "Codecompanion: select custome prompt",
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
          ["Easy explain to me like baby"] = {
            strategy = "chat",
            description = "Jelaskan code yang di copy ini bekerja, jelaskan seperti sedang berbicara dengan anak kecil",
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
                content = function()
                  -- local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                  return string.format(
                    [[Jelaskan code yang di copy ini bekerja, jelaskan seperti sedang berbicara dengan anak kecil:

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
          ["Fix this string notes"] = {
            strategy = "chat",
            description = "Fix this string notes",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "fix_this_line_notes", --->> ini short name nya
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function()
                  return string.format(
                    [[Tolong perbaiki kalimat nya agar mudah dimengerti

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
          ["Fix this todo string"] = {
            strategy = "chat",
            description = "Fix this todo string",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "fix_this_line_todo", --->> ini short name nya
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function()
                  return string.format(
                    [[Tolong perbaiki kalimat dan juga format todo ini

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
