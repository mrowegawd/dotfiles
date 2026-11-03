-- file: utils/event_profiler.lua

local M = {}

local uv = vim.uv
local active = false
local events = {}
local started_at
local augroup

local watched_events = {
  "BufAdd",
  "BufDelete",
  "BufEnter",
  "BufNewFile",
  "BufReadPost",
  "BufReadPre",
  "BufUnload",
  "BufWinEnter",
  "BufWipeout",
  "FileType",
  "LspAttach",
  "UIEnter",
  "LspDetach",
  "SessionLoadPost",
  "TabClosed",
  "TabEnter",
  "TermClose",
  "WinClosed",
  "WinEnter",
  "WinNew",
}

-- event yang perlu stack trace (untuk tahu siapa pemanggilnya)
local trace_events = {
  BufAdd = true,
  BufReadPre = true,
  LspAttach = true,

  UIEnter = true,
}

local function stop_timer()
  if M._timer then
    M._timer:stop()
    M._timer:close()
    M._timer = nil
  end
end

function M.start()
  events = {}
  active = true
  started_at = uv.hrtime()

  -- augroup: autocmd tidak menumpuk kalau start() dipanggil berkali-kali
  augroup = vim.api.nvim_create_augroup("EventProfiler", { clear = true })

  for _, event in ipairs(watched_events) do
    vim.api.nvim_create_autocmd(event, {
      group = augroup,
      callback = function(args)
        if not active then
          return
        end

        local extra = ""
        if event == "LspAttach" then
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          extra = c and c.name or "?"
        end

        local bt, ft = "", ""
        if args.buf and vim.api.nvim_buf_is_valid(args.buf) then
          bt = vim.bo[args.buf].buftype
          ft = vim.bo[args.buf].filetype
        end

        events[#events + 1] = {
          event = event,
          elapsed = (uv.hrtime() - started_at) / 1e6,
          file = args.file,
          match = args.match,
          buf = args.buf,
          info = string.format("bt=%s ft=%s %s", bt, ft, extra),
          trace = trace_events[event] and debug.traceback("", 2) or nil,
        }
      end,
    })
  end

  -- Detektor blocking: timer jalan tiap 10ms. Kalau main thread macet,
  -- callback-nya telat, dan selisih waktunya kita catat sebagai BLOCKED.
  stop_timer()
  local last = uv.hrtime()
  M._timer = uv.new_timer()
  M._timer:start(
    0,
    10,
    vim.schedule_wrap(function()
      local now = uv.hrtime()
      local gap = (now - last) / 1e6
      last = now
      if active and gap > 40 then
        events[#events + 1] = {
          event = "BLOCKED",
          elapsed = (now - started_at) / 1e6,
          info = string.format("main thread macet %.0f ms", gap),
        }
      end
    end)
  )

  vim.notify "Event profiler started"
end

function M.stop()
  if not active then
    return
  end
  active = false

  stop_timer()

  if augroup then
    vim.api.nvim_del_augroup_by_id(augroup)
    augroup = nil
  end

  -- sort dulu, baru bikin lines
  table.sort(events, function(a, b)
    return a.elapsed < b.elapsed
  end)

  local lines = {}

  for _, item in ipairs(events) do
    lines[#lines + 1] = string.format(
      "%8.2f ms | %-16s | buf=%-4s | %s | %s",
      item.elapsed,
      item.event,
      item.buf and tostring(item.buf) or "-",
      item.info or "",
      item.file or item.match or ""
    )

    if item.trace then
      for line in item.trace:gmatch "[^\n]+" do
        lines[#lines + 1] = "           " .. line
      end
    end
  end

  vim.fn.writefile(lines, "/tmp/nvim-event-profile.log")

  vim.notify("Event profile saved: /tmp/nvim-event-profile.log\n" .. #events .. " events captured")
end

function M.mark(label)
  if not active or not started_at then
    return
  end

  events[#events + 1] = {
    event = "MARK",
    elapsed = (uv.hrtime() - started_at) / 1e6,
    info = label,
  }
end

return M
