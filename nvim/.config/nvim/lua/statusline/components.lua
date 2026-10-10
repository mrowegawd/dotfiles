local M = {}

local Conditions
local H = require "utils.highlights"

local function get_conditions()
  if not Conditions then
    Conditions = require "heirline.conditions"
  end

  return Conditions
end

local UtilQf = function()
  return require "utils.qf"
end
local Icons = require "icons"
local ConfigPath = require("config").path

local function rpad(child)
  return { condition = child.condition, child }
end

local dap_ft_include = { "dapui_scopes", "dapui_stacks", "dapui_watches", "dapui_breakpoints", "dap-repl" }

local get_vars = {
  filetype = function()
    return vim.bo.filetype
  end,

  path = function()
    return vim.api.nvim_buf_get_name(0)
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

local GRAY_FT = {
  dapui_watches = true,
  dapui_stacks = true,
  dapui_breakpoints = true,
  dapui_scopes = true,
  dbui = true,
}
local GREEN_FT = {
  help = true,
}
local DONT_SHOW_AT_FT = {
  oil = true,
  DiffviewFilePanel = true,
}
local AI_PROMPT_FT = {
  codecompanion = true,
}
local NOTE_FT = {
  org = true,
  markdown = true,
  octo = true,
}

local set_conditions = {
  buffer_not_empty = function()
    return vim.api.nvim_buf_get_name(0) ~= ""
  end,

  ---@param size? number
  hide_in_width = function(size)
    size = size or 120
    return vim.api.nvim_win_get_width(0) < size
  end,

  ---@param size? number
  hide_in_col_width = function(size)
    size = size or 120
    return vim.o.columns > size
  end,

  hide_in_laststatus = function()
    return vim.o.laststatus == 2
  end,

  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")

    return gitdir ~= "" and #gitdir < #filepath
  end,

  is_path_git_relative = function()
    local path = vim.api.nvim_buf_get_name(0)

    return path:match "^fugitive:/" or path:match "^diffview:/" or path:match "^neogit:/" or path:match "^gitsigns:/"
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
    return GRAY_FT[vim.bo.filetype] == true
  end,

  is_green_ft = function()
    return GREEN_FT[vim.bo.filetype] == true
  end,

  is_dont_show_at_ft = function()
    return DONT_SHOW_AT_FT[vim.bo.filetype] == true
  end,

  is_aiprompt_ft = function()
    return AI_PROMPT_FT[vim.bo.filetype] == true
  end,

  is_note_ft = function()
    return NOTE_FT[vim.bo.filetype] == true
  end,
}

-- ├───────────────────────────────┤ LSP HELPER ├───────────────────────────────┤

local lsp_cache = {}

local function update_lsp_cache(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local clients = vim.lsp.get_clients { bufnr = buf }
  local names = {}

  -- LSP
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end

  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype

  if buftype == "" and filetype ~= "" then
    -- nvim-lint
    local lint = package.loaded.lint

    if lint then
      for _, linter in ipairs(lint.linters_by_ft[filetype] or {}) do
        names[#names + 1] = "+" .. linter
      end
    end

    -- conform.nvim
    local conform = package.loaded.conform

    if conform then
      local ok, formatters = pcall(conform.list_formatters, {
        bufnr = buf,
      })

      if ok then
        for _, formatter in ipairs(formatters) do
          if type(formatter.name) == "string" then
            names[#names + 1] = "~" .. formatter.name
          end
        end
      end
    end
  end

  table.sort(names)

  lsp_cache[buf] = {
    names = names,
    has_lsp = #clients > 0,
  }
end

local function refresh_lsp(buf)
  local old = lsp_cache[buf]

  update_lsp_cache(buf)

  local new = lsp_cache[buf]

  if not new then
    return
  end

  if not old or old.has_lsp ~= new.has_lsp or table.concat(old.names, "\0") ~= table.concat(new.names, "\0") then
    vim.cmd.redrawstatus()
  end
end

local lsp_augroup = vim.api.nvim_create_augroup("statusline_lsp_cache", { clear = true })
vim.api.nvim_create_autocmd({
  "LspAttach",
  "LspDetach",
  "BufEnter",
  "FileType",
}, {
  group = lsp_augroup,

  callback = function(args)
    refresh_lsp(args.buf)
  end,
})

-- ├──────────────────────────────┤ TASKS HELPER ├───────────────────────────┤

local symbols_overseer = {
  CANCELED = " ",
  FAILURE = "󰅚 ",
  SUCCESS = "󰄴 ",
  RUNNING = "󰑮 ",
}

local OVERSEER_STATUSES = {
  CANCELED = true,
  FAILURE = true,
  SUCCESS = true,
  RUNNING = true,
}

local Overseer
local overseer_has_task = false

local Rmux

local function get_overseer()
  if Overseer then
    return Overseer
  end

  local ok, overseer = pcall(require, "overseer")

  if not ok then
    return nil
  end

  Overseer = overseer

  return Overseer
end

local function refresh_overseer_status()
  local overseer = get_overseer()

  if not overseer then
    overseer_has_task = false
    return
  end

  local tasks = overseer.list_tasks {
    unique = true,
  }

  overseer_has_task = false

  for _, task in ipairs(tasks) do
    if OVERSEER_STATUSES[task.status] then
      overseer_has_task = true
      break
    end
  end
end

local function get_rmux()
  if Rmux then
    return Rmux
  end

  local ok, rmux = pcall(require, "rmux.statusline")

  if not ok then
    return nil
  end

  Rmux = rmux

  return Rmux
end

-- Keep the Overseer cache in sync without querying Overseer
-- from the statusline render path.
vim.api.nvim_create_autocmd("User", {
  pattern = "OverseerTask*",
  callback = function()
    refresh_overseer_status()
    vim.cmd.redrawstatus()
  end,
})

-- Initial state.
vim.schedule(function()
  refresh_overseer_status()
end)

local overseer_tasks_for_status = function(status, colors)
  return {
    condition = function(self)
      return self.tasks[status] ~= nil
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

      return {
        fg = fg,
        bg = bg,
        bold = true,
      }
    end,
  }
end

-- ├─────────────────────────────────┤ NAVIC ├──────────────────────────────┤

local Navic

local function get_navic()
  if Navic then
    return Navic
  end

  local ok, navic = pcall(require, "nvim-navic")

  if not ok then
    return nil
  end

  Navic = navic

  return Navic
end

-- ├────────────────────────────────┤ PINNBUF ├─────────────────────────────┤

local Pinnedbuffer

local get_pinnedBuf = function()
  if Pinnedbuffer then
    return Pinnedbuffer
  end

  local ok, pinned = pcall(require, "stickybuf")
  if not ok then
    return nil
  end

  Pinnedbuffer = pinned

  return Pinnedbuffer
end

-- ├───────────────────────────────┤ QFBOOKMARK ├───────────────────────────────┤

local Qfbookmark

local get_qfbookmark = function()
  if Qfbookmark then
    return Qfbookmark
  end

  local ok, qfbook = pcall(require, "qfbookmark.qf")
  if not ok then
    return nil
  end

  Qfbookmark = qfbook

  return Qfbookmark
end

-- ├────────────────────────────────┤ SESSION ├─────────────────────────────┤

local SessionBuf

local function get_session()
  if not SessionBuf then
    local ok, session = pcall(require, "resession")

    if not ok then
      return nil
    end

    SessionBuf = session
  end

  return SessionBuf
end

-- ├────────────────────────────────┤ PDFVIEW ├─────────────────────────────┤

local PDFview

local get_pdfview = function()
  if not PDFview then
    local ok, pdfview = pcall(require, "pdfview.renderer")
    if not ok then
      return nil
    end

    PDFview = pdfview
  end

  return PDFview
end

-- ├─────────────────────────────────┤ COLORS ├─────────────────────────────────┤

local function __colors()
  local light_themes = {}

  for _, name in ipairs(vim.g.lightthemes or {}) do
    light_themes[name] = true
  end

  light_themes["base46-seoul256_dark"] = true
  light_themes["base46-zenburn"] = true

  local is_light = light_themes[vim.g.colorscheme] == true

  local keyword_fg
  local diff_add
  local diff_change
  local diff_delete

  if is_light then
    keyword_fg = -0.05
    diff_add = H.tint(H.get("GitSignsAdd", "fg"), -0.07)
    diff_change = H.tint(H.get("GitSignsChange", "fg"), -0.1)
    diff_delete = H.tint(H.get("GitSignsDelete", "fg"), -0.1)
  else
    keyword_fg = 0.7
    diff_add = H.get("GitSignsAdd", "fg")
    diff_change = H.get("GitSignsChange", "fg")
    diff_delete = H.get("GitSignsDelete", "fg")
  end

  local normal_bg = H.get("Normal", "bg")
  local statusline_fg = H.get("StatusLine", "fg")
  local winbar_fg = H.get("WinBar", "fg")
  local boolean_fg = H.get("Boolean", "fg")
  local keyword = H.get("Keyword", "fg")
  local error_fg = H.get("Error", "fg")
  local string_fg = H.get("String", "fg")
  local git_delete = H.get("GitSignsDelete", "fg")
  local git_add = H.get("GitSignsAdd", "fg")

  return {
    statusline_fg = statusline_fg,
    statusline_bg = H.get("StatusLine", "bg"),

    winbar_fg = winbar_fg,
    winbar_bg = H.get("WinBar", "bg"),
    winbar_bg_bottom = H.get("PanelSideNormal", "bg"),
    winbar_bright = H.tint(winbar_fg, 0.8),

    bright = H.tint(statusline_fg, 0.65),

    keyword = H.darken(keyword, keyword_fg, normal_bg),

    statusline_fg_notice = H.tint(statusline_fg, 0.6),

    normal_bg = normal_bg or "#000000",
    directory = H.get("Directory", "fg") or "#000000",

    qf_indicator_fg = H.tint(keyword, 0.5),
    qf_indicator_bg = H.darken(keyword, 0.5, normal_bg),

    lf_indicator_fg = H.tint(string_fg, 0.5),
    lf_indicator_bg = H.darken(string_fg, 0.5, normal_bg),

    qf_keyword_fg = H.get("QuickFixWinbar", "fg"),
    qf_keyword_bg = H.get("QuickFixWinbar", "bg"),

    search_count_fg = H.tint(git_delete, 1),
    search_count_bg = H.darken(git_delete, 0.5, normal_bg),

    block_notice = H.tint(H.darken(error_fg, 0.7, H.get("CurSearch", "fg")), 0.1),

    block_notice_keyword = H.tint(H.darken(error_fg, 0.6, normal_bg), 1.5),

    task_fg = git_add,
    task_bg = H.darken(git_add, 0.2, normal_bg),

    modified_fg = error_fg or "#000000",
    coldisorent = H.get("LineNr", "fg") or "#000000",

    mode_gray_fg = H.get("WinBarGrey", "fg"),
    mode_gray_fg_bright = H.tint(H.get("WinBarGrey", "fg"), 0.25),
    mode_gray_bg = H.get("WinBarGrey", "bg"),

    mode_note_fg = H.get("WinBarNote", "fg"),
    mode_note_fg_bright = H.tint(H.get("WinBarNote", "fg"), 0.5),
    mode_note_bg = H.get("WinBarNote", "bg"),

    mode_aiprompt_fg = H.get("WinBarAiPrompt", "fg"),
    mode_aiprompt_fg_bright = H.tint(H.get("WinBarAiPrompt", "fg"), 0.5),
    mode_aiprompt_bg = H.get("WinBarAiPrompt", "bg"),

    mode_red_fg = H.get("WinBarRed", "fg"),
    mode_red_fg_bright = H.tint(H.get("WinBarRed", "fg"), 0.3),
    mode_red_bg = H.get("WinBarRed", "bg"),

    mode_yellow_fg = H.get("WinBarYellow", "fg"),
    mode_yellow_fg_bright = H.tint(H.get("WinBarYellow", "fg"), 0.3),
    mode_yellow_bg = H.get("WinBarYellow", "bg"),

    mode_green_fg = H.get("WinBarGreen", "fg"),
    mode_green_fg_bright = H.tint(H.get("WinBarGreen", "fg"), 0.3),
    mode_green_bg = H.get("WinBarGreen", "bg"),

    mode_visual_bg = H.get("Visual", "bg"),
    mode_visual_fg = H.tint(H.get("Visual", "bg"), 0.5),

    mode_term_fg = boolean_fg,
    mode_term_bg = H.tint(H.darken(boolean_fg, 0.8, normal_bg), 0.1),
    mode_term_statusline_fg = H.tint(H.darken(boolean_fg, 0.5, normal_bg), 0.2),
    mode_term_statusline_bg = H.tint(H.darken(boolean_fg, 0.1, normal_bg), 0.1),

    diff_add = diff_add,
    diff_change = diff_change,
    diff_delete = diff_delete,

    diagnostic_err = H.get("DiagnosticSignError", "fg"),
    diagnostic_hint = H.get("DiagnosticSignHint", "fg"),
    diagnostic_info = H.get("DiagnosticSignInfo", "fg"),
    diagnostic_warn = H.get("DiagnosticSignWarn", "fg"),
  }
end

local colors = __colors()

local function get_winbar_mode()
  if set_conditions.is_readonly() then
    return colors.mode_red_fg, colors.mode_red_bg, colors.mode_red_fg_bright
  end

  if set_conditions.is_gray_ft() then
    return colors.mode_gray_fg, colors.mode_gray_bg, colors.mode_gray_fg_bright
  end

  if set_conditions.is_note_ft() then
    return colors.mode_note_fg, colors.mode_note_bg, colors.mode_note_fg_bright
  end

  if set_conditions.is_aiprompt_ft() then
    return colors.mode_aiprompt_fg, colors.mode_aiprompt_bg, colors.mode_aiprompt_fg_bright
  end

  if set_conditions.is_green_ft() then
    return colors.mode_green_fg, colors.mode_green_bg, colors.mode_green_fg_bright
  end

  if set_conditions.is_path_git_relative() then
    return colors.mode_yellow_fg, colors.mode_yellow_bg, colors.mode_yellow_fg_bright
  end

  return nil
end

local set_winbar_hl = function(is_more_bright)
  local fg = colors.winbar_fg
  local bg = colors.winbar_bg

  if is_more_bright then
    fg = colors.winbar_bright
  end

  local mode_fg, mode_bg, mode_fg_bright = get_winbar_mode()

  if mode_fg then
    fg = is_more_bright and mode_fg_bright or mode_fg
    if mode_bg then
      bg = mode_bg
    end
  end

  if vim.bo.filetype == "qf" then
    bg = colors.winbar_bg_bottom
  end

  return {
    fg = fg,
    bg = bg,
  }
end

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

-- ├───────────────────────────────┤ PATH LABOR ├───────────────────────────────┤

local PATH_SEP = package.config:sub(1, 1)

local FILEPATH_EXCLUDE_FT = {
  ["neo-tree"] = true,
  Outline = true,
  trouble = true,
  qf = true,
  codecompanion = true,
  oil = true,
  DiffviewFiles = true,
  ["grug-far"] = true,
}

local function get_git_type(bufname)
  if bufname:match "^gitsigns://" then
    return "gitsigns"
  elseif bufname:match "^diffview://" then
    return "diffview"
  elseif bufname:match "^fugitive://" then
    return "fugitive"
  end
end

---@param bufname string
---@return string path
local function get_relative_path(bufname)
  if bufname == "" then
    return ""
  end

  local root = require("utils.root").get {
    normalize = true,
  }

  local cwd = require("utils.root").cwd()

  if cwd ~= "" and bufname:find(cwd, 1, true) == 1 then
    return bufname:sub(#cwd + 2)
  end

  if root ~= "" and bufname:find(root, 1, true) == 1 then
    return bufname:sub(#root + 2)
  end

  return bufname
end

---@param bufname string
---@param git_type string
---@return string|nil commit
---@return string|nil filepath
local function parse_git_path(bufname, git_type)
  local clean = bufname:gsub("^%w+://", "")

  if git_type == "gitsigns" then
    local filepath, commit = clean:match "^(.-)//(.*)$"
    return commit, filepath
  end

  if git_type == "diffview" then
    local commit, filepath = clean:match "/%.git/([^/]+)/(.+)$"

    return commit, filepath
  end

  if git_type == "fugitive" then
    local commit, filepath = clean:match "%.git//(%x+)/(.*)$"

    return commit, filepath
  end
end

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                              PARTS STATUSLINE                               ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

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
    local status = vim.b.gitsigns_status_dict
    self.branch = status and status.head or ""
  end,

  provider = function(self)
    if self.branch == "" then
      return ""
    end

    return "  " .. self.branch .. " "
  end,

  hl = { bold = true },
}
M.FilePath = {
  update = {
    "BufEnter",
    "BufFilePost",
    "DirChanged",
  },

  init = function(self)
    self.bufname = vim.api.nvim_buf_get_name(0)
    self.filename = get_vars.filename(self.bufname)
    self.filetype = vim.bo.filetype

    self.exclude_ft = FILEPATH_EXCLUDE_FT[self.filetype] == true
    self.git_type = get_git_type(self.bufname)
    self.path = get_relative_path(self.bufname)
    local cwd = vim.uv.cwd()
    self.cwd_name = cwd and vim.fn.fnamemodify(cwd, ":t") or ""
  end,

  {
    provider = function(self)
      if set_conditions.is_terminal_ft() or self.git_type or self.exclude_ft or self.filetype == "octo" then
        return " "
      end

      if self.cwd_name == "" then
        return ""
      end

      return " " .. self.cwd_name
    end,

    hl = {
      fg = colors.directory,
      bold = true,
    },
  },

  {
    provider = function(self)
      if self.exclude_ft then
        return ""
      end

      if self.filetype == "codecompanion" or self.filetype == "pdfview" then
        return ""
      end

      if self.path == "" then
        return " "
      end

      if #self.filename == 0 then
        return "[Unknown Filename]"
      end

      Conditions = get_conditions()

      local is_very_narrow = not Conditions.width_percent_below(#self.filename, 0.47)
        and set_conditions.hide_in_col_width(40)

      local is_medium_width = Conditions.width_percent_below(#self.filename, 0.30)

      local parts = vim.split(self.path, "[\\/]")

      if #parts <= 3 then
        table.remove(parts, #parts)
      else
        local part_middle = 2
        local part_last = 1

        local middle_pack
        local last_pack
        local part_first = "…"

        if not is_very_narrow then
          last_pack = #parts - 1
          middle_pack = #parts - 3

          if is_medium_width then
            middle_pack = 1
            part_first = ""
          end
        else
          middle_pack = #parts - 3 + part_middle
          last_pack = #parts - part_last
        end

        if self.filetype == "octo" then
          part_middle = 4
          part_last = 2
        end

        parts = {
          part_first,
          unpack(parts, middle_pack, last_pack),
        }
      end

      local path = table.concat(parts, PATH_SEP)

      if is_medium_width then
        path = path:gsub("^/", "")
      end

      return #path > 1 and ("/" .. path .. PATH_SEP) or "/"
    end,
  },

  {
    provider = function(self)
      local path = vim.fn.fnamemodify(self.bufname, ":t")

      if self.filetype == "pdfview" then
        if not PDFview then
          PDFview = get_pdfview()
        end

        if PDFview and PDFview.pdf_path then
          return vim.fn.fnamemodify(PDFview.pdf_path, ":~") .. " (Page " .. PDFview.current_page .. ")"
        end
      end

      if #self.filename == 0 then
        return " " .. self.filetype
      end

      if self.filetype == "qf" then
        if path:find(ConfigPath.home, 1, true) == 1 then
          path = path:sub(#ConfigPath.home + 2)
        end

        return require("utils.file").basename(path)
      end

      if self.git_type then
        local commit, filepath = parse_git_path(self.bufname, self.git_type)

        if filepath and commit then
          local parts = vim.split(path, "[\\/]")

          if #parts > 3 then
            parts = {
              "…",
              unpack(parts, #parts - 3 + 1),
            }
          end

          local display_path = table.concat(parts, "/")

          return string.format("%s [%s] ", display_path, commit:sub(1, 7))
        end
      end

      return require("utils.file").basename(self.filename)
    end,

    hl = {
      bold = true,
      fg = colors.winbar_bright,
    },
  },

  {
    provider = Icons.misc.separator_up,

    hl = {
      fg = colors.statusline_bg,
    },
  },
}
M.Filetype = {
  init = function(self)
    self.filetype = get_vars.filetype()
  end,
  condition = function(self)
    return self.filetype
  end,

  {
    provider = function(self)
      if self.filetype and self.filetype ~= "" then
        return "[" .. self.filetype .. "] "
      end

      return "[??] "
    end,

    hl = { fg = colors.statusline_fg },
  },
}
M.FileIcon = {
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)
    self.path = get_vars.path()
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    self.is_excluded = vim.tbl_contains({ "qf", "pdfview", "codecompanion" }, vim.bo.filetype)
  end,
  condition = function()
    return vim.bo.filetype ~= "qf"
  end,
  provider = function(self)
    if self.path == "" then
      return ""
    end

    if self.is_excluded then
      return "  "
    end

    return self.icon and (" " .. self.icon .. " ")
  end,
  hl = function(self)
    local hl_opts = set_winbar_hl()
    local fg = self.icon_color
    if self.is_excluded then
      fg = hl_opts.bg
    end
    return { fg = fg, bg = hl_opts.bg }
  end,
}
M.Git = {
  condition = function()
    Conditions = get_conditions()
    return Conditions.is_git_repo()
  end,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
  end,

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
M.QuickfixStatus = {
  init = function(self)
    self.height = vim.api.nvim_buf_line_count(0)
    local utilqf = UtilQf()

    self.title_qflist = utilqf.get_title_qf()
    self.stack_qflists = #utilqf.get_total_stack_qf()

    self.title_loclist = utilqf.get_title_qf(true)
    self.stack_loclists = #utilqf.get_total_stack_qf(true)

    self.utilqf = utilqf
  end,
  condition = function()
    return vim.bo[0].filetype == "qf"
  end,
  {
    provider = function(self)
      if self.utilqf.is_loclist() then
        return " LF "
      else
        return " QF "
      end
    end,
    hl = function(self)
      local fg = colors.qf_indicator_fg
      local bg = colors.qf_indicator_bg
      if self.utilqf.is_loclist() then
        fg = colors.lf_indicator_fg
        bg = colors.lf_indicator_bg
      end
      return { fg = fg, bg = bg, bold = true }
    end,
  },
  {
    provider = Icons.misc.separator_up,
    hl = function(self)
      local fg = colors.qf_indicator_bg
      if self.utilqf.is_loclist() then
        fg = colors.lf_indicator_bg
      end
      return { fg = fg, bg = colors.winbar_bg_bottom }
    end,
  },
  {
    provider = Icons.misc.separator_up,
    hl = { fg = colors.winbar_bg_bottom, bg = colors.qf_keyword_bg },
  },
  {
    provider = function(self)
      local parts = {}
      local stacklists = #self.utilqf.get_total_stack_qf(self.utilqf.is_loclist())
      local current_stacklists = self.utilqf.get_current_history_qf(self.utilqf.is_loclist())
      local idx_lists = self.utilqf.get_current_idx_qf(self.utilqf.is_loclist())
      table.insert(
        parts,
        string.format("  %d/%d 󱗿 %d/%d ", idx_lists, self.height, current_stacklists, stacklists)
      )
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.qf_keyword_fg, bg = colors.qf_keyword_bg, bold = false },
  },
  {
    provider = Icons.misc.separator_up,
    hl = { fg = colors.qf_keyword_bg, bg = colors.winbar_bg_bottom },
  },
  {
    provider = Icons.misc.separator_up,
    hl = { fg = colors.winbar_bg_bottom, bg = colors.qf_keyword_bg },
  },
  {
    provider = function(self)
      local parts = {}
      if self.utilqf.is_loclist() then
        table.insert(parts, string.format(" %s %s ", "LFtitle:", self.title_loclist))
      else
        table.insert(parts, string.format(" %s %s ", "QFtitle:", self.title_qflist))
      end
      return table.concat(parts, " ")
    end,
    hl = { fg = colors.qf_keyword_fg, bg = colors.qf_keyword_bg, bold = false },
  },
  {
    provider = Icons.misc.separator_up,
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
        icon_flag = Icons.misc.readonly
      end

      if is_modifiled then
        icon_flag = Icons.misc.modified
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
    return set_conditions.hide_in_col_width(130) and (vim.env.VIRTUAL_ENV ~= nil) and vim.bo.filetype == "python"
  end,
  init = function(self)
    local bufname = get_vars.bufname()
    local filename = get_vars.filename(bufname)
    local extension = get_vars.extension(filename)
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

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
      local ok, uv = pcall(require, "uv")

      if not ok then
        return ""
      end

      local venv = uv.get_venv()

      if not venv then
        return ""
      end

      return string.format(" %s  ", venv)
    end,
    hl = function(self)
      return { fg = self.icon_color, bold = true }
    end,
  },
}
M.LSPActive = {
  update = {
    "LspAttach",
    "LspDetach",
    "BufEnter",
    "FileType",
  },

  condition = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      return false
    end

    local buf = vim.api.nvim_get_current_buf()
    local cache = lsp_cache[buf]

    return (
      cache
      and cache.has_lsp
      and vim.bo.filetype ~= "qf"
      and vim.fn.mode(1) ~= "t"
      and not set_conditions.is_path_git_relative()
      and set_conditions.hide_in_col_width(100)
    ) or vim.bo.filetype == "octo"
  end,

  init = function(self)
    local cache = lsp_cache[vim.api.nvim_get_current_buf()]

    self.names = cache and cache.names or {}
  end,

  {
    provider = " LSP: ",
    hl = { italic = false },
  },

  {
    provider = function(self)
      local str = table.concat(self.names, ", ")

      return Conditions.width_percent_below(#str, 0.50) and str or "~too many~"
    end,
  },

  {
    condition = function(self)
      return #self.names > 0
    end,

    provider = "  ",
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
  init = function(self)
    local d = vim.diagnostic
    local diagnostics = d.get(0)

    local errors = 0
    local warnings = 0
    local info = 0
    local hints = 0

    for _, diagnostic in ipairs(diagnostics) do
      local severity = diagnostic.severity

      if severity == d.severity.ERROR then
        errors = errors + 1
      elseif severity == d.severity.WARN then
        warnings = warnings + 1
      elseif severity == d.severity.INFO then
        info = info + 1
      elseif severity == d.severity.HINT then
        hints = hints + 1
      end
    end

    self.errors = errors
    self.warnings = warnings
    self.info = info
    self.hints = hints
  end,
  condition = function()
    return vim.bo[0].filetype ~= "lazy" and Conditions.has_diagnostics
  end,

  {
    condition = function(self)
      return self.errors > 0
    end,
    provider = function(self)
      return Icons.diagnostics.Error .. self.errors .. " "
    end,
    hl = { fg = colors.diagnostic_err, bold = true },
  },
  {
    condition = function(self)
      return self.warnings > 0
    end,
    provider = function(self)
      return Icons.diagnostics.Warn .. self.warnings .. " "
    end,
    hl = { fg = colors.diagnostic_warn, bold = true },
  },
  {
    condition = function(self)
      return self.info > 0
    end,
    provider = function(self)
      return Icons.diagnostics.Info .. self.info .. " "
    end,
    hl = { fg = colors.diagnostic_info, bold = true },
  },
  {
    condition = function(self)
      return self.hints > 0
    end,
    provider = function(self)
      return Icons.diagnostics.Hint .. self.hints .. " "
    end,
    hl = { fg = colors.diagnostic_hint, bold = true },
  },
  {
    condition = function(self)
      return self.errors > 0 or self.warnings > 0 or self.info > 0 or self.hints > 0
    end,
    provider = " ",
  },
}
M.Sessions = {
  condition = function()
    local session = get_session()

    if not session then
      return false
    end

    return session.get_current() ~= nil
  end,

  provider = function()
    return Icons.misc.session .. "On" .. "  "
  end,
}
M.PinnedBuffer = {
  condition = function()
    local pinned = get_pinnedBuf()
    return pinned and pinned.is_pinned() or false
  end,
  {
    provider = function()
      return Icons.misc.dashboard .. " "
    end,
    hl = { fg = colors.diagnostic_err },
  },
}
M.QFbookmark = {
  condition = function()
    Qfbookmark = get_qfbookmark()
    return Qfbookmark and Qfbookmark.status_mark() or false
  end,
  {
    provider = function()
      return Icons.misc.flags .. "  "
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
          return Icons.misc.separator_down
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
}
M.RmuxTargetPane = {
  init = function(self)
    local status = get_rmux()

    -- rmux is not available.
    if not status then
      self.status = nil
      self.run_with = nil
      self.task = 0
      self.watch = ""
      self.has_overseer_task = overseer_has_task
      return
    end

    status = status.get()

    self.status = status
    self.run_with = status.run_with
    self.task = status.task or 0
    self.watch = status.watch or ""

    -- Do not call overseer.list_tasks() here.
    self.has_overseer_task = overseer_has_task
  end,

  condition = function()
    local status = get_rmux()
    return status ~= nil
  end,

  {
    provider = function(self)
      if self.task > 0 or self.watch ~= "" then
        return Icons.misc.separator_down
      end
    end,

    hl = {
      fg = colors.statusline_bg,
      bg = colors.task_bg,
    },
  },

  {
    provider = function(self)
      if self.task > 0 or self.watch ~= "" then
        return " Tmux:"
      end
    end,

    hl = {
      fg = colors.task_fg,
      bg = colors.task_bg,
      bold = true,
    },
  },

  {
    provider = function(self)
      if self.task > 0 then
        return "  " .. self.task
      end
    end,

    hl = {
      fg = colors.task_fg,
      bg = colors.task_bg,
      bold = true,
    },
  },

  {
    provider = function(self)
      if self.watch ~= "" then
        return "  " .. self.watch
      end
    end,

    hl = {
      fg = colors.task_fg,
      bg = colors.task_bg,
      bold = true,
    },
  },

  {
    provider = function(self)
      if self.task > 0 or self.watch ~= "" then
        return Icons.misc.separator_down
      end
    end,

    hl = {
      fg = colors.task_bg,
      bg = colors.task_bg,
    },
  },

  {
    provider = function(self)
      local has_task = self.task > 0 or self.watch ~= ""

      if has_task or self.has_overseer_task then
        return Icons.misc.separator_down .. "  "
      end
    end,

    hl = function(self)
      local fg = colors.statusline_bg

      local has_task = self.task > 0 or self.watch ~= ""

      if set_conditions.is_terminal_ft() then
        fg = colors.mode_term_statusline_bg
      elseif not set_conditions.hide_in_col_width(120) then
        fg = colors.statusline_bg
      elseif has_task or self.has_overseer_task then
        fg = colors.task_bg
      end

      return {
        fg = fg,
        bg = colors.statusline_bg,
      }
    end,
  },
}
M.Filetype = {
  init = function(self)
    self.filetype = get_vars.filetype()
  end,

  {
    provider = function(self)
      if self.filetype and self.filetype ~= "" then
        return "[" .. self.filetype .. "] "
      end

      return "[??] "
    end,

    hl = { fg = colors.statusline_fg },
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
        rhs = rhs
      end
      -- rhs = rhs .. "/"
      -- rhs = rhs .. self.width
      return rhs .. "  "
    end,
    hl = { fg = colors.bright, bold = true },
  },
}
M.Clock = {
  condition = function()
    return not vim.env.TMUX and not (vim.env.TERM_PROGRAM == "WezTerm") and set_conditions.hide_in_col_width(120)
  end,
  {
    provider = Icons.misc.separator_up,
    hl = { bg = colors.diagnostic_err, fg = colors.statusline_bg },
  },
  {
    provider = function()
      return "  " .. os.date "%H:%M "
    end,
    hl = { bg = colors.diagnostic_err, fg = colors.normal_bg, bold = true },
  },
}

-- local spinner_index = 1
--
-- M.codecompanion = {
--   init = function(self)
--     if not self._au then
--       self._au = true
--       vim.api.nvim_create_autocmd("User", {
--         pattern = "CodeCompanionRequest*",
--         callback = function()
--           vim.cmd "redrawstatus"
--         end,
--       })
--     end
--   end,
--   {
--     provider = function()
--       local spinner_symbols = {
--         "▰▱▱▱▱▱▱",
--         "▰▰▱▱▱▱▱",
--         "▰▰▰▱▱▱▱",
--         "▰▰▰▰▱▱▱",
--         "▰▰▰▰▰▱▱",
--         "▰▰▰▰▰▰▱",
--         "▰▰▰▰▰▰▰",
--         "▰▱▱▱▱▱▱",
--       }
--       -- { "█", "▓", "▒", "░" }
--       -- { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "▇", "▆", "▅", "▄", "▃", "▂" }
--       -- { "㊂", "㊀", "㊁" }
--       local spinner_symbols_len = #spinner_symbols
--       if vim.g.processing_ai then
--         spinner_index = (spinner_index % spinner_symbols_len) + 1
--         return Icons.misc.ai .. spinner_symbols[spinner_index] .. " " -- nerd font robot
--       end
--       return nil
--     end,
--     hl = { fg = colors.keyword },
--   },
--   {
--     provider = " ",
--   },
-- }
--
-- M.Separator = {
--   { provider = " " },
-- }

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                 STATUSLINE                                  ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

M.status_active_left = {
  condition = function()
    Conditions = get_conditions()
    return Conditions.is_active()
  end,
  M.Mode,
  M.SearchCount,
  M.FilePath,
  M.FileFlags,
  M.Ruler,
  -- M.FileIcon,

  M.Gap,

  -- M.LazyStatus,
  -- M.codecompanion,
  -- M.Dap,

  M.Diagnostics,
  M.LSPActive,
  M.virtualenv,
  -- M.SnacksProfile,
  M.PinnedBuffer,
  M.QFbookmark,
  M.Sessions,
  -- M.Tasks,
  M.RmuxTargetPane,
  M.Filetype,
  M.Branch,
  M.Git,
  M.Clock,

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

-- ╓─────────────────────────────────────────────────────────────────────────────╖
-- ║                                   WINBAR                                    ║
-- ╙─────────────────────────────────────────────────────────────────────────────╜

M.WinbarSeparator = {
  { provider = " " },
}
M.WinbarFilePath = {
  update = {
    "BufEnter",
    "BufFilePost",
    "DirChanged",
  },

  init = function(self)
    self.bufname = vim.api.nvim_buf_get_name(0)
    self.filetype = vim.bo.filetype

    self.git_type = get_git_type(self.bufname)
    self.tclock_type = self.bufname:match ":tclock" and "tclock" or self.bufname:match ":timr" and "timr"
    self.path = get_relative_path(self.bufname)
    self.filename = vim.fn.fnamemodify(self.bufname, ":t")
  end,

  condition = function()
    return vim.bo.filetype ~= "qf"
  end,

  {
    provider = function(self)
      if self.path == "" then
        return ""
      end

      local parts = vim.split(self.path, "[\\/]")

      if #parts > 3 then
        local select_last = 1
        local select_middle = 1

        if self.filetype == "octo" then
          select_middle = 0
          select_last = 2
        end

        parts = {
          "…",
          unpack(parts, #parts - 3 + select_middle, #parts - select_last),
        }
      else
        table.remove(parts, #parts)
      end

      local path = table.concat(parts, PATH_SEP)

      if set_conditions.hide_in_width(55) then
        return " "
      end

      return #path > 0 and (" " .. path .. PATH_SEP) or " "
    end,

    hl = function()
      local hl_opts = set_winbar_hl()

      return {
        fg = hl_opts.fg,
        bg = hl_opts.bg,
      }
    end,
  },

  {
    condition = function()
      return not set_conditions.is_dont_show_at_ft()
    end,

    provider = function(self)
      local path = self.filename

      if self.filetype == "octo" then
        local parts = vim.split(self.bufname, "[\\/]")

        return parts[#parts - 1] .. "/" .. parts[#parts]
      end

      if self.tclock_type == "tclock" then
        return "Jangan lupa minum!"
      elseif self.tclock_type == "timr" then
        return "21 TODO menunggu!"
      end

      if self.git_type then
        local commit, filepath = parse_git_path(self.bufname, self.git_type)

        if filepath and commit then
          if commit:match "^0+$" then
            commit = "NEW"
          end

          local parts = vim.split(path, "[\\/]")

          if #parts > 3 then
            parts = {
              "…",
              unpack(parts, #parts - 3 + 1),
            }
          end

          local display_path = table.concat(parts, "/")

          return string.format("%s [%s] ", display_path, commit:sub(1, 7))
        end
      end

      return path
    end,

    hl = function()
      local hl_opts = set_winbar_hl(true)

      return {
        fg = hl_opts.fg,
        bg = hl_opts.bg,
        bold = true,
      }
    end,
  },
}

local function format_part(item, is_color) -- function helper to add highlights group
  is_color = is_color or false

  local hl_group = "LspKind" .. item.type

  if is_color then
    return string.format("%%#%s#%s%s%%*", hl_group, item.icon, item.name)
  end
  return string.format("%%#%s#%s%%#WinBar#%s%%*", hl_group, item.icon, item.name)
end
local function build_full_location(data_items)
  local parts = {}
  for idx, d in ipairs(data_items) do
    local set_color = false
    if idx == 1 then
      set_color = true
    end
    parts[#parts + 1] = format_part(d, set_color)
  end
  return table.concat(parts, "%#NavicSeparator# > %*")
end

local CODECOMPANION_FT = {
  codecompanion = true,
}

local function get_display_width(str)
  return vim.fn.strdisplaywidth(str)
end

M.WinbarNavic = {
  init = function(self)
    self.navic = get_navic()
    self.buf = vim.api.nvim_get_current_buf()
    self.filetype = vim.bo.filetype
  end,

  condition = function()
    local navic = get_navic()

    return navic ~= nil and not set_conditions.is_note_ft()
  end,

  {
    condition = function(self)
      local navic = self.navic or get_navic()

      if not navic then
        return false
      end

      return set_conditions.is_lsp_attached()
        and navic.is_available()
        and not set_conditions.is_path_git_relative()
        and not set_conditions.is_terminal_ft()
        and not CODECOMPANION_FT[self.filetype]
        and not set_conditions.is_diff()
    end,

    provider = function(self)
      local navic = self.navic

      if not navic then
        return
      end

      local data = navic.get_data(self.buf)

      if not data or #data == 0 then
        return
      end

      local first = format_part(data[1], true)
      local sep = " "

      if set_conditions.hide_in_width(80) then
        return string.format("%s%%#NavicSeparator# %s %%#NavicSeparator#", sep, first)
      end

      if set_conditions.hide_in_width(90) then
        local last = format_part(data[#data])

        return string.format("%s%%#NavicSeparator# %s %%#NavicSeparator# … %%* %s", sep, first, last)
      end

      local full = build_full_location(data)

      if not Conditions.width_percent_below(get_display_width(full), 0.50) then
        local last = format_part(data[#data])

        return string.format("%s%%#NavicSeparator# %s %%#NavicSeparator# … %%* %s", sep, first, last)
      end

      return sep .. "%#NavicSeparator# " .. full
    end,
  },

  hl = function()
    return {
      fg = colors.winbar_fg,
      bg = colors.winbar_bg,
      bold = true,
    }
  end,
}

M.status_winbar_active_left = {
  M.WinbarSeparator,
  M.FileIcon,
  M.WinbarFilePath,
  M.WinbarNavic,
  M.QuickfixStatus,

  M.Gap,

  hl = function()
    local hl_opts = set_winbar_hl()
    return { fg = hl_opts.fg, bg = hl_opts.bg, bold = false }
  end,
}

return M
