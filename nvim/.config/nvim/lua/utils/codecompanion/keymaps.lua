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
      modes = { n = { "<C-c>xR", "<C-c><C-r>" } },
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
      modes = { n = { "<C-o>", "<c-c><c-c>" }, i = { "<C-o>", "<C-c><C-c>" } },
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
      modes = { n = "<CR>" },
      description = "Codecompanion: action palette",
      callback = function()
        vim.defer_fn(function()
          vim.cmd.CodeCompanionActions()
        end, 1)
      end,
    },

    change_adapter = {
      modes = { n = "<C-c>sc" },
      description = "Codecompanion: change adapter",
    },

    debug = {
      modes = { n = "<F5>" },
      description = "Codecompanion: debug",
      callback = open_debug,
    },

    clear_approvals = {
      modes = { n = "<C-c>sX" },
      description = "Codecompanion: clear approvals",
    },

    -- Chat modes
    _btw = {
      modes = { n = "<C-c>sW" },
      description = "Codecompanion: _bw",
    },

    yolo_mode = {
      modes = { n = "<C-c>sY" },
      description = "Codecompanion: yolo mode",
    },

    -- Buffer sync
    sync_all = {
      modes = { n = "<C-c>bs" },
      description = "Codecompanion: buffer sync all",
    },
    sync_diff = {
      modes = { n = "<C-c>bd" },
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

local function setup_codecompanion_filetype_mappings(e)
  local bufnr = e.buf

  UtilKey.nnoremap("<C-c>il", insert_last_user_prompt, {
    desc = "Codecompanion: insert last user prompt",
    buf = bufnr,
    remap = true,
    force = true,
  })

  UtilKey.nnoremap("<Leader>mm", window_helpers.toggle_chat_zoom, {
    desc = "Codecompanion: toggle zoom",
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
        { "<C-c>s", group = "set", buffer = e.buf },
        { "<C-c>x", group = "exec", buffer = e.buf },
        { "<C-c>i", group = "insert", buffer = e.buf },
        { "<C-c>f", group = "find", buffer = e.buf },
        { "<C-c>b", group = "buffer", buffer = e.buf },
      }
    end,
  })
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

function M.setup(group)
  setup_filetype_mappings(group)
  setup_global_mappings()
end

return M
