local fn, fmt = vim.fn, string.format
local hl = vim.api.nvim_set_hl
local get_option = vim.api.nvim_buf_get_option

local sttsline_utils = require "sttusline.utils"
local sttsline_colors = require "sttusline.utils.color"

local Util = require "r.utils"

local modules = Util.lsp.lazy_require {
  sources = "r.plugins.colorthemes.sttusline.diagnostic-sources",
}

local highlight = require "r.config.highlights"
local icons = require("r.config").icons

local col_bg_StatusLine = highlight.get("StatusLine", "bg")
local col_bg_ErrorMsg = highlight.get("ErrorMsg", "fg")

local ICON_HIGHLIGHT = "STTUSLINE_FILE_ICON"

local colors = {
  base_bg = highlight.tint(col_bg_StatusLine, 0),
  base_fg = highlight.tint(col_bg_StatusLine, 3),

  branch_fg = highlight.tint(col_bg_StatusLine, 4),
  mode_bg = highlight.tint(col_bg_StatusLine, 1),
  filename_fg = highlight.tint(col_bg_StatusLine, 6),
  modified_fg = highlight.tint(col_bg_ErrorMsg, 0),
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

local M = {}

M.set_event = {
  "WinEnter",
  "BufEnter",
  "BufNewFile",
  "SessionLoadPost",
  "FileChangedShellPost",
  "VimResized",
  -- "Filetype",
  "CursorMoved",
  "CursorMovedI",
  "ModeChanged",
}

M.mode = function()
  local Mode = require "sttusline.components.mode"

  Mode.set_event(M.set_event)

  Mode.set_config {
    modes = {
      ["n"] = { "N", "STTUSLINE_NORMAL_MODE" },
      ["no"] = { "N (no)", "STTUSLINE_NORMAL_MODE" },
      ["nov"] = { "N (nov)", "STTUSLINE_NORMAL_MODE" },
      ["noV"] = { "N (noV)", "STTUSLINE_NORMAL_MODE" },
      ["noCTRL-V"] = { "NORMAL", "STTUSLINE_NORMAL_MODE" },
      ["niI"] = { "N i", "STTUSLINE_NORMAL_MODE" },
      ["niR"] = { "N r", "STTUSLINE_NORMAL_MODE" },
      ["niV"] = { "N v", "STTUSLINE_NORMAL_MODE" },

      ["nt"] = { "T", "STTUSLINE_NTERMINAL_MODE" },
      ["ntT"] = { "T (ntT)", "STTUSLINE_NTERMINAL_MODE" },

      ["v"] = { "V", "STTUSLINE_VISUAL_MODE" },
      ["vs"] = { "V-CHAR (Ctrl O)", "STTUSLINE_VISUAL_MODE" },
      ["V"] = { "V-LINE", "STTUSLINE_VISUAL_MODE" },
      ["Vs"] = { "V-LINE", "STTUSLINE_VISUAL_MODE" },
      [""] = { "V-BLOCK", "STTUSLINE_VISUAL_MODE" },

      ["i"] = { "I", "STTUSLINE_INSERT_MODE" },
      ["ic"] = { "I (completion)", "STTUSLINE_INSERT_MODE" },
      ["ix"] = { "I completion", "STTUSLINE_INSERT_MODE" },

      ["t"] = { "T", "STTUSLINE_TERMINAL_MODE" },
      ["!"] = { "SHELL", "STTUSLINE_TERMINAL_MODE" },

      ["R"] = { "R", "STTUSLINE_REPLACE_MODE" },
      ["Rc"] = { "R (Rc)", "STTUSLINE_REPLACE_MODE" },
      ["Rx"] = { "R (Rx)", "STTUSLINE_REPLACE_MODE" },
      ["Rv"] = { "V-REPLACE", "STTUSLINE_REPLACE_MODE" },
      ["Rvc"] = { "V-REPLACE (Rvc)", "STTUSLINE_REPLACE_MODE" },
      ["Rvx"] = { "V-REPLACE (Rvx)", "STTUSLINE_REPLACE_MODE" },

      ["s"] = { "S", "STTUSLINE_SELECT_MODE" },
      ["S"] = { "S-LINE", "STTUSLINE_SELECT_MODE" },
      [""] = { "S-BLOCK", "STTUSLINE_SELECT_MODE" },

      ["c"] = { "C", "STTUSLINE_COMMAND_MODE" },
      ["cv"] = { "C", "STTUSLINE_COMMAND_MODE" },
      ["ce"] = { "C", "STTUSLINE_COMMAND_MODE" },

      ["r"] = { "PROMPT", "STTUSLINE_CONFIRM_MODE" },
      ["rm"] = { "MORE", "STTUSLINE_CONFIRM_MODE" },
      ["r?"] = { "CONFIRM", "STTUSLINE_CONFIRM_MODE" },
      ["x"] = { "CONFIRM", "STTUSLINE_CONFIRM_MODE" },
    },
    mode_colors = {
      ["STTUSLINE_NORMAL_MODE"] = { fg = sttsline_colors.blue, bg = colors.mode_bg },
      ["STTUSLINE_INSERT_MODE"] = { fg = sttsline_colors.green, bg = colors.mode_bg },
      ["STTUSLINE_VISUAL_MODE"] = { fg = sttsline_colors.purple, bg = sttsline_utils.magenta },
      ["STTUSLINE_NTERMINAL_MODE"] = { fg = sttsline_colors.gray, bg = colors.mode_bg },
      ["STTUSLINE_TERMINAL_MODE"] = { fg = sttsline_colors.cyan, bg = colors.mode_bg },
      ["STTUSLINE_REPLACE_MODE"] = { fg = sttsline_colors.red, bg = colors.mode_bg },
      ["STTUSLINE_SELECT_MODE"] = { fg = sttsline_colors.magenta, bg = colors.mode_bg },
      ["STTUSLINE_COMMAND_MODE"] = { fg = sttsline_colors.yellow, bg = colors.mode_bg },
      ["STTUSLINE_CONFIRM_MODE"] = { fg = sttsline_colors.yellow, bg = colors.mode_bg },
    },
    auto_hide_on_vim_resized = true,
  }

  return Mode
end
M.datetime = function()
  local Datetime = require("sttusline.component").new()
  Datetime.set_config {
    style = "default",
  }

  Datetime.set_timing(true)

  Datetime.set_update(function()
    local style = Datetime.get_config().style
    local time_Fmt = style
    if style == "default" then
      time_Fmt = "%A, %B %d | %H.%M"
    elseif style == "us" then
      time_Fmt = "%m/%d/%Y"
    elseif style == "uk" then
      time_Fmt = "%d/%m/%Y"
    elseif style == "iso" then
      time_Fmt = "%Y-%m-%d"
    end
    return os.date(time_Fmt) .. ""
  end)
  return Datetime
end
M.filename = function()
  local Filename = require("sttusline.component").new()

  -- Filename.set_event { "BufWritePost", "BufEnter", "InsertLeave", "ModeChanged" }
  Filename.set_event(M.set_event)

  Filename.set_config {
    icon = require("r.config").icons.git.branch,
    colors = {
      normal = { fg = colors.base_fg, bg = colors.base_bg, bold = true },
      filename = { fg = colors.filename_fg, bg = colors.base_bg, bold = true },
      modified = { fg = colors.modified_fg, bg = colors.base_bg, bold = true },
    },
  }

  Filename.set_update(function()
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")

    local filename = fn.expand "%:t"
    if filename == "" then
      filename = "No File"
    end
    local icon, color_icon = nil, nil
    if has_devicons then
      icon, color_icon = devicons.get_icon_color(filename, fn.expand "%:e")
    end

    local parts

    local opts = {
      relative = "cwd",
      modified_hl = "Constant",
    }

    local path = vim.fn.expand "%:p"
    local sep

    local root = Util.root.get { normalize = true }
    local cwd = Util.root.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    sep = package.config:sub(1, 1)
    parts = vim.split(path, "[\\/]")
    if #parts > 3 then
      parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
      if vim.bo[0].modified then
        parts[#parts] = sttsline_utils.add_highlight_name(parts[#parts], "STTUSLINE_MODIFIEDC")
      elseif vim.bo[0].readonly then
        parts[#parts] = sttsline_utils.add_highlight_name(parts[#parts], "Comment")
      else
        parts[#parts] = sttsline_utils.add_highlight_name(parts[#parts], "STTUSLINE_MOD_FILENAMEC")
      end
    else
      parts = path
    end

    if not icon then
      local buftype = get_option(0, "buftype")
      local filetype = get_option(0, "filetype")
      if buftype == "terminal" then
        icon, color_icon = "", sttsline_colors.magenta
      elseif filetype == "NvimTree" then
        icon, color_icon = "󱏒", sttsline_colors.red
      elseif filetype == "neo-tree" then
        icon, color_icon = "󱏒", sttsline_colors.magenta
      elseif filetype == "TelescopePrompt" then
        icon, color_icon = "", sttsline_colors.yellow
        parts = "TelescopePromp"
      elseif filetype == "fzf" then
        icon, color_icon = "", sttsline_colors.purple
        parts = "FZFLua"
      elseif filetype == "mason" then
        icon, color_icon = "󰏔", sttsline_colors.pink
        parts = "Mason"
      elseif filetype == "lazy" then
        icon, color_icon = "󰏔", sttsline_colors.pink
        parts = "Lazy"
      elseif filetype == "qf" then
        icon, color_icon = "󰏔", sttsline_colors.magenta
        if Util.qf.is_loclist() then
          parts = fmt("Loclist:%s", fn.getloclist(0, { title = 0 }).title)
        else
          parts = fmt("Quickfix: %s %s", fn.getqflist({ id = 0 }).id, fn.getqflist({ title = 0 }).title)
        end
      else
        icon, color_icon = "󰏔", sttsline_colors.gray
      end
    end

    hl(0, "STTUSLINE_MODIFIEDC", Filename.get_config().colors.modified)
    hl(0, "STTUSLINE_MOD_FILENAMEC", Filename.get_config().colors.filename)
    hl(0, ICON_HIGHLIGHT, { fg = color_icon })

    if icon and parts ~= nil and type(parts) == "table" then
      return sttsline_utils.add_highlight_name(icon, ICON_HIGHLIGHT)
        .. " "
        .. sttsline_utils.add_highlight_name(table.concat(parts, sep), "STTUSLINE_FILENAMEC")
    elseif parts == "" then
      return ""
    else
      return sttsline_utils.add_highlight_name(icon, ICON_HIGHLIGHT)
        .. " "
        .. sttsline_utils.add_highlight_name(parts, "STTUSLINE_FILENAMEC")
    end
  end)

  Filename.set_onhighlight(function()
    hl(0, "STTUSLINE_FILENAMEC", Filename.get_config().colors.normal)
  end)

  return Filename
end
M.filereadonly = function()
  local Readonly = require("sttusline.component").new()

  Readonly.set_config {
    color = { fg = colors.modified_fg, bg = colors.base_bg },
  }
  Readonly.set_event(M.set_event)

  Readonly.set_update(function()
    local nomodified = vim.bo[0].readonly

    if nomodified then
      return sttsline_utils.add_highlight_name("[]ReadOnly", "STTUSLINE_READONLYC")
    end

    return ""
  end)

  Readonly.set_onhighlight(function()
    hl(0, "STTUSLINE_READONLYC", Readonly.get_config().color)
  end)

  return Readonly
end
M.branch = function()
  local Branch = require("sttusline.component").new()

  Branch.set_event { "BufWritePost", "VimResized", "BufEnter" }

  Branch.set_config {
    icon = require("r.config").icons.git.branch,
    color = { fg = colors.branch_fg, bg = colors.base_bg, bold = false },
  }

  Branch.set_update(function()
    local config = Branch.get_config()
    local icon = config.icon

    local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read "*a"

    if is_git_branch == "true\n" then
      for line in io.popen("git branch 2>/dev/null"):lines() do
        local current_branch = line:match "%* (.+)$"
        if current_branch then
          return sttsline_utils.add_highlight_name(icon .. current_branch, "STTUSLINE_GITBRANCHC")
        end
      end
    else
      return ""
    end
  end)

  Branch.set_onhighlight(function()
    hl(0, "STTUSLINE_GITBRANCHC", Branch.get_config().color)
  end)

  return Branch
end
M.diagnostics = function()
  local Diagnostics = require("sttusline.component").new()

  Diagnostics.set_event(M.set_event)

  Diagnostics.set_update(function()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics_count
    local last_diagnostics_count = {}
    local result = {}

    if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i" then
      local diag_source = modules.sources.get_diagnostics { "nvim_diagnostic" }

      local error_count, warning_count, info_count, hint_count = 0, 0, 0, 0

      for _, data in pairs(diag_source) do
        error_count = error_count + data.error
        warning_count = warning_count + data.warn
        info_count = info_count + data.info
        hint_count = hint_count + data.hint
      end
      diagnostics_count = {
        error = error_count,
        warn = warning_count,
        info = info_count,
        hint = hint_count,
      }
      -- Save count for insert mode
      last_diagnostics_count[bufnr] = diagnostics_count
    else -- Use cached count in insert mode with update_in_insert disabled
      diagnostics_count = last_diagnostics_count[bufnr] or { error = 0, warn = 0, info = 0, hint = 0 }
    end

    local always_visible = false

    -- format the counts with symbols and highlights
    local symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    }
    local sections = { "error", "warn", "info", "hint" }
    -- local colored = true
    -- local highlight_groups = { "error", "warn", "info", "hint" }

    -- if colored then
    --   local colorsss, bgs = {}, {}
    --   for name, hll in pairs(highlight_groups) do
    --     colorsss[name] = self:format_hl(hll)
    --     bgs[name] = modules.utils.extract_highlight_colors(colorsss[name]:match "%%#(.-)#", "bg")
    --   end
    --   local previous_section, padding
    --   for _, section in ipairs(sections) do
    --     if diagnostics_count[section] ~= nil and (always_visible or diagnostics_count[section] > 0) then
    --       padding = previous_section and (bgs[previous_section] ~= bgs[section]) and " " or ""
    --       previous_section = section
    --       table.insert(result, colorsss[section] .. padding .. symbols[section] .. diagnostics_count[section])
    --     end
    --   end
    -- else
    for _, section in ipairs(sections) do
      if diagnostics_count[section] ~= nil and (always_visible or diagnostics_count[section] > 0) then
        table.insert(result, symbols[section] .. diagnostics_count[section])
      end
    end

    return table.concat(result, " ")
  end)

  return Diagnostics
end
M.lsp_notify = function()
  local LSPFormatters = require "sttusline.components.lsps-formatters"

  LSPFormatters.set_colors { fg = sttsline_colors.magenta, bg = colors.mode_bg }

  return LSPFormatters
end
M.gitdiff = function()
  local Gitdiff = require "sttusline.components.git-diff"

  Gitdiff.set_event(M.set_event)

  return Gitdiff
end
M.trailing = function()
  local Trailing = require("sttusline.component").new()

  Trailing.set_event(M.set_event)

  Trailing.set_update(function()
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
  end)

  return Trailing
end
M.mixindent = function()
  local Mixindent = require("sttusline.component").new()

  Mixindent.set_event(M.set_event)

  Mixindent.set_update(function()
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
  end)

  return Mixindent
end

return M
