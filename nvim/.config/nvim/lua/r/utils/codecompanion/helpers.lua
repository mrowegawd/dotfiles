local codecompanion = require "codecompanion"
local Config = require "codecompanion.config"

local M = {
  repo = {},
  state = {},
  chat = {},
  window = {},
  usage = {},
}

local function git_root(path)
  local target = path or vim.api.nvim_buf_get_name(0)
  if target == "" then
    target = vim.uv.cwd()
  end

  return vim.fs.root(target, ".git")
end

-- ├────────────────────────────┤ REPO/FILESYSTEM ├─────────────────────────┤
function M.repo.git_root_or_notify(path)
  local root = git_root(path)
  if root then
    return root
  end

  vim.notify("Not inside a Git repository. Could not determine the project root.", vim.log.levels.ERROR)
  return nil
end

function M.repo.git_root_file(filename, path)
  vim.validate("filename", filename, "string")

  local root = git_root(path)
  if not root then
    return nil
  end

  local filepath = vim.fs.joinpath(root, filename)
  local stat = vim.uv.fs_stat(filepath)
  if not stat or stat.type ~= "file" then
    return nil
  end

  return filepath
end

function M.state.get_last_chat()
  local ok, chat = pcall(codecompanion.last_chat)
  if ok and chat then
    return chat
  end
  return nil
end

-- ├──────────────────────────────────┤ CHAT ├──────────────────────────────────┤
function M.chat.run_slash_command(name, opts)
  opts = opts or {}

  local chat = M.chat.get_or_create_chat()
  local cmd = Config.interactions.chat.slash_commands[name]

  if cmd and type(cmd.callback) == "function" then
    cmd.callback(chat, opts)
    M.window.focus_or_toggle_chat { startinsert = false }
  else
    RUtils.error("Slash command not found: " .. tostring(name))
  end
end

function M.chat.get_or_create_chat()
  return M.state.get_last_chat() or codecompanion.chat()
end

function M.chat.add_context(files)
  local chat = M.chat.get_or_create_chat()
  if not chat then
    return nil
  end

  for _, file in ipairs(files) do
    local fd = io.open(file, "r")
    local content
    if fd then
      content = fd:read "*a"
      fd:close()
    end

    if not content then
      vim.notify("Could not read file: " .. file, vim.log.levels.ERROR)
    else
      local normalized_file = vim.fs.normalize(file)
      local id = string.format("<file>%s</file>", normalized_file)

      -- Add context manually (rather than via chat:add_context) because that helper
      -- drops msg.context.path which ACP adapters need to see the file
      chat:add_message({
        role = "user",
        content = string.format("Here is the content of %s:%s", normalized_file, content),
      }, {
        visible = false,
        context = { id = id, path = normalized_file },
        _meta = { tag = "file" },
      })
      chat.context:add { id = id, path = normalized_file }
    end
  end

  M.window.focus_or_toggle_chat { startinsert = false }
end

function M.chat.submit_user_message(chat, content)
  chat:add_buf_message {
    role = Config.constants.USER_ROLE,
    content = content,
  }
  chat:add_message {
    role = Config.constants.USER_ROLE,
    content = content,
  }
  chat:submit()
end

-- ├─────────────────────────────────┤ STATE ├──────────────────────────────┤

local function get_chat_ordinal(bufnr)
  for i, chat_bufnr in ipairs(_G.codecompanion_buffers or {}) do
    if chat_bufnr == bufnr then
      return i
    end
  end
end

function M.state.get_chat_label(chat)
  local ordinal = get_chat_ordinal(chat.bufnr)
  local label = ordinal and ("Chat " .. ordinal) or nil

  if not label then
    pcall(function()
      for _, entry in pairs(codecompanion.buf_get_chat()) do
        if entry.chat == chat then
          label = entry.name
          break
        end
      end
    end)
  end

  if not label or label == "" then
    label = "Chat " .. chat.bufnr
  end

  local title = (chat.title ~= "" and chat.title) or (chat.opts and chat.opts.title)
  if title and title ~= "" then
    label = string.format("%s · %s", label, title)
  end

  return label
end

function M.state.for_each_open_chat(callback)
  local ok, chats = pcall(codecompanion.buf_get_chat)
  if not ok or not chats then
    return
  end

  for _, entry in pairs(chats) do
    callback(entry.chat, entry)
  end
end

local function get_open_chat_count()
  local count = 0
  M.state.for_each_open_chat(function()
    count = count + 1
  end)
  return count
end

function M.state.format_open_chat_count()
  local count = get_open_chat_count()
  return ({
    [1] = "¹",
    [2] = "²",
    [3] = "³",
    [4] = "⁴",
    [5] = "⁵",
  })[count] or tostring(count)
end

function M.state.get_current_system_role_prompt()
  local chat = M.state.get_last_chat()
  if not chat or type(chat.messages) ~= "table" then
    return nil
  end

  local system_role = nil
  for _, entry in ipairs(chat.messages) do
    if entry.role == "system" then
      system_role = entry.content
    end
  end

  return system_role
end

function M.state.get_last_user_prompt()
  local chat = M.state.get_last_chat()
  if not chat or type(chat.messages) ~= "table" then
    return nil
  end

  for i = #chat.messages, 1, -1 do
    local msg = chat.messages[i]
    if msg.role == "user" then
      return msg.content
    end
  end

  return nil
end

function M.state.get_cycle_count()
  local bufnr = vim.api.nvim_get_current_buf()
  local metadata = (_G.codecompanion_chat_metadata or {})[bufnr] or {}
  return metadata.cycles or 0
end

function M.state.provider_icon(name)
  name = (name or ""):lower()
  if name:find "claude" or name:find "anthropic" then
    return "" -- cod-sparkle
  elseif name:find "codex" or name:find "openai" or name:find "gpt" then
    return "󰙴" -- md-creation
  elseif name:find "gemini" or name:find "google" then
    return "󰊭" -- md-google
  end
  return "󰚩" -- md-robot
end

function M.state.get_adapter_model(adapter)
  return vim.tbl_get(adapter, "schema", "model", "default")
    or vim.tbl_get(adapter, "defaults", "session_config_options", "model")
    or vim.tbl_get(adapter, "defaults", "model")
end

function M.state.get_adapter_effort(adapter)
  local effort = vim.tbl_get(adapter, "schema", "reasoning.effort", "default")
    or vim.tbl_get(adapter, "schema", "reasoning_effort", "default")

  -- local home = vim.env.HOME
  -- if not effort and home and adapter.name == "claude_code" then
  --   local ok, settings = pcall(vim.json.decode, u.read_file(home .. "/.claude/settings.json") or "")
  --   effort = ok and settings.effortLevel or nil
  -- elseif not effort and home and adapter.name == "codex" then
  --   effort = (u.read_file(home .. "/.codex/config.toml") or ""):match "model_reasoning_effort%s*=%s*[\"']([^\"']+)"
  -- end

  if effort and effort ~= "" and effort ~= "none" then
    return tostring(effort)
  end
end

function M.state.get_adapter_context_window(adapter)
  if type(adapter) ~= "table" then
    return nil
  end

  local model = M.state.get_adapter_model(adapter)
  if not model then
    return nil
  end

  local context_window = vim.tbl_get(adapter, "schema", "model", "choices", model, "meta", "context_window")
  if type(context_window) == "number" then
    return context_window
  end

  return nil
end

function M.state.format_context_usage(adapter)
  local bufnr = vim.api.nvim_get_current_buf()
  local metadata = (_G.codecompanion_chat_metadata or {})[bufnr] or {}
  local tokens = metadata.tokens or 0
  local max_ctx = M.state.get_adapter_context_window(adapter)

  if not max_ctx then
    return string.format("unknown ctx (%d)", tokens)
  end

  return string.format("%.1f%% (%d)", (tokens / max_ctx) * 100, tokens)
end

-- Usage limits: shell out to the ai_session_usage script
local usage_cache = {}
local usage_labels = { claude_code = "Claude", codex = "Codex" }
local usage_flags = { claude_code = "--claude", codex = "--codex" }
local usage_last_run = {}
local USAGE_TTL = 120

-- Run the ai_session_usage script and hand back its ANSI-stripped output
function M.usage.run(name, cb)
  vim.system({ "ai_session_usage", usage_flags[name] }, { text = true }, function(obj)
    local out = (obj.stdout or ""):gsub("\27%[[0-9;]*m", ""):gsub("%s+$", "")
    cb(out)
  end)
end

function M.usage.get(name)
  return usage_cache[name]
end

-- Cache the 5h usage for claude_code/codex, parsed from the script output; cb
-- re-renders the footer once data lands. Results are reused for USAGE_TTL
-- seconds per adapter
function M.usage.refresh(name, cb)
  if not usage_labels[name] then
    return
  end
  -- Throttle on time regardless of success so a rate-limited window can recover
  if os.time() - (usage_last_run[name] or 0) < USAGE_TTL then
    if cb then
      vim.schedule(cb)
    end
    return
  end
  usage_last_run[name] = os.time()
  M.usage.run(name, function(out)
    local label = usage_labels[name]
    local pct, reset = out:match(label .. "%s+5h:%s+([%d%.]+)%%%s+%(resets ([^)]+)%)")
    pct = pct or out:match(label .. "%s+5h:%s+([%d%.]+)")
    if pct then
      usage_cache[name] = { pct = tonumber(pct), reset = reset }
    end
    if cb then
      vim.schedule(cb)
    end
  end)
end

-- ├──────────────────────────────┤ Chat windows ├──────────────────────────────┤
function M.window.try_focus_chat_float()
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    local conf = vim.api.nvim_win_get_config(win_id)
    local bufnr = vim.api.nvim_win_get_buf(win_id)
    local filetype = vim.bo[bufnr].filetype

    if conf.focusable and conf.relative ~= "" and filetype == "codecompanion" then
      vim.api.nvim_set_current_win(win_id)
      return true
    end
  end

  return false
end

function M.window.focus_or_toggle_chat(opts)
  opts = opts or {}

  if M.window.try_focus_chat_float() then
    return
  end

  local startinsert
  if opts.startinsert ~= nil then
    startinsert = opts.startinsert
  else
    startinsert = next(codecompanion.buf_get_chat()) == nil
  end

  codecompanion.toggle_chat()

  if startinsert then
    vim.defer_fn(function()
      vim.cmd.startinsert()
    end, 10)
  end
end

function M.window.toggle_cc_zoom()
  local win = vim.api.nvim_get_current_win()
  local win_config = vim.api.nvim_win_get_config(win)
  local saved = vim.w.cc_default_float_conf

  if saved then
    vim.api.nvim_win_set_config(win, saved)
    vim.w.cc_default_float_conf = nil
    return
  end

  vim.w.cc_default_float_conf = win_config
  vim.api.nvim_win_set_config(win, {
    relative = "editor",
    row = 1,
    col = math.floor(vim.o.columns * 0.10),
    width = math.floor(vim.o.columns * 0.80),
    height = vim.o.lines - 4,
  })
end

return M
