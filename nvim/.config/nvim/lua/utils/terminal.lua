local Plugin = require "utils.plugin"
local Layout = require "utils.layout"

local Log = require "utils.log"

local has_ergoterm = Plugin.has "ergoterm.nvim"

---@alias WrapCmdOpts {cmd?: string, name?:string, layout?:string, is_toggle: boolean?}

local M = setmetatable({}, {
  __call = function(m, ...)
    return m.open(...)
  end,
})

local base_term = {}

local load_egoterm = function()
  require("vim-pack").load_now "ergoterm.nvim"
end

local term_package = {
  ["ergoterm"] = {
    get = function(opts)
      load_egoterm()
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

---@param opts WrapCmdOpts
function M.wrap_open_cmd(opts)
  opts = opts or {}

  if not has_ergoterm then
    Log.warn "ergoterm is not installed"
    return
  end

  if not opts.is_toggle or opts.name == nil then
    return term_package.ergoterm.get(opts)
  end

  if not base_term[opts.name] then
    local term_opts = vim.tbl_deep_extend("force", {
      cmd = "zsh",
    }, opts)

    base_term[opts.name] = term_package.ergoterm.get(term_opts)
  end

  return base_term[opts.name]
end

---@param opts WrapCmdOpts
local function open_new_terminal(opts)
  local t = M.wrap_open_cmd(opts)
  if t then
    t:toggle()
  end
end

function M.float_calcure()
  local t = M.wrap_open_cmd {
    name = "calcure",
    cmd = " calcure",
    layout = "float",
    is_toggle = false,
  }

  if t then
    t:toggle()
  end
end

function M.float_note()
  open_new_terminal {
    name = "Notes Wiki",
    dir = "~/Dropbox/neorg/",
    cmd = " nvim",
    layout = "float",
    is_toggle = true,
  }
end

function M.float_newsboat()
  open_new_terminal {
    name = "newsboat",
    cmd = [[newsboat -u ~/Dropbox/data.programming.forprivate/newsboat-urls]],
    layout = "float",
    is_toggle = true,
  }
end

function M.float_btop()
  open_new_terminal {
    name = "btop",
    cmd = "btop",
    layout = "float",
    is_toggle = true,
  }
end

function M.float_resterm()
  open_new_terminal {
    name = "Resterm",
    cmd = "resterm",
    layout = "float",
  }
end

function M.float_rkill()
  open_new_terminal {
    name = "Rkill",
    cmd = [[bash -i -c "r_kill"]],
    layout = "float",
    is_toggle = true,
  }
end

function M.lazydocker()
  open_new_terminal {
    name = "Lazydocker",
    cmd = "lazydocker",
    layout = "float",
    is_toggle = true,
  }
end

function M.lazygit()
  open_new_terminal {
    name = "Lazygit",
    cmd = [[lazygit --use-config-file=$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme/fla.yml]],
    layout = "float",
    is_toggle = true,
  }
end

local select_layout_terminal_cmd = {
  ["clock"] = {
    get = function()
      open_new_terminal {
        name = "STerm Tclock",
        cmd = "timr-tui",
        is_toggle = true,
        layout = "window",
      }
    end,
  },
  ["pomodoro"] = {
    get = function(timer)
      open_new_terminal {
        name = "STerm Tclock Pomodoro",
        cmd = "tclock -c red timer -d " .. timer .. " -M",
        layout = "window",
      }
    end,
  },
}

---Helper to open clock mode in terminal
---@param select_command string
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

      vim.api.nvim_win_resize(clock_win, 10, -1, { anchor = "left" })

      local mode_clock_name
      if type(select_command) == "table" then
        mode_clock_name = "pomodoro"
        select_layout_terminal_cmd["pomodoro"].get(select_command.pomodoro.timer)
      else
        mode_clock_name = "clock"
        select_layout_terminal_cmd["clock"].get()
      end

      -- Needed because many terminal plugins use scheduled callbacks.
      -- Even after leaving the terminal window, they may still restore
      -- or keep terminal/insert mode active.
      vim.defer_fn(function()
        if curwin and vim.api.nvim_win_is_valid(curwin) then
          vim.api.nvim_set_current_win(curwin) -- after toggle term, focus curwin now
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
        end
      end, 100)

      vim.schedule(function()
        vim.cmd "stopinsert"
      end)

      -- always renew clock win
      Layout.update_win_layout(mode_clock_name, clock_win)
    end)
  end)
end

---@param select_command table|string
---@param is_toggle? boolean
function M.clock_mode(select_command, is_toggle)
  is_toggle = is_toggle or false
  select_command = select_command or "clock"

  local main_layout = Layout.get_Win()
  if not main_layout.layout then
    Log.warn "field `layout` is missing or get renewed, check file`layout.lua`"
    return
  end

  local clock_win = Layout.get_support_win_layout()
  local curwin = vim.api.nvim_get_current_win()

  if is_toggle then
    if type(select_command) == "string" and clock_win[select_command] then
      Layout.close_support_window(select_command)
      return
    end
  end

  -- if clock_win and vim.api.nvim_win_is_valid(clock_win) then
  --   open_clock(main_layout.win, curwin, clock_win)
  --   return
  -- end

  local current_tab = vim.fn.tabpagenr()
  local main = main_layout.layout[current_tab]

  if not main or not main.win or not vim.api.nvim_win_is_valid(main.win) then
    Log.warn "`main.win` is invalid or dead, create a new one!"
    return
  end
  open_clock(select_command, main.win, curwin)
end

--- For layout caller command --> check layout.lua
function M.open_clock()
  M.clock_mode "clock"
end

function M.open_smart_split()
  Log.warn "not implemented yet"
end

---@param cwd string?
function M.open_terminal_in_filetree(cwd)
  local opts = {}

  cwd = cwd or nil
  local parent_dir
  if cwd then
    parent_dir = vim.fn.fnamemodify(cwd, ":h")
  else
    parent_dir = vim.uv.cwd()
  end

  if not parent_dir then
    return
  end

  opts.name = "   " .. vim.fn.fnamemodify(parent_dir, ":~")
  opts.dir = parent_dir
  opts.layout = "float"

  vim.g.open_terminal_in_filetree = true

  open_new_terminal(opts)
end

function M.open_float()
  local function open_term()
    if vim.g.open_terminal_in_filetree then
      return
    end

    local t = M.wrap_open_cmd {
      name = "Float Term",
      layout = "float",
    }

    if t then
      t:toggle()
    end
  end

  if not vim.g.open_terminal_in_filetree then
    open_term()
    return
  end

  vim.ui.input({
    prompt = "Terminal filetree is opened, kill anyway? (y/n) ",
  }, function(input)
    if input ~= "y" then
      return
    end

    vim.g.open_terminal_in_filetree = false
    open_term()
  end)
end

function M.open_right()
  open_new_terminal {
    layout = "right",
  }
end

function M.open_below()
  open_new_terminal {
    layout = "below",
  }
end

function M.tab_term()
  open_new_terminal {
    layout = "tab",
  }
end

function M.toggle_term()
  open_new_terminal {
    name = "vterm",
    layout = "below",
    is_toggle = true,
  }
end

return M
