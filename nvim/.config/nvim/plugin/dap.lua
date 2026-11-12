local add = require("vim-pack").add
local add_on_event = require("vim-pack").add_on_event

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local Plugin = lazy "utils.plugin"
local IconsDebug = lazy("icons").dap
local UtilKey = lazy "utils.map"
local UtilAugroup = lazy("utils.map").augroup

local dap = lazy "dap"
local dv = lazy "dap-view"
local osv = lazy "osv"
local fzf = lazy "fzf-lua"
local dap_bps = lazy "dap.breakpoints"
local util_fzflua = lazy "utils.fzflua"

local LISTENER_ID = "dap-config"

local function has_session()
  return dap.session() ~= nil
end

local session_maps = {
  --stylua: ignore
  { "H", function() dap.step_out() end, "step out" },
  --stylua: ignore
  { "L", function() dap.step_into() end, "step into" },
  --stylua: ignore
  { "J", function() dap.step_over() end, "step over" },
}

local keymaps_active = false
local saved_maps = {}

local function enable_session_keymaps()
  if keymaps_active then
    return
  end
  keymaps_active = true
  for _, m in ipairs(session_maps) do
    saved_maps[m[1]] = vim.fn.maparg(m[1], "n", false, true)
    vim.keymap.set("n", m[1], m[2], { desc = ("Debug: %s [nvim-dap]"):format(m[3]) })
  end
end

local function disable_session_keymaps()
  if not keymaps_active then
    return
  end
  keymaps_active = false
  for _, m in ipairs(session_maps) do
    pcall(vim.keymap.del, "n", m[1])
    local old = saved_maps[m[1]]
    if old and not vim.tbl_isempty(old) then
      pcall(vim.fn.mapset, "n", false, old)
    end
  end
  saved_maps = {}
end

local function sync_session_keymaps()
  if has_session() then
    enable_session_keymaps()
  else
    disable_session_keymaps()
  end
end

local listeners_ready = false
local function setup_listeners()
  if listeners_ready then
    return
  end
  listeners_ready = true

  local function sync()
    vim.schedule(sync_session_keymaps)
  end

  dap.listeners.on_session[LISTENER_ID] = sync

  for _, ev in ipairs { "event_initialized", "event_terminated", "event_exited", "disconnect" } do
    dap.listeners.after[ev][LISTENER_ID] = sync
  end

  local function safe(fn)
    return function(...)
      local ok, err = pcall(fn, ...)
      if not ok then
        vim.schedule(function()
          Log.error("dap-view listener error: " .. tostring(err))
        end)
      end
    end
  end

  dap.listeners.before.attach[LISTENER_ID] = safe(function()
    dv.open()
  end)
  dap.listeners.before.launch[LISTENER_ID] = safe(function()
    dv.open()
  end)
  dap.listeners.before.event_terminated[LISTENER_ID] = safe(function()
    dv.close()
  end)
  dap.listeners.before.event_exited[LISTENER_ID] = safe(function()
    dv.close()
  end)
end

local function prune_dead_sessions()
  for id, s in pairs(dap.sessions()) do
    if s.closed then
      dap.sessions()[id] = nil
    end
  end
end

local function quit_dap()
  local s = dap.session()
  if not s then
    prune_dead_sessions()
    sync_session_keymaps()
    return
  end

  dap.terminate()

  vim.defer_fn(function()
    if dap.session() == s then
      pcall(dap.disconnect, { terminateDebuggee = true })
      pcall(dap.close)
    end
    prune_dead_sessions()
    sync_session_keymaps()
  end, 2000)
end

---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return lazy("dap.utils").splitstr(new_args)
  end
  return config
end

local function focus_source_win()
  local cur = vim.api.nvim_get_current_buf()
  if vim.bo[cur].buftype == "" and not vim.bo[cur].filetype:match "^dap" then
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "" and vim.api.nvim_win_get_config(win).relative == "" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

local function safe_continue()
  focus_source_win()
  prune_dead_sessions()
  dap.continue()
end

local function move_line(delta)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd.move(tostring(line + delta))
  pcall(function()
    vim.cmd.normal { args = { "zO" }, bang = true, mods = { silent = true } }
  end)
end

local function get_active_adapter_info()
  local s = dap.session()
  if not s or not s.adapter then
    return nil
  end
  return {
    host = s.adapter.host,
    port = s.adapter.port,
    type = s.adapter.type,
    id = s.id,
  }
end

local function find_pids_on_port(port)
  if not port then
    return {}
  end
  local cmd = string.format(
    "lsof -t -i :%d 2>/dev/null || ss -lptn 'sport = :%d' 2>/dev/null | grep -oP 'pid=\\K[0-9]+' || true",
    port,
    port
  )
  local pids = vim.fn.systemlist(cmd)
  return vim.tbl_filter(function(p)
    return p and p ~= "" and p:match "^%d+$"
  end, pids)
end

local function kill_port(port, label)
  if not port then
    return 0
  end
  local pids = find_pids_on_port(port)
  if #pids == 0 then
    return 0
  end
  for _, pid in ipairs(pids) do
    vim.fn.system { "kill", "-9", pid }
  end
  Log.warn(("DAP: killing %d processes on port %d (%s)"):format(#pids, port, label or "adapter"))
  return #pids
end

local function force_disconnect()
  pcall(dap.terminate)

  vim.defer_fn(function()
    pcall(dap.disconnect, { terminateDebuggee = true })
    pcall(dap.close)
    sync_session_keymaps()
    Log.warn "DAP: session forcibly terminated"
  end, 300)
end

local function recover_dap()
  local info = get_active_adapter_info()

  force_disconnect()

  vim.defer_fn(function()
    if info and info.port then
      kill_port(info.port, info.type or "adapter")
    end

    vim.defer_fn(function()
      keymaps_active = false
      saved_maps = {}
      prune_dead_sessions()
      sync_session_keymaps()
      Log.info "DAP: recovery complete, try <Leader>dn again"
    end, 200)
  end, 400)
end

local function kill_all_known_adapter_ports()
  local known_ports = {
    { 8086, "osv/nlua" }, -- one-small-step-for-vimkind
    { 38697, "debugpy" }, -- nvim-dap-python (default)
    { 4711, "debugpy-alt" }, -- debugpy alternative
    { 12345, "delve" }, -- nvim-dap-go (default)
  }
  local total = 0
  for _, p in ipairs(known_ports) do
    total = total + kill_port(p[1], p[2])
  end
  if total == 0 then
    Log.info "DAP: tidak ada proses adapter di port umum"
  end
end

local function dap_status()
  local s = dap.session()

  local lines = {
    "DAP session: " .. (s and ("active (id=" .. tostring(s.id) .. ")") or "none"),
  }

  if s and s.adapter and s.adapter.port then
    lines[#lines + 1] = ("Adapter port: %d (%s)"):format(s.adapter.port, s.adapter.type or "?")
  end

  local known = { 8086, 38697, 4711, 12345 }
  for _, port in ipairs(known) do
    local busy = find_pids_on_port(port)
    if #busy > 0 then
      lines[#lines + 1] = ("Port %d: IN USE (pid: %s)"):format(port, table.concat(busy, ","))
    end
  end

  if #lines == 1 then
    lines[#lines + 1] = "No common adapter ports are in use"
  end

  Log.info(table.concat(lines, "\n"))
end

add_on_event("UIEnter", {
  {
    src = "jbyuki/one-small-step-for-vimkind",
    setup = false,
    on_setup = function()
      UtilKey.nnoremap("<Leader>dL", function()
        osv.launch { port = 8086 }
      end, { desc = "Debug: launch lua adapter", remap = true, force = true })
    end,
  },
})

local function edit_breakpoint()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]

  local bp = { condition = "", logMessage = "", hitCondition = "", line = lnum }
  for _, candidate in ipairs((dap_bps.get(bufnr) or {})[bufnr] or {}) do
    if candidate.line == lnum then
      bp = vim.tbl_extend("force", bp, candidate)
      break
    end
  end

  local fields = {
    { label = "Condition", key = "condition" },
    { label = "Hit Condition", key = "hitCondition" },
    { label = "Log Message", key = "logMessage" },
  }

  vim.ui.select(fields, {
    prompt = "Edit Breakpoint",
    format_item = function(f)
      return ("%s: %s"):format(f.label, bp[f.key] or "")
    end,
  }, function(f)
    if not f then -- dibatalkan
      return
    end
    bp[f.key] = vim.fn.input { prompt = f.label .. ": ", default = bp[f.key] or "" }
    dap.set_breakpoint(bp.condition, bp.hitCondition, bp.logMessage)
  end)
end

-- ┌─────────────────────────────────────────────────────────────────────────────┐
--                                     PLUGIN
-- └─────────────────────────────────────────────────────────────────────────────┘

add {
  {
    src = "mfussenegger/nvim-dap",
    setup = false,
    -- on_setup = setup_listeners,
    on_setup = function()
      setup_listeners()

      -- dap.adapters.nlua = function(callback, config)
      --   callback {
      --     type = "server",
      --     host = config.host or "127.0.0.1",
      --     port = config.port or 8086,
      --   }
      -- end
      dap.adapters.nlua = function(callback, config)
        local host, port = config.host or "127.0.0.1", config.port or 8086
        local tcp = vim.uv.new_tcp()
        if not tcp then
          return
        end

        tcp:connect(host, port, function(err)
          tcp:close()
          vim.schedule(function()
            if err then
              Log.error(("osv is not listening on %s:%d, run <Leader>dL in the target instance"):format(host, port))
              return
            end
            callback { type = "server", host = host, port = port }
          end)
        end)
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance (osv)",
          host = "127.0.0.1",
          port = 8086,
        },
      }
    end,
  },
  {
    src = "theHamsta/nvim-dap-virtual-text",
    setup = false,
  },
  {
    src = "leoluz/nvim-dap-go",
    module_name = "dap-go",
  },
  {
    src = "mfussenegger/nvim-dap-python",
    module_name = "dap-python",
    setup = false,
    on_setup = function()
      lazy("dap-python").setup "debugpy-adapter"
    end,
  },
  {
    src = "igorlfs/nvim-dap-view",
    module_name = "dap-view",
    opts = {
      winbar = {
        show_keymap_hints = true,
        sections = {
          "watches",
          "scopes",
          "exceptions",
          "repl",
          "sessions",
          "breakpoints",
          "threads",
          "console",
        },
        default_section = "threads",
      },
      windows = { size = 18 },
      switchbuf = "usetab,uselast",

      keymaps = {
        scopes = {
          toggle = { "<CR>", "<2-LeftMouse>" },
          jump_to_parent = "[[",
          set_value = "s",
        },
        watches = {
          toggle = { "<CR>", "<2-LeftMouse>" },
          jump_to_parent = "[[",
          set_value = "s",
          copy_value = "c",
          delete_expression = "d",
          append_expression = "a",
          insert_expression = "i",
          edit_expression = "e",
        },
        hover = {
          quit = "q",
          toggle = { "<CR>", "<2-LeftMouse>" },
          jump_to_parent = "[[",
          set_value = "s",
        },
        help = {
          quit = "q",
        },
        console = {
          next_session = "]s",
          prev_session = "[s",
        },
        threads = {
          toggle_subtle_frames = "t",
          filter = "f",
          invert_filter = "o",
          jump_to_frame = { "<CR>", "<2-LeftMouse>" },
          force_jump = "<C-w><CR>",
        },
        exceptions = {
          toggle_filter = { "<CR>", "<2-LeftMouse>" },
        },
        sessions = {
          switch_session = { "<CR>", "<2-LeftMouse>" },
        },
        breakpoints = {
          delete_breakpoint = "d",
          jump_to_breakpoint = { "<CR>", "<2-LeftMouse>" },
          force_jump = "<C-w><CR>",
        },
        base = {
          next_view = "gl",
          prev_view = "gh",
          jump_to_first = "gH",
          jump_to_last = "gL",
          help = "g?",
        },
      },
    },
  },
  {
    src = "jay-babu/mason-nvim-dap.nvim",
    setup = false,
    on_setup = function()
      if Plugin.has "mason-nvim-dap.nvim" then
        lazy("mason-nvim-dap").setup {
          automatic_installation = true,
          handlers = {
            python = function() end,
          },
          ensure_installed = { "delve" },
        }
      end

      local vscode = lazy "dap.ext.vscode"
      local json = lazy "plenary.json"
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
}

vim.fn.sign_define {
  {
    name = "DapBreakpoint",
    texthl = "DapBreakpoint",
    -- linehl = "DapBreakpointLine",
    text = IconsDebug.Breakpoint,
  },
  {
    name = "DapBreakpointCondition",
    texthl = "DapBreakpointCondition",
    text = IconsDebug.BreakpointCondition,
  },
  {
    name = "DapStopped",
    texthl = "DapStoppedIcon",
    numhl = "DapStopped",
    linehl = "DapStoppedLine",
    text = IconsDebug.Stopped,
  },
  {
    name = "DapBreakpointRejected",
    texthl = "DapBreakpointRejected",
    numhl = "DapBreakpointRejected",
    linehl = "DapBreakpointRejectedLine",
    text = IconsDebug.BreakpointRejected,
  },
}

-- ────────────────────────────────────────────────────────────────────────────────
-- ╒═════════════════════════════════════════════════════════════════════════════╕
--        - TAKEN FROM: https://igorlfs.github.io/nvim-dap-view/completion
-- ╘═════════════════════════════════════════════════════════════════════════════╛
---@param line integer?
---@diagnostic disable-next-line: undefined-doc-name
---@return dap.bp?
local function get_breakpoint_by_line(line)
  local line_ = line or vim.api.nvim_win_get_cursor(0)[1]
  local buf = vim.api.nvim_get_current_buf()
  local breakpoints = lazy("dap.breakpoints").get(buf)
  local breakpoint = vim.iter(breakpoints[buf] or {}):find(function(bp)
    ---@diagnostic disable-next-line: undefined-field
    return bp.line == line_
  end)

  return breakpoint
end

local function set_breakpoint_conditional()
  local default = get_breakpoint_by_line()

  vim.ui.input({
    prompt = "Breakpoint condition: ",
    -- Note that the function is not called directly
    completion = "customlist,v:lua.require'dap-view'.complete",
    ---@diagnostic disable-next-line: undefined-field
    default = default and default.condition,
  }, function(input)
    if input then
      dap.set_breakpoint(input)
    end
  end)
end

local function set_log_point()
  local default = get_breakpoint_by_line()

  vim.ui.input({
    prompt = "Log point message: ",
    completion = "customlist,v:lua.require'dap-view'.complete",
    ---@diagnostic disable-next-line: undefined-field
    default = default and default.logMessage,
  }, function(input)
    if input then
      dap.set_breakpoint(nil, nil, input)
    end
  end)
end
-- ────────────────────────────────────────────────────────────────────────────────

-- ┌─────────────────────────────────────────────────────────────────────────────┐
--                                     KEYMAPS
-- └─────────────────────────────────────────────────────────────────────────────┘

UtilAugroup("dap_options", {
  event = "FileType",
  pattern = "dap-view",
  command = function()
    vim.wo[0][0].listchars = "space: ,tab:   "
  end,
  desc = "Set options for DAP UI",
})

local function open_debug_commands()
  local debug_cmds = {
    ["Breakpoint - breakpoint with conditions"] = edit_breakpoint,
    ["Breakpoint - breakpoint clear all"] = dap.clear_breakpoints,
    --stylua: ignore
    ["Breakpoint - breakpoints send to qf"] = function() dap.list_breakpoints(true) end,
    ["Cursor - go to line"] = dap.goto_,
    ["Run - run at cursor"] = dap.run_to_cursor,
    ["Run - run last"] = dap.run_last,
    --stylua: ignore
    ["Run - run with arguments"] = function() dap.continue { before = get_args } end,
    ["Run - run / start / continue"] = safe_continue,
    ["Run - restart"] = recover_dap,
    ["Run - quit / close / terminate the debug session"] = quit_dap,
    --stylua: ignore
    ["Run - printout or show the session"] = function() Log.info(vim.inspect(dap.session(), { depth = 2 })) end,
    ["REPL - toggle dap REPL"] = dap.repl.toggle,
    ["GUI - toggle dap GUI"] = dv.toggle,
  }

  if vim.bo.filetype == "lua" then
    debug_cmds["DebugLSP - run launch attach debug PORT 8086 [Nlua]"] = function()
      osv.launch { port = 8086 }
    end
  end

  if vim.bo.filetype == "python" then
    debug_cmds["DebugLSP - run debug python method"] = function()
      lazy("dap-python").test_method()
    end
    debug_cmds["DebugLSP - run debug python class"] = function()
      lazy("dap-python").test_class()
    end
  end

  util_fzflua.open_cmd_bulk_center(debug_cmds, {
    winopts = {
      title = string.format(" %s Debug Commands ", IconsDebug.BreakpointCondition),
    },
  })
end

local cmds = {
  --stylua: ignore
  { "<Leader>dl", function() dap.run_last() end, "run last" },
  --stylua: ignore
  { "<Leader>dbb", function() dap.toggle_breakpoint() end, "toggle breakpoint" },
  --stylua: ignore
  { "<Leader>dbC", function() dap.clear_breakpoints() end, "clear all breakpoint" },
  --stylua: ignore
  { "<Leader>dbc", set_breakpoint_conditional, "conditional breakpoint" },
  --stylua: ignore
  { "<Leader>dbl", set_log_point,"set log breakpoint" },
  --stylua: ignore
  { "<Leader>dbf", function() fzf.dap_breakpoints() end, "list breakpoints (fzflua)" },
  --stylua: ignore
  { "<Leader>dn", safe_continue, "run/start/continue" },
  { "<Leader>dR", recover_dap, "recovery session & adapter" },
  { "<Leader>dK", kill_all_known_adapter_ports, "kill all known adapter ports" },
  { "<Leader>dS", dap_status, "check status session & port" },
  --stylua: ignore
  { "<Leader>dC", quit_dap, "quit/close" },
  --stylua: ignore
  { "<S-Down>", function() if has_session() then dap.down() else move_line(vim.v.count1) end end, "step down (stack)" },
  --stylua: ignore
  { "<S-Up>", function() if has_session() then dap.up() else move_line(-vim.v.count1 - 1) end end, "step up (stack)" },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], cmd[2], { desc = ("Debug: %s [nvim-dap]"):format(cmd[3]) })
end

UtilKey.nnoremap("<Leader>dF", open_debug_commands, { desc = "Bulk: debug commands" })
--stylua: ignore
UtilKey.nnoremap("<Leader>duu", function() dv.toggle() end, { desc = "Toggle: gui" })
