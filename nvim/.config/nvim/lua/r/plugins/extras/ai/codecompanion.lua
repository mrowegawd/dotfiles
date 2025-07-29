local newline = "\n\n"
local code_block_delimiter = "```"
local COPILOT_REVIEW =
  string.format [[Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.
  
Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.
 
If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]]
local COPILOT_REFACTOR =
  string.format [[Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
]]

local function get_selected_lines(context)
  local code_helper = require "codecompanion.helpers.actions"
  local selected_lines = code_helper.get_code(context.start_line, context.end_line)
  local visual = RUtils.cmd.get_visual_selection {}
  if visual ~= nil then
    selected_lines = visual.selection
  end

  return selected_lines
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local codecompanion_group = augroup("CodeCompanionAutoSave", { clear = true })

local function save_codecompanion_buffer(bufnr)
  local save_dir = vim.fn.stdpath "data" .. "/codecompanion"

  vim.fn.mkdir(save_dir, "p")

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Extract the unique ID from the buffer name
  local id = bufname:match "%[CodeCompanion%] (%d+)"
  local date = os.date "%Y-%m-%d"
  local save_path

  if id then
    -- Use date plus ID to ensure uniqueness
    save_path = save_dir .. "/" .. date .. "_codecompanion_" .. id .. ".md"
  else
    -- Fallback with timestamp to ensure uniqueness if no ID
    save_path = save_dir .. "/" .. date .. "_codecompanion_" .. os.date "%H%M%S" .. ".md"
  end

  -- Write buffer content to file
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local file = io.open(save_path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
  end
end

autocmd({ "InsertLeave", "TextChanged", "BufLeave", "FocusLost" }, {
  group = codecompanion_group,
  callback = function(args)
    local bufnr = args.buf
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match "%[CodeCompanion%]" then
      save_codecompanion_buffer(bufnr)
    end
  end,
})

-- Keymaps stuf
local function try_focus_chat_float()
  -- Focus window if already open (we search for a floating window with specifix zindex)
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    local conf = vim.api.nvim_win_get_config(win_id)
    if conf.focusable and conf.relative ~= "" and conf.zindex == 45 then
      vim.api.nvim_set_current_win(win_id)
      return true
    end
  end
  return false
end

local function focus_or_toggle_chat()
  if try_focus_chat_float() then
    return
  end

  local codecompanion = require "codecompanion"
  codecompanion.toggle()
  vim.defer_fn(function()
    vim.cmd "startinsert"
  end, 1)
end

return {
  -- CODECOMPANION
  {
    "olimorris/codecompanion.nvim",
    -- enabled = false,
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
      -- "jellydn/spinner.nvim", -- Show loading spinner when request is started
      "nvim-treesitter/nvim-treesitter",
      { "zbirenbaum/copilot.lua", opts = { suggestion = { enabled = false } } },
      { "franco-ruggeri/codecompanion-spinner.nvim", opts = {} },
    },
    keys = {
      {
        "<Leader>ac",
        ":CodeCompanion ",
        desc = "Codecompanion: run :CodeCompanion command in normal or visual mode",
        mode = { "n", "v" },
      },
      {
        "<Leader>aa",
        function()
          focus_or_toggle_chat()
        end,
        desc = "Codecompanion: toggle open",
      },
      {
        "<Leader>aA",
        "<CMD>CodeCompanionActions<CR>",
        desc = "Codecompanion: select actions",
      },
      {
        "<leader>aF",
        function()
          local codecompanion_cwd = vim.fn.stdpath "data" .. "/codecompanion"
          return require("fzf-lua").files {
            prompt = RUtils.fzflua.default_title_prompt(),
            winopts = { title = RUtils.fzflua.format_title("Codecompanion Saved", "󰈙"), fullscreen = true },
            cwd = codecompanion_cwd,
            fzf_opts = { ["--header"] = [[^r:rgflow  ^g:grep  ^x:delete  ^y:yank  ^q:ignore  ^o:hidden]] },
            actions = {
              ["ctrl-g"] = function()
                require("fzf-lua").live_grep_glob {
                  winopts = { title = RUtils.fzflua.format_title("Grep: Codecompanion Saved", "󰈙") },
                  cwd = codecompanion_cwd,
                }
              end,
              ["ctrl-x"] = function(selected, _)
                local del_tbl = {}
                if #selected > 1 then
                  del_tbl = selected
                else
                  del_tbl[#del_tbl + 1] = selected[1]
                end

                if #del_tbl > 0 then
                  for _, dir in pairs(del_tbl) do
                    local file_path = codecompanion_cwd .. "/" .. RUtils.fzflua.__strip_str(dir)
                    if vim.fn.filereadable(file_path) == 1 then
                      local ok, err = os.remove(file_path)
                      if ok then
                        ---@diagnostic disable-next-line: undefined-field
                        RUtils.info("File deleted: " .. file_path, { title = "Codecompanion File Saved" })
                      else
                        RUtils.error("Failed to delete file: " .. err, { title = "Codecompanion File Saved" })
                      end
                    end
                  end
                end

                require("fzf-lua").actions.resume()
              end,
            },
          }
        end,
        desc = "Codecompanion: find and grep previous chats",
      },
      {
        "<Leader>af",
        function()
          local git_ft_stuff = { "fugitive" }
          local prompt_cmds = {
            -- Ask a question
            ask_question_with_ai = { cmd = "CodeCompanion /ai_chat", ft = {} },

            -- Explain stuff
            explain_to_me = { cmd = "CodeCompanion /explain_to_me", ft = {} },

            -- Translate
            translate_id = { cmd = "CodeCompanion /translate_in_bahasa", ft = {} },
            translate_en = { cmd = "CodeCompanion /translate_in_en", ft = {} },

            -- Fix, correct, improve the EN or IDN sentence.
            fix_or_correct_en_sentence = { cmd = "CodeCompanion /correct_sentence_en", ft = {} },
            fix_or_correct_todo_sentence = { cmd = "CodeCompanion /correct_todo_sentence", ft = {} },
            fix_or_correct_wiki_sentence = { cmd = "CodeCompanion /correct_wiki_sentence", ft = {} },

            -- Git stuff
            git_commit = { cmd = "CodeCompanion /commit", ft = git_ft_stuff },
            -- git_commit_our = { cmd = "CodeCompanion /write_commit", ft = {} },
            git_check_or_rewrote_commit = { cmd = "CodeCompanion /commit", ft = {} },

            -- Write doc
            write_inline_doc = { cmd = "CodeCompanion /inline_doc", ft = {} },
            write_doc = { cmd = "CodeCompanion /doc", ft = {} },

            -- Programming stuff
            review_code = { cmd = "CodeCompanion /review", ft = {} },
            refactor_inline_code = { cmd = "CodeCompanion /refactor", ft = {} },
            refactor_side_effect_code = { cmd = "CodeCompanion /refactor_side_effect", ft = {} },
            naming_variable_inline_code = { cmd = "CodeCompanion /naming", ft = {} },
            naming_variable_code = { cmd = "CodeCompanion /better_naming", ft = {} },

            -- exract_func = { cmd = "CodeCompanion /commit", ft = {} },
            -- exract_variable = { cmd = "CodeCompanion /commit", ft = {} },
            -- generate_boilerplate_test_code = { cmd = "CodeCompanion /commit", ft = {} },
            -- generate_docs = { cmd = "CodeCompanion /commit", ft = {} },
            -- sugest_or_fix_the_code = { cmd = "CodeCompanion /commit", ft = {} },
            -- generate_some_funcs = { cmd = "CodeCompanion /commit", ft = {} },
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
            local results = {}
            for i, x in pairs(prompt_cmds) do
              if vim.tbl_contains(git_ft_stuff, vim.bo.filetype) then
                if is_tables_are_equal(git_ft_stuff, x.ft) then
                  results[#results + 1] = i
                end
              else
                results[#results + 1] = i
              end
            end

            return results
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
            intro_message = "",
            roles = {
              -- user = os.getenv "USER",
              llm = function(adapter)
                if not (adapter and adapter.schema and adapter.schema.model) then
                  return "CodeCompanion"
                end

                return "CodeCompanion (" .. adapter.formatted_name .. ":" .. adapter.schema.model.default .. ")"
              end,
            },
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
                  n = "<Leader>C",
                  i = "<Leader>C",
                },
                index = 4,
                callback = "keymaps.clear",
                description = "Clear Chat",
              },
              close = {
                modes = {
                  n = "<C-c>",
                  i = "<C-c>",
                },
                index = 5,
                callback = function()
                  return {}
                end,
                description = "The <c-c> mapping is disabled",
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
                  n = "<a-n>",
                },
                index = 13,
                callback = "keymaps.next_header",
                description = "Next Header",
              },
              previous_header = {
                modes = {
                  n = "<a-p>",
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
        display = {
          chat = {
            intro_message = "",
            icons = {
              pinned_buffer = " ",
              watched_buffer = " ",
            },
            -- window = { -- Atm, using a floating window may cause conflicts when using 'translate' for the browser
            --   layout = "float",
            --   border = "rounded",
            --   height = vim.o.lines - 5, -- (tabline, statuline and cmdline height + row)
            --   width = 0.45,
            --   relative = "editor",
            --   col = vim.o.columns, -- right position
            --   row = 1,
            --   opts = {},
            -- },
            debug_window = {
              width = math.floor(vim.o.columns * 0.535),
              height = vim.o.lines - 4,
            },
          },
          action_palette = {
            prompt = "> ",
            opts = {
              show_default_actions = true,
              show_default_prompt_library = false,
            },
          },
          diff = { layout = "vertical" },
        },
        prompt_library = {
          ["Ask ai chat"] = {
            strategy = "chat",
            description = "Ask the AI via chat",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "ai_chat",
              auto_submit = false,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  return get_selected_lines(context) .. newline
                end,
              },
            },
          },

          ["Explain to me"] = {
            strategy = "chat",
            description = "Explains the code, how it works, and its process",
            opts = {
              index = 6,
              is_default = true,
              is_slash_cmd = false,
              modes = { "v" },
              short_name = "explain_to_me",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header =
                    "Jelaskan secara singkat dan jelas bagaimana kode berikut bekerja. Sebutkan apa inputnya, proses utamanya, dan outputnya. Jika memungkinkan, berikan contoh sederhana agar lebih mudah dipahami:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },

          --           ["Write Commit Message"] = {
          --             strategy = "inline",
          --             description = "Writes commit message on gitcommit buffer",
          --             opts = {
          --               index = 10,
          --               is_default = false,
          --               is_slash_cmd = false,
          --               short_name = "write_commit",
          --               auto_submit = false,
          --             },
          --             prompts = {
          --               {
          --                 role = "user",
          --                 content = function()
          --                   return string.format(
          --                     [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please @editor generate a commit message for me inside of the current #buffer:
          --
          -- ```diff
          -- %s
          -- ```
          --
          -- And the previous 10 commits, just in case they're related to the current changes:
          -- ```gitcommit
          -- %s
          -- ```]],
          --                     vim.fn.system "git diff --no-ext-diff --staged",
          --                     vim.fn.system "git log -n 10"
          --                   )
          --                 end,
          --                 opts = {
          --                   contains_code = false,
          --                 },
          --               },
          --             },
          --           },

          -- Fix, correct, improve the sentence, ToDo, or Wiki entry in either English or Indonesian.
          ["Fix this sentence in properly English"] = {
            strategy = "chat",
            description = "Fix the English sentence properly",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "correct_sentence_en",
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header =
                    "Tolong perbaiki kalimat bahasa inggris ini dengan proper, benar dan jika terdapat kesalahan penulisan atau kalimat nya kurang jelas tolong diperbaiki:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Fix this wiki sentence"] = {
            strategy = "chat",
            description = "Fix this string notes",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "correct_wiki_sentence",
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header = "Tolong perbaiki kalimat berikut ini agar lebih jelas dan spesifik, dengan kondisi seperti ini:"
                    .. newline
                    .. "- jika terdapat code, tolong jelaskan code dan dijabarkan dengan benar"
                    .. newline
                    .. "- jika perlu tambahkan juga contoh-contoh code penggunaannya, mungkin dengan kasus yang berbeda"
                    .. newline
                    .. "- jika judul terbaca kurang jelas atau ambigu, tolong perbaiki dengan menyesuaikan konteksnya :"
                    .. newline
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Fix this todo sentence"] = {
            strategy = "chat",
            description = "Fix this todo string",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "correct_todo_sentence",
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header =
                    "Tolong perbaiki kalimat TODO berikut ini agar lebih jelas dan spesifik. Sertakan tujuan, langkah yang harus dilakukan, dan kriteria keberhasilan jika memungkinkan:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },

          -- Translate
          ["Translate into indo xclip"] = {
            strategy = "chat",
            description = "Translate these text into bahasa indonesia with xclip",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "translate_in_bahasa_xclip",
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function()
                  local header =
                    "Tolong translate kalimat ini ke bahasa indonesia, perbaiki maksud jika kalimat nya kurang baku, tanda baca dan juga jelaskan secara singkat tapi mudah dimengerti:"
                  local body = code_block_delimiter
                    .. "text"
                    .. "\n"
                    .. vim.system { "xclip", "-o", "-se", "clip" }
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Translate into indo"] = {
            strategy = "chat",
            description = "Translate these text into bahasa indonesia",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "translate_in_bahasa",
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header =
                    "Tolong translate text ini ke bahasa indonesia, perbaiki maksud jika kalimat nya kurang baku, tanda baca dan juga jelaskan secara singkat tapi mudah dimengerti:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Translate into english"] = {
            strategy = "chat",
            description = "Translate this from xclip",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "translate_in_en",
              auto_submit = true,
              display = { chat = { window = { layout = "buffer" } } },
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header =
                    "Tolong translate ini ke bahasa inggris, perbaiki maksud jika kalimat nya kurang baku, tanda baca dan juga jelaskan secara singkat tapi mudah dimengerti dengan bahasa indonesia:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },

          -- Write a documentation comment
          ["Inline Document"] = {
            strategy = "inline",
            description = "Add documentation for code",
            opts = {
              modes = { "v" },
              short_name = "inline_doc",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local header =
                    "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability."
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Document"] = {
            strategy = "chat",
            description = "Write documentation for code.",
            opts = {
              modes = { "v" },
              short_name = "doc",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local header =
                    "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability."
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },

          -- Programming stuff
          ["Review"] = {
            strategy = "chat",
            description = "Review the provided code snippet.",
            opts = {
              modes = { "v" },
              short_name = "review",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = COPILOT_REVIEW,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = function(context)
                  local header =
                    "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability, explain in bahasa but do not translate the code comments:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Review Code"] = {
            strategy = "chat",
            description = "Review code and provide suggestions for improvement.",
            opts = {
              short_name = "review_code",
              auto_submit = false,
              is_slash_cmd = true,
            },
            prompts = {
              {
                role = "system",
                content = COPILOT_REVIEW,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.",
              },
            },
          },
          ["Refactor"] = {
            strategy = "inline",
            description = "Refactor the provided code snippet.",
            opts = {
              modes = { "v" },
              short_name = "refactor",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = COPILOT_REFACTOR,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = function(context)
                  local header =
                    "Please refactor the following code to improve its clarity and readability, explain in bahasa but do not translate the code comments:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Refactor side effect"] = {
            strategy = "chat",
            description = "Refactor the provided code snippe, and better side effect",
            opts = {
              modes = { "v" },
              short_name = "refactor_side_effect",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "system",
                content = COPILOT_REFACTOR,
                opts = {
                  visible = false,
                },
              },
              {
                role = "user",
                content = function(context)
                  local header = [[
Refaktor fungsi berikut dengan ketentuan:
- Meminimalkan efek samping (hindari mengubah state eksternal atau variabel global).
- Mengurangi dependensi (batasi penggunaan modul eksternal atau kode yang saling terkait erat).
- Mudah untuk diuji (fungsi murni, input/output jelas, tidak ada state tersembunyi).

Silakan berikan kode hasil refaktor beserta penjelasan singkat mengenai perubahan yang dilakukan.
]]
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Naming"] = {
            strategy = "inline",
            description = "Give betting naming for the provided code snippet",
            opts = {
              modes = { "v" },
              short_name = "naming",
              auto_submit = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local header = "Please provide better names for the following variables and functions:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Better Naming"] = {
            strategy = "chat",
            description = "Give betting naming for the provided code snippet",
            opts = {
              modes = { "v" },
              short_name = "better_naming",
              auto_submit = true,
              is_slash_cmd = true,
              user_prompt = false,
              stop_context_insertion = true,
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local header =
                    "Please suggest more descriptive and meaningful names for the following variables and functions:"
                  local body = code_block_delimiter
                    .. context.filetype
                    .. "\n"
                    .. get_selected_lines(context)
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
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
    config = function(_, opts)
      require("codecompanion").setup(opts)
      -- RUtils.codecompanion_fidget:init()
    end,
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "markdown", "codecompanion" },
    opts = { file_types = { "markdown", "codecompanion" } },
  },
}
