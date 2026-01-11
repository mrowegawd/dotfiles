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
  local visual = RUtils.get_visual_selection {}
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
end

local last_online_check, online_status
local online_cache_timeout = 30
local function is_online()
  local now = os.time()
  if last_online_check and (now - last_online_check < online_cache_timeout) then
    return online_status
  end
  online_status = vim.system({ "ping", "-c", "1", "8.8.8.8" }, { timeout = 1000 }):wait().code == 0
  last_online_check = now
  return online_status
end

return {
  -- CODECOMPANION
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/codecompanion-history.nvim",
      { "zbirenbaum/copilot.lua", opts = { suggestion = { enabled = false } } },
    },
    keys = {
      { "<Leader>ma", "", desc = "add", ft = "codecompanion" },
      { "<Leader>mb", "", desc = "buffer", ft = "codecompanion" },
      { "<Leader>mf", "", desc = "find/list/adapter/model", ft = "codecompanion" },

      {
        "<Localleader>aa",
        "<cmd>CodeCompanionChat Add<CR>",
        desc = "Codecompanion: Add code to a chat buffer",
        mode = { "v" },
      },
      {
        "<Localleader>ac",
        ":CodeCompanion ",
        desc = "Codecompanion: run :CodeCompanion command in normal or visual mode",
        mode = { "n", "x" },
      },
      {
        "<Localleader>ai",
        function()
          focus_or_toggle_chat()
        end,
        desc = "Codecompanion: toggle open",
      },
      {
        "<Localleader>aC",
        "<CMD>CodeCompanionActions<CR>",
        desc = "Codecompanion: select actions",
      },
      {
        "<Localleader>aF",
        function()
          local function codecompanion_picker()
            local codecompanion_cwd = vim.fn.stdpath "data" .. "/codecompanion"
            return require("fzf-lua").files {
              prompt = RUtils.fzflua.padding_prompt(),
              winopts = { title = RUtils.fzflua.format_title("Codecompanion Saved", "󰈙"), fullscreen = true },
              cwd = codecompanion_cwd,
              fzf_opts = { ["--header"] = [[^r:rgflow  ^g:grep  ^x:delete  a-c:yank  ^q:ignore  ^z:hidden]] },
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
                          ---@diagnostic disable-next-line: undefined-field
                          RUtils.error("Failed to delete file: " .. err, { title = "Codecompanion File Saved" })
                        end
                      end
                    end
                  end

                  -- idk how to reload or open the picker, but it works
                  vim.schedule(codecompanion_picker)
                end,
              },
            }
          end

          codecompanion_picker()
        end,
        desc = "Codecompanion: find and grep previous chats",
      },
      {
        "<Localleader>af",
        function()
          local fzf_lua = require "fzf-lua"
          local git_ft_stuff = { "fugitive" }
          local prompt_cmds = {
            -- Ask a question
            ["Ask - ai"] = { cmd = "CodeCompanion /ai_chat", ft = {} },

            -- Explain stuff
            ["Code - Explain to me?"] = { cmd = "CodeCompanion /explain_to_me", ft = {} },

            -- Translate
            ["Translate - into idn"] = { cmd = "CodeCompanion /translate_in_bahasa", ft = {} },
            ["Translate - into english"] = { cmd = "CodeCompanion /translate_in_en", ft = {} },

            -- Fix, correct, improve the EN or IDN sentence.
            ["Fix words - ENG sentence"] = { cmd = "CodeCompanion /correct_sentence_en", ft = {} },
            ["Fix words - TODO sentence"] = { cmd = "CodeCompanion /correct_todo_sentence", ft = {} },
            ["Fix words - WIKI sentence"] = { cmd = "CodeCompanion /correct_wiki_sentence", ft = {} },

            -- Git stuff
            ["Git - commit"] = { cmd = "CodeCompanion /commit", ft = git_ft_stuff },
            -- git_commit_our = { cmd = "CodeCompanion /write_commit", ft = {} },
            ["Git - fix or rewrote commit"] = { cmd = "CodeCompanion /commit", ft = {} },

            -- Write doc
            ["Doc - write for inline doc codes"] = { cmd = "CodeCompanion /inline_doc", ft = {} },
            ["Doc - write for func docs"] = { cmd = "CodeCompanion /doc", ft = {} },

            -- Programming stuff
            ["Code - Review code"] = { cmd = "CodeCompanion /review", ft = {} },
            ["Refactor - Inline code"] = { cmd = "CodeCompanion /refactor", ft = {} },
            ["Refactor - Avoid side effect from code"] = { cmd = "CodeCompanion /refactor_side_effect", ft = {} },
            ["Refactor - Rewrite naming variable"] = { cmd = "CodeCompanion /naming", ft = {} },
            ["Refactor - Seggest better naming variable"] = { cmd = "CodeCompanion /better_naming", ft = {} },
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

            -- Bandingkan tiap elemen
            for key, value in pairs(t1) do
              if not is_tables_are_equal(value, t2[key]) then
                return false
              end
            end

            return true
          end

          local results_formats = function()
            local width_cmd = 1
            for idx, _ in pairs(prompt_cmds) do
              local str_x = vim.split(idx, " ")
              if width_cmd < #str_x[1] then
                width_cmd = #str_x[1]
              end
            end

            local results = {}
            for idx, x in pairs(prompt_cmds) do
              if vim.tbl_contains(git_ft_stuff, vim.bo.filetype) then
                if is_tables_are_equal(git_ft_stuff, x.ft) then
                  local str_x = vim.split(idx, "-")
                  local str_x_hl = fzf_lua.utils.ansi_from_hl("GitSignsAdd", str_x[1])
                  results[#results + 1] = string.format("%-" .. (width_cmd + 25) .. "s - %s", str_x_hl, str_x[2])
                end
              else
                local str_x = vim.split(idx, "-")
                local str_x_hl = fzf_lua.utils.ansi_from_hl("GitSignsAdd", str_x[1])
                results[#results + 1] = string.format("%-" .. (width_cmd + 25) .. "s - %s", str_x_hl, str_x[2])
              end
            end

            table.sort(results)

            return results
          end

          local function is_get_lines()
            local line = RUtils.get_visual_selection()
            if line and line.selection then
              vim.fn.setreg("+", line.selection)
            end
          end

          local opts = RUtils.fzflua.open_center_small_wide {
            winopts = {
              title = RUtils.fzflua.format_title(
                "Select Custom Prompt Ai [CodeCompanion]",
                RUtils.config.icons.misc.ai
              ),
            },
            actions = {
              ["default"] = function(selected, _)
                if not selected then
                  return
                end

                local sel = selected[1]

                local display_str = fzf_lua.utils.strip_ansi_coloring(sel)
                local display_str_split = vim.split(display_str, "-")

                local build_idx_cmd = RUtils.strip_whitespaces(display_str_split[1])
                  .. " - "
                  .. RUtils.strip_whitespaces(display_str_split[2])

                local prompt = prompt_cmds[build_idx_cmd]
                if prompt then
                  is_get_lines()
                  vim.cmd(prompt.cmd)
                  return
                end

                ---@diagnostic disable-next-line: undefined-field
                RUtils.info "Selection doesn't match!"
              end,
            },
          }

          local results = results_formats()
          require("fzf-lua").fzf_exec(results, opts)
        end,
        mode = { "n", "x" },
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
                modes = { n = "g?" },
                callback = "keymaps.options",
                description = "Options",
                hide = true,
              },
              completion = {
                modes = { i = "<C-_>" },
                index = 1,
                callback = "keymaps.completion",
                description = "[Chat] Completion menu",
              },
              send = {
                modes = {
                  n = { "<CR>", "<C-s>" },
                  i = "<C-s>",
                },
                index = 2,
                callback = "keymaps.send",
                description = "[Request] Send response",
              },
              regenerate = {
                modes = { n = "<Leader>mR" },
                index = 3,
                callback = "keymaps.regenerate",
                description = "[Request] Regenerate response",
              },
              close = {
                modes = {
                  n = "<C-c>",
                  i = "<C-c>",
                },
                index = 4,
                callback = "keymaps.close",
                description = "[Chat] Close",
              },
              stop = {
                modes = { n = "q" },
                index = 5,
                callback = "keymaps.stop",
                description = "[Request] Stop",
              },
              clear = {
                modes = { n = "<Leader>mC" },
                index = 6,
                callback = "keymaps.clear",
                description = "[Chat] Clear",
              },
              codeblock = {
                modes = { n = "<Leader>ic" },
                index = 7,
                callback = "keymaps.codeblock",
                description = "[Chat] Insert codeblock",
              },
              yank_code = {
                modes = { n = "<Leader>my" },
                index = 8,
                callback = "keymaps.yank_code",
                description = "[Chat] Yank or copy code",
              },
              buffer_sync_all = {
                modes = { n = "<Leader>mba" },
                index = 9,
                callback = "keymaps.buffer_sync_all",
                description = "[Chat] Toggle buffer syncing",
              },
              buffer_sync_diff = {
                modes = { n = "<Leader>mbd" },
                index = 10,
                callback = "keymaps.buffer_sync_diff",
                description = "[Chat] Toggle buffer diff syncing",
              },
              next_chat = {
                modes = { n = "<C-c>gn" },
                index = 11,
                callback = "keymaps.next_chat",
                description = "[Nav] Next chat",
              },
              previous_chat = {
                modes = { n = "<C-n>gp" },
                index = 12,
                callback = "keymaps.previous_chat",
                description = "[Nav] Previous chat",
              },
              next_header = {
                modes = { n = "<C-n>" },
                index = 13,
                callback = "keymaps.next_header",
                description = "[Nav] Next header",
              },
              previous_header = {
                modes = { n = "<C-p>" },
                index = 14,
                callback = "keymaps.previous_header",
                description = "[Nav] Previous header",
              },
              change_adapter = {
                modes = { n = "<Leader>mfa" },
                index = 15,
                callback = "keymaps.change_adapter",
                description = "[Adapter] Change adapter and model",
              },
              fold_code = {
                modes = { n = "<Leader>mG" },
                index = 15,
                callback = "keymaps.fold_code",
                description = "[Chat] Fold code",
              },
              debug = {
                modes = { n = "<Leader>mD" },
                index = 16,
                callback = "keymaps.debug",
                description = "[Chat] View debug info",
              },
              system_prompt = {
                modes = { n = "<Leader>mS" },
                index = 17,
                callback = "keymaps.toggle_system_prompt",
                description = "[Chat] Toggle system prompt",
              },
              rules = {
                modes = { n = "<Leader>R" },
                index = 18,
                callback = "keymaps.clear_rules",
                description = "[Chat] Clear Rules",
              },
              clear_approvals = {
                modes = { n = "<Leader>mc" },
                index = 19,
                callback = "keymaps.clear_approvals",
                description = "[Tools] Clear approvals",
              },
              yolo_mode = {
                modes = { n = "gty" },
                index = 20,
                callback = "keymaps.yolo_mode",
                description = "[Tools] Toggle YOLO mode",
              },
              goto_file_under_cursor = {
                modes = { n = "<Leader>be" },
                index = 21,
                callback = "keymaps.goto_file_under_cursor",
                description = "[Chat] Open file under cursor",
              },
              copilot_stats = {
                modes = { n = "<Leader>mI" },
                index = 22,
                callback = "keymaps.copilot_stats",
                description = "[Adapter] Copilot statistics",
              },
              super_diff = {
                modes = { n = "<Leader>mz" },
                index = 23,
                callback = "keymaps.super_diff",
                description = "[Tools] Show Super Diff",
              },

              -- Keymaps for ACP permission requests
              _acp_allow_always = {
                modes = { n = "g1" },
                description = "Allow Always",
              },
              _acp_allow_once = {
                modes = { n = "g2" },
                description = "Allow Once",
              },
              _acp_reject_once = {
                modes = { n = "g3" },
                description = "Reject Once",
              },
              _acp_reject_always = {
                modes = { n = "g4" },
                description = "Reject Always",
              },
            },
            -- keymaps = {
            --   options = {
            --     modes = { n = "?" },
            --     callback = function()
            --       require("which-key").show { global = false }
            --     end,
            --     description = "Codecompanion Keymaps",
            --     hide = true,
            --   },
            --   regenerate = {
            --     modes = {
            --       n = "gr",
            --     },
            --     index = 3,
            --     callback = "keymaps.regenerate",
            --     description = "Regenerate the last response",
            --   },
            --   clear = {
            --     modes = {
            --       n = "<Leader>C",
            --       i = "<Leader>C",
            --     },
            --     index = 4,
            --     callback = "keymaps.clear",
            --     description = "Clear Chat",
            --   },
            --   close = {
            --     modes = {
            --       n = "<C-c>",
            --       i = "<C-c>",
            --     },
            --     index = 5,
            --     callback = function()
            --       return {}
            --     end,
            --     description = "The <c-c> mapping is disabled",
            --   },
            --   --   codeblock = {
            --   --     modes = {
            --   --       n = "gc",
            --   --     },
            --   --     index = 7,
            --   --     callback = "keymaps.codeblock",
            --   --     description = "Insert Codeblock",
            --   --   },
            --   --   yank_code = {
            --   --     modes = {
            --   --       n = "gy",
            --   --     },
            --   --     index = 8,
            --   --     callback = "keymaps.yank_code",
            --   --     description = "Yank Code",
            --   --   },
            --   --   pin = {
            --   --     modes = {
            --   --       n = "gp",
            --   --     },
            --   --     index = 9,
            --   --     callback = "keymaps.pin_reference",
            --   --     description = "Pin Reference",
            --   --   },
            --   --   watch = {
            --   --     modes = {
            --   --       n = "gw",
            --   --     },
            --   --     index = 10,
            --   --     callback = "keymaps.toggle_watch",
            --   --     description = "Watch Buffer",
            --   --   },
            --   next_header = {
            --     modes = {
            --       n = "<a-n>",
            --     },
            --     index = 13,
            --     callback = "keymaps.next_header",
            --     description = "Next Header",
            --   },
            --   previous_header = {
            --     modes = {
            --       n = "<a-p>",
            --     },
            --     index = 14,
            --     callback = "keymaps.previous_header",
            --     description = "Previous Header",
            --   },
            --   next_chat = {
            --     modes = {
            --       n = "<a-n>",
            --     },
            --     index = 11,
            --     callback = "keymaps.next_chat",
            --     description = "Next Chat",
            --   },
            --   previous_chat = {
            --     modes = {
            --       n = "<a-p>",
            --     },
            --     index = 12,
            --     callback = "keymaps.previous_chat",
            --     description = "Previous Chat",
            --   },
            -- },
          },
        },
        display = {
          chat = {
            intro_message = "",
            icons = {
              pinned_buffer = " ",
              watched_buffer = " ",
            },
            -- window = { -- atm, using a floating window may cause conflicts with the translation plugin
            --   layout = "float",
            --   border = "rounded",
            --   height = vim.o.lines - 5, -- (tabline, statuline and cmdline height + row)
            --   width = 0.45,
            --   relative = "editor",
            --   col = vim.o.columns, -- right position
            --   row = 1,
            --   opts = { winfixbuf = true },
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
            interaction = "chat",
            description = "Ask the AI via chat",
            opts = {
              alias = "ai_chat",
              is_slash_cmd = true,
              ignore_system_prompt = true,
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function()
                  -- return "```" .. newline .. get_selected_lines(context) .. newline .. "```"
                  return newline
                end,
              },
            },
          },

          ["Explain to me"] = {
            interaction = "chat",
            description = "Explains the code, how it works, and its process",
            opts = {
              modes = { "v" },
              is_slash_cmd = true,
              alias = "explain_to_me",
              stop_context_insertion = true,
              auto_submit = true,
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function(context)
                  local header = "Jelaskan secara singkat dan jelas bagaimana kode ini bekerja. "
                    .. "Sebutkan apa inputnya, proses utamanya, dan outputnya."
                    .. "Jika memungkinkan, berikan contoh sederhana agar lebih mudah dipahami:"
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

          -- Fix, correct, improve the sentence, ToDo, or Wiki entry in either English or Indonesian.
          ["Fix this sentence in properly English"] = {
            interaction = "chat",
            description = "Fix the English sentence properly",
            opts = {
              alias = "correct_sentence_en",
              is_slash_cmd = true,
              auto_submit = true,
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
              },
            },
          },
          ["Fix this wiki sentence"] = {
            interaction = "chat",
            description = "Fix this string notes",
            opts = {
              alias = "correct_wiki_sentence",
              is_slash_cmd = true,
              auto_submit = true,
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
              },
            },
          },
          ["Fix this todo sentence"] = {
            interaction = "chat",
            description = "Fix this todo string",
            opts = {
              alias = "correct_todo_sentence",
              is_slash_cmd = true,
              auto_submit = true,
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
              },
            },
          },

          -- Translate
          ["Translate into indo xclip"] = {
            interaction = "chat",
            description = "Translate these text into bahasa indonesia with xclip",
            opts = {
              alias = "translate_in_bahasa_xclip",
              is_slash_cmd = true,
              auto_submit = true,
            },
            prompts = {
              {
                role = constants.USER_ROLE,
                content = function()
                  local result = vim.system({ "xclip", "-o", "-se", "clip" }, { text = true }):wait()
                  if result.code ~= 0 then
                    ---@diagnostic disable-next-line: undefined-field
                    RUtils.error("Failed to xclip", { title = "Config Keymaps" })
                    return
                  end

                  local header =
                    "Tolong translate kalimat ini ke bahasa indonesia, perbaiki maksud jika kalimat nya kurang baku, tanda baca dan juga jelaskan secara singkat tapi mudah dimengerti:"
                  local body = code_block_delimiter
                    .. "text"
                    .. "\n"
                    .. result.stdout
                    .. newline
                    .. code_block_delimiter

                  return header .. newline .. body .. newline
                end,
              },
            },
          },
          ["Translate into indo"] = {
            interaction = "chat",
            description = "Translate these text into bahasa indonesia",
            opts = {
              alias = "translate_in_bahasa",
              is_slash_cmd = true,
              auto_submit = true,
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
              },
            },
          },
          ["Translate into english"] = {
            interaction = "chat",
            description = "Translate this from xclip",
            opts = {
              alias = "translate_in_en",
              is_slash_cmd = true,
              auto_submit = true,
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
              },
            },
          },

          -- Write a documentation comment
          ["Inline Document"] = {
            interaction = "inline",
            description = "Add documentation for code",
            opts = {
              modes = { "v" },
              alias = "inline_doc",
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
            interaction = "chat",
            description = "Write documentation for code.",
            opts = {
              modes = { "v" },
              alias = "doc",
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
            interaction = "chat",
            description = "Review the provided code snippet.",
            opts = {
              modes = { "v" },
              alias = "review",
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
            interaction = "chat",
            description = "Review code and provide suggestions for improvement.",
            opts = {
              alias = "review_code",
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
            interaction = "inline",
            description = "Refactor the provided code snippet.",
            opts = {
              modes = { "v" },
              alias = "refactor",
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
            interaction = "inline",
            description = "Refactor the provided code snippe, and better side effect",
            opts = {
              modes = { "v" },
              alias = "refactor_side_effect",
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
            interaction = "inline",
            description = "Give betting naming for the provided code snippet",
            opts = {
              modes = { "v" },
              alias = "naming",
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
            interaction = "inline",
            description = "Give betting naming for the provided code snippet",
            opts = {
              modes = { "v" },
              alias = "better_naming",
              auto_submit = true,
              is_slash_cmd = true,
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

        extensions = {
          history = {
            enabled = true,
            opts = {
              auto_generate_title = is_online(),
              keymap = "<Leader>fr",
              auto_save = true,
              expiration_days = 50,
              picker_keymaps = {
                rename = { n = "r", i = "<c-r>" },
                delete = { n = "d", i = "<c-x>" },
              },
              save_chat_keymap = { n = "<nop>", i = "<nop>" },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- Spinner
      local ns_id = vim.api.nvim_create_namespace "codecompanion_spinner"
      local spinner_states = { "", "", "" }
      local spinner_bufnr, spinner_line, spinner_timer, spinner_index = nil, nil, nil, 1

      local function clear_spinner()
        if spinner_bufnr and vim.api.nvim_buf_is_valid(spinner_bufnr) then
          vim.api.nvim_buf_clear_namespace(spinner_bufnr, ns_id, 0, -1)
        end
        spinner_bufnr, spinner_line, spinner_index = nil, nil, 1
        if spinner_timer then
          spinner_timer:stop()
          spinner_timer:close()
          spinner_timer = nil
        end
      end

      local function update_spinner()
        if spinner_bufnr and spinner_line and vim.api.nvim_buf_is_valid(spinner_bufnr) then
          vim.api.nvim_buf_clear_namespace(spinner_bufnr, ns_id, spinner_line, spinner_line + 1)
          vim.api.nvim_buf_set_extmark(spinner_bufnr, ns_id, spinner_line, -1, {
            virt_text = {
              { " Working " .. spinner_states[spinner_index], "Comment" },
            },

            hl_mode = "combine",
          })
          spinner_index = spinner_index % #spinner_states + 1
        end
      end

      RUtils.map.augroup("SpinnerCodeCompanions", {
        event = "User",
        pattern = "CodeCompanionRequestStarted",
        command = function()
          if vim.bo.filetype == "codecompanion" then
            vim.cmd.stopinsert()
          end
          clear_spinner()
          spinner_bufnr = vim.api.nvim_get_current_buf()
          spinner_line = vim.api.nvim_win_get_cursor(0)[1] - 1
          spinner_timer = vim.uv.new_timer()
          if spinner_timer then
            spinner_timer:start(0, 250, vim.schedule_wrap(update_spinner))
          end
        end,
        desc = "Start CodeCompanion spinner on request start",
      }, {
        event = "User",
        pattern = "CodeCompanionRequestFinished",
        command = function()
          vim.defer_fn(function()
            clear_spinner()
            if vim.bo.filetype == "codecompanion" then
              vim.cmd.startinsert()
            end
          end, 50)
        end,
        desc = "Clear spinner and start insert on request finish",
      })
    end,
  },
  -- RENDER-MARKDOWN
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = { "markdown", "codecompanion" },
    opts = { file_types = { "markdown", "codecompanion" } },
  },
  -- NVIM-TREESITTER
  { -- disable fold for codecompanion
    "nvim-treesitter/nvim-treesitter",
    opts = {
      fold = {
        disable = {
          "codecompanion",
        },
      },
    },
  },
}
