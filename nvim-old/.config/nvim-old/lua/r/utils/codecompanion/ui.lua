local codecompanion = require "codecompanion"
local config = require "codecompanion.config"

local state_helpers = require("r.utils.codecompanion.helpers").state
local usage_helpers = require("r.utils.codecompanion.helpers").usage
local prompt_library = require "r.utils.codecompanion.prompt_library"

local M = {}

-- local function cwd_footer()
--   return vim.uv.cwd():match "([^/]+/[^/]+/[^/]+)$" or ""
-- end

local function chat_footer(chat)
  local parts = {}
  local adapter = chat and chat.adapter
  if adapter then
    -- acp agents show their name (Claude/Codex); http shows the model
    local labels = { claude_code = "Claude", codex = "Codex" }
    local label = labels[adapter.name] or state_helpers.get_adapter_model(adapter) or adapter.name
    table.insert(parts, string.format("%s %s", state_helpers.provider_icon(adapter.name), label))
  end
  -- local cwd = cwd_footer()
  -- if cwd ~= "" then
  --   table.insert(parts, " " .. cwd)
  -- end
  if chat then
    table.insert(parts, string.format(" %d", state_helpers.get_cycle_count(chat)))
    table.insert(parts, string.format(" %s", state_helpers.format_context_usage(chat)))
    if adapter and adapter.type == "acp" then
      local usage = usage_helpers.get(adapter.name)
      if usage then
        local label = string.format(" 5h %.0f%%", usage.pct)
        if usage.reset then
          label = label .. " (" .. usage.reset .. ")"
        end
        table.insert(parts, label)
      end
    end
  end
  return table.concat(parts, " · ")
end

local function chat_title(chat)
  return string.format(
    "╭[◉_◉]╮ %s %s",
    state_helpers.format_open_chat_count(),
    state_helpers.get_chat_label(chat)
  )
end

local function set_chat_win_title(e)
  e = e or {}

  local ok, chat = pcall(function()
    return codecompanion.buf_get_chat(vim.api.nvim_get_current_buf())
  end)

  if not ok or not chat or not chat.ui or not chat.ui.winnr then
    -- vim.defer_fn(function()
    --   local picker = telescope_action_state.get_current_picker(vim.api.nvim_get_current_buf())
    --   if picker then
    --     vim.api.nvim_win_close(picker.prompt_win, true)
    --   end
    -- end, 50)
    -- vim.wait(100)

    if vim.bo.filetype == "codecompanion" and e.data and e.data.title then
      local win_id = vim.api.nvim_get_current_win()
      local current = vim.api.nvim_win_get_config(win_id)
      vim.api.nvim_win_set_config(win_id, {
        title = current.title[1][1]:gsub("%b()", "(" .. e.data.title .. ")"),
      })
    end
    return
  end

  local chatmap = {}
  for _, entry in pairs(codecompanion.buf_get_chat()) do
    chatmap[entry.chat.ui.winnr] = entry.name
  end

  vim.api.nvim_win_set_config(chat.ui.winnr, {
    title = string.format(
      "╭[◉_◉]╮ %s%s",
      chatmap[chat.ui.winnr],
      (chat.opts.title and chat.opts.title ~= "") and string.format(" (%s)", chat.opts.title) or ""
    ),
    footer = chat_footer(chat),
    footer_pos = "center",
  })
end

local function refresh_chat_footer(bufnr)
  local ok, chat = pcall(function()
    return codecompanion.buf_get_chat(bufnr)
  end)
  if not ok or not chat or not chat.ui or not chat.ui.winnr then
    return
  end
  if not vim.api.nvim_win_is_valid(chat.ui.winnr) then
    return
  end
  vim.api.nvim_win_set_config(chat.ui.winnr, {
    footer = chat_footer(chat),
    footer_pos = "center",
  })
end

local function refresh_all_chat_titles()
  state_helpers.for_each_open_chat(function(chat)
    if chat and chat.ui and chat.ui.winnr and vim.api.nvim_win_is_valid(chat.ui.winnr) then
      vim.api.nvim_win_set_config(chat.ui.winnr, {
        title = chat_title(chat),
      })
    end
  end)
end

-- Role label formatter for the chat UI
function M.llm_role(adapter)
  local current_system_role_prompt = state_helpers.get_current_system_role_prompt()
  local system_role = prompt_library.SYSTEM_ROLE

  for name, prompt in pairs(config.prompt_library or {}) do
    local prompts = prompt and prompt.prompts
    if type(prompts) == "table" then
      local first = prompts[1]
      if first and type(first.content) == "string" then
        if first.content == current_system_role_prompt then
          system_role = name
          break
        end
      end
    end
  end

  local adapter_name = adapter.formatted_name or adapter.name or "unknown"
  local model = state_helpers.get_adapter_model(adapter) or "unknown"
  local effort = state_helpers.get_adapter_effort(adapter)
  if effort then
    model = string.format("%s %s", model, effort)
  end

  if not system_role then
    local max_len = 25
    local short_model_name = require("qfbookmark.ui.utils").shorten_text(model, max_len)

    local header_format
    if config.config.display.chat.window.layout and config.config.display.chat.window.layout ~= "float" then
      header_format = string.format("%s (%s)", adapter_name, short_model_name)
    else
      header_format = string.format("%s (%s) | %s", adapter_name, short_model_name, os.date "%Y-%m-%d %H:%M:%S")
    end
    return header_format
  end

  return string.format("%s (%s) | %s", adapter_name, model, system_role)
end

-- Spinner internals
local spinner = {
  states = {
    "🤘 ",
    "🤟 ",
    "🖖 ",
    "✋ ",
    "🤚 ",
    "👆 ",
  },

  ns = vim.api.nvim_create_namespace "codecompanion_spinner",
  bufnr = nil,
  timer = nil,
  index = 1,
}

local function spinner_winnr()
  if not (spinner.bufnr and vim.api.nvim_buf_is_valid(spinner.bufnr)) then
    return nil
  end
  local winnr = vim.fn.bufwinid(spinner.bufnr)
  if winnr == -1 or not vim.api.nvim_win_is_valid(winnr) then
    return nil
  end
  return winnr
end

local function clear_spinner()
  if spinner.timer then
    spinner.timer:stop()
    spinner.timer:close()
    spinner.timer = nil
  end

  if spinner.bufnr and vim.api.nvim_buf_is_valid(spinner.bufnr) then
    vim.api.nvim_buf_clear_namespace(spinner.bufnr, spinner.ns, 0, -1)
  end

  spinner.bufnr = nil
end

local function update_spinner()
  if not spinner_winnr() then
    return
  end

  local last_line = vim.api.nvim_buf_line_count(spinner.bufnr) - 1
  vim.api.nvim_buf_set_extmark(spinner.bufnr, spinner.ns, last_line, 0, {
    id = 1,
    virt_text = { { spinner.states[spinner.index], "CodeCompanionSpinner" } },
    virt_text_pos = "right_align",
  })
  spinner.index = spinner.index % #spinner.states + 1
end

-- Chat display
function M.chat_display()
  return {
    fold_context = false, -- Fold context in the chat buffer?
    intro_message = "",
    icons = {
      sync_all = " ",
      sync_diff = " ",
    },
    window = {
      layout = "float",
      border = "rounded",
      height = vim.o.lines - 7,
      width = 0.45,
      relative = "editor",
      col = vim.o.columns,
      row = 1,
      opts = {
        winfixbuf = true,
        number = false,
      },
    },
    debug_window = {
      width = math.floor(vim.o.columns * 0.535),
      height = vim.o.lines - 4,
    },
  }
end

-- ├──────────────┤ Handle markdown rendering not being applied ├───────────┤
---@param buf integer
local function force_render_buf(buf)
  local ok_rm, render_markdown = pcall(require, "render-markdown")
  if not ok_rm then
    return
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      -- Run as if this window were the current one (without actually
      -- moving the user's cursor), then toggle off->on so render-markdown
      -- fully re-renders from scratch, instead of being a no-op because
      -- the state is already "enabled".
      vim.api.nvim_win_call(win, function()
        render_markdown.buf_disable()
        render_markdown.buf_enable()
      end)
    end
  end
end

---@type table<integer, uv.uv_timer_t>
local debounce_timers = {}
local DEBOUNCE_MS = 250

---@param buf integer
local function schedule_debounced_render(buf)
  local timer = debounce_timers[buf]
  if not timer then
    ---@diagnostic disable-next-line: cast-local-type
    timer = vim.uv.new_timer()
    debounce_timers[buf] = timer
  end

  ---@diagnostic disable-next-line: need-check-nil
  timer:stop()
  ---@diagnostic disable-next-line: need-check-nil
  timer:start(
    DEBOUNCE_MS,
    0,
    vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(buf) then
        force_render_buf(buf)
      end
    end)
  )
end

---@return boolean
local function has_active_codecompanion_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "codecompanion" then
      return true
    end
  end
  return false
end

M.active = true

--- Cleans up all resources created by M.setup():
--- per-buffer debounce timers, the spinner timer, and buffer-local flags.
--- Safe to call multiple times (idempotent).
function M.teardown()
  M.active = false

  -- 1. Remove all autocmds registered in this group.
  --    The augroup itself is preserved, so its ID remains valid and can be
  --    reused if M.setup() is called again.
  -- pcall(vim.api.nvim_clear_autocmds, { group = group })

  -- 2. Stop and close any remaining debounce timers.
  for buf, timer in pairs(debounce_timers) do
    if timer then
      pcall(function()
        timer:stop()
        timer:close()
      end)
    end
    debounce_timers[buf] = nil
  end

  -- 3. Stop the spinner timer if it's still running.
  clear_spinner()

  -- 4. Clear the buffer-local flag so M.setup() can safely reattach to the
  --    buffer if it's called again (e.g. when opening a new chat), rather
  --    than skipping the attachment because of a stale flag.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.b[buf].cc_force_render_attached = nil
    end
  end
end

function M.setup()
  -- +-----------------------------------------------------------------------------+
  -- |                                Window titles                                |
  -- +-----------------------------------------------------------------------------+
  vim.api.nvim_create_autocmd("User", {
    -- group = group,
    pattern = {
      "CodeCompanionChatCreated",
      "CodeCompanionChatOpened",
      "CodeCompanionACPChatRestored",
      "CodeCompanionBackgroundTitleSet",
      "CodeCompanionChatClosed",
    },
    desc = "Set CodeCompanion chat window title after chat events",
    callback = function(e)
      M.active = true -- re-activate semua fitur lain

      if config.config.display.chat.window.layout and config.config.display.chat.window.layout ~= "float" then
        return
      end

      vim.defer_fn(function()
        set_chat_win_title(e)
        refresh_all_chat_titles()
      end, 1)
    end,
  })

  -- +-----------------------------------------------------------------------------+
  -- |                              Spinner lifecycle                              |
  -- +-----------------------------------------------------------------------------+
  vim.api.nvim_create_autocmd("User", {
    -- group = group,
    pattern = "CodeCompanionChatSubmitted",
    desc = "Start CodeCompanion spinner when a chat turn begins",
    callback = function(e)
      if not M.active then
        return
      end

      clear_spinner()

      local bufnr = e.data and e.data.bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      spinner.bufnr = bufnr
      spinner.timer = vim.uv.new_timer()
      spinner.timer:start(0, 100, vim.schedule_wrap(update_spinner))
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionChatDone", "CodeCompanionChatStopped" },
    desc = "Clear CodeCompanion spinner when a chat turn ends",
    callback = function()
      if not M.active then
        return
      end

      vim.defer_fn(clear_spinner, 50)
    end,
  })

  -- ├──────────────┤ Handle markdown rendering not being applied ├───────────┤
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatOpened",
    callback = function(request)
      if not M.active then
        return
      end

      local buf = request.buf
      if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      if vim.b[buf].cc_force_render_attached then
        return
      end
      vim.b[buf].cc_force_render_attached = true

      vim.api.nvim_buf_attach(buf, false, {
        on_lines = function()
          -- Debounce ONLY here -- toggling render off/on is relatively
          -- heavy, so it's not ideal to call it on every streamed token.
          schedule_debounced_render(buf)
        end,
        on_detach = function()
          local timer = debounce_timers[buf]
          if timer then
            timer:stop()
            timer:close()
            debounce_timers[buf] = nil
          end
        end,
      })
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    callback = function(request)
      if not M.active then
        return
      end

      local buf = request.buf or (request.data and request.data.bufnr)
      if buf and vim.api.nvim_buf_is_valid(buf) then
        schedule_debounced_render(buf)
      end
    end,
  })

  -- local group = vim.api.nvim_create_augroup("CodeCompanionForceScroll", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionRequestStreaming", "CodeCompanionRequestFinished" },
    -- group = group,
    callback = function(request)
      if not M.active then
        return
      end

      local bufnr = request.data and request.data.bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- Cari window yang sedang menampilkan buffer chat ini
      for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(winid) == bufnr then
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          vim.api.nvim_win_set_cursor(winid, { line_count, 0 })
          -- paksa juga viewport-nya biar baris terakhir kelihatan
          vim.api.nvim_win_call(winid, function()
            vim.cmd "normal! zb"
          end)
        end
      end
    end,
  })

  -- +-----------------------------------------------------------------------------+
  -- |                                   Footer                                    |
  -- +-----------------------------------------------------------------------------+
  vim.api.nvim_create_autocmd("User", {
    pattern = {
      "CodeCompanionChatDone",
      "CodeCompanionChatStopped",
      "CodeCompanionACPChatRestored",
    },
    desc = "Refresh CodeCompanion chat footer when displayed state changes",
    callback = function(e)
      if not M.active then
        return
      end
      local bufnr = e.data and e.data.bufnr
      if not bufnr then
        return
      end
      vim.defer_fn(function()
        refresh_chat_footer(bufnr)
      end, 50)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionChatAdapter", "CodeCompanionChatModel" },
    desc = "Refresh CodeCompanion chat footer when the adapter or model changes",
    callback = function(e)
      if not M.active then
        return
      end
      local bufnr = e.data and e.data.bufnr
      if not bufnr then
        return
      end

      vim.schedule(function()
        refresh_chat_footer(bufnr)
        -- refresh_chat_usage(bufnr)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequest*",
    callback = function(request)
      if not M.active then
        return
      end

      if request.match == "CodeCompanionRequestStarted" then
        vim.g.processing_ai = true
      elseif request.match == "CodeCompanionRequestFinished" then
        vim.g.processing_ai = false
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatClosed",
    callback = function()
      if not M.active then
        return
      end

      -- Defer slightly because the recently closed buffer may still be reported
      -- as valid when this event fires.
      vim.defer_fn(function()
        if not has_active_codecompanion_buffers() then
          M.teardown()
        end
      end, 50)
    end,
  })
end

return M
