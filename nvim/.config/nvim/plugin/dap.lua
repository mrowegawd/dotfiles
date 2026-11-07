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

  dap.listeners.before.attach[LISTENER_ID] = function()
    dv.open()
  end
  dap.listeners.before.launch[LISTENER_ID] = function()
    dv.open()
  end
  dap.listeners.before.event_terminated[LISTENER_ID] = function()
    dv.close()
  end
  dap.listeners.before.event_exited[LISTENER_ID] = function()
    dv.close()
  end
end

local function quit_dap()
  local s = dap.session()
  if not s then
    return
  end
  dap.terminate()
  vim.defer_fn(function()
    if dap.session() == s then
      pcall(dap.disconnect, { terminateDebuggee = true })
      pcall(dap.close)
    end
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

add {
  {
    src = "mfussenegger/nvim-dap",
    setup = false,
    on_setup = setup_listeners,
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
        threads = {
          filter = "s",
          toggle_subtle_frames = "i",
        },
        watches = {
          edit_expression = "x",
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

UtilAugroup("dap_options", {
  event = "FileType",
  pattern = "dap-view",
  command = function()
    vim.wo[0][0].listchars = "space: ,tab:   "
  end,
  desc = "Set options for DAP UI",
})

vim.fn.sign_define {
  {
    name = "DapBreakpoint",
    texthl = "DapBreakpoint",
    text = IconsDebug.Breakpoint,
  },
  {
    name = "DapStopped",
    texthl = "DapStoppedIcon",
    numhl = "DapStopped",
    linehl = "DapStopped",
    text = IconsDebug.Stopped,
  },
  {
    name = "DapBreakpointRejected",
    texthl = "DapBreakpointRejected",
    numhl = "DapBreakpointRejected",
    linehl = "DapBreakpointRejected",
    text = IconsDebug.BreakpointRejected,
  },
}

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

local function open_debug_commands()
  local debug_cmds = {
    ["Breakpoint - breakpoint with conditions"] = edit_breakpoint,
    ["Breakpoint - breakpoint clear all"] = function()
      dap.clear_breakpoints()
    end,
    ["Breakpoint - breakpoints send to qf"] = function()
      dap.list_breakpoints(true)
    end,
    ["Cursor - go to line"] = function()
      dap.goto_()
    end,
    ["Run - run at cursor"] = function()
      dap.run_to_cursor()
    end,
    ["Run - run last"] = function()
      dap.run_last()
    end,
    ["Run - run with arguments"] = function()
      dap.continue { before = get_args }
    end,
    ["Run - run / start / continue"] = function()
      dap.continue()
    end,
    ["Run - quit / close / terminate the debug session"] = quit_dap,
    ["Run - printout or show the session"] = function()
      Log.info(vim.inspect(dap.session(), { depth = 2 }))
    end,
    ["REPL - toggle dap REPL"] = function()
      dap.repl.toggle()
    end,
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

local function move_line(delta)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.cmd.move(tostring(line + delta))
  pcall(function()
    vim.cmd.normal { args = { "zO" }, bang = true, mods = { silent = true } }
  end)
end

local cmds = {
  --stylua: ignore
  { "<Leader>dl", function() dap.run_last() end, "run last" },
  --stylua: ignore
  { "<Leader>db", function() dap.toggle_breakpoint() end, "toggle breakpoint" },
  --stylua: ignore
  { "<Leader>dB", function() dap.clear_breakpoints() end, "clear all breakpoint" },
  --stylua: ignore
  { "<Leader>dc", function() dap.set_breakpoint(vim.fn.input "Breakpoint condition: ") end, "conditional breakpoint" },
  --stylua: ignore
  { "<Leader>df", function() fzf.dap_breakpoints() end, "list breakpoints (fzflua)" },
  --stylua: ignore
  { "<Leader>dn", function() dap.continue() end, "run/start/continue" },
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
