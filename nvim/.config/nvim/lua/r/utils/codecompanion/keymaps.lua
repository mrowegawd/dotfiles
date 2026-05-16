local codecompanion = require "codecompanion"
local keymaps = require "codecompanion.interactions.chat.keymaps"

local chat_helpers = require("r.utils.codecompanion.helpers").chat
local state_helpers = require("r.utils.codecompanion.helpers").state
local window_helpers = require("r.utils.codecompanion.helpers").window

local M = {}

-- Chat window callbacks
local function hide_chats()
  codecompanion.toggle()
  vim.defer_fn(function()
    vim.cmd.stopinsert()
  end, 1)
end

local function send_message(chat_obj)
  vim.cmd.stopinsert()
  keymaps.send.callback(chat_obj)
end

local function close(chat_obj)
  -- TODO: buatkan input yes or no, untuk close the chat window
  vim.ui.input({
    prompt = "Close this chat anyway? (y/n) ",
  }, function(input)
    if input == "y" then
      keymaps.close.callback(chat_obj)
    end
  end)
end

local function open_debug(chat_obj)
  keymaps.debug.callback(chat_obj)
  vim.defer_fn(function()
    vim.cmd.stopinsert()
    local win_id = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win_id)
    if win_config.relative == "editor" then
      win_config.col = 1
      vim.api.nvim_win_set_config(win_id, win_config)
    end
  end, 1)
end

function M.chat_keymaps()
  return {
    -- Chat lifecycle
    create_chat = {
      modes = { n = "<A-c>", i = "<A-c>" },
      description = "Create new chat",
      callback = function()
        vim.cmd.CodeCompanionChat()
        -- Hack to make completions work immediately in a new chat
        vim.cmd.stopinsert()
        vim.defer_fn(function()
          vim.cmd.startinsert { bang = true }
        end, 100)
      end,
    },

    hide_chats = {
      modes = { n = "<Leader>bk" },
      description = "Hide chats",
      callback = hide_chats,
    },

    close = {
      modes = { n = { "<Leader>bK", "<C-x>" } },
      callback = close,
    },
    clear = { modes = { n = "<A-w>", i = "<A-w>" } },

    -- Stop the request
    stop = { modes = { n = "q" } },
    yank_code = { modes = { n = "<C-y>", i = "<C-y>" } },

    -- Message actions
    send = {
      modes = { n = "<C-o>", i = "<C-o>" },
      description = "Send message",
      callback = send_message,
    },

    fold_code = { modes = { n = "zc" } },

    -- Navigations
    next_chat = { modes = { n = "<A-n>", i = "<A-n>" } },
    previous_chat = { modes = { n = "<A-p>", i = "<A-p>" } },

    previous_header = { modes = { n = "<C-p>", i = "<C-p>" } },
    next_header = { modes = { n = "<C-n>", i = "<C-n>" } },

    goto_file_under_cursor = { modes = { n = { "gf", "<Leader>oe" } } },

    -- Chat tools
    action_palette = {
      modes = { n = "<Localleader>qf" },
      description = "Action palette",
      callback = function()
        vim.defer_fn(function()
          vim.cmd.CodeCompanionActions()
        end, 1)
      end,
    },

    change_adapter = { modes = { n = "<Localleader>qC" } },

    debug = {
      modes = { n = "<Localleader>qD" },
      callback = open_debug,
    },

    clear_approvals = { modes = { n = "<Leader>ra" } },

    -- Chat modes
    _btw = {
      modes = { n = "<Localleader>qW" },
    },

    yolo_mode = { modes = { n = "<Localleader>qY" } },

    -- Buffer sync
    buffer_sync_all = { modes = { n = "<Localleader>qp" } },
    buffer_sync_diff = { modes = { n = "<Localleader>qw" } },

    -- Helps
    options = {
      modes = { n = { "g?", "?" } },
      callback = "keymaps.options",
      description = "Options",
      hide = true,
    },
  }
end

-- Shared interactions keymaps
function M.shared_keymaps()
  return {
    view_diff = { modes = { n = "ds" } },
    always_accept = { modes = { n = "aa" } },
    accept_change = { modes = { n = "dp" } },
    reject_change = { modes = { n = "de" } },
    next_hunk = { modes = { n = "]h" } },
    previous_hunk = { modes = { n = "[h" } },
    cancel = { modes = { n = "ct" } },
  }
end

-- CodeCompanion chat filetype-local mapping callbacks
local function show_adapter_info(chat_obj)
  local adapter = chat_obj.adapter
  local model = state_helpers.get_adapter_model(adapter)
  local params = adapter.type == "acp" and adapter.defaults or chat_obj.settings
  local adapter_info = {
    { "type", adapter.type },
    { "name", adapter.name },
    { "model", model },
    { "model_params", params },
  }
  local lines = vim
    .iter(adapter_info)
    :map(function(item)
      return string.format("%s = %s", item[1], vim.inspect(item[2]))
    end)
    :totable()
  RUtils.info(string.format("Adapter Info\n%s", table.concat(lines, "\n")))
end

local function insert_last_user_prompt()
  vim.cmd.stopinsert()
  local last = state_helpers.get_last_user_prompt()
  if not last or last == "" then
    return
  end
  vim.api.nvim_put(vim.split(last, "\n", { plain = true }), "c", true, true)
  vim.defer_fn(function()
    vim.cmd.startinsert { bang = true }
  end, 1)
end

local function toggle_chat_zoom()
  vim.cmd.stopinsert()
  window_helpers.toggle_cc_zoom()
end

local function setup_codecompanion_filetype_mappings(e)
  local bufnr = e.buf

  RUtils.map.nnoremap("<Localleader>qsI", function()
    local chat_obj = codecompanion.buf_get_chat(bufnr)
    show_adapter_info(chat_obj)
  end, { desc = "Show adapter info", buf = bufnr }, true)

  RUtils.map.nnoremap("<Localleader>qsS", function()
    vim.cmd.stopinsert()
    local system_role = state_helpers.get_current_system_role_prompt()
    if not system_role or system_role == "" then
      return
    end
    RUtils.info(system_role)
    vim.schedule(function()
      vim.cmd.normal { args = { "g<" }, bang = true }
    end)
  end, { desc = "Show system role prompt in message window", buf = bufnr }, true)

  RUtils.map.nnoremap(
    "<Localleader>qP",
    insert_last_user_prompt,
    { desc = "Insert last user prompt", buf = bufnr },
    true
  )

  RUtils.map.nnoremap("<Leader>mm", toggle_chat_zoom, { desc = "toggle zoom", buf = bufnr }, true)
end

local function setup_filetype_mappings(group_name)
  RUtils.map.augroup(group_name, {
    event = "FileType",
    pattern = { "codecompanion" },
    command = function(e)
      setup_codecompanion_filetype_mappings(e)
    end,
  })
end

local function select_custom_prompt_and_commands()
  local fzf_lua = require "fzf-lua"
  local git_ft_stuff = { "fugitive" }
  local prompt_cmds = {
    -- Ask a question
    ["Ask - ai"] = { cmd = "CodeCompanion /ai_chat", ft = {} },

    -- Explain stuff
    ["Code - Explain to me?"] = { cmd = "CodeCompanion /explain_to_me", ft = {} },

    -- Translate
    ["Translator - indonesia english"] = { cmd = "CodeCompanion /translator_role", ft = {} },
    ["Translator - japan english"] = { cmd = "CodeCompanion /translate_in_en", ft = {} },

    -- Fix, correct, improve the EN or IDN sentence.
    ["Fix words - ENG sentence"] = { cmd = "CodeCompanion /correct_sentence_en", ft = {} },
    ["Fix words - TODO sentence"] = { cmd = "CodeCompanion /correct_todo_sentence", ft = {} },
    ["Fix words - WIKI sentence"] = { cmd = "CodeCompanion /correct_wiki_sentence", ft = {} },

    -- Git stuff
    ["Git - commit"] = { cmd = "CodeCompanion /git_role", ft = git_ft_stuff },
    -- git_commit_our = { cmd = "CodeCompanion /write_commit", ft = {} },
    ["Git - fix or rewrote commit"] = { cmd = "CodeCompanion /commit", ft = {} },

    -- Note
    ["Note - Perbaiki note, structure, rapikan"] = { cmd = "CodeCompanion /writer_and_reformat_note_id" },

    -- Write doc
    ["Doc - write for inline doc codes"] = { cmd = "CodeCompanion /inline_doc", ft = {} },
    ["Doc - write for func docs"] = { cmd = "CodeCompanion /doc", ft = {} },

    -- Programming stuff
    ["Code - Review code"] = { cmd = "CodeCompanion /review", ft = {} },
    ["Refactor - Inline code"] = { cmd = "CodeCompanion /refactor", ft = {} },
    ["Refactor - Avoid side effect from code"] = { cmd = "CodeCompanion /refactor_side_effect", ft = {} },
    ["Refactor - Rewrite naming variable"] = { cmd = "CodeCompanion /naming", ft = {} },
    ["Refactor - Seggest better naming variable"] = { cmd = "CodeCompanion /better_naming", ft = {} },

    -- Open or CodeCompanion commands stuff
    ["Open - New CodeCompanionChat"] = { cmd = "CodeCompanionChat", ft = {} },
    ["Open - CodeCompanionHistory"] = { cmd = "CodeCompanionHistory", ft = {} },
    ["Open - CodeCompanionActions"] = { cmd = "CodeCompanionActions", ft = {} },
    ["Open - CodeCompanionCmd"] = { cmd = "CodeCompanionCmd", ft = {} },
    ["Open - Select edit prompts"] = {
      cmd = function()
        local FzfLua = require "fzf-lua"
        return FzfLua.files {
          cwd = RUtils.config.path.prompt_dir,
          no_header = false,
          no_header_i = true, -- hide interactive header?
          fzf_opts = { ["--header"] = [[^x:delete  ^r:rename]] },
          cmd = "fd -d 1 -e md --exec stat --format '%Z %n' {} | sort -nr | cut -d' ' -f2- | sed 's/.json$//' | sed 's/\\.\\///'",
          winopts = { title = "Edit Prompts", preview = { hidden = true } },
        }
      end,
      ft = {},
    },
    ["Open - CodeCompanionListChat"] = {
      cmd = function()
        local function get_items()
          local registry = require "codecompanion.interactions.shared.registry"
          local items = {}
          for _, entry in ipairs(registry.list()) do
            table.insert(items, {
              name = entry.name,
              interaction = entry.interaction,
              description = entry.description,
              bufnr = entry.bufnr,
              callback = entry.open,
            })
          end
          return items
        end

        local items = get_items()
        if #items == 0 then
          vim.cmd.CodeCompanionActions()
          return
        end

        local context = require("codecompanion.utils.context").get(vim.api.nvim_get_current_buf())
        return require("codecompanion.action_palette").launch_picker(items, {
          columns = { "name", "description" },
          context = context,
          title = "List actions",
        })
      end,
      ft = {},
    },
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
      title = RUtils.fzflua.format_title("Select Custom Prompt Ai [CodeCompanion]", RUtils.config.icons.misc.ai),
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

          if type(prompt.cmd) == "string" then
            vim.cmd(prompt.cmd)
            return
          end

          if type(prompt.cmd) == "function" then
            prompt.cmd()
            return
          end
        end

        ---@diagnostic disable-next-line: undefined-field
        RUtils.info "Selection doesn't match!"
      end,
    },
  }

  local results = results_formats()
  require("fzf-lua").fzf_exec(results, opts)
end

local function paste_selection_to_chat()
  codecompanion.add()
  if vim.bo.filetype ~= "codecompanion" then
    window_helpers.try_focus_chat_float()
    vim.api.nvim_feedkeys(vim.keycode "<Esc>", "n", false)
  end
end

-- CodeCompanion global mappings
local function setup_global_mappings()
  RUtils.map.nnoremap("<Localleader>af", function()
    vim.cmd.CodeCompanionActions()
  end, { desc = "Codecompanion: open CodeCompanionActions" })

  RUtils.map.nnoremap("<Localleader>ar", function()
    vim.api.nvim_input ":CodeCompanion "
  end, { desc = "Codecompanion: run :CodeCompanion command" })
  RUtils.map.xnoremap("<Localleader>ar", function()
    vim.api.nvim_input ":CodeCompanion "
  end, { desc = "Codecompanion: run :CodeCompanion command (visual)" })

  RUtils.map.nnoremap("<Localleader>aF", function()
    local function select_file_codecompanion_history()
      local codecompanion_cwd = vim.fn.stdpath "data" .. "/codecompanion"
      return require("fzf-lua").files {
        prompt = RUtils.fzflua.padding_prompt(),
        winopts = { title = RUtils.fzflua.format_title("Codecompanion Saved", "󰈙"), fullscreen = true },
        cwd = codecompanion_cwd,
        fzf_opts = { ["--header"] = [[^r:grugfar  ^g:grep  ^x:delete  a-c:yank  ^q:ignore  ^z:hidden]] },
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
            vim.schedule(select_file_codecompanion_history)
          end,
        },
      }
    end
    select_file_codecompanion_history()
  end, { desc = "Codecompanion: select file saved previous chats" })

  RUtils.map.nnoremap(
    "<Localleader>aa",
    select_custom_prompt_and_commands,
    { desc = "Codecompanion: select custom prompt and commands" }
  )
  RUtils.map.xnoremap(
    "<Localleader>aa",
    select_custom_prompt_and_commands,
    { desc = "Codecompanion: select custom prompt and commands (visual)" }
  )

  RUtils.map.nnoremap("<Localleader>ab", vim.cmd.CodeCompanionHistory, { desc = "Codecompanion: history" })

  -- Selection and context mappings
  RUtils.map.nnoremap("<Localleader>ac", function()
    chat_helpers.add_context { vim.api.nvim_buf_get_name(0) }
  end, { desc = "Codecompanion: add current file" })

  RUtils.map.vnoremap("<Localleader>ap", paste_selection_to_chat, { desc = "Codecompanion: paste selection to chat" })
end

function M.setup(group)
  setup_filetype_mappings(group)
  setup_global_mappings()
end

return M
