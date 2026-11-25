local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local UtilKey = lazy "utils.map"
local UtilGit = lazy "utils.git"

local codecompanion = lazy "codecompanion"
local code_review = lazy "codecompanion.interactions.code_review"
local keymaps = lazy "codecompanion.interactions.chat.keymaps"

local chat_helpers = lazy("utils.codecompanion.helpers").chat
local state_helpers = lazy("utils.codecompanion.helpers").state
local repo_helpers = lazy("utils.codecompanion.helpers").repo
local window_helpers = lazy("utils.codecompanion.helpers").window
local open_chats = lazy "utils.codecompanion.pickers.open_chats"
local usage_helpers = lazy("utils.codecompanion.helpers").usage
local bulk_commands = lazy "utils.codecompanion.pickers.bulk_commands"
local worktrees = lazy "utils.codecompanion.pickers.worktrees"

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

local function open_options()
  keymaps.options.callback()
  vim.defer_fn(function()
    vim.cmd.stopinsert()
    vim.api.nvim_win_resize(0, math.min(160, vim.o.columns), -1)
  end, 1)
end

local function open_debug(chat_obj)
  keymaps.debug.callback(chat_obj)
  vim.defer_fn(function()
    vim.cmd.stopinsert()
    local win_id = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win_id)
    if win_config.relative == "editor" then
      win_config.width = math.floor(vim.o.columns * 0.535)
      win_config.height = vim.o.lines - 4
      win_config.row = 1
      win_config.col = math.floor((vim.o.columns - win_config.width) / 2)
      vim.api.nvim_win_set_config(win_id, win_config)
    end
  end, 1)
end

local function create_chat(cwd)
  if cwd then
    local args = {
      cwd = cwd,
      buffer_context = lazy("codecompanion.utils.context").get(),
    }
    args.callbacks = lazy("codecompanion.interactions.shared.rules.helpers").add_callbacks(args)
    lazy("codecompanion.interactions.chat").new(args)
  else
    vim.cmd.CodeCompanionChat()
  end
  -- Hack to make completions work immediately in a new chat
  vim.cmd.stopinsert()
  vim.defer_fn(function()
    vim.cmd.startinsert { bang = true }
  end, 100)
end

local function create_chat_in_directory(chat_obj)
  local cwd = chat_obj.opts.cwd or vim.uv.cwd()
  local root = UtilGit.git_root(cwd)
  vim.ui.input({
    prompt = "Chat directory: ",
    default = (root and vim.fs.dirname(root) or cwd) .. "/",
    completion = "dir",
  }, function(dir)
    if not dir or dir == "" then
      return
    end

    dir = vim.fs.normalize(dir)
    local stat = vim.uv.fs_stat(dir)
    if not stat or stat.type ~= "directory" then
      return vim.notify("Not a directory: " .. dir, vim.log.levels.ERROR)
    end

    chat_obj.ui:hide()
    create_chat(UtilGit.git_root(dir) or dir)
  end)
end

-- Chat window keymaps
function M.chat_keymaps()
  return {
    -- Chat lifecycle
    create_chat = {
      modes = { n = "<A-c>", i = "<A-c>" },
      description = "Codecompanion: create new chat",
      callback = function()
        create_chat()
      end,
    },
    create_chat_in_directory = {
      modes = { n = "<A-e>", i = "<A-e>" },
      description = "Codecompanion: create new chat in directory",
      callback = create_chat_in_directory,
    },
    hide_chats = {
      modes = { n = "<Leader>bk" },
      description = "Codecompanion: hide chats",
      callback = hide_chats,
    },
    close = { modes = { n = "<Leader>bK" } },
    clear = { modes = { n = "dM" } },

    -- Message actions
    send = {
      modes = { n = "<C-o>", i = "<C-o>" },
      description = "Codecompanion: send message",
      callback = send_message,
    },
    stop = { modes = { n = "q" } },
    yank_code = { modes = { n = "<C-x>Y", i = "<Nope>" } },
    regenerate = {
      modes = { n = { "<C-x>eR" } },
      index = 3,
      callback = "keymaps.regenerate",
      description = "Codecompanion: regenerate the last response",
    },
    -- Navigations
    next_chat = { modes = { n = "<C-n>" } },
    previous_chat = { modes = { n = "<C-p>" } },
    previous_header = { modes = { n = "<A-p>" } },
    next_header = { modes = { n = "<A-n>" } },
    fold_code = { modes = { n = "zc" } },
    goto_file_under_cursor = { modes = { n = { "gf", "<Leader>oe" } } },

    -- Chat tools
    action_palette = {
      modes = { n = "<CR>" },
      description = "Codecompanion: action palette",
      callback = function()
        vim.cmd.CodeCompanionActions()
      end,
    },
    options = {
      modes = { n = { "g?", "<Leader>?" } },
      callback = open_options,
    },
    change_adapter = { modes = { n = "<C-x>sc" }, description = "Codecompanion: change adapter" },
    debug = { modes = { n = "<C-x>od" }, description = "Codecompanion: debug", callback = open_debug },

    -- Chat modes
    _btw = { modes = { n = "<C-x>sW" }, description = "Codecompanion: _bw" },

    -- Buffer sync
    sync_all = {
      modes = { n = "<C-x>bs" },
      description = "Codecompanion: buffer sync all",
    },
    sync_diff = {
      modes = { n = "<C-x>bd" },
      description = "Codecompanion: buffer sync diff",
    },

    clear_approvals = { modes = { n = "<C-x>Fa" }, description = "Codecompanion: clear approvals" },
    yolo_mode = { modes = { n = "<C-x>sY" }, description = "Codecompanion: yolo mode" },
  }
end

-- Shared interactions keymaps
function M.shared_keymaps()
  return {
    accept_change = { modes = { n = "dp" } },
    always_accept = { modes = { n = "aa" } },
    cancel = { modes = { n = "ct" } },
    next_hunk = { modes = { n = "]h" } },
    previous_hunk = { modes = { n = "[h" } },
    reject_change = { modes = { n = "de" } },
    view_diff = { modes = { n = "ds" } },
  }
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

local function yank_session_id()
  local chat = codecompanion.buf_get_chat(vim.api.nvim_get_current_buf())
  local session_id = chat.acp_connection and chat.acp_connection.session_id
  if not session_id then
    vim.notify("No ACP session ID available", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", session_id)
  vim.fn.setreg("*", session_id)
  vim.notify("Yanked session ID: " .. session_id, vim.log.levels.INFO)
end

local function open_file_link()
  local target = vim.api.nvim_get_current_line():match "%b[]%((.-)%)"
  if not target then
    return
  end
  local file, line = target:match "^(.-):(%d+)$"
  UtilKey.split_open(file or target)
  if line then
    vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
    vim.cmd.normal "zz"
  end
end

-- CodeCompanion chat filetype-local mappings
local function setup_codecompanion_filetype_mappings(e)
  local bufnr = e.buf

  UtilKey.nnoremap("<C-x>il", insert_last_user_prompt, {
    desc = "Codecompanion: insert last user prompt",
    buf = bufnr,
    remap = true,
    force = true,
  })

  UtilKey.nnoremap("<Leader>mm", toggle_chat_zoom, {
    desc = "Codecompanion: toggle zoom",
    buf = bufnr,
    remap = true,
    force = true,
  })

  UtilKey.nnoremap("<Leader>ys", yank_session_id, {
    desc = "Codecompanion: yank session id",
    buf = bufnr,
    remap = true,
    force = true,
  })

  UtilKey.nnoremap("<Leader>ov", open_file_link, {
    desc = "Codecompanion: yank session id",
    buf = bufnr,
    remap = true,
    force = true,
  })
end

---@param group_name string
local function setup_filetype_mappings(group_name)
  local whichkey = lazy "which-key"

  UtilKey.augroup(group_name, {
    event = "FileType",
    pattern = { "codecompanion" },
    command = function(e)
      setup_codecompanion_filetype_mappings(e)

      whichkey.add {
        { "<C-x>s", group = "set", buffer = e.buf },
        { "<C-x>e", group = "exec", buffer = e.buf },
        { "<C-x>i", group = "insert", buffer = e.buf },
        { "<C-x>f", group = "find", buffer = e.buf },
        { "<C-x>b", group = "buffer", buffer = e.buf },
      }
    end,
  })
end

local function paste_selection_to_chat()
  codecompanion.add()
  if vim.bo.filetype ~= "codecompanion" then
    window_helpers.try_focus_chat_float()
    vim.api.nvim_feedkeys(vim.keycode "<Esc>", "n", false)
  end
end

---@param range table
local function add_review_comment(range)
  if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
    Log.warn "Review comments require a regular file buffer"
    return
  end
  vim.cmd.CodeCompanionCodeReview { args = { "Comment" }, range = range }
end

local function explore_review_comments()
  local comments = code_review.pending()
  if #comments == 0 then
    Log.warn "No pending CodeCompanion review comments"
    return
  end

  local cwd = vim.uv.cwd() or vim.fn.getcwd()
  local root = UtilGit.git_root(cwd) or vim.fs.normalize(cwd)
  local items = vim
    .iter(comments)
    :map(function(comment)
      return {
        filename = vim.startswith(comment.path, "/") and comment.path or vim.fs.joinpath(root, comment.path),
        lnum = comment.start_line,
        end_lnum = comment.end_line,
        text = comment.comment:gsub("%s+", " "),
      }
    end)
    :totable()
  vim.fn.setqflist({}, " ", {
    title = "CodeCompanion Review Comments",
    items = items,
  })
  vim.cmd.copen()
end

local function send_review_comments()
  if #code_review.pending() == 0 then
    Log.warn "No pending CodeCompanion review comments"
    return
  end

  local chat = codecompanion.last_chat()
  if not chat then
    Log.warn "No CodeCompanion chat available"
    return
  end

  chat_helpers.submit_user_message(chat, "Please address #{code_review}")
  window_helpers.focus_or_toggle_chat { startinsert = false }
end

local function show_ai_usage()
  vim.api.nvim_echo({ { "Retrieving rate limits..." } }, false, {})
  usage_helpers.run(nil, function(out)
    vim.schedule(function()
      if out == "" then
        vim.api.nvim_echo({ { "" } }, false, {})
        Log.warn "ai_session_usage: no output"
      else
        vim.api.nvim_echo({ { out } }, false, {})
      end
    end)
  end)
end

local function edit_repo_rules()
  local git_root = repo_helpers.git_root_or_notify()
  if not git_root then
    return
  end

  local file = repo_helpers.git_root_file("AGENTS.md", git_root) or repo_helpers.git_root_file("CLAUDE.md", git_root)
  if not file then
    Log.warn "No AGENTS.md or CLAUDE.md found at the repository root"
    return
  end

  UtilKey.split_open(file)
end

-- CodeCompanion global mappings
local function setup_global_mappings()
  -- AI rate limits
  --stylua: ignore
  UtilKey.nnoremap("<Leader>aoi", show_ai_usage, { desc = "Codecompanion: show AI usage (rate limits)" })
  --stylua: ignore
  UtilKey.nnoremap("<Leader>aa", window_helpers.focus_or_toggle_chat, { desc = "Codecompanion: toggle go to" })
  --stylua: ignore
  UtilKey.noremap({ "n", "x" }, "<Leader>ai", function() vim.api.nvim_input ":CodeCompanion " end, { desc = "Codecompanion: input commandline" })
  --stylua: ignore
  UtilKey.noremap({ "n", "x" }, "<Leader>aF", bulk_commands.select_custom_prompt_and_commands, { desc = "Codecompanion: bulk codecompanion cmds" })
  --stylua: ignore
  UtilKey.nnoremap("<Leader>af", function() open_chats.browse(codecompanion.buf_get_chat(vim.api.nvim_get_current_buf())) end, { desc = "Codecompanion: browse open CodeCompanion chats" })
  --stylua: ignore
  UtilKey.nnoremap("<Leader>ase", edit_repo_rules, { desc = "Codecompanion: edit repo agent rules file" })

  --stylua: ignore
  UtilKey.nnoremap("<Leader>aot", function() worktrees.browse(create_chat) end, { desc = "Codecompanion: chat, create, merge, or remove" })

  --stylua: ignore
  UtilKey.nnoremap("<Leader>axf", function() chat_helpers.add_context { vim.api.nvim_buf_get_name(0) } end, { desc = "Codecompanion: add current file" })
  -- --stylua: ignore
  UtilKey.xnoremap("<Leader>axp", paste_selection_to_chat, { desc = "Codecompanion: paste selection to chat" })

  UtilKey.nnoremap("<Leader>axc", add_review_comment, { desc = "Codecompanion: add with CodeCompanion" })

  UtilKey.xnoremap("<Leader>axc", function()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local anchor_line = vim.fn.line "v"
    vim.cmd.normal { vim.keycode "<Esc>", bang = true }
    add_review_comment {
      math.min(anchor_line, cursor_line),
      math.max(anchor_line, cursor_line),
    }
  end, { desc = "Codecompanion: add comment with codecompanion" })

  --stylua: ignore
  UtilKey.nnoremap("<Leader>axs", send_review_comments, { desc = "Codecompanion: send to CodeCompanion" })
  --stylua: ignore
  UtilKey.nnoremap("<Leader>aoc", explore_review_comments, { desc = "Codecompanion: explore comment in quickfix", })
end

-- Public setup
function M.setup(group)
  setup_filetype_mappings(group)
  setup_global_mappings()
end

return M
