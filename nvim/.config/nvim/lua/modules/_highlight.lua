local get = require("modules._tools")
local api = vim.api

local magenta = get.xresources("magenta")
local white = get.xresources("white")
local black = get.xresources("black")
local red = get.xresources("red")
local yellow = get.xresources("yellow")
local black_non = vim.g.myguibg_non
local green = get.xresources("green")

local col_active_statusline = get.xresources("background_active_statusline")
local col_non_statusline = get.xresources("background_non_active_statusline")
local col_folded = get.vimfg("Folded")
-- local col_fontPmenu = get.vimfg("Statusline")
local col_lineNr = get.vimbg("LineNr")
local git_status = get.mygit()

local M = {}

M.git_status = git_status

-- Mode Prompt Table
M.current_mode = setmetatable({
  ["n"] = "Nor",
  ["no"] = "N·Operator Pending",
  ["v"] = "Vis",
  ["V"] = "Vis",
  ["^V"] = "VBlock",
  ["s"] = "Select",
  ["S"] = "S·Line",
  ["^S"] = "S·Block",
  ["i"] = "Ins",
  ["ic"] = "Ins",
  ["ix"] = "Ins",
  ["R"] = "Replace",
  ["Rv"] = "V·Replace",
  ["c"] = "Com",
  ["cv"] = "Vim Ex",
  ["ce"] = "Ex",
  ["r"] = "Prompt",
  ["rm"] = "More",
  ["r?"] = "Confirm",
  ["!"] = "Shell",
  ["t"] = "Term",
}, {

  __index = function(_, _)
    return "V·Block"
  end,
})

M.redraw_color = function(mode)
  if mode == "n" then
    vim.api.nvim_command(
      "hi Mode guibg=" .. red .. " guifg=" .. red .. " gui=bold"
    )
    if M.git_status ~= nil then
      vim.api.nvim_command(
        "hi ModeSeparator guifg=" .. red .. " guibg=" .. black
      )
    else
      vim.api.nvim_command(
        "hi ModeSeparator guifg="
          .. red
          .. " guibg="
          .. col_active_statusline
      )
    end
  end

  if mode == "i" then
    vim.api.nvim_command(
      "hi Mode guibg=" .. green .. " guifg=" .. green .. " gui=bold"
    )
    vim.api.nvim_command("hi ModeSeparator guifg=" .. green)
  end

  if mode == "v" or mode == "V" or mode == "^V" then
    vim.api.nvim_command(
      "hi Mode guibg=" .. yellow .. " guifg=" .. yellow .. " gui= bold"
    )
    vim.api.nvim_command("hi ModeSeparator guifg=" .. yellow)
  end

  -- if mode == 't' then
  --   vim.api.nvim_command('hi Mode guibg=' .. blue .. ' guifg=' .. blue .. ' gui=' .. blue)
  --   vim.api.nvim_command('hi ModeSeparator guifg='.. blue)
  -- end
end

M.start_custom_hi = function()
  local hi_custom = {
    ["SeparatorGit"] = {
      ["guibg"] = col_active_statusline,
      ["guifg"] = black,
      ["gui"] = "",
    },
    ["MyModified"] = {
      ["guibg"] = col_active_statusline,
      ["guifg"] = red,
      ["gui"] = "",
    },
    ["CursorLineNr"] = {
      ["guibg"] = black_non,
      ["guifg"] = yellow,
      ["gui"] = "bold",
    },
    ["ActiveStatusline"] = {
      ["guibg"] = col_active_statusline,
      ["guifg"] = col_folded,
      ["gui"] = "",
    },
    ["InActiveStatusline"] = {
      ["guibg"] = col_non_statusline,
      ["guifg"] = col_folded,
      ["gui"] = "italic",
    },
    ["FileNamePath"] = {
      ["guibg"] = col_active_statusline,
      ["guifg"] = white,
      ["gui"] = "bold",
    },
    ["TabLineSel"] = {
      ["guibg"] = magenta,
      ["guifg"] = black,
      ["gui"] = "bold",
    },
    ["TabLine"] = {
      ["guibg"] = "NONE",
      ["guifg"] = col_folded,
      ["gui"] = "None",
    },
    ["TabLineSeparator"] = {
      ["guibg"] = "NONE",
      ["guifg"] = "#4d4d4d",
      ["gui"] = "None",
    },
    ["TabLineSelSeparator"] = {
      ["guibg"] = "NONE",
      ["guifg"] = "#ff92d0",
      ["gui"] = "",
    },
    ["TabLineFill"] = {
      ["guibg"] = "NONE",
      ["guifg"] = "NONE",
      ["gui"] = "None",
    },
    ["PmenuSel"] = {
      ["guibg"] = "white",
      ["guifg"] = black,
      ["gui"] = "bold",
    },
    ["Pmenu"] = {
      ["guibg"] = black,
      ["guifg"] = green,
      ["gui"] = "bold",
    },
    ["LspDiagnosticsDefaultError"] = {
      ["guibg"] = col_lineNr,
      ["guifg"] = red,
      ["gui"] = "bold",
    },
    ["LspDiagnosticsFloatingError"] = {
      ["guibg"] = "",
      ["guifg"] = red,
      ["gui"] = "bold,italic",
    },
    ["LspDiagnosticsDefaultWarning"] = {
      ["guibg"] = col_lineNr,
      ["guifg"] = yellow,
      ["gui"] = "bold",
    },
    ["LspDiagnosticsFloatingWarning"] = {
      ["guibg"] = "",
      ["guifg"] = yellow,
      ["gui"] = "bold,italic",
    },
    ["LspDiagnosticsDefaultInformation"] = {
      ["guibg"] = col_lineNr,
      ["guifg"] = magenta,
      ["gui"] = "bold",
    },
    ["LspDiagnosticsFloatingInformation"] = {
      ["guibg"] = "",
      ["guifg"] = magenta,
      ["gui"] = "bold,italic",
    },
    ["LspDiagnosticsDefaultHint"] = {
      ["guibg"] = col_lineNr,
      ["guifg"] = white,
      ["gui"] = "bold",
    },
    ["LspDiagnosticsFloatingHint"] = {
      ["guibg"] = "",
      ["guifg"] = white,
      ["gui"] = "bold,italic",
    },
    ["Mygit"] = {
      ["guibg"] = black,
      ["guifg"] = red,
      ["gui"] = "bold",
    },
  }

  for j, v in pairs(hi_custom) do
    for _ in pairs(v) do
      if v["gui"] == "" then
        local my_string = string.format("hi %s guibg=%s guifg=%s", j, v["guibg"], v["guifg"])
        api.nvim_command(my_string)
      else
        local my_string = string.format(
          "hi %s guibg=%s guifg=%s gui=%s",
          j,
          v["guibg"],
          v["guifg"],
          v["gui"]
        )
        api.nvim_command(my_string)
      end
    end
  end
  return true
end

M.start_custom_hi()

return M
