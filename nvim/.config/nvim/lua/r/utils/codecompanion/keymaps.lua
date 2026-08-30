local codecompanion = require "codecompanion"
local keymaps = require "codecompanion.interactions.chat.keymaps"

local chat_helpers = require("r.utils.codecompanion.helpers").chat
local state_helpers = require("r.utils.codecompanion.helpers").state
local window_helpers = require("r.utils.codecompanion.helpers").window
local usage_helpers = require("r.utils.codecompanion.helpers").usage
local slash_commands = require "r.utils.codecompanion.slash_commands"

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
  vim.ui.input({
    prompt = "Close this chat anyway? (y/n) ",
  }, function(input)
    if input == "y" then
      keymaps.close.callback(chat_obj)
    end
  end)
end

local function force_close(chat_obj)
  keymaps.close.callback(chat_obj)
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
      modes = { n = "<A-c>" },
      description = "Codecompanion: create new chat",
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
      description = "Codecompanion: hide chats",
      callback = hide_chats,
    },

    regenerate = {
      modes = { n = "<localleader>qr" },
      index = 3,
      callback = "keymaps.regenerate",
      description = "Codecompanion: regenerate the last response",
    },

    close = {
      modes = { n = { "<Leader>bK", i = "<nope>" } },
      description = "Codecompanion: kill or close chat buffer",
      callback = force_close,
    },
    clear = {
      modes = { n = "dM" },
      description = "Codecompanion: clear chat buffer",
    },

    -- Stop the request
    stop = {
      modes = { n = "q" },
      description = "Codecompanion: stop request",
    },
    yank_code = {
      modes = { n = "Y", i = "<Nope>" },
      description = "Codecompanion: yank code",
    },

    -- Message actions
    send = {
      modes = { n = "<C-o>", i = "<C-o>" },
      description = "Codecompanion: send message",
      callback = send_message,
    },

    fold_code = {
      modes = { n = "zc" },
      description = "Codecompanion: fold code",
    },

    -- Navigations
    next_chat = {
      modes = { n = "<C-n>" },
      description = "Codecompanion: next chat",
    },
    previous_chat = {
      modes = { n = "<C-p>" },
      description = "Codecompanion: prev chat",
    },

    previous_header = {
      modes = { n = "<A-p>" },
      description = "Codecompanion: prev header",
    },
    next_header = {
      modes = { n = "<A-n>" },
      description = "Codecompanion: next header",
    },

    goto_file_under_cursor = {
      modes = { n = { "gf", "<Leader>oe" } },
      description = "Codecompanion: go to file under cursor",
    },

    -- Chat tools
    action_palette = {
      modes = { n = "<Localleader>qf" },
      description = "Codecompanion: action palette",
      callback = function()
        vim.defer_fn(function()
          vim.cmd.CodeCompanionActions()
        end, 1)
      end,
    },

    change_adapter = {
      modes = { n = "<Localleader>qC" },
      description = "Codecompanion: change adapter",
    },

    debug = {
      modes = { n = "<F5>" },
      description = "Codecompanion: debug",
      callback = open_debug,
    },

    clear_approvals = {
      modes = { n = "<Localleader>qX" },
      description = "Codecompanion: clear approvals",
    },

    -- Chat modes
    _btw = {
      modes = { n = "<Localleader>qW" },
      description = "Codecompanion: _bw",
    },

    yolo_mode = {
      modes = { n = "<Localleader>qY" },
      description = "Codecompanion: yolo mode",
    },

    -- Buffer sync
    sync_all = {
      modes = { n = "<Localleader>qp" },
      description = "Codecompanion: buffer sync all",
    },
    sync_diff = {
      modes = { n = "<Localleader>qw" },
      description = "Codecompanion: buffer sync diff",
    },

    -- Helps
    options = {
      modes = { n = { "g?", "?" } },
      callback = "keymaps.options",
      description = "Codecompanion: show help",
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
  ---@diagnostic disable-next-line: undefined-field
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

local function select_custom_prompt_and_commands()
  local fzf_lua = require "fzf-lua"
  local git_ft_stuff = { "fugitive", "NeogitCommitMessage", "gitcommit" }
  local prompt_cmds = {
    -- +-----------------------------------------------------------------------------+
    -- |                                  Ai STUFF                                   |
    -- +-----------------------------------------------------------------------------+

    -- ├─────────────────────────────┤ EXPLAIN STUFF ├──────────────────────────┤
    ["Code - explain to me"] = {
      cmd = function()
        slash_commands.explain_selection "explain_code"
      end,
      mode = "V",
      ft = {},
    },

    -- ├─────────────┤ FIX, CORRECT, IMPROVE THE EN OR IDN SENTENCE. ├──────────┤
    ["Correct - eng sentence"] = { cmd = "CodeCompanion /correct_sentence_en", ft = {} },
    ["Correct - todo sentence"] = { cmd = "CodeCompanion /correct_todo_sentence", ft = {} },
    ["Correct - wiki sentence"] = { cmd = "CodeCompanion /correct_wiki_sentence", ft = {} },

    -- ├──────────────────────────────────┤ GIT ├───────────────────────────────┤
    ["_Git - commit"] = {
      cmd = function()
        chat_helpers.run_slash_command "conventional_commit"
      end,
      mode = "n",
      ft = git_ft_stuff,
    },
    ["_Git - fix or rewrote commit"] = { cmd = "CodeCompanion /commit", ft = {} },

    -- ├───────────────────────────────┤ WRITE DOC ├────────────────────────────┤
    ["Doc - write for inline doc codes"] = { cmd = "CodeCompanion /inline_doc", ft = {} },
    ["Doc - write for func docs"] = { cmd = "CodeCompanion /doc", ft = {} },

    -- +-----------------------------------------------------------------------------+
    -- |                                  TRANSLATE                                  |
    -- +-----------------------------------------------------------------------------+
    ["Translator - eng id"] = {
      cmd = function()
        slash_commands.explain_selection "translate_this_line_to_ind"
      end,
      mode = "V",
      ft = {},
    },

    -- +-----------------------------------------------------------------------------+
    -- |                                    SHOW                                     |
    -- +-----------------------------------------------------------------------------+
    ["ChatBuffer - info adapter"] = {
      cmd = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local chat_obj = codecompanion.buf_get_chat(bufnr)
        show_adapter_info(chat_obj)
      end,
      mode = "n",
      ft = { "codecompanion" },
    },

    ["ChatBuffer - info system role"] = {
      cmd = function()
        vim.cmd.stopinsert()
        local system_role = state_helpers.get_current_system_role_prompt()
        if not system_role or system_role == "" then
          return
        end
        ---@diagnostic disable-next-line: undefined-field
        RUtils.info(system_role)
      end,
      mode = "n",
      ft = { "codecompanion" },
    },
    ["ChatBuffer - zoom"] = {
      cmd = function()
        toggle_chat_zoom()
      end,
      mode = "n",
      ft = { "codecompanion" },
    },

    -- +-----------------------------------------------------------------------------+
    -- |                                    NOTE                                     |
    -- +-----------------------------------------------------------------------------+
    ["Note - fix note global"] = { cmd = "CodeCompanion /writer_and_reformat_note_id" },
    ["Note - fix note Org"] = { cmd = "CodeCompanion /writer_and_reformat_note_id_org" },

    -- +-----------------------------------------------------------------------------+
    -- |                                   CODING                                    |
    -- +-----------------------------------------------------------------------------+
    -- Programming stuff
    ["Refactor - Inline code"] = { cmd = "CodeCompanion /refactor", ft = {} },
    ["Refactor - Avoid side effect from code"] = { cmd = "CodeCompanion /refactor_side_effect", ft = {} },
    ["Refactor - Rewrite naming variable"] = { cmd = "CodeCompanion /naming", ft = {} },
    ["Refactor - Seggest better naming variable"] = { cmd = "CodeCompanion /better_naming", ft = {} },

    -- +-----------------------------------------------------------------------------+
    -- |                                COMMAND OPEN                                 |
    -- +-----------------------------------------------------------------------------+
    ["Chat - ask ai"] = {
      cmd = function()
        window_helpers.focus_or_toggle_chat { startinsert = false }
      end,
      mode = "n",
      ft = {},
    },
    ["Chat - new"] = { cmd = "CodeCompanionChat", mode = "n", ft = {} },
    ["Chat - history"] = { cmd = "CodeCompanionHistory", mode = "n", ft = {} },
    ["Chat - actions"] = { cmd = "CodeCompanionActions", mode = "n", ft = {} },
    ["Chat - edit prompts"] = {
      cmd = function()
        local FzfLua = require "fzf-lua"
        return FzfLua.files {
          cwd = RUtils.config.path.prompt_dir,
          no_header = false,
          no_header_i = true, -- hide interactive header?
          fzf_opts = { ["--header"] = [[^x:delete  ^r:rename]] },
          cmd = "fd -d 1 -e md --exec stat --format '%Z %n' {} | sort -nr | cut -d' ' -f2- | sed 's/.json$//' | sed 's/\\.\\///'",
          winopts = { title = "Edit Prompts", preview = { hidden = false } },
        }
      end,
      mode = "n",
      ft = {},
    },
    ["Chat - CodeCompanionListChat"] = {
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
      mode = "n",
      ft = {},
    },
  }

  local results_formats = function()
    local width_cmd = 1

    for idx, _ in pairs(prompt_cmds) do
      local str_x = vim.split(idx, " ")
      if width_cmd < #str_x[1] then
        width_cmd = #str_x[1]
      end
    end

    local results = {}
    local mode = vim.api.nvim_get_mode().mode

    for idx, x in pairs(prompt_cmds) do
      if x.ft and #x.ft > 0 and vim.tbl_contains(x.ft, vim.bo.filetype) then
        if x.mode and x.mode == mode then
          local str_x = vim.split(idx, "-")
          local str_x_hl = fzf_lua.utils.ansi_from_hl("GitSignsAdd", str_x[1])
          results[#results + 1] = string.format("%-" .. (width_cmd + 25) .. "s - %s", str_x_hl, str_x[2])
        end
        goto continue
      end

      -- An empty `x.ft` would be included in the results,
      -- so we need to ensure length `x.ft` is `0`.
      if x.ft and #x.ft > 0 then
        goto continue
      end

      local str_x = vim.split(idx, "-")
      local str_x_hl = fzf_lua.utils.ansi_from_hl("GitSignsAdd", str_x[1])
      if x.mode and x.mode == mode then
        results[#results + 1] = string.format("%-" .. (width_cmd + 25) .. "s - %s", str_x_hl, str_x[2])
      end

      ::continue::
    end

    table.sort(results)

    return results
  end

  local opts = RUtils.fzflua.open_center_small_wide {
    winopts = {
      title = RUtils.fzflua.format_title("Select Prompt Ai [CodeCompanion]", RUtils.config.icons.misc.ai),
      height = 0.4,
      width = 0.5,
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
        if not prompt then
          ---@diagnostic disable-next-line: undefined-field
          RUtils.error(string.format("Prompt indexing failed for build_idx_cmd: %s", build_idx_cmd))
          return
        end

        if type(prompt.cmd) == "string" then
          vim.cmd(prompt.cmd)
          return
        end

        if type(prompt.cmd) == "function" then
          prompt.cmd()
          return
        end
      end,
    },
  }

  local results = results_formats()
  local Fzflua = RUtils.fzflua.setup_fzflua()
  Fzflua.fzf_exec(results, opts)
end

local function setup_codecompanion_filetype_mappings(e)
  local bufnr = e.buf

  RUtils.map.nnoremap(
    "<Localleader>qP",
    insert_last_user_prompt,
    { desc = "Codecompanion: insert last user prompt", buf = bufnr },
    true
  )

  RUtils.map.nnoremap("<Leader>mm", toggle_chat_zoom, { desc = "Codecompanion: toggle zoom", buf = bufnr }, true)

  RUtils.map.nnoremap(
    "<CR>",
    select_custom_prompt_and_commands,
    { desc = "Codecompanion: bulk codecompanion cmds", buf = bufnr },
    true
  )
end

---@param group_name string -- The name of the autogroup to which mappings will be added
local function setup_filetype_mappings(group_name)
  RUtils.map.augroup(group_name, {
    event = "FileType",
    pattern = { "codecompanion" },
    command = function(e)
      setup_codecompanion_filetype_mappings(e)
    end,
  })
end

local function show_ai_usage()
  vim.api.nvim_echo({ { "Retrieving rate limits..." } }, false, {})
  usage_helpers.run(nil, function(out)
    vim.schedule(function()
      if out == "" then
        vim.api.nvim_echo({ { "" } }, false, {})
        vim.notify("ai_session_usage: no output", vim.log.levels.WARN)
      else
        vim.api.nvim_echo({ { out } }, false, {})
      end
    end)
  end)
end

local function paste_selection_to_chat()
  codecompanion.add()
  -- if vim.bo.filetype ~= "codecompanion" then
  --   window_helpers.try_focus_chat_float()
  --   vim.api.nvim_feedkeys(vim.keycode "<Esc>", "n", false)
  -- end
end

-- CodeCompanion global mappings
local function setup_global_mappings()
  -- AI rate limits
  --stylua: ignore
  RUtils.map.nnoremap("<Leader>ai", show_ai_usage, { desc = "Codecompanion: show AI usage (rate limits)", })

  --stylua: ignore
  RUtils.map.nnoremap("<Leader>ar", function() vim.api.nvim_input ":CodeCompanion " end, { desc = "Codecompanion: cmdline :CodeCompanion" })
  --stylua: ignore
  RUtils.map.xnoremap("<Leader>ar", function() vim.api.nvim_input ":CodeCompanion " end, { desc = "Codecompanion: cmdline :CodeCompanion" })

  --stylua: ignore
  RUtils.map.nnoremap("<Leader>af", select_custom_prompt_and_commands, { desc = "Codecompanion: bulk codecompanion cmds" })
  --stylua: ignore
  RUtils.map.xnoremap( "<Leader>af", select_custom_prompt_and_commands, { desc = "Codecompanion: bulk codecompanion cmds (visual)" })

  -- Selection and context mappings
  --stylua: ignore
  RUtils.map.nnoremap("<Leader>ac", function() chat_helpers.add_context { vim.api.nvim_buf_get_name(0) } end, { desc = "Codecompanion: add current file" })
  --stylua: ignore
  RUtils.map.xnoremap("<Leader>ac", paste_selection_to_chat, { desc = "Codecompanion: paste selection to chat" })
end

function M.setup(group)
  setup_filetype_mappings(group)
  setup_global_mappings()
end

return M
