local codecompanion = require "codecompanion"

local M = {}

local function cwd_footer()
  return vim.uv.cwd():match "([^/]+/[^/]+/[^/]+)$" or ""
end

local function set_footer(winnr, text)
  vim.api.nvim_win_set_config(winnr, {
    footer = text,
    footer_pos = "center",
  })
end

local function set_chat_win_title(e)
  e = e or {}

  local ok, chat = pcall(function()
    return codecompanion.buf_get_chat(vim.api.nvim_get_current_buf())
  end)

  if not ok or not chat or not chat.ui or not chat.ui.winnr then
    vim.defer_fn(function()
      local picker = telescope_action_state.get_current_picker(vim.api.nvim_get_current_buf())
      if picker then
        vim.api.nvim_win_close(picker.prompt_win, true)
      end
    end, 50)

    vim.wait(100)

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
    footer = cwd_footer(),
    footer_pos = "center",
  })
end

-- Restore history metadata to be used by label below
local function restore_chat_history_metadata(bufnr)
  local history = codecompanion.extensions.history
  local chat = codecompanion.buf_get_chat(bufnr)
  local save_id = chat and chat.opts and chat.opts.save_id
  local saved_chat = save_id and history.load_chat(save_id)
  if not saved_chat then
    return
  end

  _G.codecompanion_chat_metadata = _G.codecompanion_chat_metadata or {}
  _G.codecompanion_chat_metadata[chat.bufnr] =
    vim.tbl_deep_extend("force", _G.codecompanion_chat_metadata[chat.bufnr] or {}, {
      cycles = saved_chat.cycle,
      tokens = history.get_chats()[save_id].token_estimate,
    })

  vim.cmd.redrawstatus()
end

-- Spinner internals
local spinner = {
  states = {
    "⢀⠀",
    "⡀⠀",
    "⠄⠀",
    "⢂⠀",
    "⡂⠀",
    "⠅⠀",
    "⢃⠀",
    "⡃⠀",
    "⠍⠀",
    "⢋⠀",
    "⡋⠀",
    "⠍⠁",
    "⢋⠁",
    "⡋⠁",
    "⠍⠉",
    "⠋⠉",
    "⠋⠉",
    "⠉⠙",
    "⠉⠙",
    "⠉⠩",
    "⠈⢙",
    "⠈⡙",
    "⢈⠩",
    "⡀⢙",
    "⠄⡙",
    "⢂⠩",
    "⡂⢘",
    "⠅⡘",
    "⢃⠨",
    "⡃⢐",
    "⠍⡐",
    "⢋⠠",
    "⡋⢀",
    "⠍⡁",
    "⢋⠁",
    "⡋⠁",
    "⠍⠉",
    "⠋⠉",
    "⠋⠉",
    "⠉⠙",
    "⠉⠙",
    "⠉⠩",
    "⠈⢙",
    "⠈⡙",
    "⠈⠩",
    "⠀⢙",
    "⠀⡙",
    "⠀⠩",
    "⠀⢘",
    "⠀⡘",
    "⠀⠨",
    "⠀⢐",
    "⠀⡐",
    "⠀⠠",
    "⠀⢀",
    "⠀⡀",
  },
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

  local winnr = spinner_winnr()
  if winnr then
    set_footer(winnr, cwd_footer())
  end

  spinner.bufnr = nil
end

local function update_spinner()
  local winnr = spinner_winnr()
  if not winnr then
    return
  end

  local base = cwd_footer()
  local glyph = spinner.states[spinner.index]
  local text = base == "" and glyph or string.format("%s %s", base, glyph)
  set_footer(winnr, text)
  spinner.index = spinner.index % #spinner.states + 1
end

-- Chat display
function M.chat_display()
  return {
    intro_message = "",
    icons = {
      buffer_sync_all = " ",
      buffer_sync_diff = " ",
    },
    window = {
      layout = "float",
      border = "rounded",
      height = vim.o.lines - 5,
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

function M.setup()
  -- Icons
  -- devicons.set_icon {
  --   codecompanion = { icon = " " },
  -- }
  -- devicons.set_icon_by_filetype { codecompanion = "codecompanion" }

  -- Window titles
  vim.api.nvim_create_autocmd("User", {
    pattern = {
      "CodeCompanionChatCreated",
      "CodeCompanionChatOpened",
      "CodeCompanionHistoryTitleSet",
    },
    desc = "Set CodeCompanion chat window title after chat events",
    callback = function(e)
      vim.defer_fn(function()
        set_chat_win_title(e)
      end, 1)
    end,
  })
  vim.api.nvim_create_autocmd("DirChanged", {
    desc = "Refresh CodeCompanion chat window title after directory change from chat",
    callback = function()
      if vim.bo.filetype ~= "codecompanion" then
        return
      end
      vim.defer_fn(function()
        set_chat_win_title()
      end, 1)
    end,
  })

  -- Spinner lifecycle
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatSubmitted",
    desc = "Start CodeCompanion spinner when a chat turn begins",
    callback = function(e)
      clear_spinner()

      local bufnr = e.data and e.data.bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      spinner.bufnr = bufnr
      spinner.timer = vim.uv.new_timer()
      spinner.timer:start(0, 200, vim.schedule_wrap(update_spinner))
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionChatDone", "CodeCompanionChatStopped" },
    desc = "Clear CodeCompanion spinner when a chat turn ends",
    callback = function()
      vim.defer_fn(clear_spinner, 50)
    end,
  })

  -- Diff behavior
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionDiffAttached",
    desc = "Ensure diffs start in normal mode and preserve window order",
    callback = function()
      vim.defer_fn(function()
        vim.cmd.stopinsert()
        if vim.api.nvim_win_get_config(0).relative ~= "" then
          return
        end
        vim.cmd.wincmd "x"
        vim.cmd.wincmd "p"
      end, 1)
    end,
  })

  -- History extension
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatCreated",
    desc = "Restore CodeCompanion history metadata",
    callback = function(args)
      vim.schedule(function()
        restore_chat_history_metadata(args.data.bufnr)
      end)
    end,
  })
end

return M
