local M = {}

local fn, fmt, icons, falsy = vim.fn, string.format, as.ui.icons, as.falsy

local state = { lsp_clients_visible = true }

local function status_dap()
  local ok, dap = pcall(require, "dap")

  if not ok then
    return ""
  end

  return dap.status()
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 120
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  width_percent_below = function(n, thresh, is_winbar)
    local winwidth
    if vim.o.laststatus == 3 and not is_winbar then
      winwidth = vim.o.columns
    else
      winwidth = vim.api.nvim_win_get_width(0)
    end

    return n / winwidth <= thresh
  end,

  debugger_status_run = function()
    if #status_dap() > 0 then
      return false
    else
      return true
    end
  end,
}

-- local color = vim.api.nvim_get_hl(0, { name = "Normal" })
-- local bg_filename = string.format("#%06x", color.fg)

local gstatus = { ahead = 0, behind = 0 }
local exclude = {
  ["NvimTree"] = true,
  ["capture"] = true,
  ["dap-repl"] = true,
  ["dap-terminal"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_console"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
  ["help"] = true,
  ["mind"] = true,
  ["neo-tree"] = true,
  ["noice"] = true,
  ["prompt"] = true,
  ["scratch"] = true,
  ["terminal"] = true,
  ["toggleterm"] = true,
  ["TelescopePrompt"] = true,
} -- Ignore float windows and exclude filetype

local function update_gstatus()
  local Job = require "plenary.job"
  Job:new({
    command = "git",
    args = { "rev-parse", "--abbrev-ref", "HEAD" },
    on_exit = function(job, _)
      local head = job:result()[1]
      if not head then
        return
      end
      Job:new({
        command = "git",
        args = {
          "rev-list",
          "--left-right",
          "--count",
          head .. "...origin/" .. head,
        },
        on_exit = function(_job, _)
          local res = _job:result()[1]
          if type(res) ~= "string" then
            return
          end
          local ok, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")
          if ok then
            gstatus = { ahead = ahead, behind = behind }
          end
        end,
      }):start()
    end,
  }):start()
end

if _G.Gstatus_timer == nil then
  _G.Gstatus_timer = vim.uv.new_timer()
else
  _G.Gstatus_timer:stop()
end

_G.Gstatus_timer:start(0, 2000, vim.schedule_wrap(update_gstatus))

M.mode = function()
  return {
    function()
      -- local mode_color = {
      --     n = colors.dark_green,
      --     i = colors.blue,
      --     v = colors.dark_green,
      --     [""] = colors.pale_pink,
      --     V = colors.bright_yellow,
      --     -- c = colors.white,
      --     -- no = colors.red,
      --     -- s = colors.orange,
      --     -- S = colors.orange,
      --     -- [""] = colors.orange,
      --     -- ic = colors.yellow,
      --     -- R = colors.violet,
      --     -- Rv = colors.violet,
      --     -- cv = colors.red,
      --     -- ce = colors.red,
      --     -- r = colors.cyan,
      --     -- rm = colors.cyan,
      --     -- ["r?"] = colors.cyan,
      --     -- ["!"] = colors.red,
      --     -- t = colors.red,
      -- }

      local alias = { n = "N", i = "I", c = "C", V = "V", [""] = "V", t = "T" }
      return fmt("   %s", alias[vim.fn.mode()])
    end,
    color = { gui = "bold" },
  }
end
M.branch = function()
  return {
    "branch",
    icon = "",
    color = { gui = "bold", fg = "cyan" },
    -- cond = conditions.hide_in_width,
  }
end
M.diff = function()
  return {
    "diff",

    symbols = {
      added = icons.git.add,
      modified = icons.git.mod,
      removed = icons.git.remove,
    },

    source = function()
      ---@diagnostic disable-next-line: undefined-field
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
    -- cond = conditions.hide_in_width,
  }
end
M.diffbranch = function()
  return {
    function()
      return gstatus.ahead .. " " .. gstatus.behind .. ""
    end,
    color = {},
  }
end
M.filetype = function()
  return {
    "filetype",
    cond = conditions.debugger_status_run,
  }
end
M.filename = function()
  return {
    function()
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
      if not conditions.width_percent_below(#filename, 0.40) then
        filename = vim.fn.pathshorten(filename)
      end
      return fmt("%s", filename)
    end,

    -- "filename",
    -- path = 4,
    color = {
      gui = "bold", --[[ bg = bg_filename, ]]
      fg = "lightgrey",
    },
  }
end
M.file_modified = function()
  return {
    function()
      local modified = vim.bo[0].modified
      local nomodified = vim.bo[0].readonly

      local ft_modified = ""

      if modified then
        ft_modified = " ✘ "
      elseif nomodified then
        ft_modified = "  "
      else
        ft_modified = " "
      end
      return ft_modified
    end,
    padding = { left = 0 },
    color = { fg = "red" },
  }
end
M.location = function()
  return {
    "location",
  }
end
M.location_mod = function()
  return {
    function()
      local rhs = ""

      if vim.fn.winwidth(0) > 80 then
        local column = vim.fn.virtcol "."
        local width = vim.fn.virtcol "$"
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local height = vim.api.nvim_buf_line_count(0)

        -- Add padding to stop RHS from changing too much as we move the cursor.
        local padding = #tostring(height) - #tostring(line)
        if padding > 0 then
          rhs = rhs .. (" "):rep(padding)
        end

        rhs = rhs .. "ℓ " -- (Literal, \u2113 "SCRIPT SMALL L").
        rhs = rhs .. line
        rhs = rhs .. "/"
        rhs = rhs .. height
        rhs = rhs .. " 𝚌 " -- (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
        rhs = rhs .. column
        rhs = rhs .. "/"
        rhs = rhs .. width
        rhs = rhs .. " "

        -- Add padding to stop rhs from changing too much as we move the cursor.
        if #tostring(column) < 2 then
          rhs = rhs .. " "
        end
        if #tostring(width) < 2 then
          rhs = rhs .. " "
        end
      end

      return rhs
    end,
    -- cond = conditions.hide_in_width,
  }
end
M.progress = function()
  return {
    "progress",
    -- color = { fg = col_fg, gui = "bold" }
  }
end
M.diagnostics = function()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = icons.diagnostics.error,
      warn = icons.diagnostics.warn,
      info = icons.diagnostics.info,
      hint = icons.diagnostics.hint,
    },
  }
end
M.mid_sec = function()
  return {
    function()
      -- make center statusline
      return "%="
    end,
  }
end
M.treesitter = function()
  return {
    function()
      local b = vim.api.nvim_get_current_buf()
      if next(vim.treesitter.highlighter.active[b]) then
        return ""
      end
      return ""
    end,
    color = { fg = "green" },
    cond = conditions.hide_in_width,
  }
end
M.python_env = function()
  return {
    function()
      local function env_cleanup(venv)
        if string.find(venv, "/") then
          local final_venv = venv
          for w in venv:gmatch "([^/]+)" do
            final_venv = w
          end
          venv = final_venv
        end
        return venv
      end

      if vim.bo.filetype == "python" then
        local venv = os.getenv "CONDA_DEFAULT_ENV"
        if venv then
          return string.format(":(%s)", env_cleanup(venv))
        end
        venv = os.getenv "VIRTUAL_ENV"
        if venv then
          return string.format(":(%s)", env_cleanup(venv))
        end
      end
      return ""
    end,
    icon = "",
    -- cond = conditions.hide_in_width,
    color = { fg = "DarkYellow", gui = "italic,bold" },
  }
end
M.clock = function()
  return {
    function()
      return " " .. os.date "%H:%M"
    end,
    color = { fg = "white", gui = "bold" },
    -- cond = conditions.hide_in_width,
  }
end
M.sessions = function()
  return {
    function()
      local sess = vim.g.persisting
      if sess ~= nil then
        return "%#Mymisc_fg# "
      else
        return " "
      end
    end,
    cond = conditions.debugger_status_run,
  }
end
M.check_loaded_buf = function()
  return {
    function()
      local is_loaded = vim.api.nvim_buf_is_loaded
      local tbl = vim.api.nvim_list_bufs()
      local loaded_bufs = 0
      for i = 1, #tbl do
        if is_loaded(tbl[i]) then
          loaded_bufs = loaded_bufs + 1
        end
      end
      return loaded_bufs
    end,
    icon = icons.kind.stacked,
    cond = conditions.debugger_status_run,
    color = { fg = "DarkCyan", gui = "bold" },
  }
end
M.root_dir = function()
  return {
    function()
      local HAVE_GITSIGNS = pcall(require, "gitsigns")

      ---@diagnostic disable-next-line: undefined-field
      local status = vim.b.gitsigns_status_dict or nil

      local root_path
      if not HAVE_GITSIGNS or status == nil or status["root"] == nil then
        root_path = fn.getcwd()
      else
        root_path = status["root"]
      end

      if root_path and #root_path > 0 then
        root_path = vim.fs.basename(root_path)
      end

      return root_path
    end,
    icon = "",
    color = { fg = "Cyan", gui = "bold" },
  }
end
M.get_lsp_client_notify = function()
  return {
    function()
      local clients = vim.lsp.get_active_clients { bufnr = 0 }

      if falsy(clients) then
        return "No LSP clients available"
      end

      if not state.lsp_clients_visible then
        return fmt("%d attached", #clients)
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      local lint_s, lint = pcall(require, "lint")
      if lint_s then
        for ft_k, ft_v in pairs(lint.linters_by_ft) do
          if type(ft_v) == "table" then
            for _, linter in ipairs(ft_v) do
              if buf_ft == ft_k then
                table.insert(buf_client_names, linter)
              end
            end
          elseif type(ft_v) == "string" then
            if buf_ft == ft_k then
              table.insert(buf_client_names, ft_v)
            end
          end
        end
      end
      -- This needs to be a string only table so we can use concat below
      local unique_client_names = {}
      for _, client_name_target in ipairs(buf_client_names) do
        local is_duplicate = false
        for _, client_name_compare in ipairs(unique_client_names) do
          if client_name_target == client_name_compare then
            is_duplicate = true
          end
        end
        if not is_duplicate then
          table.insert(unique_client_names, client_name_target)
        end
      end

      for _, server in pairs(clients) do
        table.insert(unique_client_names, server.name)
      end

      local client_names_str = table.concat(unique_client_names, ", ")

      local language_servers = string.format(" LSP(s):[%s]", client_names_str)

      return language_servers
    end,
    color = { fg = "DarkMagenta", gui = "bold" },
    -- cond = conditions.hide_in_width,
  }
end
M.term_akinsho = function()
  return {
    function()
      local terms = require "toggleterm.terminal"
      local count_term = terms.get_all()
      if #count_term == 0 then
        return ""
      else
        return fmt("No.%s of ﬑ %s ", as.term_count, #count_term)
      end
    end,
  }
end
M.rmux = function()
  return {
    "rmux",
    colored = true,
    label = "kampang",
    icon_enabled = true,
  }
end
M.navic = function()
  return {
    require("nvim-navic").get_location,
    cond = require("nvim-navic").is_available,
    color = { fg = "red" },
    -- colored = true,
  }
end
M.overseer = function()
  return {
    function()
      local ok, overseer = pcall(require, "overseer")
      if not ok then
        return ""
      end

      local tasks = overseer.task_list
      local STATUS = overseer.constants.STATUS
      local symbols = {
        ["FAILURE"] = " ",
        ["CANCELED"] = " ",
        ["SUCCESS"] = " ",
        ["RUNNING"] = "省",
      }

      -- local colors = {
      --     ["FAILURE"] = "red",
      --     ["CANCELED"] = "gray",
      --     ["SUCCESS"] = "green",
      --     ["RUNNING"] = "yellow",
      --     j
      -- }

      local colors = {
        ["FAILURE"] = "GitSignsDelete",
        ["CANCELED"] = "Boolean",
        ["SUCCESS"] = "GitSignsAdd",
        ["RUNNING"] = "GitSignsChange",
      }
      local tasks_by_status = overseer.util.tbl_group_by(tasks.list_tasks { unique = true }, "status")

      for _, status in ipairs(STATUS.values) do
        local status_tasks = tasks_by_status[status]
        if symbols[status] and status_tasks then
          return "%#" .. colors[status] .. "# " .. symbols[status]
          -- .. "%##"
        end
      end
      return ""
    end,
    color = { fg = "red" },
  }
end
M.debugger = function()
  return {
    function()
      return status_dap()
    end,
    color = { fg = "red", gui = "bold" },
  }
end
M.noice_status = function()
  return {
    function()
      local isNoice, noice = pcall(require, "noice")
      if isNoice then
        return noice.api.status.search.get()
      end
      return ""
    end,
    cond = function()
      local isNoice, noice = pcall(require, "noice")
      if isNoice then
        return noice.api.status.search.has()
      end
    end,
    color = { fg = "#ff9e64", gui = "bold" },
  }
end
M.lazy_updates = function()
  return {
    function()
      return "updates: " .. require("lazy.status").updates()
    end,
    cond = require("lazy.status").has_updates,
    color = { fg = "#ff9e64", gui = "bold" },
  }
end
M.trailing = function()
  return {

    function()
      if not vim.o.modifiable or exclude[vim.bo.filetype] then
        return ""
      end

      local line_num = nil

      for i = 1, fn.line "$" do
        local linetext = vim.fn.getline(i)
        -- To prevent invalid escape error, we wrap the regex string with `[[]]`.
        local idx = fn.match(linetext, [[\v\s+$]])

        if idx ~= -1 then
          line_num = i
          break
        end
      end

      local msg = ""
      if line_num ~= nil then
        msg = fmt("[%d]trailing", line_num)
      end

      return msg
    end,
    color = { fg = "red", gui = "bold" },
  }
end
M.mixindent = function()
  return {
    function()
      if not vim.o.modifiable or exclude[vim.bo.filetype] then
        return ""
      end

      local space_pat = [[\v^ +]]
      local tab_pat = [[\v^\t+]]
      local space_indent = fn.search(space_pat, "nwc")
      local tab_indent = fn.search(tab_pat, "nwc")
      local mixed = (space_indent > 0 and tab_indent > 0)
      local mixed_same_line
      if not mixed then
        mixed_same_line = fn.search([[\v^(\t+ | +\t)]], "nwc")
        mixed = mixed_same_line > 0
      end
      if not mixed then
        return ""
      end
      if mixed_same_line ~= nil and mixed_same_line > 0 then
        return "MI:" .. mixed_same_line
      end
      local space_indent_cnt = fn.searchcount({
        pattern = space_pat,
        max_count = 1e3,
      }).total
      local tab_indent_cnt = fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
      if space_indent_cnt > tab_indent_cnt then
        return "MI:" .. tab_indent
      else
        return "MI:" .. space_indent
      end
    end,
    color = { gui = "bold" },
  }
end
M.vmux = function()
  return {
    function()
      local status_fn

      if OverseerConfig.fnpane_run ~= 0 then
        status_fn = "R:" .. OverseerConfig.fnpane_run
      end

      if OverseerConfig.fnpane_runtest ~= 0 then
        status_fn = status_fn .. " T:" .. OverseerConfig.fnpane_runtest .. " "
      end

      if OverseerConfig.fnpane_runmisc ~= 0 then
        status_fn = status_fn .. " M:" .. OverseerConfig.fnpane_runmisc
      end

      if status_fn ~= nil then
        return status_fn
      else
        return ""
      end
    end,
    color = { gui = "bold", fg = "yellow" },
  }
end

return M
