local Conditions = require "heirline.conditions"

local M = {}

local function rpad(child)
  return { condition = child.condition, child }
end

local state = { lsp_clients_visible = true }
local dap_ft_include = { "dapui_scopes", "dapui_stacks", "dapui_watches", "dapui_breakpoints", "dap-repl" }
local get_vars = {
  filetype = function()
    local filetype = vim.bo.filetype
    if RUtils.qf.is_loclist() then
      filetype = "loclist"
    end
    return filetype
  end,
  path = function()
    return vim.fn.expand "%:p" --[[@as string]]
  end,
  bufname = function()
    return vim.api.nvim_buf_get_name(0)
  end,
  filename = function(bufname)
    return vim.fn.fnamemodify(bufname, ":.")
  end,
  extension = function(filename)
    return vim.fn.fnamemodify(filename, ":e")
  end,
}
local set_conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function(size)
    size = size or 120
    return vim.fn.winwidth(0) > size
  end,
  hide_in_col_width = function(size)
    size = size or 120
    local col = RUtils.cmd.get_option "columns"
    return col > size
  end,
  hide_in_laststatus = function()
    return vim.opt.laststatus == 2
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local stl_lsp_clients = function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if not state.lsp_clients_visible then
    return { { name = fmt("%d attached", #clients), priority = 7 } }
  end

  local lint = package.loaded.lint
  if lint and vim.bo.buftype == "" then
    for _, linter in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
      table.insert(clients, { name = "+" .. linter })
    end
  end

  local conform = package.loaded.conform
  if conform and vim.bo.buftype == "" then
    local formatters = conform.list_formatters()
    local formatter_names = vim.tbl_map(function(f)
      return f.name
    end, formatters)
    for _, formatter in ipairs(formatter_names) do
      table.insert(clients, { name = "~" .. formatter })
    end
  end

  if RUtils.cmd.falsy(clients) then
    return { { name = "No LSP clients available", priority = 7 } }
  end

  table.sort(clients, function(a, b)
    return a.name < b.name
  end)

  return vim.tbl_map(function(client)
    return { name = client.name, priority = 4 }
  end, clients)
end
local overseer_tasks_for_status = function(status)
  return {
    condition = function(self)
      return self.tasks[status]
    end,
    provider = function(self)
      return string.format("%s%d", self.symbols[status], #self.tasks[status])
    end,
    hl = function()
      local fg
      if status == "RUNNING" then
        fg = colors.diff_delete
      elseif status == "SUCCESS" then
        fg = colors.diff_add
      else
        fg = colors.diagnostic_err
      end
      return { fg = fg, bold = true }
    end,
  }
end
local rmux_pane = function()
  local watch = ""
  local run_with = ""
  local rmux = require("rmux").status_panes_targeted()
  if type(rmux) == "table" and (rmux.watch and #rmux.watch > 0) then
    watch = table.concat(rmux.watch, " ")
  end
  if type(rmux) == "table" and (rmux.run_with and #rmux.run_with > 0) then
    run_with = rmux.run_with
  end

  return run_with, watch
end
local __colors = function()
  local H = require "r.settings.highlights"
  local UIPallette = require("r.utils").uisec

  local set_col_light = { fg_normal = 2, fg_branch = 4 }
  local set_col_normal = { fg_normal = 3, fg_branch = 2 }
  local col_opts = vim.tbl_contains(vim.g.lightthemes, vim.g.colorscheme) and set_col_light or set_col_normal

  return {
    statusline_fg = H.get("StatusLine", "fg"),
    statusline_bg = H.get("StatusLine", "bg"),

    -- keyword = H.get("Keyword", "fg"),
    keyword = H.tint(H.get("StatusLine", "fg"), 4),

    normal_bg = H.get("Normal", "bg") or "#000000",

    block_fg = H.tint(H.get("StatusLine", "bg"), col_opts.fg_normal),
    block_bg = H.tint(H.get("StatusLine", "bg"), 0.5),
    block_fg_darken = H.tint(H.get("StatusLine", "bg"), 1.4),
    block_bg_darken = H.tint(H.get("StatusLine", "bg"), 0.25),
    block_bg_darken_winbar = H.tint(H.get("StatusLine", "bg"), 0.1),
    --
    block_fg_qf = H.tint(UIPallette.palette.grey, 1),
    block_bg_qf = H.tint(UIPallette.palette.grey, -0.05),
    block_fg_loclist = H.tint(UIPallette.palette.light_gray, 1),
    block_bg_loclist = H.tint(UIPallette.palette.light_gray, -0.2),

    block_notice = H.tint(H.darken(H.get("GitSignsDelete", "fg"), 0.7, H.get("CurSearch", "fg")), 0.1),
    block_notice_keyword = H.tint(H.darken(H.get("GitSignsDelete", "fg"), 0.6, H.get("Folded", "bg")), 2),

    winbar_fg = H.get("WinbarFilepath", "fg"),
    -- winbar_keyword = H.get("Keyword", "fg"),
    winbar_keyword = H.tint(H.darken(H.get("Keyword", "fg"), 0.6, H.get("Folded", "bg")), 0.5),
    winbar_dap_fg = H.tint(H.darken(UIPallette.palette.light_gray, 0.4, H.get("Normal", "bg")), 0.6),
    winbar_dap_bg = H.tint(H.darken(UIPallette.palette.light_gray, 0.4, H.get("Normal", "bg")), -0.2),

    modified_fg = H.get("KeywordMatch", "fg") or "#000000",
    coldisorent = H.get("LineNr", "fg") or "#000000",

    mode_insert_bg = H.get("KeywordMatch", "fg"),

    mode_term_bg = H.get("Boolean", "fg"),
    mode_visual_bg = H.get("Visual", "bg"),

    branch_fg = H.darken(H.get("GitSignsDelete", "fg"), col_opts.fg_branch, H.get("WinSeparator", "fg")),
    branch_bg = H.darken(H.get("GitSignsDelete", "fg"), 0.4, H.get("Normal", "bg")),

    diff_add = H.get("GitSignsAdd", "fg"),
    diff_change = H.get("GitSignsChange", "fg"),
    diff_delete = H.get("GitSignsDelete", "fg"),

    diagnostic_err = H.get("DiagnosticSignError", "fg"),
    diagnostic_hint = H.get("DiagnosticSignHint", "fg"),
    diagnostic_info = H.get("DiagnosticSignInfo", "fg"),
    diagnostic_warn = H.get("DiagnosticSignWarn", "fg"),
  }
end
local colors = __colors()

local function get_branch_name(buf)
  buf = buf or 0
  if not vim.api.nvim_buf_is_valid(buf) then
    return ""
  end
  if vim.bo[buf].buftype == "nofile" then
    return ""
  end

  local branch = vim.tbl_get(vim.b.gitsigns_status_dict or {}, "head")
  if branch then
    return branch
  end

  local branch_cmd = "git rev-parse --abbrev-ref HEAD"
  branch = vim.fn.system(branch_cmd)
  if vim.v.shell_error ~= 0 then
    return ""
  end

  if #branch == 0 then
    return ""
  end

  -- trim white space off branch
  return string.gsub(branch, "%s+", "")
end

local mode_exclude = {
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
local mode_icons = {
  n = "",
  no = "",
  nov = "",
  noV = "",
  ["no\22"] = "",
  niI = "",
  niR = "",
  niV = "",
  nt = "",
  v = "",
  vs = "",
  V = "",
  Vs = "",
  ["\22"] = "",
  ["\22s"] = "",
  s = "󱐁",
  S = "󱐁",
  ["\19"] = "󱐁",
  i = "",
  ic = "",
  ix = "",
  R = "",
  Rc = "",
  Rx = "",
  Rv = "",
  Rvc = "",
  Rvx = "",
  c = "",
  cv = "",
  r = "",
  rm = "",
  ["r?"] = "",
  ["!"] = "",
  t = "",
}
local mode_colors = {
  n = colors.keyword,
  i = colors.mode_insert_bg,
  v = colors.mode_visual_bg,
  V = colors.mode_visual_bg,
  ["\22"] = "cyan",
  c = colors.mode_term_bg,
  s = "yellow",
  S = "yellow",
  ["\19"] = "orange",
  R = "purple",
  r = "purple",
  ["!"] = "green",
  t = colors.mode_term_bg,
}

M.Mode = {
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()

    -- execute this only once, this is required if you want the ViMode
    -- component to be updated on operator pending mode
    if not self.once then
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:*o",
        command = "redrawstatus",
      })
      self.once = true
    end
  end,
  static = { mode_icons = mode_icons, mode_colors = mode_colors },
  {
    provider = function(self)
      local icon = self.mode_icons[self.mode]
      if vim.bo[0].filetype == "qf" then
        icon = ""
      end
      return string.format("   %s ", icon)
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      local fg = colors.normal_bg
      if mode == "V" or mode == "v" or mode == "vs" then
        fg = colors.keyword
      end
      return { bg = self.mode_colors[mode], fg = fg, bold = true }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      local bg = colors.branch_bg

      if not Conditions.is_git_repo() then
        bg = tostring(colors.statusline_bg)
      end

      return { fg = self.mode_colors[mode], bg = bg }
    end,
  },
}
M.Branch = {
  init = function(self)
    self.branch = get_branch_name()
  end,
  {
    provider = function(self)
      if #self.branch > 0 then
        return "  " .. self.branch .. " "
      end
      return ""
    end,
    hl = { fg = colors.branch_fg, bg = colors.branch_bg, bold = true },
  },
}
M.FilePath = {
  init = function(self)
    self.bufname = get_vars.bufname()
    self.filename = get_vars.filename(self.bufname)
    self.exclude_ft = vim.tbl_contains(
      { "neo-tree", "Outline", "trouble", "qf" },
      vim.api.nvim_get_option_value("filetype", { buf = 0 })
    )
  end,
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.block_bg
      if Conditions.is_git_repo() or (#get_branch_name() > 0) then
        fg = colors.branch_bg
      end
      return { fg = fg, bg = colors.block_bg }
    end,
  },
  {
    provider = function(self)
      local opts = {
        relative = "cwd",
        length = 3,
      }

      local path = vim.fn.expand "%:p" --[[@as string]]
      if path == "" then
        return ""
      end

      if #self.filename == 0 then
        return "[Unknown Filename]"
      end

      local root = RUtils.root.get { normalize = true }
      local cwd = RUtils.root.cwd()

      if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
        path = path:sub(#cwd + 2)
      elseif path:find(root, 1, true) == 1 then
        path = path:sub(#root + 2)
      end

      local sep = package.config:sub(1, 1)
      local parts = vim.split(path, "[\\/]")

      if opts.length == 0 then
        parts = parts
      elseif #parts > opts.length and opts.relative == "cwd" then
        -- remove the last one to modified hl self.filename
        parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts - 1) }
      else
        -- remove the last one too
        parts = { parts[1], "…", unpack(parts, #parts - opts.length + 1, #parts - 2) }
      end

      if not Conditions.width_percent_below(#self.filename, 0.47) and set_conditions.hide_in_col_width(30) then
        path = table.concat(parts, sep)
        if #path > 0 then
          return " " .. path .. sep
        end
      end

      if Conditions.is_active() then
        parts = vim.split(self.filename, "[\\/]")
        table.remove(parts, #parts)
        path = table.concat(parts, sep)
        if #path > 0 then
          if path:find(RUtils.config.path.home, 1, true) == 1 then
            path = path:sub(#RUtils.config.path.home + 2)
          end
          return " " .. path .. sep
        end
      end
    end,
    hl = { fg = colors.block_fg, bg = colors.block_bg },
  },
  {
    provider = function(self)
      if #self.filename == 0 then
        return " " .. vim.api.nvim_get_option_value("filetype", { buf = 0 }) .. " "
      end

      if vim.bo.filetype == "qf" then
        local path = self.bufname
        if path:find(RUtils.config.path.home, 1, true) == 1 then
          path = path:sub(#RUtils.config.path.home + 2)
        end
        return " " .. path .. " "
      end
      return RUtils.file.basename(self.filename) .. " "
    end,
    hl = function(self)
      local fg = tostring(colors.keyword)
      local bg = colors.block_bg
      if self.exclude_ft or #self.filename == 0 then
        fg = colors.block_fg
      end
      return { fg = fg, bg = bg }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.block_bg, bg = colors.statusline_bg },
  },
}
M.FileIcon = {
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)
    self.path = get_vars.path()
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  condition = function()
    return vim.bo.filetype ~= "qf"
  end,
  provider = function(self)
    if self.path == "" then
      return ""
    end
    return self.icon and (" " .. self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}
M.Git = {
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  condition = function()
    return Conditions.is_git_repo()
  end,
  {
    provider = function(self)
      local count_add = self.status_dict.added or 0
      if count_add > 0 then
        return " "
      end
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("A+" .. count)
    end,
    hl = { fg = colors.diff_add },
  },
  {
    provider = function(self)
      local count_removed = self.status_dict.removed or 0
      if count_removed > 0 then
        return " "
      end
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("D-" .. count)
    end,
    hl = { fg = colors.diff_delete },
  },
  {
    provider = function(self)
      local count_changed = self.status_dict.changed or 0
      if count_changed > 0 then
        return " "
      end
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("M~" .. count)
    end,
    hl = { fg = colors.diff_change },
  },
  {
    provider = function(self)
      local count_add = self.status_dict.added or 0
      local count_changed = self.status_dict.changed or 0
      local count_removed = self.status_dict.removed or 0
      if count_add > 0 or count_changed > 0 or count_removed > 0 then
        return " "
      end
    end,
  },
}
M.QuickfixStatus = {
  init = function(self)
    self.height = vim.api.nvim_buf_line_count(0)

    self.title_qflist = vim.fn.getqflist({ title = 0 }).title
    self.stack_qflists = function()
      -- Taken from fzflua internal
      local qflists = {}
      for i = 1, 10 do -- (n)vim keeps at most 10 quickfix lists in full
        local qflist = vim.fn.getqflist { nr = i, id = 0, title = true, items = true }
        if not vim.tbl_isempty(qflist.items) then
          table.insert(qflists, qflist)
        end
      end
      return qflists
    end

    self.title_loclist = vim.fn.getloclist(0, { title = 0 }).title
    self.stack_loclists = function()
      local loclists = {}
      for i = 1, 10 do
        local loclist = vim.fn.getloclist(0, { all = "", nr = tonumber(i) })
        if not vim.tbl_isempty(loclist.items) then
          table.insert(loclists, loclist)
        end
      end
      return loclists
    end
  end,
  condition = function()
    return vim.bo[0].filetype == "qf"
  end,
  {
    provider = function()
      if RUtils.qf.is_loclist() then
        return " LF "
      else
        return " QF "
      end
    end,
    hl = function()
      local fg = colors.block_fg_qf
      local bg = colors.block_bg_qf
      if RUtils.qf.is_loclist() then
        fg = colors.block_fg_loclist
        bg = colors.block_bg_loclist
      end
      return { fg = fg, bg = bg }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.block_bg_qf
      if RUtils.qf.is_loclist() then
        fg = colors.block_bg_loclist
      end
      return { fg = fg, bg = colors.normal_bg }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.normal_bg
      -- if RUtils.qf.is_loclist() then
      --   fg = colors.block_bg_loclist
      -- end
      return { fg = fg, bg = colors.block_bg_darken }
    end,
  },
  {
    provider = function(self)
      local parts = {}
      if RUtils.qf.is_loclist() then
        -- set index_loclist harus di bagian block provider, jangan di block init
        -- begitu juga deang index_qf
        local index_loclist = vim.fn.getloclist(0, { nr = 0 }).nr
        table.insert(parts, string.format("  %d/%d 󱗿 %d ", self.height, index_loclist, #self.stack_loclists()))
      else
        local index_qf = vim.fn.getqflist({ id = 0 }).id
        table.insert(parts, string.format("  %d/%d 󱗿 %d ", self.height, index_qf, #self.stack_qflists()))
      end
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.block_fg_darken, bg = colors.block_bg_darken },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.block_bg_darken, bg = colors.normal_bg },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.normal_bg
      -- if RUtils.qf.is_loclist() then
      --   fg = colors.block_bg_loclist
      -- end
      return { fg = fg, bg = colors.block_bg_darken }
    end,
  },
  {
    provider = function(self)
      local parts = {}
      if RUtils.qf.is_loclist() then
        table.insert(parts, string.format(" %s ", self.title_loclist))
      else
        table.insert(parts, string.format(" %s ", self.title_qflist))
      end
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.block_fg_darken, bg = colors.block_bg_darken },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.block_bg_darken, bg = colors.normal_bg },
  },
}
M.FileFlags = {
  {
    condition = function()
      return vim.bo.modified and not (vim.bo.filetype == "TelescopePrompt")
    end,
    provider = " " .. RUtils.config.icons.misc.modified,
    hl = { fg = colors.modified_fg },
  },
  {
    condition = function()
      return (not vim.bo.modifiable or vim.bo.readonly) and not (vim.bo.filetype == "DiffviewFiles")
    end,
    provider = " " .. RUtils.config.icons.misc.readonly,
    hl = function()
      local fg = colors.diagnostic_err
      if Conditions.is_not_active() then
        fg = colors.coldisorent
      end
      return { fg = fg }
    end,
  },
}
M.Gap = { { provider = "%=" } }
M.Tasks = {
  condition = function()
    return package.loaded.overseer and set_conditions.hide_in_col_width(120)
  end,
  init = function(self)
    local tasks = require("overseer.task_list").list_tasks { unique = true }
    local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
    self.tasks = tasks_by_status
  end,
  static = {
    symbols = {
      ["CANCELED"] = " ",
      ["FAILURE"] = "󰅚 ",
      ["SUCCESS"] = "󰄴 ",
      ["RUNNING"] = "󰑮 ",
    },
  },
  {
    provider = function(self)
      for i, _ in pairs(self.symbols) do
        if self.tasks[i] then
          return "Overseer: "
        end
      end
    end,
    hl = function()
      return { fg = colors.statusline_fg }
    end,
  },
  rpad(overseer_tasks_for_status "CANCELED"),
  rpad(overseer_tasks_for_status "RUNNING"),
  rpad(overseer_tasks_for_status "SUCCESS"),
  rpad(overseer_tasks_for_status "FAILURE"),
  {
    provider = function(self)
      for i, _ in pairs(self.symbols) do
        if self.tasks[i] then
          return "  "
        end
      end
    end,
  },
}
M.Dap = {
  condition = function()
    if package.loaded.dap == nil then
      return false
    end
    if vim.tbl_contains(dap_ft_include, vim.api.nvim_get_option_value("filetype", { buf = 0 })) then
      return false
    end
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return " " .. require("dap").status() .. "  "
  end,
  hl = { fg = colors.diagnostic_err, bg = colors.statusline_bg, bold = true },
}
M.virtualenv = {
  condition = function()
    -- return set_conditions.hide_in_col_width(130) and RUtils.has "venv-selector.nvim"
    return set_conditions.hide_in_col_width(130) and (vim.env.VIRTUAL_ENV ~= nil)
  end,
  init = function(self)
    local python_logo = " "
    local poetry_status = python_logo .. "UV Virtualenv"
    local msg = ""

    local venv_root = RUtils.extras.wants {
      ft = "python",
      root = {
        "pyproject.toml",
        "pyrightconfig.json",
      },
    }
    -- local venv_name = require("venv-selector").venv()
    local venv_name = vim.env.VIRTUAL_ENV
    if venv_name ~= nil and venv_root then
      if venv_name:find "%.venv" then
        msg = poetry_status .. " ON"
      end
    end
    self.venv = msg
  end,
  {
    provider = function(self)
      if #self.venv > 0 then
        return self.venv .. "  "
      end
    end,
    hl = { fg = colors.mode_term_bg, bold = false },
  },
}
M.LSPActive = {
  update = { "LspAttach", "LspDetach", "VimResized", "FileType", "BufEnter", "BufWritePost" },

  condition = function()
    return Conditions.lsp_attached and set_conditions.hide_in_col_width(120)
  end,

  init = function(self)
    local lsp_clients = vim
      .iter(ipairs(stl_lsp_clients()))
      :map(function(_, client)
        return client.name
      end)
      :totable()

    self.names = lsp_clients
  end,
  {
    provider = " LSP(s): ",
    hl = { fg = colors.statusline_fg, italic = true },
  },
  {
    provider = function(self)
      local lsp_clients_str = table.concat(self.names, ", ") -- "  "
      if not Conditions.width_percent_below(#lsp_clients_str, 0.33) then
        return "~too many~"
      end
      return lsp_clients_str
    end,
    hl = { fg = colors.keyword, bold = true },
  },
  {
    provider = function(self)
      if #self.names > 0 then
        return "  "
      end
    end,
  },
}
M.SearchCount = {
  init = function(self)
    local ok, s_count = pcall(vim.fn.searchcount, (self or {}).options or { recompute = true })
    self.result = s_count
    self.isok = ok
  end,

  provider = function(self)
    if not self.isok or self.result.current == nil or self.result.total == 0 then
      return ""
    end
  end,

  {
    condition = function(self)
      if self.result ~= nil and self.result.current ~= nil then
        if self.result.current == 0 then
          return false
        end
      end
      return true
    end,

    provider = function(self)
      if self.result.incomplete == 1 then
        return "?/?"
      end

      local too_many = (">%d"):format(self.result.maxcount)
      local current = self.result.current > self.result.maxcount and too_many or self.result.current
      local total = self.result.total > self.result.maxcount and too_many or self.result.total

      -- return "%#MyStatusLine_red_fg#" .. string.format(" %s/%s ", current, total) .. "%*"
      return string.format(" %s/%s  ", current, total)
    end,
    hl = { fg = colors.diagnostic_err },
  },
}
M.Diagnostics = {
  condition = function()
    if vim.bo[0].filetype == "lazy" then
      return false
    end
    return Conditions.has_diagnostics
  end,
  static = {
    error_icon = RUtils.config.icons.diagnostics.Error,
    warn_icon = RUtils.config.icons.diagnostics.Warn,
    info_icon = RUtils.config.icons.diagnostics.Info,
    hint_icon = RUtils.config.icons.diagnostics.Hint,
  },
  init = function(self)
    local function count(severity)
      return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] })
    end

    self.errors = count "ERROR"
    self.warnings = count "WARN"
    self.hints = count "HINT"
    self.info = count "INFO"
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  {
    condition = function(self)
      return self.errors > 0
    end,
    {
      provider = function(self)
        return self.error_icon
      end,
      hl = { fg = colors.diagnostic_err },
    },
    {
      provider = function(self)
        return self.errors .. " "
      end,
      hl = { fg = colors.diagnostic_err, bold = true },
    },
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    {
      provider = function(self)
        return self.warn_icon
      end,
      hl = { fg = colors.diagnostic_warn },
    },
    {
      provider = function(self)
        return self.warnings .. " "
      end,
      hl = { fg = colors.diagnostic_warn, bold = true },
    },
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    {
      provider = function(self)
        return self.info_icon
      end,
      hl = { fg = colors.diagnostic_info },
    },
    {
      provider = function(self)
        return self.info .. " "
      end,
      hl = { fg = colors.diagnostic_info, bold = true },
    },
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    {
      provider = function(self)
        return self.hint_icon
      end,
      hl = { fg = colors.diagnostic_hint },
    },
    {
      provider = function(self)
        return self.hints .. " "
      end,
      hl = { fg = colors.diagnostic_hint, bold = true },
    },
  },
  {
    provider = function(self)
      if self.errors > 0 or self.warnings > 0 or self.hints > 0 or self.info > 0 then
        return " "
      end
    end,
  },
}
M.LazyStatus = {
  condition = function()
    return require("lazy.status").has_updates() and set_conditions.hide_in_col_width(150)
  end,
  {
    provider = "Updates ",
    hl = { fg = colors.statusline_fg, bold = true },
  },
  {
    provider = function()
      local status_lazy = require("lazy.status").updates()
      if #status_lazy then
        return status_lazy .. "  "
      end
    end,
    hl = { fg = colors.block_notice, bold = true },
  },
}
M.Sessions = {
  condition = function()
    return set_conditions.hide_in_col_width(120)
  end,
  init = function(self)
    local sess_status

    if RUtils.has "persistence.nvim" then
      local ok, ses_persistent = pcall(require, "persistence")
      if ok then
        local get_current_ses = ses_persistent.current()
        local sess = vim.fn.filereadable(get_current_ses) == 1
        if sess ~= nil then
          sess_status = "On"
        end
      end
    elseif RUtils.has "resession.nvim" then
      local ok, res_resession = pcall(require, "resession")
      if ok then
        local get_current_ses = res_resession.get_current()
        if get_current_ses ~= nil then
          sess_status = get_current_ses
        end
      end
    elseif RUtils.has "auto-session" then
      local ok, _ = pcall(require, "auto-session")
      if ok then
        local get_current_ses = require("auto-session.lib").current_session_name(true)
        if #get_current_ses > 0 then
          sess_status = get_current_ses
        end
      end
    end

    self.ses_status = sess_status
  end,
  {
    provider = function(self)
      local icon_ses = "󰅟 " -- "  "
      local ses_status = self.ses_status
      if self.ses_status == nil then
        return
      end

      return icon_ses .. ses_status .. "  "
    end,
    hl = { fg = colors.statusline_fg },
  },
}
M.PinnedBuffer = {
  {
    provider = function()
      if RUtils.has "stickybuf.nvim" then
        local is_pinned = require("stickybuf").is_pinned()
        if is_pinned then
          return RUtils.config.icons.misc.dashboard .. "  "
        end
      end
    end,
    hl = { fg = colors.diagnostic_err },
  },
}
M.Marks = {
  condition = function()
    return set_conditions.hide_in_col_width(120)
  end,
  {
    provider = function()
      local ok, _ = pcall(require, "qfsilet")
      if ok then
        local cur_mark = require("qfsilet.marks").get_current_status_buf()
        if cur_mark > 0 then
          return RUtils.config.icons.misc.marks .. "  "
        end
      end
    end,
    hl = { fg = colors.diagnostic_err },
  },
}
M.BufferCwd = {
  init = function(self)
    self.bufnr = self.bufnr or 0
  end,
  condition = function()
    return set_conditions.hide_in_col_width(150)
  end,
  {
    provider = function()
      local patc = vim.uv.cwd()
      if patc then
        local cwd = vim.fn.fnamemodify(patc, ":t")
        if not cwd or cwd == "" then
          return ""
        end
        -- return "%#MyStatusLine_directory_fg# " .. cwd .. "%* "
        -- return " " .. cwd .. "%*"
        return cwd .. "  "
      end
    end,
    hl = { fg = colors.statusline_fg },
  },
}
M.RmuxTargetPane = {
  init = function(self)
    self.run_with, self.watch = rmux_pane()
  end,
  condition = function()
    return set_conditions.hide_in_col_width(120)
  end,
  {
    provider = function(self)
      if #self.watch > 0 then
        return RUtils.config.icons.misc.separator_down .. " "
      end
    end,
    hl = { fg = colors.statusline_bg, bg = colors.block_notice },
  },
  {
    provider = function(self)
      if #self.watch > 0 then
        return self.run_with
      end
    end,
    hl = { fg = colors.normal_bg, bg = colors.block_notice },
  },

  {
    provider = function(self)
      if #self.watch > 0 then
        return " W "
      end
    end,
    hl = { fg = colors.normal_bg, bg = colors.block_notice },
  },
  {
    provider = function(self)
      if #self.watch > 0 then
        return self.watch
      end
    end,
    hl = { fg = colors.block_notice_keyword, bg = colors.block_notice, bold = true },
  },
  {
    provider = function(self)
      if #self.watch > 0 then
        return RUtils.config.icons.misc.separator_down
      end
    end,
    hl = { fg = colors.block_notice, bg = colors.block_notice },
  },
}
M.Filetype = {
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    self.run_with, self.watch = rmux_pane()
    self.filetype = get_vars.filetype()
  end,
  {
    provider = function(self)
      if self.filetype and #self.filetype > 0 then
        return RUtils.config.icons.misc.separator_down .. " "
      end
    end,
    hl = function(self)
      local fg = colors.statusline_bg
      if #self.watch > 0 then
        fg = colors.block_notice
      end
      return { fg = fg, bg = colors.block_bg_darken }
    end,
  },
  {
    provider = function(self)
      if self.filetype and #self.filetype > 0 then
        return self.icon and (self.icon .. " " .. self.filetype .. " ")
      end
    end,
    hl = { fg = colors.block_fg_darken, bg = colors.block_bg_darken },
  },
}
M.Ruler = {
  init = function(self)
    self.column = vim.fn.virtcol "."
    self.width = vim.fn.virtcol "$"
    self.line = vim.api.nvim_win_get_cursor(0)[1]
    self.height = vim.api.nvim_buf_line_count(0)

    local rhs = ""
    self.rhs = rhs
  end,
  {
    provider = RUtils.config.icons.misc.separator_down .. " ",
    hl = { fg = colors.block_bg_darken, bg = colors.block_bg },
  },
  {
    provider = function(self)
      local rhs = ""

      -- Add padding to stop RHS from changing too much as we move the cursor.
      local padding = #tostring(self.height) - #tostring(self.line)
      if padding > 0 then
        rhs = rhs .. (" "):rep(padding)
      end
      return rhs
    end,
    hl = { bg = colors.block_bg },
  },
  -- {
  --   provider = function(self)
  --     -- local rhs = self.rhs
  --     -- rhs = rhs .. "ℓ: " -- (Literal, \ℓ "SCRIPT SMALL L").
  --     return self.rhs
  --   end,
  --   hl = { fg = colors.statusline_fg, bold = true },
  -- },
  {
    provider = function(self)
      local rhs = self.rhs
      rhs = rhs .. self.line
      return rhs
    end,
    hl = { fg = colors.keyword, bg = colors.block_bg },
  },
  {
    provider = function(self)
      -- Add padding to stop RHS from changing too much as we move the cursor.
      local rhs = self.rhs
      rhs = rhs .. "/"
      rhs = rhs .. self.height
      return rhs
    end,
    hl = { fg = colors.block_fg, bg = colors.block_bg },
  },
  -- {
  --   provider = function(self)
  --     local rhs = self.rhs
  --     rhs = rhs .. " Col: " -- (Literal, \ℓ "SCRIPT SMALL L").
  --     return rhs
  --   end,
  --   hl = { fg = colors.statusline_fg, bold = true },
  -- },
  {
    provider = function(self)
      -- Add padding to stop RHS from changing too much as we move the cursor.
      local rhs = self.rhs
      -- rhs = rhs .. self.column

      -- Add padding to stop rhs from changing too much as we move the cursor.
      -- if #tostring(self.column) < 2 then
      --   rhs = rhs .. " "
      -- end
      return rhs .. " "
    end,
    hl = { fg = colors.keyword, bg = colors.block_bg },
  },
}
M.Clock = {
  condition = function()
    return not vim.env.TMUX and not (vim.env.TERM_PROGRAM == "WezTerm") and set_conditions.hide_in_col_width(120)
  end,
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { bg = colors.diagnostic_err, fg = colors.statusline_bg },
  },
  {
    provider = function()
      return "  " .. os.date "%H:%M "
    end,
    hl = { bg = colors.diagnostic_err, fg = colors.normal_bg, bold = true },
  },
}

-- no longer used..
M.Mixindent = {
  {
    provider = function()
      if not vim.o.modifiable or mode_exclude[vim.bo.filetype] then
        return ""
      end

      local space_pat = [[\v^ +]]
      local tab_pat = [[\v^\t+]]
      local space_indent = vim.fn.search(space_pat, "nwc")
      local tab_indent = vim.fn.search(tab_pat, "nwc")
      local mixed = (space_indent > 0 and tab_indent > 0)
      local mixed_same_line
      if not mixed then
        mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
        mixed = mixed_same_line > 0
      end
      if not mixed then
        return ""
      end
      if mixed_same_line ~= nil and mixed_same_line > 0 then
        return "MI:" .. mixed_same_line
      end
      local space_indent_cnt = vim.fn.searchcount({
        pattern = space_pat,
        max_count = 1e3,
      }).total
      local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
      if space_indent_cnt > tab_indent_cnt then
        return "MI:" .. tab_indent
      else
        return "MI:" .. space_indent
      end
    end,
  },
}
M.SnacksProfile = {
  condition = function()
    return set_conditions.hide_in_width(100)
  end,
  {
    provider = function()
      return Snacks.profiler.status()[1]() .. " "
    end,
    hl = { fg = colors.statusline_fg, bold = true },
  },
  {
    provider = " ",
  },
}
M.Separator = {
  { provider = " " },
}

-- ╓
-- ║ STATUSLINE
-- ╙
M.status_active_left = {
  condition = Conditions.is_active,
  -- M.Mode,
  M.Branch,
  M.FilePath,
  -- M.FileIcon,
  M.Git,
  -- M.QuickfixStatus,
  M.FileFlags,

  M.Gap,

  M.LazyStatus,
  M.Tasks,
  M.Dap,
  -- M.LSPActive,
  M.Diagnostics,
  M.virtualenv,
  -- M.SnacksProfile,
  -- M.SearchCount, -- this func make nvim slow!
  M.PinnedBuffer,
  M.Marks,
  M.Sessions,
  M.BufferCwd,
  M.RmuxTargetPane,
  M.Filetype,
  M.Ruler,
  -- M.Clock,

  hl = { fg = colors.statusline_fg, bg = colors.statusline_bg },
}

-- ╓
-- ║ WINBAR
-- ╙
M.WinbarSeparator = {
  { provider = " " },
}
M.WinbarFilePath = {
  init = function(self)
    self.bufname = get_vars.bufname()
    self.filename = get_vars.filename(self.bufname)
  end,
  condition = function()
    return vim.bo[0].filetype ~= "qf"
  end,
  {
    provider = function(self)
      local opts = {
        relative = "cwd",
        length = 3,
      }

      local path = vim.fn.expand "%:p" --[[@as string]]
      if path == "" then
        return ""
      end

      if #self.filename == 0 then
        return "[Unknown Filename]"
      end

      local root = RUtils.root.get { normalize = true }
      local cwd = RUtils.root.cwd()

      if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
        path = path:sub(#cwd + 2)
      elseif path:find(root, 1, true) == 1 then
        path = path:sub(#root + 2)
      end

      local sep = package.config:sub(1, 1)
      local parts = vim.split(path, "[\\/]")

      if opts.length == 0 then
        parts = parts
      elseif #parts > opts.length and opts.relative == "cwd" then
        -- remove the last one to modified hl self.filename
        parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts - 1) }
      else
        -- remove the last one too
        parts = { parts[1], "…", unpack(parts, #parts - opts.length + 1, #parts - 2) }
      end

      if not Conditions.width_percent_below(#self.filename, 0.2) and not set_conditions.hide_in_width(80) then
        path = table.concat(parts, sep)
        if #path > 0 then
          return path .. sep
        end
      end

      parts = vim.split(self.filename, "[\\/]")
      if #parts == 1 then
        return ""
      end

      table.remove(parts, #parts)
      path = table.concat(parts, sep)
      if #path > 0 then
        if path:find(RUtils.config.path.home, 1, true) == 1 then
          path = path:sub(#RUtils.config.path.home + 2)
        end
        return path .. sep
      end

      -- return statusline path untuk non active window
      return self.filename
    end,
    hl = { fg = colors.winbar_fg, bold = true },
  },
  {
    provider = function(self)
      return RUtils.file.basename(self.filename) .. " "
    end,
    hl = function()
      local fg = colors.winbar_fg
      local bg = colors.normal_bg
      if Conditions.is_active() then
        fg = colors.winbar_keyword
      end

      if
        vim.tbl_contains({ "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes" }, vim.bo.filetype)
      then
        fg = colors.winbar_dap_fg
        if Conditions.is_active() then
          fg = colors.winbar_keyword
        end
        bg = colors.winbar_dap_bg
      end
      return { fg = fg, bg = bg, bold = true, italic = true }
    end,
  },
}

M.status_winbar_active_left = {
  -- M.WinbarSeparator,
  M.FileIcon,
  M.WinbarFilePath,
  M.QuickfixStatus,

  M.Gap,

  hl = function()
    if vim.tbl_contains({ "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes" }, vim.bo.filetype) then
      return { fg = colors.winbar_fg, bg = colors.winbar_dap_bg, bold = true }
    end
    return { fg = colors.statusline_fg, bg = colors.normal_bg }
  end,
}

return M
