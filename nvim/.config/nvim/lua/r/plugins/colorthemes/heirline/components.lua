local fn = vim.fn
-- local Util = require "r.utils"
local Icon = require("r.config").icons
local Conditions = require "heirline.conditions"
local Highlight = require "r.config.highlights"

local M = {}

local col_bg_StatusLine = Highlight.get("ColorColumn", "bg")
local col_bg_ErrorMsg = Highlight.get("ErrorMsg", "fg")
local col_normal_statusLine = Highlight.get("StatusLine", "bg")

local colors = {
  base_bg = col_normal_statusLine,
  base_fg = Highlight.tint(col_bg_StatusLine, 3),

  branch_fg = Highlight.tint(col_bg_StatusLine, 4),
  mode_bg = Highlight.tint(col_bg_StatusLine, 1),
  filename_fg = Highlight.tint(col_bg_StatusLine, 6),
  modified_fg = Highlight.tint(col_bg_ErrorMsg, 0.3),

  coldisorent = Highlight.tint(col_bg_StatusLine, 0.5),

  mod_norm = Highlight.get("@field", "fg"),
  mod_ins = Highlight.tint(col_bg_ErrorMsg, 0),
  mod_vis = Highlight.get("visual", "bg"),
  mod_term = Highlight.get("Boolean", "fg"),

  diff_add = Highlight.get("diffAdd", "fg"),
  diff_delete = Highlight.get("diffDelete", "fg"),
  diff_change = Highlight.get("diffChange", "fg"),

  diagnostic_warn = Highlight.get("DiagnosticSignWarn", "fg"),
  diagnostic_err = Highlight.get("DiagnosticSignError", "fg"),
  diagnostic_info = Highlight.get("DiagnosticSignInfo", "fg"),
  diagnostic_hint = Highlight.get("DiagnosticSignHint", "fg"),
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

local function git_branch()
  local status
  if vim.b.mdpreview_session then
    status = vim.b[vim.b.mdpreview_session.source_buf].gitsigns_status_dict
  else
    status = vim.b.gitsigns_status_dict
  end
  return vim.tbl_get(status or {}, "head")
end

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
      n = colors.mod_norm,
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
      t = colors.mod_term,
    },
  },
  {
    provider = function(self)
      return string.format("    %s   ", self.mode_icons[self.mode])
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { bg = self.mode_colors[mode], fg = colors.base_bg, bold = true }
    end,
  },

  -- {
  --   provider = sep.rounded_right,
  --   hl = function(self)
  --     local mode = self.mode:sub(1, 1)
  --     if conditions.is_git_repo() then
  --       return { fg = self.mode_colors[mode], bg = "gray" }
  --     else
  --       return { fg = self.mode_colors[mode], bg = "bg_statusline" }
  --     end
  --   end,
  -- },
}
M.Branch = {
  condition = function()
    return git_branch() ~= nil
  end,

  {
    provider = function()
      return string.format("  %s", git_branch())
    end,
    hl = { fg = colors.base_fg, bg = colors.base_bg, bold = true },
  },
}
M.Git = {
  condition = Conditions.is_git_repo,
  provider = " ",

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = colors.base_fg, bg = colors.base_bg, bold = true },

  {
    provider = function(self)
      return "  " .. self.status_dict.head .. " "
    end,
    hl = { bold = true },
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count .. "")
    end,
    hl = { fg = colors.diff_add },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (" -" .. count .. "")
    end,
    hl = { fg = colors.diff_delete },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (" ~" .. count .. "")
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
M.FilePath = {
  init = function(self)
    self.bufname = vim.api.nvim_buf_get_name(0)
  end,
  provider = " ",
  {
    -- condition = function(self)
    --   return require("my.configure.heirline.conditions").should_show_filename(self.bufname)
    -- end,
    provider = function()
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
      if filename == "" then
        return "[No Name]"
      end
      -- now, if the filename would occupy more than 90% of the available
      -- space, we trim the file path to its initials
      if not Conditions.width_percent_below(#filename, 0.40) then
        filename = vim.fn.pathshorten(filename)
      end
      return filename
    end,
  },
}
M.FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = " [+]",
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = " ",
  },
}
M.LSPActive = {
  update = { "LspAttach", "LspDetach", "VimResized", "FileType", "BufEnter", "BufWritePost" },

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
        return " [" .. table.concat(self.names, " ") .. "] "
      end
    end,
  },
  {
    condition = Conditions.lsp_attached,
    provider = " [LSP] ",
  },
  {
    condition = Conditions.lsp_attached,
    provider = " ",
  },
}
M.FileIcon = {
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (" " .. self.icon)
  end,
  hl = function(self)
    return { fg = self.icon_color, bg = colors.base_bg }
  end,
}
M.SearchCount = {
  init = function(self)
    local _, result = pcall(fn.searchcount, { recompute = 1, maxcount = 10000 })
    self.result = result
  end,

  provider = function(self)
    if vim.tbl_isempty(self.result) then
      return ""
    end
    if self.result.current > 0 then
      return " "
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
      if vim.tbl_isempty(self.result) then
        return ""
      end
      if self.result.incomplete == 1 then -- timed out
        return "?/?? "
      elseif self.result.incomplete == 2 then -- max count exceeded
        if self.result.total > self.result.maxcount and self.result.current > self.result.maxcount then
          return string.format(">%d/>%d ", self.result.current, self.result.total)
        elseif self.result.total > self.result.maxcount then
          return "%#MyStatusLine_red_fg#" .. string.format("%d/>%d ", self.result.current, self.result.total) .. "%*"
        end
      end
      return "%#MyStatusLine_red_fg#" .. string.format("%d/%d ", self.result.current, self.result.total) .. "%*"
    end,
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
  provider = " ",
  {
    provider = function()
      local ok, ses_persistent = pcall(require, "persistence")
      if not ok then
        return "%#MyStatusLine_notif_fg# No Plugin%* "
      end

      local ses_persistent_get_current = ses_persistent.get_current()
      local sess = vim.fn.filereadable(ses_persistent_get_current) == 1
      if sess ~= nil then
        return "%#MyStatusLine_notif_fg# On%* "
      end

      return "%#MyStatusLine_notif_fg# off%* "
    end,
    -- hl = function(self)
    --   return { fg = self.icon_color, bg = colors.base_bg }
    -- end,
  },
}
M.BufferCwd = {
  init = function(self)
    self.bufnr = self.bufnr or 0
  end,
  provider = " ",
  {
    provider = function(self)
      local cwd = vim.fn.fnamemodify(vim.b[self.bufnr].project_nvim_cwd or vim.uv.cwd(), ":t")
      if not cwd or cwd == "" then
        return ""
      end

      return "%#MyStatusLine_directory_fg# " .. cwd .. "%* "
    end,
  },
}
M.Ruler = {
  provider = " ",
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

      return rhs
    end,
    hl = function()
      return { fg = colors.base_fg, bg = colors.base_bg, bold = true }
    end,
  },
}

return M