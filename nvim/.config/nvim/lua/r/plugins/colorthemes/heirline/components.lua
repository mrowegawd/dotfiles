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
  ---@param size number
  hide_in_width = function(size)
    size = size or 120
    return vim.api.nvim_win_get_width(0) < size
  end,
  hide_in_col_width = function(size)
    size = size or 120
    local col = RUtils.get_option "columns"
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
    return path:match "fugitive:/" or path:match "diffview:/" or path:match "neogit:/" or path:match "gitsigns:/"
  end,
  is_terminal_ft = function()
    return vim.bo.buftype == "terminal"
  end,
  is_lsp_attached = function()
    return next(vim.lsp.get_clients { bufnr = 0 }) ~= nil
  end,
  is_diff = function()
    return vim.wo.diff
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
  is_dont_show_at_ft = function()
    local dont_show_at_ft = { "oil", "DiffviewFilePanel" }
    return vim.tbl_contains(dont_show_at_ft, vim.bo.filetype)
  end,
  is_note_ft = function()
    local note_ft = { "org", "markdown", "octo", "codecompanion" }
    return vim.tbl_contains(note_ft, vim.bo.filetype)
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

  if RUtils.falsy(clients) then
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
      return string.format("%s%d ", symbols_overseer[status], #self.tasks[status])
    end,
    hl = function()
      local fg
      local bg = colors.task_bg
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

local rmux_pane, navic_mod, qfbookmark, pinnedbuffer, session_buf

---@return {run_with: string, task: integer, watch: string}
local get_rmux = function()
  if not rmux_pane then
    return require("rmux.statusline").get()
  end
  return rmux_pane
end
local get_navic = function()
  if not navic_mod then
    local ok, navic = pcall(require, "nvim-navic")
    if ok then
      navic_mod = navic
    end
  end
  return navic_mod
end
local get_pinnedBuf = function()
  if not pinnedbuffer then
    local ok, pinned = pcall(require, "stickybuf")
    if ok then
      pinnedbuffer = pinned
    end
  end
  return pinnedbuffer
end
local get_qfbookmark = function()
  if not qfbookmark then
    local ok, qfbook = pcall(require, "qfbookmark.qf")
    if ok then
      qfbookmark = qfbook
    end
  end
  return qfbookmark
end
local get_session = function()
  if not session_buf then
    local ok, session = pcall(require, "resession")
    if ok then
      session_buf = session
    end
  end
  return session_buf
end

local __colors = function()
  local H = require "r.settings.highlights"

  local set_col_light = {
    keyword_fg = -0.05,

    diff_add = H.tint(H.get("GitSignsAdd", "fg"), -0.07),
    diff_change = H.tint(H.get("GitSignsChange", "fg"), -0.1),
    diff_delete = H.tint(H.get("GitSignsDelete", "fg"), -0.1),
  }

  local set_col_normal = {
    keyword_fg = 0.7,

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

    winbar_fg = H.get("WinBar", "fg"),
    winbar_bg = H.get("WinBar", "bg"),
    winbar_bg_bottom = H.get("PanelSideNormal", "bg"),

    bright = H.tint(H.get("StatusLine", "fg"), 0.65),
    bright_winbar = H.tint(H.get("StatusLineWinbar", "fg"), 0.65),

    keyword = H.darken(H.get("Keyword", "fg"), col_opts.keyword_fg, H.get("Normal", "bg")),

    statusline_fg_notice = H.tint(H.get("StatusLine", "fg"), 0.6),

    normal_bg = H.get("Normal", "bg") or "#000000",

    qf_indicator_fg = H.get("Keyword", "fg"),
    qf_indicator_bg = H.darken(H.get("Keyword", "fg"), 0.2, H.get("Normal", "bg")),
    lf_indicator_fg = H.get("String", "fg"),
    lf_indicator_bg = H.darken(H.get("String", "fg"), 0.2, H.get("Normal", "bg")),

    qf_keyword_fg = H.get("QuickFixWinbar", "fg"),
    qf_keyword_bg = H.get("QuickFixWinbar", "bg"),

    search_count_fg = H.tint(H.get("GitSignsDelete", "fg"), 1),
    search_count_bg = H.darken(H.get("GitSignsDelete", "fg"), 0.5, H.get("Normal", "bg")),

    block_notice = H.tint(H.darken(H.get("Error", "fg"), 0.7, H.get("CurSearch", "fg")), 0.1),
    block_notice_keyword = H.tint(H.darken(H.get("Error", "fg"), 0.6, H.get("Normal", "bg")), 1.5),

    task_fg = H.get("GitSignsAdd", "fg"),
    task_bg = H.darken(H.get("GitSignsAdd", "fg"), 0.2, H.get("Normal", "bg")),

    modified_fg = H.get("GitSignsDelete", "fg") or "#000000",
    coldisorent = H.get("LineNr", "fg") or "#000000",

    -- Termasuk filetype: debug dap, dbui
    mode_gray_fg = H.get("WinBarGrey", "fg"),
    mode_gray_fg_bright = H.tint(H.get("WinBarGrey", "fg"), 0.25),
    mode_gray_bg = H.get("WinBarGrey", "bg"),

    -- Termasuk filetype: note
    mode_note_fg = H.get("WinBarNote", "fg"),
    mode_note_fg_bright = H.tint(H.get("WinBarNote", "fg"), 0.25),
    mode_note_bg = H.get("WinBarNote", "bg"),

    -- Termasuk filetype: readonly, commit
    mode_red_fg = H.get("WinBarRed", "fg"),
    mode_red_fg_bright = H.tint(H.get("WinBarRed", "fg"), 0.3),
    mode_red_bg = H.get("WinBarRed", "bg"),

    -- Termasuk filetype: git fugtive-relative
    mode_yellow_fg = H.get("WinBarYellow", "fg"),
    mode_yellow_fg_bright = H.tint(H.get("WinBarYellow", "fg"), 0.3),
    mode_yellow_bg = H.get("WinBarYellow", "bg"),

    -- Termasuk filetype: help,
    mode_green_fg = H.get("WinBarGreen", "fg"),
    mode_green_fg_bright = H.tint(H.get("WinBarGreen", "fg"), 0.3),
    mode_green_bg = H.get("WinBarGreen", "bg"),

    mode_visual_bg = H.get("Visual", "bg"),
    mode_visual_fg = H.tint(H.get("Visual", "bg"), 0.5),
    mode_term_fg = H.get("Boolean", "fg"),
    mode_term_bg = H.tint(H.darken(H.get("Boolean", "fg"), 0.8, H.get("Normal", "bg")), 0.1),
    mode_term_statusline_fg = H.tint(H.darken(H.get("Boolean", "fg"), 0.5, H.get("Normal", "bg")), 0.2),
    mode_term_statusline_bg = H.tint(H.darken(H.get("Boolean", "fg"), 0.1, H.get("Normal", "bg")), 0.1),

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

local set_winbar_hl = function(is_more_bright)
  is_more_bright = is_more_bright or false

  local hlWinbarOpts = {
    fg = colors.winbar_fg,
    bg = colors.winbar_bg,
  }

  if is_more_bright then
    hlWinbarOpts.fg = colors.statusline_fg
    hlWinbarOpts.bg = colors.winbar_bg
  end

  if set_conditions.is_readonly() then
    hlWinbarOpts.fg = colors.mode_red_fg
    hlWinbarOpts.bg = colors.mode_red_bg
    if is_more_bright then
      hlWinbarOpts.fg = colors.mode_red_fg_bright
    end
  end

  if set_conditions.is_gray_ft() then
    hlWinbarOpts.fg = colors.mode_gray_fg
    hlWinbarOpts.bg = colors.mode_gray_bg
    if is_more_bright then
      hlWinbarOpts.fg = colors.mode_gray_fg_bright
    end
  end

  if set_conditions.is_note_ft() then
    hlWinbarOpts.fg = colors.mode_note_fg
    hlWinbarOpts.bg = colors.mode_note_bg
    if is_more_bright then
      hlWinbarOpts.fg = colors.mode_note_fg_bright
    end
  end

  if set_conditions.is_green_ft() then
    hlWinbarOpts.fg = colors.mode_green_fg
    hlWinbarOpts.bg = colors.mode_green_bg
    if is_more_bright then
      hlWinbarOpts.fg = colors.mode_green_fg_bright
    end
  end

  if set_conditions.is_path_git_relative() then
    hlWinbarOpts.fg = colors.mode_yellow_fg
    hlWinbarOpts.bg = colors.mode_yellow_bg
    if is_more_bright then
      hlWinbarOpts.fg = colors.mode_yellow_fg_bright
    end
  end

  if vim.bo.filetype == "qf" then
    hlWinbarOpts.bg = colors.winbar_bg_bottom
  end

  return hlWinbarOpts
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
  n = colors.mode_green_fg,
  i = colors.mode_red_fg,
  v = colors.mode_visual_fg,
  V = colors.mode_visual_fg,
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
      -- return string.format("   %s ", icon)
      return string.format(" %s ", icon)
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      -- local fg = colors.statusline_fg
      -- if mode == "V" or mode == "v" or mode == "vs" then
      --   fg = colors.diagnostic_err
      -- end
      -- return { bg = self.mode_colors[mode], fg = fg, bold = true }
      return { fg = self.mode_colors[mode], bold = true }
    end,
  },
  -- {
  --   provider = RUtils.config.icons.misc.separator_up,
  --   hl = function(self)
  --     local mode = self.mode:sub(1, 1)
  --     local bg = colors.branch_bg
  --
  --     if not Conditions.is_git_repo() then
  --       bg = tostring(colors.statusline_bg)
  --     end
  --
  --     return { fg = self.mode_colors[mode], bg = bg }
  --   end,
  -- },
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
    hl = { bold = true },
  },
}
M.FilePath = {
  init = function(self)
    self.bufname = get_vars.bufname()
    self.filename = get_vars.filename(self.bufname)
    self.exclude_ft = vim.tbl_contains(
      { "neo-tree", "Outline", "trouble", "qf", "codecompanion", "oil", "DiffviewFiles" },
      vim.api.nvim_get_option_value("filetype", { buf = 0 })
    )
    -- Detect valid filetype git
    self.git_type = self.bufname:match "^gitsigns://" and "gitsigns"
      or self.bufname:match "^diffview://" and "diffview"
      or self.bufname:match "^fugitive://" and "fugitive"
      or nil
  end,
  {
    provider = function(self)
      if
        set_conditions.is_terminal_ft()
        or set_conditions.is_path_git_relative()
        or self.exclude_ft
        or (vim.bo.filetype == "octo")
      then
        return " "
      end

      local path = vim.uv.cwd()
      if path then
        local cwd = vim.fn.fnamemodify(path, ":t")
        if not cwd or cwd == "" then
          return ""
        end

        return " " .. cwd .. "/"
      end
    end,
    hl = { bold = true },
  },
  {
    provider = function(self)
      if self.exclude_ft then
        return ""
      end

      local opts = { relative = "cwd", length = 3 }

      if vim.bo.filetype == "codecompanion" then
        return ""
      end

      local path = vim.fn.expand "%:p" --[[@as string]]
      if path == "" then
        return " "
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

      local is_very_narrow = not Conditions.width_percent_below(#self.filename, 0.47)
        and set_conditions.hide_in_col_width(40)

      local is_medium_width = Conditions.width_percent_below(#self.filename, 0.30)

      local sep = package.config:sub(1, 1)
      local parts = vim.split(path, "[\\/]")

      if #parts <= opts.length then
        table.remove(parts, #parts)
      else
        local part_middle = 2
        local part_last = 1

        local middle_pack, last_pack
        local part_first = "…"

        if not is_very_narrow then
          last_pack = #parts - 1
          middle_pack = #parts - opts.length

          if is_medium_width then
            middle_pack = 1
            part_first = ""
          end
        else
          middle_pack = #parts - opts.length + part_middle
          last_pack = #parts - part_last
        end

        if vim.bo.filetype == "octo" then
          part_middle = 4
          part_last = 2
        end

        parts = { part_first, unpack(parts, middle_pack, last_pack) }
      end

      path = table.concat(parts, sep)
      if is_medium_width then
        path = path:gsub("^/", "")
      end
      return #path > 0 and (path .. sep)
    end,
    hl = { bold = true },
  },
  {
    provider = function(self)
      local opts = { relative = "cwd", length = 3 }
      local path = vim.fn.fnamemodify(self.bufname, ":t")

      if #self.filename == 0 then
        return " " .. vim.api.nvim_get_option_value("filetype", { buf = 0 })
      end

      if vim.bo.filetype == "qf" then
        if path:find(RUtils.config.path.home, 1, true) == 1 then
          path = path:sub(#RUtils.config.path.home + 2)
        end
        return RUtils.file.basename(path)
      end

      if self.git_type then
        local commit, filepath
        local clean = self.bufname:gsub("^%w+://", "")

        if self.git_type == "diffview" then
          commit, filepath = clean:match "/%.git/([^/]+)/(.+)$"
        elseif self.git_type == "diffview" then
          commit, filepath = clean:match "/%.git/([^/]+)/(.+)$"
        elseif self.git_type == "fugitive" then
          commit, filepath = clean:match "/%.git//(%x+)/(.*)$"
        end

        if filepath and commit then
          local dir = path
          if dir == "." then
            dir = ""
          end

          local parts = vim.split(dir, "[\\/]")
          if #parts > opts.length then
            parts = { "…", unpack(parts, #parts - opts.length + 1) }
          end

          local display_path = table.concat(parts, "/")
          if #display_path > 0 then
            display_path = display_path
          end

          return string.format("%s [%s] ", display_path, commit:sub(1, 7))
        end
      end

      return RUtils.file.basename(self.filename)
    end,
    hl = function()
      local fg = colors.bright
      if vim.bo.filetype == "qf" then
        fg = colors.statusline_fg
      end
      return { fg = fg, bold = true }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.statusline_bg
      if set_conditions.is_terminal_ft() then
        fg = colors.mode_term_statusline_bg
      end

      return { fg = fg }
    end,
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
    local hl_opts = set_winbar_hl()
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
      local fg = colors.qf_indicator_fg
      local bg = colors.qf_indicator_bg
      if RUtils.qf.is_loclist() then
        fg = colors.lf_indicator_fg
        bg = colors.lf_indicator_bg
      end
      return { fg = fg, bg = bg, bold = true }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = function()
      local fg = colors.qf_indicator_bg
      if RUtils.qf.is_loclist() then
        fg = colors.lf_indicator_bg
      end
      return { fg = fg, bg = colors.winbar_bg_bottom }
    end,
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.winbar_bg_bottom, bg = colors.qf_keyword_bg },
  },
  {
    provider = function(self)
      local parts = {}
      local stacklists = #RUtils.qf.get_total_stack_qf(RUtils.qf.is_loclist())
      local current_stacklists = RUtils.qf.get_current_history_qf(RUtils.qf.is_loclist())
      local idx_lists = RUtils.qf.get_current_idx_qf(RUtils.qf.is_loclist())
      table.insert(
        parts,
        string.format("  %d/%d 󱗿 %d/%d ", idx_lists, self.height, current_stacklists, stacklists)
      )
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.qf_keyword_fg, bg = colors.qf_keyword_bg, bold = true },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.qf_keyword_bg, bg = colors.winbar_bg_bottom },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.winbar_bg_bottom, bg = colors.qf_keyword_bg },
  },
  {
    provider = function(self)
      local parts = {}
      if RUtils.qf.is_loclist() then
        table.insert(parts, string.format(" %s %s ", "LFtitle:", self.title_loclist))
      else
        table.insert(parts, string.format(" %s %s ", "QFtitle:", self.title_qflist))
      end
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.statusline_fg, bg = colors.qf_keyword_bg, bold = true },
  },
  {
    provider = RUtils.config.icons.misc.separator_up,
    hl = { fg = colors.qf_keyword_bg, bg = colors.winbar_bg_bottom },
  },
}
M.FileFlags = {
  {
    provider = function()
      local icon_flag = "  "
      local is_readonly = (not vim.bo.modifiable or vim.bo.readonly) and true or false
      local is_modifiled = vim.bo.modified

      if is_readonly then
        icon_flag = RUtils.config.icons.misc.readonly
      end

      if is_modifiled then
        icon_flag = RUtils.config.icons.misc.modified
      end

      return " " .. icon_flag .. " "
    end,
    hl = { fg = colors.modified_fg },
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
    --
    --   local python_logo = "" -- Icon Python
    --   local venv_path = vim.env.VIRTUAL_ENV or ""
    --   local venv_name = ""
    --
    --   -- Ambil nama folder virtualenv (nama environment)
    --   if venv_path ~= "" then
    --     venv_name = venv_path:match "([^/\\]+)$" or venv_path
    --   end
    --
    --   -- Cek apakah ini Poetry (.venv biasanya Poetry default)
    --   local is_poetry_venv = venv_name:find "%.venv" ~= nil
    --
    --   if is_poetry_venv then
    --     self.venv = string.format("%s UV ", python_logo)
    --   elseif venv_name ~= "" then
    --     self.venv = string.format("%s venv ", python_logo)
    --   else
    --     self.venv = ""
    --   end
  end,
  {
    provider = function()
      local uv = require "uv"
      local uv_venv = uv.get_venv()
      local python_logo = "" -- Icon Python

      local venv = ""
      if uv_venv then
        venv = string.format("%s %s ", python_logo, uv_venv)
      end
      return venv
    end,
    hl = function(self)
      return { fg = self.icon_color, bold = true }
    end,
  },
}
M.LSPActive = {
  update = { "LspAttach", "LspDetach", "VimResized", "FileType", "BufEnter", "BufWritePost" },
  condition = function()
    return Conditions.lsp_attached
        and vim.bo.filetype ~= "qf"
        and vim.fn.mode(1) ~= "t"
        and not set_conditions.is_path_git_relative()
        and set_conditions.hide_in_col_width(100)
      or (vim.bo.filetype == "octo")
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
    provider = " LSP: ",
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
      if self.result.incomplete == 1 or self.result.incomplete == nil then
        return ""
      end

      -- Retrieve the current search query from Neovim's search register.
      -- This gets the last pattern used for searching with '/' in normal mode.
      local search_query = vim.fn.getreg "/"

      local too_many = (">%d"):format(self.result.maxcount)
      local current = self.result.current > self.result.maxcount and too_many or self.result.current
      local total = self.result.total > self.result.maxcount and too_many or self.result.total
      if search_query == "" then
        return string.format("%s/%s  ", current, total)
      else
        return string.format(" (%s) %s/%s  ", search_query, current, total)
      end
    end,
    hl = { bg = colors.search_count_bg, fg = colors.search_count_fg, bold = true },
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
    return require("lazy.status").has_updates() and set_conditions.hide_in_col_width(100)
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
    local ses = get_session()
    if ses and ses.get_current() then
      return true
    end
    return false
  end,
  {
    provider = function()
      local ses_status = get_session().get_current()
      return RUtils.config.icons.misc.session .. ses_status .. "  "
    end,
  },
}
M.PinnedBuffer = {
  condition = function()
    local pinned = get_pinnedBuf()
    if pinned and pinned.is_pinned() then
      return true
    end
    return false
  end,
  {
    provider = function()
      return RUtils.config.icons.misc.dashboard .. "  "
    end,
    hl = { fg = colors.diagnostic_err },
  },
}
M.QFbookmark = {
  condition = function()
    local qfbook = get_qfbookmark()
    if qfbook and qfbook.status_mark() then
      return true
    end
    return false
  end,
  {
    provider = function()
      return RUtils.config.icons.misc.flags .. " "
    end,
    hl = { fg = colors.diagnostic_err },
  },
}
M.Tasks = {
  condition = function()
    return package.loaded.overseer and set_conditions.hide_in_col_width(120)
  end,
  init = function(self)
    local tasks = require("overseer").list_tasks { unique = true }
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
    hl = { fg = colors.statusline_bg, bg = colors.task_bg },
  },
  {
    provider = function(self)
      for i, _ in pairs(symbols_overseer) do
        if self.tasks[i] then
          return " Overseer: "
        end
      end
    end,
    hl = { fg = colors.statusline_bg, bg = colors.task_bg, bold = true },
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
    hl = { fg = colors.task_bg, bg = colors.task_bg },
  },
}
M.RmuxTargetPane = {
  init = function(self)
    local status = get_rmux()

    self.run_with = status.run_with
    self.task = status.task
    self.watch = status.watch

    local overseer = require "overseer"
    local tasks = overseer.list_tasks { unique = true }
    self.tasks_overseer = require("overseer.util").tbl_group_by(tasks, "status")

    self.has_overseer_task = false
    for i, _ in pairs(symbols_overseer) do
      if self.tasks_overseer[i] then
        self.has_overseer_task = true
        break
      end
    end
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
      return { fg = fg, bg = colors.task_bg }
    end,
  },
  {
    provider = function(self)
      if self.task > 0 then
        return "  " .. self.task
      end
    end,
    hl = { fg = colors.task_fg, bg = colors.task_bg, bold = true },
  },
  {
    provider = function(self)
      if #self.watch > 0 then
        return "  " .. self.watch
      end
    end,
    hl = { fg = colors.task_fg, bg = colors.task_bg, bold = true },
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
    hl = { fg = colors.task_bg, bg = colors.task_bg },
  },
  {
    provider = function(self)
      local has_task = self.task > 0 or (self.watch and #self.watch > 0)

      if has_task or set_conditions.is_terminal_ft() or self.has_overseer_task then
        return RUtils.config.icons.misc.separator_down .. " "
      end
    end,
    hl = function(self)
      local fg = colors.statusline_bg

      local has_task = self.task > 0 or (self.watch and #self.watch > 0)

      if set_conditions.is_terminal_ft() then
        fg = colors.mode_term_statusline_bg
      elseif not set_conditions.hide_in_col_width(120) then
        fg = colors.statusline_bg
      elseif has_task or self.has_overseer_task then
        fg = colors.task_bg
      end

      return { fg = fg, bg = colors.statusline_bg }
    end,
  },
}
M.Filetype = {
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)

    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local status = get_rmux()
    self.run_with = status.run_with
    self.task = status.task or 0
    self.watch = status.watch or ""

    local overseer = require "overseer"
    local tasks = overseer.list_tasks { unique = true }
    self.tasks_overseer = require("overseer.util").tbl_group_by(tasks, "status")

    self.filetype = get_vars.filetype()
  end,
  -- {
  --   provider = function(self)
  --     if self.filetype and #self.filetype > 0 then
  --       return RUtils.config.icons.misc.separator_down .. " "
  --     end
  --   end,
  --   hl = function(self)
  --     local fg = colors.statusline_bg
  --
  --     local has_task = self.task > 0 or (self.watch and #self.watch > 0)
  --     local has_overseer_task = false
  --
  --     for i, _ in pairs(symbols_overseer) do
  --       if self.tasks_overseer[i] then
  --         has_overseer_task = true
  --         break
  --       end
  --     end
  --
  --     if set_conditions.is_terminal_ft() then
  --       fg = colors.mode_term_statusline_bg
  --     elseif not set_conditions.hide_in_col_width(120) then
  --       fg = colors.statusline_bg
  --     elseif has_task or has_overseer_task then
  --       fg = colors.task_bg
  --     end
  --
  --     return { fg = fg, bg = colors.statusline_bg }
  --   end,
  -- },
  {
    provider = function(self)
      -- if self.filetype and #self.filetype > 0 then
      --   return self.icon and (self.icon .. " " .. self.filetype .. " ")
      -- end

      if self.filetype and #self.filetype > 0 then
        return self.filetype .. " "
      end
    end,
    hl = { fg = colors.statusline_fg },
  },
  -- {
  --   provider = RUtils.config.icons.misc.separator_down .. " ",
  --   hl = function(self)
  --     local fg = colors.statusline_bg
  --     -- if set_conditions.is_terminal_ft() then
  --     --   fg = colors.mode_term_statusline_bg
  --     -- end
  --     -- if self.filetype and #self.filetype > 0 then
  --     --   fg = colors.statusline_right_block_bg_darken
  --     --   fg = colors.statusline_right_block_bg_darken
  --     -- end
  --     -- return { fg = fg, bg = colors.statusline_right_block_bg }
  --     return { fg = fg, bg = colors.statusline_bg }
  --   end,
  -- },
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
      local padding = #tostring(self.height) - #tostring(self.line)
      if padding > 0 then
        rhs = rhs .. (" "):rep(padding)
      end
      return rhs
    end,
  },
  -- {
  --   provider = function(self)
  --     local rhs = self.rhs
  --     rhs = rhs .. "ℓ " -- (Literal, \ℓ "SCRIPT SMALL L").
  --     return rhs
  --   end,
  --   hl = { fg = colors.statusline_fg, bg = colors.statusline_bg, bold = false },
  -- },
  {
    provider = function(self)
      local rhs = self.rhs
      rhs = rhs .. self.line
      return rhs
    end,
    hl = { fg = colors.bright, bold = true },
  },
  {
    provider = function(self)
      local rhs = self.rhs
      rhs = rhs .. "/"
      rhs = rhs .. self.height
      return rhs
    end,
    hl = { fg = colors.statusline_fg, bold = false },
  },
  {
    provider = function(self)
      local rhs = self.rhs
      rhs = rhs .. " 𝚌 "
      return rhs
    end,
    hl = { fg = colors.statusline_fg, bold = false },
  },
  {
    provider = function(self)
      local rhs = self.rhs
      rhs = rhs .. self.column
      if #tostring(self.column) < 2 then
        rhs = rhs .. " "
      end
      -- rhs = rhs .. "/"
      -- rhs = rhs .. self.width
      return rhs .. " "
    end,
    hl = { fg = colors.bright, bold = true },
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
  M.Mode,
  M.SearchCount,
  M.FilePath,
  M.FileFlags,
  M.Ruler,
  -- M.FileIcon,
  -- M.QuickfixStatus,

  M.Gap,

  -- M.LazyStatus,
  M.Dap,
  M.Diagnostics,
  M.LSPActive,
  M.virtualenv,
  -- M.SnacksProfile,
  -- M.SearchCount, -- this func make nvim slow!
  M.PinnedBuffer,
  -- M.Sessions,
  M.QFbookmark,
  M.Tasks,
  M.RmuxTargetPane,
  M.Filetype,
  M.Branch,
  M.Git,
  -- M.Clock,

  hl = function()
    local fg = colors.statusline_fg
    local bg = colors.statusline_bg

    if set_conditions.is_terminal_ft() then
      fg = colors.mode_term_statusline_fg
      bg = colors.mode_term_statusline_bg
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
    self.bufname = vim.api.nvim_buf_get_name(0)
    -- Detect valid filetype git
    self.git_type = self.bufname:match "^gitsigns://" and "gitsigns"
      or self.bufname:match "^diffview://" and "diffview"
      or self.bufname:match "^fugitive://" and "fugitive"
      or nil
  end,
  condition = function()
    return vim.bo.filetype ~= "qf"
  end,
  {
    provider = function()
      local opts = { relative = "cwd", length = 3 }

      local raw_path = vim.fn.expand "%:p"
      if raw_path == "" then
        return ""
      end

      local root = RUtils.root.get { normalize = true }
      local cwd = RUtils.root.cwd()
      local path = raw_path

      if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
        path = path:sub(#cwd + 2)
      elseif path:find(root, 1, true) == 1 then
        path = path:sub(#root + 2)
      end

      local sep = package.config:sub(1, 1)
      local parts = vim.split(path, "[\\/]")

      if #parts > opts.length then
        local select_last = 1
        local select_middle = 1

        -- If we're using Octo, we need to use the correct format
        -- userrepo/repo/issue/<commit> or userrepo/repo/request/<commit>."
        if vim.bo.filetype == "octo" then
          select_middle = 0
          select_last = 2
        end

        parts = { "…", unpack(parts, #parts - opts.length + select_middle, #parts - select_last) }
      else
        table.remove(parts, #parts)
      end

      path = table.concat(parts, sep)
      return #path > 0 and (" " .. path .. sep) or " "
    end,
    hl = function()
      local hl_opts = set_winbar_hl()
      return { fg = hl_opts.fg, bg = hl_opts.bg }
    end,
  },
  {
    condition = function()
      return not (set_conditions and set_conditions.is_dont_show_at_ft())
    end,
    provider = function(self)
      local opts = { relative = "cwd", length = 3 }
      local path = vim.fn.fnamemodify(self.bufname, ":t")

      if vim.bo.filetype == "octo" then
        path = vim.fn.fnamemodify(self.bufname, ":p")
        local parts = vim.split(path, "[\\/]")
        parts = { "…", unpack(parts, #parts - opts.length + 1, #parts) }
        return parts[#parts - 1] .. "/" .. parts[#parts]
      end

      if self.git_type then
        local commit, filepath
        local clean = self.bufname:gsub("^%w+://", "")

        if self.git_type == "gitsigns" then
          filepath, commit = clean:match "^(.-)//(.*)$"
        elseif self.git_type == "diffview" then
          commit, filepath = clean:match "/%.git/([^/]+)/(.+)$"
        elseif self.git_type == "fugitive" then
          commit, filepath = clean:match "%.git//(%x+)/(.*)$"
        end

        if filepath and commit then
          if commit:match "^0+$" then
            commit = "NEW"
          end

          -- Get the path
          -- local dir = vim.fn.fnamemodify(filepath, ":h")
          local dir = path
          if dir == "." then
            dir = ""
          end

          -- Shorten the path
          local parts = vim.split(dir, "[\\/]")
          if #parts > opts.length then
            parts = { "…", unpack(parts, #parts - opts.length + 1) }
          end

          local display_path = table.concat(parts, "/")
          if #display_path > 0 then
            display_path = display_path
          end

          return string.format("%s [%s] ", display_path, commit:sub(1, 7))
        end
      end
      return path
    end,
    hl = function()
      local hl_opts = set_winbar_hl(true)
      return { fg = hl_opts.fg, bg = hl_opts.bg, bold = true }
    end,
  },
}
M.WinbarNavic = {
  init = function(self)
    self.req_navic = get_navic()
  end,
  condition = function()
    return get_navic() ~= nil
  end,
  {
    condition = function(self)
      return set_conditions.is_lsp_attached()
        and self.req_navic.is_available()
        and not set_conditions.is_path_git_relative()
        and not set_conditions.is_terminal_ft()
        and not vim.tbl_contains({ "codecompanion" }, vim.bo.filetype)
        and not set_conditions.is_diff()
    end,
    provider = function(self)
      local buf = vim.api.nvim_get_current_buf()
      local data = self.req_navic.get_data(buf)

      if not data or #data == 0 then
        return
      end

      local location = self.req_navic.get_location()
      local parts = {}
      for _, d in ipairs(data) do
        table.insert(parts, d.icon .. d.name)
      end

      local function format_part(item) -- function helper to add highlights group
        local hl_group = "LspKind" .. item.type
        return string.format("%%#%s#%s%%#WinBar#%s%%*", hl_group, item.icon, item.name)
      end

      local sep = " "
      local first = format_part(data[1])

      local fmt_navic

      if set_conditions.hide_in_width(80) then
        fmt_navic = string.format("%s%%#NavicSeparator# %s %%#NavicSeparator#", sep, first)
      elseif set_conditions.hide_in_width(90) then
        local last = format_part(data[#data])
        fmt_navic = string.format("%s%%#NavicSeparator# %s %%#NavicSeparator# … %%* %s", sep, first, last)
      else
        fmt_navic = sep .. "%#NavicSeparator# " .. location

        local function get_display_width(str)
          local clean_str = str:gsub("%%#.-#", "") -- Hapus kode highlight %#GroupName#
          clean_str = clean_str:gsub("%%%*", "") -- Hapus kode penutup highlight %*
          clean_str = clean_str:gsub("%%.", "") -- Hapus item statusline lainnya->  %l, %c, dsb
          return vim.fn.strdisplaywidth(clean_str)
        end
        local display_width = get_display_width(fmt_navic)

        if not Conditions.width_percent_below(display_width, 0.50) then
          local last = format_part(data[#data])
          fmt_navic = string.format("%s%%#NavicSeparator# %s %%#NavicSeparator# … %%* %s", sep, first, last)
        end
      end

      return fmt_navic
    end,
  },
  hl = function()
    local fg = colors.winbar_fg
    local bg = colors.winbar_bg

    if set_conditions.is_note_ft() then
      fg = colors.mode_note_fg
      bg = colors.mode_note_bg
    end

    return { fg = fg, bg = bg }
  end,
}

M.status_winbar_active_left = {
  -- M.WinbarSeparator,
  M.FileIcon,
  M.WinbarFilePath,
  M.WinbarNavic,
  M.QuickfixStatus,

  M.Gap,

  hl = function()
    local hl_opts = set_winbar_hl()
    return { fg = hl_opts.fg, bg = hl_opts.bg, bold = true }
  end,
}

return M
