local lsp_status = require("lsp-status")
local highlight = require("modules._highlight")
local api = vim.api
local fn = vim.fn
local bo = vim.bo

local M = {}

-- local right_separator = ""
local right_separator = ""
local blank = " "

------------------------------------------------------------------------
--                             StatusLine                             --
------------------------------------------------------------------------

local statline_trimdir = function()

  local basename = fn.fnamemodify(fn.expand("%:h"), ":p:~:.")
  local width_window = math.floor(0.3 * fn.winwidth(0))

  if basename == "" or basename == "." then
    return ""
  end

  if width_window > #basename then
    return basename:gsub("/$", "") .. "/"
  end

  return ""

end

local statline_errlinter = function(statusline)

  if #vim.lsp.buf_get_clients() == 0 then
    return statusline
  end

  return statusline .. lsp_status.status()
end

local statline_fmodiefied = function(mystatusline)

  local statusline = mystatusline
  if bo.readonly == true then
    statusline = statusline .. "%#MyModified#" .. "  "
  end
  if bo.modified == true then
    statusline = statusline .. "%#MyModified#" .. " ..✘"
  end
  return statusline

end

local statline_filetype = function()

  local has_devicons, web_devicons = pcall(require, "nvim-web-devicons")

  if not has_devicons then
    print("warn: dont forget to install nvim-web-devicons!!")
    return ""
  end

  local get_extension = fn.fnamemodify(fn.expand("%:t"), ":e") or ""
  local icon = web_devicons.get_icon("", get_extension) or ""

  if #icon > 0 then
    return icon
  end

  local filetype = api.nvim_buf_get_option(api.nvim_get_current_buf(), "filetype")
  return "[" .. filetype .. "]"

end

-- Taken from and thanks to: https://github.com/wincent/wincent
local statline_lineCol = function()

  local rhs = " "

  if fn.winwidth(0) > 80 then
    local column = fn.virtcol(".")
    local width = fn.virtcol("$")
    local line = api.nvim_win_get_cursor(0)[1]
    local height = api.nvim_buf_line_count(0)

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

end

function M.activeLine()

  local statusline = ""

  -- Component: Mode
  local mode = api.nvim_get_mode()["mode"]

  highlight.redraw_color(mode)

  statusline = statusline .. "%#Mode#" .. highlight.current_mode[mode]

  statusline = statusline .. "%#ModeSeparator#" .. right_separator .. "%*"

  -- Component: Git
  if highlight.git_status ~= nil then
    statusline = statusline
      .. "%#Mygit# "
      .. highlight.git_status
      .. "%#SeparatorGit#"
      .. right_separator
      .. "%*"
  end

  -- Component: Working Directory
  statusline = statusline .. "%#ActiveStatusline# " .. statline_trimdir() .. "%*"

  statusline = statusline .. "%#FileNamePath#" .. "%t" .. blank .. "%*"

  -- Component: Filetype
  statusline = statusline
    .. "%#ActiveStatusline#"
    .. statline_filetype()
    .. blank
    .. "%*"

  -- Check file is readonly or modifiable
  statusline = statline_fmodiefied(statusline) .. "%#ActiveStatusline#" .. "%*"

  -- Alignment to left
  statusline = statusline .. "%#ActiveStatusline#" .. "%="

  -- Show error linter
  statusline = statline_errlinter(statusline)

  statusline = statusline
    .. "%#InActiveStatusline#"
    .. statline_lineCol()
    .. "%#EndOfBuffer#"
    .. "%*"

  return statusline

end

function M.inActiveLine()

  return "" .. "%#InActiveStatusline# %{expand(\"%:.\")}"

end

return M
