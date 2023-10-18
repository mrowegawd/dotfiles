local fn = vim.fn
local hl = vim.api.nvim_set_hl
local get_option = vim.api.nvim_buf_get_option

local sttsline_utils = require "sttusline.utils"
local sttsline_colors = require "sttusline.utils.color"

local Util = require "r.utils"
local highlight = require "r.config.highlights"

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

local M = {}

M.mode = function()
  local Mode = require "sttusline.components.mode"

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
      ["STTUSLINE_VISUAL_MODE"] = { fg = sttsline_colors.purple, bg = colors.mode_bg },
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
    local fmt = style
    if style == "default" then
      fmt = "%A, %B %d | %H.%M"
    elseif style == "us" then
      fmt = "%m/%d/%Y"
    elseif style == "uk" then
      fmt = "%d/%m/%Y"
    elseif style == "iso" then
      fmt = "%Y-%m-%d"
    end
    return os.date(fmt) .. ""
  end)
  return Datetime
end
M.filename = function()
  local Filename = require("sttusline.component").new()

  Filename.set_event { "BufWritePost", "BufEnter", "InsertLeave", "ModeChanged" }

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

    local opts = {
      relative = "cwd",
      modified_hl = "Constant",
    }

    local path = vim.fn.expand "%:p"

    if path == "" then
      return ""
    end

    local root = Util.root.get { normalize = true }
    local cwd = Util.root.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")
    if #parts > 3 then
      parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    end

    if not icon then
      local buftype = get_option(0, "buftype")
      local filetype = get_option(0, "filetype")
      if buftype == "terminal" then
        icon, color_icon = "", sttsline_colors.red
      elseif filetype == "NvimTree" then
        icon, color_icon = "󱏒", sttsline_colors.red
      elseif filetype == "neo-tree" then
        icon, color_icon = "󱏒", sttsline_colors.red
      elseif filetype == "TelescopePrompt" then
        icon, color_icon = "", sttsline_colors.red
      elseif filetype == "mason" then
        icon, color_icon = "󰏔", sttsline_colors.red
      elseif filetype == "lazy" then
        icon, color_icon = "󰏔", sttsline_colors.red
      else
        icon, color_icon = "󰏔", sttsline_colors.red
      end
    end

    hl(0, "STTUSLINE_MODIFIEDC", Filename.get_config().colors.modified)
    hl(0, "STTUSLINE_MOD_FILENAMEC", Filename.get_config().colors.filename)
    hl(0, ICON_HIGHLIGHT, { fg = color_icon })

    if vim.bo[0].modified then
      parts[#parts] = sttsline_utils.add_highlight_name(parts[#parts], "STTUSLINE_MODIFIEDC")
    elseif vim.bo[0].readonly then
      parts[#parts] = sttsline_utils.add_highlight_name(parts[#parts], "Comment")
    else
      parts[#parts] = sttsline_utils.add_highlight_name(parts[#parts], "STTUSLINE_MOD_FILENAMEC")
    end

    return sttsline_utils.add_highlight_name(icon, ICON_HIGHLIGHT)
      .. " "
      .. sttsline_utils.add_highlight_name(table.concat(parts, sep), "STTUSLINE_FILENAMEC")
  end)

  Filename.set_onhighlight(function()
    hl(0, "STTUSLINE_FILENAMEC", Filename.get_config().colors.normal)
  end)

  return Filename
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
    end
  end)

  Branch.set_onhighlight(function()
    hl(0, "STTUSLINE_GITBRANCHC", Branch.get_config().color)
  end)

  return Branch
end
M.diagnostics = function()
  local Diagnostics = require("sttusline.component").new()

  local diag_source = modules.sources.sources
  local get_diagnostics = modules.sources.get_diagnostics

  Diagnostics.set_update(function() end)

  return Diagnostics
end
M.lsp_notify = function()
  local LSPFormatters = require "sttusline.components.lsps-formatters"

  LSPFormatters.set_colors { fg = sttsline_colors.magenta, bg = colors.mode_bg }

  return LSPFormatters
end

return M
