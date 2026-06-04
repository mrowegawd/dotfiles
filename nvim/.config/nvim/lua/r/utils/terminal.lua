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
      "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"

    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'

    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'

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

local base_term = nil

local term_package = {
  ["ergoterm"] = {
    get = function(opts)
      local terms = require "ergoterm"
      return terms.Terminal:new(opts)
    end,
  },
  ["toggleterm"] = {
    get = function(opts)
      local terms = require "toggleterm"
      return terms.Terminal:new(opts)
    end,
  },
}

---@param opts? {cmd?: string, name?:string, layout?:string}
---@param is_new? boolean
function M.wrap_open_cmd(opts, is_new)
  is_new = is_new or false
  opts = opts or {}

  local has_ergoterm = RUtils.has "ergoterm.nvim"
  -- local has_toggleterm = RUtils.has "nvim-toggleterm.lua"

  local base_term_opts = {}
  if has_ergoterm then
    base_term_opts = { cmd = "zsh" }
  end

  local term_opts = vim.tbl_deep_extend("force", base_term_opts, opts)
  if is_new then
    term_opts = opts
  end

  if is_new then
    if has_ergoterm then
      return term_package["ergoterm"].get(term_opts)
    end
  end

  if not base_term and not is_new then
    if has_ergoterm then
      base_term = term_package["ergoterm"].get(term_opts)
    end
  end

  return base_term
end

function M.float_calcure()
  local t = M.wrap_open_cmd({
    name = "calcure",
    cmd = " calcure",
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.float_note()
  local t = M.wrap_open_cmd({
    name = "Notes Wiki",
    dir = "~/Dropbox/neorg/",
    cmd = " nvim",
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.float_newsboat()
  local t = M.wrap_open_cmd({
    name = "newsboat",
    cmd = "newsboat",
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.float_btop()
  local t = M.wrap_open_cmd({
    name = "btop",
    cmd = "btop",
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.float_resterm()
  local t = M.wrap_open_cmd({
    name = "resterm",
    cmd = "resterm",
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.float_rkill()
  local t = M.wrap_open_cmd({
    name = "Rkill",
    cmd = [[bash -i -c "r_kill"]],
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.lazydocker()
  local t = M.wrap_open_cmd({
    name = "Lazydocker",
    cmd = "lazydocker",
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

function M.lazygit()
  local t = M.wrap_open_cmd({
    name = "Lazygit",
    cmd = [[lazygit --use-config-file=$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme/fla.yml]],
    layout = "float",
  }, true)

  if t then
    t:toggle()
  end
end

local select_layout_terminal_cmd = {
  ["clock"] = {
    get = function()
      local t = M.wrap_open_cmd({
        name = "STerm Tclock",
        cmd = "tclock clock -S",
        layout = "window",
      }, true)
      if t then
        t:toggle()
      end
    end,
  },
  ["pomodoro"] = {
    get = function(timer)
      local t = M.wrap_open_cmd({
        name = "STerm Tclock Pomodor",
        cmd = "tclock -c red timer -d " .. timer .. " -M",
        layout = "window",
      }, true)
      if t then
        t:toggle()
      end
    end,
  },
}

---Helper to open clock mode in terminal
---@param select_command {pomodoro: {timer: string}} | "clock"
---@param main_win integer
---@param curwin integer
---@param clock_win? integer
local function open_clock(select_command, main_win, curwin, clock_win)
  clock_win = clock_win or nil

  if not main_win or not vim.api.nvim_win_is_valid(main_win) then
    return
  end

  if not curwin or not vim.api.nvim_win_is_valid(curwin) then
    return
  end

  vim.schedule(function()
    vim.api.nvim_win_call(main_win, function()
      vim.api.nvim_set_current_win(main_win)

      vim.cmd "split"

      if clock_win == nil then
        clock_win = vim.api.nvim_get_current_win()
      end

      vim.api.nvim_win_set_height(clock_win, 10)

      local mode_clock_name
      if type(select_command) == "table" then
        mode_clock_name = "pomodoro"
        select_layout_terminal_cmd["pomodoro"].get(select_command.pomodoro.timer)
      else
        mode_clock_name = "clock"
        select_layout_terminal_cmd["clock"].get()
      end

      if curwin and vim.api.nvim_win_is_valid(curwin) then
        vim.api.nvim_set_current_win(curwin) -- after toggle term, focus curwin now

        -- Needed because many terminal plugins use scheduled callbacks.
        -- Even after leaving the terminal window, they may still restore
        -- or keep terminal/insert mode active.
        vim.defer_fn(function()
          vim.api.nvim_set_current_win(curwin) -- make sure again the current win is `curwin`
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
        end, 250)

        -- always renew clock win
        RUtils.layout.update_win_layout(mode_clock_name, clock_win)
      end
    end)
  end)
end

---@param select_command? {pomodoro: {timer: string}} | "clock"
function M.clock_mode(select_command)
  select_command = select_command or "clock"

  local main_layout = RUtils.layout.get_Win()
  if not main_layout.layout then
    RUtils.warn "field `layout` is missing or get renewed, check file`layout.lua`"
    return
  end

  local clock_win = RUtils.layout.get_win_clock_layout()

  local curwin = vim.api.nvim_get_current_win()

  if clock_win and vim.api.nvim_win_is_valid(clock_win) then
    open_clock(main_layout.win, curwin, clock_win)
    return
  end

  local current_tab = vim.fn.tabpagenr()
  local main = main_layout.layout[current_tab]

  if not main.win or not vim.api.nvim_win_is_valid(main.win) then
    RUtils.warn "`main.win` is invalid or dead, create a new one!"
    return
  end
  open_clock(select_command, main.win, curwin)
end

function M.open_smart_split()
  RUtils.warn "not implemented yet"
end

---@param cwd string
function M.open_terminal_in_filetree(cwd)
  cwd = cwd or nil
  local opts = {}

  if cwd then
    opts.name = "Path: " .. vim.fn.fnamemodify(cwd, ":t")
    opts.cwd = cwd
    opts.layout = "float"
  end

  vim.g.open_terminal_in_filetree = true

  local t = M.wrap_open_cmd(opts, true)
  if t then
    t:toggle()
  end
end

function M.open_float()
  local function __open_term_wrapper()
    if vim.g.open_terminal_in_filetree == nil or not vim.g.open_terminal_in_filetree then
      local t = M.wrap_open_cmd {
        name = "Float Term",
        layout = "float",
      }
      if t then
        t:toggle()
      end
    end
  end

  if vim.g.open_terminal_in_filetree then
    vim.ui.input({
      prompt = "Terminal filetree is opened, kill anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.g.open_terminal_in_filetree = false
        __open_term_wrapper()
      end
    end)
  end

  __open_term_wrapper()
end

function M.open_right()
  local t = M.wrap_open_cmd({
    layout = "right",
  }, true)
  if t then
    t:toggle()
  end
end

function M.open_below()
  local t = M.wrap_open_cmd({
    layout = "below",
  }, true)
  if t then
    t:toggle()
  end
end

function M.tab_term()
  local t = M.wrap_open_cmd({
    layout = "tab",
  }, true)
  if t then
    t:toggle()
  end
end

function M.toggle_term()
  local t = M.wrap_open_cmd {
    layout = "below",
  }
  if t then
    t:toggle()
  end
end

return M
