---@overload fun(cmd: string|string[], opts: LazyTermOpts): LazyFloat
---@class r.utils.terminal
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.open(...)
  end,
})

---@type table<string,LazyFloat>
local terminals = {}

---@param shell? string
function M.setup(shell)
  vim.o.shell = shell or vim.o.shell

  -- Special handling for pwsh
  if shell == "pwsh" or shell == "powershell" then
    -- Check if 'pwsh' is executable and set the shell accordingly
    if vim.fn.executable "pwsh" == 1 then
      vim.o.shell = "pwsh"
    elseif vim.fn.executable "powershell" == 1 then
      vim.o.shell = "powershell"
    else
      return RUtils.error "No powershell executable found"
    end

    -- Setting shell command flags
    vim.o.shellcmdflag =
      "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"

    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'

    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'

    -- Setting shell quote options
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end
end

---@class LazyTermOpts: LazyCmdOptions
---@field interactive? boolean
---@field esc_esc? boolean
---@field ctrl_hjkl? boolean

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyTermOpts
function M.open(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.9, height = 0.9 },
    backdrop = RUtils.has "edgy.nvim" and not cmd and 100 or nil,
  }, opts or {}, { persistent = true }) --[[@as LazyTermOpts]]

  local termkey = vim.inspect { cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 }

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require("lazy.util").float_term(cmd, opts)
    local buf = terminals[termkey].buf
    vim.b[buf].lazyterm_cmd = cmd
    if opts.esc_esc == false then
      vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
    end
    if opts.ctrl_hjkl == false then
      vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end

  return terminals[termkey]
end

local function win_width_term()
  return vim.fn.winwidth(0)
end

local function win_height_term()
  return vim.fn.winheight(0)
end

local term_win = {
  main_toggle = {
    bufnr = 0,
    winnr = 0,
  },
  misc_toggle = {},
  clock_mode = {
    bufnr = 0,
    winnr = 0,
  },
}

local function __open_term()
  local term = RUtils.cmd.windows_is_opened { "terminal" }
  if not term.found then
    local wins_togal = RUtils.cmd.get_total_wins()

    if #wins_togal == 1 then
      if RUtils.has "termim.nvim" then
        vim.cmd.Vterm()
      end
      if RUtils.has "nvim-toggleterm.lua" then
        vim.cmd.ToggleTerm()
      end
      vim.cmd.startinsert()
      vim.api.nvim_win_set_width(0, 50)
    elseif #wins_togal > 1 then
      if RUtils.has "termim.nvim" then
        vim.cmd.Vterm()
      end
      if RUtils.has "nvim-toggleterm.lua" then
        vim.cmd.ToggleTerm()
      end
      vim.cmd.startinsert()
      vim.cmd [[wincmd L]]
      vim.api.nvim_win_set_width(0, 50)
    end

    term_win.main_toggle.bufnr = vim.api.nvim_get_current_buf()
    term_win.main_toggle.winnr = vim.api.nvim_win_get_number(vim.api.nvim_get_current_win())
  end
end

function M.toggle_right_term()
  if (vim.bo.filetype == "" and vim.bo.buftype == "terminal") or vim.bo.filetype == "toggleterm" then
    if win_width_term() < 50 then
      vim.api.nvim_win_set_width(0, 50)
    end
    vim.cmd [[wincmd h]]
    return
  end

  __open_term()

  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    local winbufnr = vim.fn.winbufnr(vim.api.nvim_win_get_number(winid))
    if winbufnr == term_win.main_toggle.bufnr then
      vim.api.nvim_set_current_win(winid)
      break
    end
  end

  if win_width_term() > 50 then
    vim.api.nvim_win_set_width(0, 50)
  end

  if win_height_term() < 50 then
    vim.api.nvim_win_set_height(0, 45)
  end
end

function M.clock_mode()
  M.toggle_right_term()
  local sterm_ok, _ = pcall(require, "sterm")
  if sterm_ok then
    vim.cmd [[STerm tclock clock -S]]
  end

  local toggleterm_ok, _ = pcall(require, "toggleterm")
  if toggleterm_ok then
    vim.cmd [[TermExec dir=vertical size=50 cmd="tclock clock -S"]]
  end

  if win_height_term() > 10 then
    vim.api.nvim_win_set_height(0, 10)
    vim.cmd [[wincmd k]]
    vim.cmd [[wincmd h]]
    RUtils.map.feedkey("<esc>", "n")
  end
end

function M.smart_split()
  if win_width_term() > win_height_term() then
    if win_width_term() > win_height_term() then
      vim.cmd [[ToggleTerm direction=horizontal]]
    else
      vim.cmd [[ToggleTerm direction=vertical]]
    end
  else
    vim.cmd [[ToggleTerm direction=float]]
  end
end

local Terminal = require("toggleterm.terminal").Terminal

local calcure = Terminal:new {
  cmd = "calcure",
  hidden = true,
  display_name = ("calcure"):upper(),
  direction = "float",
  on_open = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.cmd [[startinsert]]
  end,
  float_opts = { width = vim.o.columns - 10, height = vim.o.lines - 10 },
}

local newsboat = Terminal:new {
  cmd = "proxychains -q newsboat",
  display_name = ("proxychains"):upper(),
  hidden = true,
  direction = "float",
  on_open = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.cmd [[startinsert]]
  end,
  float_opts = { width = vim.o.columns - 5, height = vim.o.lines - 5 },
}

local btop = Terminal:new {
  cmd = "btop",
  hidden = true,
  display_name = ("btop"):upper(),
  direction = "float",
  start_in_insert = true,
  on_open = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.cmd [[startinsert]]
  end,
  float_opts = { width = vim.o.columns - 10, height = vim.o.lines - 10 },
}

local lazydocker = Terminal:new {
  cmd = "lazydocker",
  hidden = true,
  display_name = ("lazydocker"):upper(),
  direction = "float",
  on_open = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.cmd [[startinsert]]
  end,
  float_opts = { width = vim.o.columns - 10, height = vim.o.lines - 10 },
}

local rkill = Terminal:new {
  -- to run alias, must have `source` the zshrc file
  cmd = "rkll",
  hidden = true,
  display_name = ("r_kill"):upper(),
  direction = "float",
  on_open = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.cmd [[startinsert]]
  end,
  float_opts = { width = vim.o.columns - 10, height = vim.o.lines - 10 },
  close_on_exit = false,
}

function M.float_calcure()
  return calcure:toggle()
end

local base_term = nil

local open_term_with_singleton = function(is_new, direction)
  direction = direction or "float"
  is_new = is_new or false

  if not base_term and not is_new then
    local terms = require "ergoterm.terminal"
    base_term = terms.Terminal:new {
      name = "Notes Wiki",
      cmd = "cd ~/Dropbox/neorg/; nvim",
      layout = direction,
    }
  end

  return base_term
end

function M.float_note()
  local t = open_term_with_singleton()
  if t then
    t:toggle()
  end
end

function M.float_newsboat()
  return newsboat:toggle()
end

function M.float_btop()
  return btop:toggle()
end

function M.float_rkill()
  return rkill:toggle()
end

function M.lazydocker()
  return lazydocker:toggle()
end

return M
