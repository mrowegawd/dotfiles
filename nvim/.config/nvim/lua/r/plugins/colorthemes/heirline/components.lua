local fn = vim.fn
local Icon = require("r.config").icons
local Conditions = require "heirline.conditions"
local Col = RUtils.colortbl

local M = {}

local setcond = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function(size)
    size = size or 120
    return vim.fn.winwidth(0) > size
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local colors = {

  base_bg = Col.statusline_bg,
  base_fg = Col.statusline_fg,
  basenc_bg = Col.statuslinenc_bg,

  branch_fg = Col.branch_fg,
  terminal_fg = Col.terminal_fg,

  mode_bg = Col.mode_bg,
  filename_fg = Col.mode_bg,
  modified_fg = Col.modified_fg,

  coldisorent = Col.disorent,

  separator_fg = Col.separator_fg,
  separator_fg_alt = Col.separator_fg_alt,
  separator_fg_inactive = Col.separator_fg_inactive,

  mod_norm = Col.error_fg,
  mod_norm_bg = Col.norm_bg,
  mod_ins = Col.mod_ins,
  mod_vis = Col.mod_vis,
  mod_term = Col.mod_term,

  diff_add = Col.diff_add,
  diff_delete = Col.diff_delete,
  diff_change = Col.diff_change,

  diagnostic_warn = Col.diagnostic_warn,
  diagnostic_err = Col.diagnostic_err,
  diagnostic_info = Col.diagnostic_info,
  diagnostic_hint = Col.diagnostic_hint,
}

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
  static = {
    mode_icons = {
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
    },
    mode_colors = {
      n = colors.separator_fg,
      i = colors.mod_ins,
      v = colors.mod_vis,
      V = colors.mod_vis,
      ["\22"] = "cyan",
      c = colors.mod_term,
      s = "yellow",
      S = "yellow",
      ["\19"] = "orange",
      R = "purple",
      r = "purple",
      ["!"] = "green",
      -- t = colors.mod_term,
      t = colors.terminal_fg,
    },
  },
  {
    provider = function(self)
      return string.format("    %s ", self.mode_icons[self.mode])
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { bg = self.mode_colors[mode], fg = colors.mod_norm_bg, bold = true }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode], bg = colors.separator_fg_alt }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = function()
      return { fg = colors.separator_fg_alt, bg = colors.base_bg }
    end,
  },
}

M.Mode_inactive = {
  {
    provider = function()
      if vim.bo[0].filetype == "qf" then
        return string.format "    QF"
      end
      return string.format "      "
    end,
    hl = function()
      if vim.bo[0].filetype == "qf" then
        return { bg = colors.separator_fg_inactive, fg = colors.coldisorent }
      end
      return { bg = colors.separator_fg_inactive, fg = colors.base_bg }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = function()
      return { bg = colors.separator_fg_inactive, fg = colors.separator_fg_inactive }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = function()
      return { fg = colors.separator_fg_inactive }
    end,
  },
}
M.Branch = {
  condition = Conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  {
    provider = function(self)
      return "  " .. self.status_dict.head .. " "
    end,
    condition = function()
      return vim.bo[0].filetype ~= "qf"
    end,
    hl = { fg = colors.branch_fg, bold = true },
  },
}
M.Git = {
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  condition = Conditions.is_git_repo,
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("A+" .. count .. " ")
    end,
    hl = { fg = colors.diff_add },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("D-" .. count .. " ")
    end,
    hl = { fg = colors.diff_delete },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("M~" .. count .. " ")
    end,
    hl = { fg = colors.diff_change },
  },
}
M.Mixindent = {
  {
    provider = function()
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
  },
}

local function is_loclist()
  return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

M.FilePathQF = {
  condition = function()
    return vim.bo[0].filetype == "qf"
  end,
  init = function(self)
    self.bufname = vim.api.nvim_buf_get_name(0)
  end,

  {
    provider = Icon.misc.separator_up,
    hl = function()
      return { fg = colors.base_bg, bg = colors.diff_add }
    end,
  },
  {
    provider = function()
      local msg
      if is_loclist() then
        msg = vim.fn.getloclist(0, { title = 0 }).title
      else
        msg = string.format("%s/total?", vim.fn.getqflist({ id = 0 }).id)
      end

      return " " .. msg .. " "
    end,
    hl = function()
      local cs = colors.base_bg

      if Conditions.is_not_active() then
        cs = colors.basenc_bg
      end

      return { fg = cs, bg = colors.diff_add, bold = true }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = { bg = colors.separator_fg_alt, fg = colors.diff_add },
  },
  {
    provider = Icon.misc.separator_up,
    hl = function()
      local cs = colors.base_bg

      if Conditions.is_not_active() then
        cs = colors.basenc_bg
      end
      return { fg = colors.separator_fg_alt, bg = cs }
    end,
  },

  --  ------------------
  {
    provider = Icon.misc.separator_up,
    hl = function()
      local cs = colors.base_bg

      if Conditions.is_not_active() then
        cs = colors.basenc_bg
      end
      return { fg = cs, bg = colors.diff_change }
    end,
  },
  {
    provider = function()
      local msg
      if is_loclist() then
        msg = vim.fn.getloclist(0, { title = 0 }).title
      else
        msg = string.format("%s", vim.fn.getqflist({ title = 0 }).title)
      end
      return " " .. msg .. " "
    end,
    hl = function()
      local cs = colors.base_bg

      if Conditions.is_not_active() then
        cs = colors.basenc_bg
      end
      return { fg = cs, bg = colors.diff_change, bold = true }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = function()
      return { fg = colors.diff_change, bg = colors.separator_fg_alt }
    end,
  },
  {
    provider = Icon.misc.separator_up,
    hl = function()
      local cs = colors.base_bg

      if Conditions.is_not_active() then
        cs = colors.basenc_bg
      end
      return { fg = colors.separator_fg_alt, bg = cs }
    end,
  },
}
M.FilePath = {
  init = function(self)
    self.bufname = vim.api.nvim_buf_get_name(0)
  end,
  {
    provider = function()
      if vim.bo[0].filetype == "qf" then
        return ""
      end

      if vim.bo[0].filetype == "dashboard" then
        return ""
      end

      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
      if filename == "" then
        return "[No Name]"
      end
      -- now, if the filename would occupy more than 90% of the available
      -- space, we trim the file path to its initials
      if not Conditions.width_percent_below(#filename, 0.40) then
        filename = vim.fn.pathshorten(filename)
      end
      return " " .. filename .. " "
    end,
    hl = function()
      if Conditions.is_not_active() then
        return { fg = Col.statuslinenc_fg }
      end
      return { fg = colors.base_fg }
    end,
  },
}
M.FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = " " .. Icon.misc.boldclose,
    hl = { fg = colors.diagnostic_err },
  },
  {
    condition = function()
      return (vim.bo.filetype ~= "fzf") and (vim.bo.filetype ~= "qf") and (not vim.bo.modifiable or vim.bo.readonly)
    end,
    provider = " ",
    hl = { fg = colors.diagnostic_err },
  },
}
M.Dap = {
  condition = function()
    if package.loaded.dap == nil then
      return false
    end
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return " " .. require("dap").status() .. " "
  end,
  hl = { fg = colors.diagnostic_err, bg = colors.base_bg, bold = true },
}
M.LSPActive = {
  update = { "LspAttach", "LspDetach", "VimResized", "FileType", "BufEnter", "BufWritePost" },

  condition = function()
    return Conditions.lsp_attached and setcond.hide_in_width(150)
  end,

  init = function(self)
    local names = {}
    local lsp = rawget(vim, "lsp")
    if lsp then
      for _, server in pairs(lsp.get_active_clients { bufnr = 0 }) do
        table.insert(names, server.name)
      end
    end
    local lint = package.loaded.lint
    if lint and vim.bo.buftype == "" then
      table.insert(names, "+")
      for _, linter in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
        table.insert(names, linter)
      end
    end
    local conform = package.loaded.conform
    if conform and vim.bo.buftype == "" then
      local formatters = conform.list_formatters(0)
      if not conform.will_fallback_lsp() then
        -- table.insert(names, "⫽")
        for _, formatter in ipairs(formatters) do
          table.insert(names, formatter.name)
        end
      end
    end
    self.names = names
  end,
  provider = function(self)
    if #self.names > 1 then
      return ""
    end
    return " "
  end,
  flexible = 1,
  {
    provider = function(self)
      if vim.tbl_isempty(self.names) then
        return ""
      else
        return " [" .. table.concat(self.names, " ") .. "]  "
      end
    end,
    hl = { fg = colors.base_fg, bg = colors.base_bg },
  },
}
M.FileIcon = {
  condition = function()
    return vim.bo.filetype ~= "qf"
  end,
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
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
    error_icon = Icon.diagnostics.Error,
    warn_icon = Icon.diagnostics.Warn,
    info_icon = Icon.diagnostics.Info,
    hint_icon = Icon.diagnostics.Hint,
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

  provider = function(self)
    if self.errors > 0 or self.warnings > 0 or self.hints > 0 or self.info > 0 then
      return " "
    end
    return ""
  end,
  {
    condition = function(self)
      return self.errors > 0
    end,
    {
      provider = function(self)
        return self.error_icon
      end,
      hl = { fg = colors.diagnostic_err, bg = colors.base_bg },
    },
    {
      provider = function(self)
        return self.errors .. " "
      end,
      hl = { fg = colors.diagnostic_err, bg = colors.base_bg, bold = true },
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
      hl = { fg = colors.diagnostic_warn, bg = colors.base_bg },
    },
    {
      provider = function(self)
        return self.warnings .. " "
      end,
      hl = { fg = colors.diagnostic_warn, bg = colors.base_bg, bold = true },
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
      hl = { fg = colors.diagnostic_info, bg = colors.base_bg },
    },
    {
      provider = function(self)
        return self.info .. " "
      end,
      hl = { fg = colors.diagnostic_info, bg = colors.base_bg, bold = true },
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
      hl = { fg = colors.diagnostic_hint, bg = colors.base_bg },
    },
    {
      provider = function(self)
        return self.hints .. " "
      end,
      hl = { fg = colors.diagnostic_hint, bg = colors.base_bg, bold = true },
    },
  },
}
M.Sessions = {
  condition = function()
    return vim.bo[0].filetype ~= "qf" and setcond.hide_in_width()
  end,
  {
    provider = function()
      local ok, ses_persistent = pcall(require, "persistence")
      if not ok then
        return "%#MyStatusLine_notif_fg# (manual)%* "
      end

      local ses_persistent_get_current = ses_persistent.get_current()
      local sess = vim.fn.filereadable(ses_persistent_get_current) == 1
      if sess ~= nil then
        -- return "%#MyStatusLine_notif_fg# On%* "
        return " On "
      end

      -- return "%#MyStatusLine_notif_fg# off%* "
      return " off "
    end,
    hl = { fg = colors.diagnostic_warn },
  },
}
M.BufferCwd = {
  init = function(self)
    self.bufnr = self.bufnr or 0
  end,
  condition = function()
    return vim.bo[0].filetype ~= "qf" and setcond.hide_in_width(80)
  end,
  provider = " ",
  {
    provider = function(self)
      local cwd = vim.fn.fnamemodify(vim.b[self.bufnr].project_nvim_cwd or vim.uv.cwd(), ":t")
      if not cwd or cwd == "" then
        return ""
      end

      -- return "%#MyStatusLine_directory_fg# " .. cwd .. "%* "
      return " " .. cwd .. "%* "
    end,
    hl = { fg = Col.direcotory },
  },
}
M.Ruler = {
  condition = function()
    return setcond.hide_in_width(130)
  end,
  {
    provider = function()
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

        rhs = rhs .. "ℓ " -- (Literal, \ℓ "SCRIPT SMALL L").
        rhs = rhs .. line
        rhs = rhs .. "/"
        rhs = rhs .. height
        rhs = rhs .. " 𝚌 " -- (Literal, \ᵨc "MATHEMATICAL MONOSPACE SMALL C").
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

      return " " .. rhs
    end,
    hl = { fg = colors.base_fg },
  },
}
M.Gap = {
  { provider = "%=" },
}

M.status_active_left = {
  condition = Conditions.is_active,
  M.Mode,
  M.Branch,
  M.FilePath,
  M.FileIcon,
  M.Git,
  M.FilePathQF,
  M.FileFlags,
  M.Gap,
  M.Dap,
  M.LSPActive,
  M.Diagnostics,
  M.SearchCount, -- this func make nvim slow!
  M.Sessions,
  M.BufferCwd,
  M.Ruler,

  hl = { fg = colors.base_fg, bg = colors.base_bg },
}

M.status_not_active = {
  condition = Conditions.is_not_active,
  M.Mode_inactive,
  M.Branch,
  M.FilePath,
  M.FileIcon,
  M.Git,
  M.FilePathQF,
  M.FileFlags,
  M.Gap,
  M.Ruler,

  hl = { bg = colors.basenc_bg },
}

return M
