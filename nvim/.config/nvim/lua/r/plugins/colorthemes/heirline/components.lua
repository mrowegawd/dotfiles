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
  is_path_git_relative = function()
    local path = get_vars.path()
    return path:match "fugitive:/" or path:match "diffview:/"
  end,
  is_terminal_ft = function()
    return vim.bo.buftype == "terminal"
  end,
  is_lsp_attached = function()
    return next(vim.lsp.get_clients { bufnr = 0 }) ~= nil
  end,

  is_readonly = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  is_gray_ft = function()
    local dap_ft = { "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes", "dbui" }
    return vim.tbl_contains(dap_ft, vim.bo.filetype)
  end,
  is_green_ft = function()
    local dap_ft = { "help" }
    return vim.tbl_contains(dap_ft, vim.bo.filetype)
  end,
}

local stl_lsp_clients = function()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if not state.lsp_clients_visible then
    return { { name = string.format("%d attached", #clients), priority = 7 } }
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

local symbols_overseer = {
  ["CANCELED"] = " ",
  ["FAILURE"] = "󰅚 ",
  ["SUCCESS"] = "󰄴 ",
  ["RUNNING"] = "󰑮 ",
}
local overseer_tasks_for_status = function(status, colors)
  return {
    condition = function(self)
      return self.tasks[status]
    end,
    provider = function(self)
      return string.format("%s%d", symbols_overseer[status], #self.tasks[status])
    end,
    hl = function()
      local fg
      local bg = colors.block_mux_bg
      if status == "RUNNING" then
        fg = colors.diff_delete
      elseif status == "SUCCESS" then
        fg = colors.diff_add
      else
        fg = colors.diagnostic_err
      end
      return { fg = fg, bg = bg, bold = true }
    end,
  }
end
local rmux_pane = function()
  return require("rmux.statusline").get()
end
local __colors = function()
  local H = require "r.settings.highlights"

  local set_col_light = {
    block_bg = 0.2,
    block_darken_bg = 0.1,
    block_darken_fg = 0.15,
    block_fg = 0.25,

    keyword_fg = -0.05,

    branch_fg = 0.8,
    diff_add = H.tint(H.get("GitSignsAdd", "fg"), -0.07),
    diff_change = H.tint(H.get("GitSignsChange", "fg"), -0.1),
    diff_delete = H.tint(H.get("GitSignsDelete", "fg"), -0.1),
  }

  local set_col_normal = {
    block_bg = 0.6,
    block_darken_bg = 0.4,
    block_darken_fg = 0.5,
    block_fg = 0.85,

    keyword_fg = 0.7,

    branch_fg = 1.5,
    diff_add = H.get("GitSignsAdd", "fg"),
    diff_change = H.get("GitSignsChange", "fg"),
    diff_delete = H.get("GitSignsDelete", "fg"),
  }

  local light_themes = vim.g.lightthemes
  light_themes[#light_themes + 1] = "base46-seoul256_dark"
  light_themes[#light_themes + 1] = "base46-zenburn"

  local col_opts = vim.tbl_contains(light_themes, vim.g.colorscheme) and set_col_light or set_col_normal

  return {
    statusline_fg = H.get("StatusLine", "fg"),
    statusline_bg = H.get("StatusLine", "bg"),

    keyword = H.darken(H.get("Keyword", "fg"), col_opts.keyword_fg, H.get("Normal", "bg")),

    statusline_fg_notice = H.tint(H.get("StatusLine", "fg"), 0.6),

    normal_bg = H.get("Normal", "bg") or "#000000",

    block_fg = H.tint(H.get("StatusLine", "fg"), col_opts.block_fg),
    block_bg = H.tint(H.get("StatusLine", "bg"), col_opts.block_bg),
    block_darken_fg = H.tint(H.get("StatusLine", "fg"), col_opts.block_darken_fg),
    block_darken_bg = H.tint(H.get("StatusLine", "bg"), col_opts.block_darken_bg),

    block_bg_darken_winbar = H.tint(H.get("StatusLine", "bg"), 0.1),

    block_fg_qf = H.tint(H.get("Keyword", "fg"), 0.5),
    block_bg_qf = H.tint(H.get("Keyword", "fg"), -0.5),

    block_notice = H.tint(H.darken(H.get("GitSignsDelete", "fg"), 0.7, H.get("CurSearch", "fg")), 0.1),
    block_notice_keyword = H.tint(H.darken(H.get("GitSignsDelete", "fg"), 0.6, H.get("Normal", "bg")), 1.5),

    block_mux_fg = H.tint(H.darken(H.get("GitSignsDelete", "fg"), 0.2, H.get("Normal", "bg")), -0.5),
    block_mux_bg = H.tint(H.darken(H.get("GitSignsDelete", "fg"), 0.6, H.get("Normal", "bg")), -0.1),

    winbar_keyword = H.get("Keyword", "fg"),
    winbar_fg = H.get("WinBar", "fg"),
    winbar_bg = H.get("WinBar", "bg"),
    winbarNC_fg = H.get("WinBarNC", "bg"),
    winbarNC_bg = H.get("WinBarNC", "bg"),
    winbar_bg_right_block = H.tint(H.darken(H.get("Keyword", "fg"), 0.1, H.get("Normal", "bg")), 0.1),

    winbar_quickfix_fg = H.get("QuickFixHeader", "fg"),
    winbar_quickfix_bg = H.get("QuickFixHeader", "bg"),
    winbar_quickfix_fg_loc = H.tint(H.get("Keyword", "fg"), -0.8),
    winbar_quickfix_bg_loc = H.tint(H.get("Keyword", "fg"), 0.35),

    modified_fg = H.get("KeywordMatch", "fg") or "#000000",
    coldisorent = H.get("LineNr", "fg") or "#000000",

    -- Termasuk filetype: debug dap, dbui
    mode_gray_fg_keyword = H.tint(H.get("PanelSideBackground", "bg"), 3),
    mode_gray_fg = H.tint(H.get("PanelSideBackground", "bg"), 2),
    mode_gray_bg = H.tint(H.get("PanelSideBackground", "bg"), 0.15),

    -- Termasuk filetype: readonly, commit
    mode_red_fg_active = H.tint(H.get("diffDelete", "fg"), 0.5),
    mode_red_fg = H.tint(H.get("diffDelete", "fg"), 0.2),
    mode_red_bg = H.tint(H.darken(H.get("diffDelete", "bg"), 0.5, H.get("Normal", "bg")), 0.15),
    mode_red_bg_right_block = H.tint(H.get("diffDelete", "bg"), 0.3),

    -- Termasuk filetype: git fugtive-relative
    mode_yellow_fg_active = H.tint(H.get("diffChange", "fg"), 0.6),
    mode_yellow_fg = H.tint(H.get("diffChange", "fg"), -0.08),
    mode_yellow_bg = H.tint(H.darken(H.get("diffChange", "bg"), 0.5, H.get("Normal", "bg")), 0.15),
    mode_yellow_bg_right_block = H.tint(H.get("diffChange", "bg"), 0.1),

    -- Termasuk filetype: help,
    mode_green_fg_active = H.tint(H.get("diffAdd", "fg"), 0.45),
    mode_green_fg = H.tint(H.get("diffAdd", "fg"), 0.2),
    mode_green_bg = H.tint(H.darken(H.get("diffAdd", "bg"), 0.5, H.get("Normal", "bg")), 0.15),
    mode_green_bg_right_block = H.tint(H.get("diffAdd", "bg"), 0.2),

    mode_visual_bg = H.get("Visual", "bg"),
    mode_term_fg = H.get("Boolean", "fg"),
    mode_term_bg = H.tint(H.darken(H.get("Boolean", "fg"), 0.8, H.get("Normal", "bg")), 0.1),
    mode_term_statusline_fg = H.tint(H.darken(H.get("Boolean", "fg"), 0.4, H.get("Normal", "bg")), 0.1),
    mode_term_statusline_bg = H.tint(H.darken(H.get("Boolean", "fg"), 0.15, H.get("Normal", "bg")), 0.1),

    mode_virtualenv_fg = H.increase_saturation(H.tint(H.get("Boolean", "fg"), -0.1), 0.6),

    branch_fg = H.tint(H.get("TabLine", "bg"), col_opts.branch_fg),
    branch_bg = H.get("StatusLine", "bg"),

    diff_add = col_opts.diff_add,
    diff_change = col_opts.diff_change,
    diff_delete = col_opts.diff_delete,

    diagnostic_err = H.get("DiagnosticSignError", "fg"),
    diagnostic_hint = H.get("DiagnosticSignHint", "fg"),
    diagnostic_info = H.get("DiagnosticSignInfo", "fg"),
    diagnostic_warn = H.get("DiagnosticSignWarn", "fg"),
  }
end
local colors = __colors()

local set_hl = function(is_base)
  is_base = is_base or false

  local hl_opts = {
    fg = colors.winbar_keyword,
    bg = colors.winbar_bg_right_block,
  }

  if is_base then
    hl_opts.fg = colors.statusline_fg
    hl_opts.bg = colors.statusline_bg
  end

  if set_conditions.is_path_git_relative() then
    hl_opts.fg = tostring(colors.mode_yellow_fg)
    hl_opts.bg = colors.mode_yellow_bg_right_block
    if is_base then
      hl_opts.bg = colors.mode_yellow_bg
    end
  end

  if set_conditions.is_readonly() then
    hl_opts.fg = tostring(colors.mode_red_fg)
    hl_opts.bg = colors.mode_red_bg_right_block
    if is_base then
      hl_opts.fg = tostring(colors.mode_red_fg)
      hl_opts.bg = colors.mode_red_bg
    end
  end

  if set_conditions.is_gray_ft() then
    hl_opts.fg = colors.mode_gray_fg
    hl_opts.bg = colors.mode_gray_bg
  end

  if set_conditions.is_green_ft() then
    hl_opts.fg = colors.mode_green_fg
    hl_opts.bg = colors.mode_green_bg_right_block
    if is_base then
      hl_opts.fg = colors.mode_green_fg
      hl_opts.bg = colors.mode_green_bg
    end
  end

  return hl_opts
end
local set_hl_separator = function()
  local hl_opts = {
    fg = colors.winbar_bg_right_block,
    bg = colors.statusline_bg,
  }

  if set_conditions.is_path_git_relative() then
    hl_opts.fg = colors.mode_yellow_bg_right_block
    hl_opts.bg = colors.mode_yellow_bg
  end

  if set_conditions.is_readonly() then
    hl_opts.fg = colors.mode_red_bg_right_block
    hl_opts.bg = colors.mode_red_bg
  end

  if set_conditions.is_gray_ft() then
    hl_opts.fg = colors.mode_gray_bg
    hl_opts.bg = colors.mode_gray_bg
  end

  if set_conditions.is_green_ft() then
    hl_opts.fg = colors.mode_green_bg_right_block
    hl_opts.bg = colors.mode_green_bg
  end

  return hl_opts
end

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

  local branch_cmd = { "git", "rev-parse", "--abbrev-ref", "HEAD" }
  branch = vim.system(branch_cmd, { text = true }):wait()
  if branch.code ~= 0 then
    return ""
  end

  local lines = vim.split(branch.stdout or "", "\n", { plain = true })
  return table.concat(lines, "")
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

    hl = function()
      local fg = colors.branch_fg
      if set_conditions.is_terminal_ft() then
        fg = tostring(colors.mode_term_fg)
      end

      return { fg = fg, bold = true }
    end,
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
  -- {
  --   provider = RUtils.config.icons.misc.separator_up,
  --   hl = function()
  --     local fg = colors.block_bg
  --     if Conditions.is_git_repo() or (#get_branch_name() > 0) then
  --       fg = tostring(colors.branch_bg)
  --     end
  --     -- return { fg = fg, bg = colors.block_bg }
  --     return { fg = fg }
  --   end,
  -- },
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
    hl = { fg = colors.block_fg },
  },
  {
    provider = function(self)
      if #self.filename == 0 then
        return " " .. vim.api.nvim_get_option_value("filetype", { buf = 0 })
      end

      if vim.bo.filetype == "qf" then
        local path = self.bufname
        if path:find(RUtils.config.path.home, 1, true) == 1 then
          path = path:sub(#RUtils.config.path.home + 2)
        end
        return " " .. path
      end
      return RUtils.file.basename(self.filename)
    end,
    hl = function(self)
      local fg = tostring(colors.keyword)
      local is_bold = true
      if self.exclude_ft or #self.filename == 0 then
        fg = colors.block_fg
      end
      return { fg = fg, bold = is_bold }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.statusline_bg },
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
    local hl_opts = set_hl()
    return { fg = self.icon_color, bg = hl_opts.bg }
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

    self.title_qflist = RUtils.qf.get_title_qf()
    self.stack_qflists = #RUtils.qf.get_total_stack_qf()

    self.title_loclist = RUtils.qf.get_title_qf(true)
    self.stack_loclists = #RUtils.qf.get_total_stack_qf(true)
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
        fg = colors.winbar_quickfix_fg_loc
        bg = colors.winbar_quickfix_bg_loc
      end
      return { fg = fg, bg = bg, bold = true }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.block_bg_qf
      if RUtils.qf.is_loclist() then
        fg = colors.winbar_quickfix_bg_loc
      end
      return { fg = fg, bg = colors.winbar_bg }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.winbar_bg, bg = colors.winbar_bg_right_block },
  },
  {
    provider = function(self)
      local parts = {}
      if RUtils.qf.is_loclist() then
        local index_loclist = RUtils.qf.get_current_idx_qf(true)
        local current_stack_loclist = RUtils.qf.get_current_history_qf(true)
        table.insert(
          parts,
          string.format(
            "  %d/%d 󱗿 %d/%d ",
            index_loclist,
            self.height,
            current_stack_loclist,
            self.stack_loclists
          )
        )
      else
        local index_qf = RUtils.qf.get_current_idx_qf()
        local current_stack_qf = RUtils.qf.get_current_history_qf()
        table.insert(
          parts,
          string.format("  %d/%d 󱗿 %d/%d ", index_qf, self.height, current_stack_qf, self.stack_qflists)
        )
      end
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.winbar_keyword, bg = colors.winbar_bg_right_block },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.winbar_bg_right_block, bg = colors.winbar_bg },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.winbar_bg, bg = colors.winbar_bg_right_block },
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
    hl = { fg = colors.winbar_keyword, bg = colors.winbar_bg_right_block },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.winbar_bg_right_block, bg = colors.winbar_bg },
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
    return set_conditions.hide_in_col_width(130) and (vim.env.VIRTUAL_ENV ~= nil)
  end,
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local python_logo = "" -- Icon Python
    local venv_path = vim.env.VIRTUAL_ENV or ""
    local venv_name = ""

    -- Ambil nama folder virtualenv (nama environment)
    if venv_path ~= "" then
      venv_name = venv_path:match "([^/\\]+)$" or venv_path
    end

    -- Cek apakah ini Poetry (.venv biasanya Poetry default)
    local is_poetry_venv = venv_name:find "%.venv" ~= nil

    if is_poetry_venv then
      self.venv = string.format("%s Poetry %s", python_logo, RUtils.config.icons.misc.check_big)
    elseif venv_name ~= "" then
      self.venv = string.format("%s venv: %s", python_logo, venv_name)
    else
      self.venv = ""
    end
  end,
  {
    provider = function(self)
      if self.venv and #self.venv > 0 then
        return self.venv .. " "
      end
      return ""
    end,
    hl = function(self)
      return { fg = self.icon_color, bold = true }
    end,
  },
}
M.LSPActive = {
  update = { "LspAttach", "LspDetach", "VimResized", "FileType", "BufEnter", "BufWritePost" },
  condition = function()
    return Conditions.lsp_attached and set_conditions.hide_in_col_width(120) and vim.bo.filetype ~= "qf"
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
    provider = " LSP ",
    hl = { italic = false },
  },
  {
    provider = function(self)
      local lsp_clients_str = table.concat(self.names, ", ") -- "  "
      if not Conditions.width_percent_below(#lsp_clients_str, 0.33) then
        lsp_clients_str = "~too many~"
      end
      return lsp_clients_str
    end,
    hl = { fg = colors.statusline_fg_notice, bold = true },
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
  {
    condition = function(self)
      if vim.v.hlsearch == 0 then
        return false
      end
      if self.result ~= nil and self.result.current ~= nil then
        if self.result.current == 0 then
          return false
        end
      end
      return true
    end,

    provider = function(self)
      if self.result.incomplete == 1 then
        return ""
      end

      -- Retrieve the current search query from Neovim's search register.
      -- This gets the last pattern used for searching with '/' in normal mode.
      local search_query = vim.fn.getreg "/"

      local too_many = (">%d"):format(self.result.maxcount)
      local current = self.result.current > self.result.maxcount and too_many or self.result.current
      local total = self.result.total > self.result.maxcount and too_many or self.result.total
      if search_query == "" then
        return string.format("%d/%d  ", current, total)
      else
        return string.format("(%s) %d/%d  ", search_query, current, total)
      end
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
      local ses_status = self.ses_status
      if self.ses_status == nil then
        return
      end

      return RUtils.config.icons.misc.session .. ses_status .. "  "
    end,
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
        return RUtils.config.icons.misc.folder .. cwd .. " "
      end
    end,
  },
}
M.Tasks = {
  condition = function()
    return package.loaded.overseer and set_conditions.hide_in_col_width(120)
  end,
  init = function(self)
    local tasks = require("overseer.task_list").list_tasks { unique = true }
    local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
    self.tasks = tasks_by_status
  end,
  {
    provider = function(self)
      for i, _ in pairs(symbols_overseer) do
        if self.tasks[i] then
          return RUtils.config.icons.misc.separator_down
        end
      end
    end,
    hl = { fg = colors.statusline_bg, bg = colors.block_mux_bg },
  },
  {
    provider = function(self)
      for i, _ in pairs(symbols_overseer) do
        if self.tasks[i] then
          return " Overseer: "
        end
      end
    end,
    hl = { fg = colors.statusline_bg, bg = colors.block_mux_bg, bold = true },
  },
  rpad(overseer_tasks_for_status("CANCELED", colors)),
  rpad(overseer_tasks_for_status("RUNNING", colors)),
  rpad(overseer_tasks_for_status("SUCCESS", colors)),
  rpad(overseer_tasks_for_status("FAILURE", colors)),
  {
    provider = function(self)
      for i, _ in pairs(symbols_overseer) do
        if self.tasks[i] then
          return RUtils.config.icons.misc.separator_down
        end
      end
    end,
    hl = { fg = colors.block_mux_bg, bg = colors.block_mux_bg },
  },
}
M.RmuxTargetPane = {
  init = function(self)
    local status = rmux_pane()

    self.run_with = status.run_with
    self.task = status.task
    self.watch = status.watch
  end,
  condition = function()
    return package.loaded.rmux and set_conditions.hide_in_col_width(120)
  end,
  {
    provider = function(self)
      if self.task > 0 or #self.watch > 0 then
        return RUtils.config.icons.misc.separator_down
      end
    end,

    hl = function()
      local fg = colors.statusline_bg
      if set_conditions.is_terminal_ft() then
        fg = colors.mode_term_statusline_bg
      end
      return { fg = fg, bg = colors.block_mux_bg }
    end,
  },
  {
    provider = function(self)
      if self.task > 0 then
        return "  " .. self.task
      end
    end,
    hl = { fg = colors.block_mux_fg, bg = colors.block_mux_bg, bold = true },
  },
  {
    provider = function(self)
      if #self.watch > 0 then
        return "  " .. self.watch
      end
    end,
    hl = { fg = colors.block_mux_fg, bg = colors.block_mux_bg, bold = true },
  },
  {
    provider = function(self)
      if self.task > 0 then
        return RUtils.config.icons.misc.separator_down
      end

      if #self.watch > 0 then
        return RUtils.config.icons.misc.separator_down
      end
    end,
    hl = { fg = colors.block_mux_bg, bg = colors.block_mux_bg },
  },
}
M.Filetype = {
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local status = rmux_pane()
    self.run_with = status.run_with
    self.task = status.task
    self.watch = status.watch

    local tasks_overseer = require("overseer.task_list").list_tasks { unique = true }
    local tasks_by_status = require("overseer.util").tbl_group_by(tasks_overseer, "status")
    self.tasks_overseer = tasks_by_status

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

      if self.task > 0 then
        fg = colors.block_mux_bg
      end

      if set_conditions.is_terminal_ft() then
        fg = colors.mode_term_statusline_bg
      end

      for i, _ in pairs(symbols_overseer) do
        if self.tasks_overseer[i] then
          fg = colors.block_mux_bg
        end
      end

      if self.task > 0 or #self.watch > 0 then
        fg = colors.block_mux_bg
      end

      if not set_conditions.hide_in_col_width(120) then
        fg = colors.statusline_bg
      end

      return { fg = fg, bg = colors.block_darken_bg }
    end,
  },
  {
    provider = function(self)
      if self.filetype and #self.filetype > 0 then
        return self.icon and (self.icon .. " " .. self.filetype .. " ")
      end
    end,
    hl = { fg = colors.block_darken_fg, bg = colors.block_darken_bg },
  },
  {
    provider = RUtils.config.icons.misc.separator_down .. " ",
    hl = function(self)
      local fg = colors.statusline_bg
      if self.filetype and #self.filetype > 0 then
        fg = colors.block_darken_bg
      end
      return { fg = fg, bg = colors.block_bg }
    end,
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
    hl = { fg = colors.winbar_keyword, bg = colors.block_bg, bold = true },
  },
  {
    provider = function(self)
      -- Add padding to stop RHS from changing too much as we move the cursor.
      local rhs = self.rhs
      rhs = rhs .. "/"
      rhs = rhs .. self.height
      return rhs
    end,
    hl = { fg = colors.block_fg, bg = colors.block_bg, bold = false },
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
  -- M.FilePath,
  -- M.FileIcon,
  M.Git,
  -- M.QuickfixStatus,
  M.FileFlags,

  M.Gap,

  M.LazyStatus,
  M.Dap,
  M.Diagnostics,
  M.SearchCount,
  M.LSPActive,
  M.virtualenv,
  -- M.SnacksProfile,
  -- M.SearchCount, -- this func make nvim slow!
  M.PinnedBuffer,
  M.Marks,
  M.Sessions,
  M.BufferCwd,
  M.Tasks,
  M.RmuxTargetPane,
  M.Filetype,
  M.Ruler,
  -- M.Clock,

  hl = function()
    local fg = colors.statusline_fg
    local bg = colors.statusline_bg

    if set_conditions.is_terminal_ft() then
      bg = colors.mode_term_statusline_bg
      fg = colors.mode_term_statusline_fg
    end

    return { fg = fg, bg = bg }
  end,
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
        path = path:sub(#cwd + 3)
      elseif path:find(root, 1, true) == 1 then
        path = path:sub(#root + 3)
      end

      local sep = package.config:sub(1, 1)
      local parts = vim.split(path, "[\\/]")

      if opts.length == 0 then
        parts = parts
      elseif #parts > opts.length and opts.relative == "cwd" then
        -- remove the last one to modified hl self.filename
        parts = { "…", unpack(parts, #parts - opts.length + 2, #parts - 1) }
        -- parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts - 1) }
      else
        -- remove the last one too
        -- parts = { parts[1], "…", unpack(parts, #parts - opts.length + 1, #parts - 2) }
        parts = { "…", unpack(parts, #parts - opts.length + 1, #parts - 1) }
      end

      if not set_conditions.is_terminal_ft() then
        local jparts = vim.split(self.filename, "[\\/]")
        if #jparts == 1 then
          return ""
        end

        path = table.concat(parts, sep)
        if #path > 0 then
          return path .. sep
        end
      end
    end,
    hl = function()
      local hl_opts = set_hl()
      return { fg = hl_opts.fg, bg = hl_opts.bg }
    end,
  },
  {
    provider = function(self)
      return RUtils.file.basename(self.filename) .. " "
    end,
    hl = function()
      local hl_opts = set_hl()
      return { fg = hl_opts.fg, bg = hl_opts.bg }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local hl_opts = set_hl_separator()
      return { fg = hl_opts.fg, bg = hl_opts.bg }
    end,
  },
}
M.WinBarNavic = {
  condition = function()
    return set_conditions.is_lsp_attached()
      and require("nvim-navic").is_available()
      and not set_conditions.is_path_git_relative()
      and not set_conditions.is_terminal_ft()
      and not vim.tbl_contains({ "codecompanion" }, vim.bo.filetype)
  end,
  provider = function()
    return string.format(" %s", require("nvim-navic").get_location())
  end,
  hl = { fg = colors.mode_yellow_fg, bg = colors.statusline_bg },
}

M.status_winbar_active_left = {
  -- M.WinbarSeparator,
  M.FileIcon,
  M.WinbarFilePath,
  M.WinBarNavic,
  M.QuickfixStatus,

  M.Gap,

  hl = function()
    local hl_opts = set_hl(true)
    return { fg = hl_opts.fg, bg = hl_opts.bg }
  end,
}

return M
