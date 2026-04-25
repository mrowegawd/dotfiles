-- Taken from and credit: https://github.com/wincent/wincent
local api, wo = vim.api, vim.wo
local H = require "r.settings.highlights"

---@class r.utils.windowdim
local autocmds = {}

---@param lower integer
---@param upper integer
---@return table
local function tryrange(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end

local focused_colorcolumn = RUtils.tryjoin_table_with_delimeter(tryrange(80, 256), ",")

local winhighlight_bottom_panel = table.concat({
  "Normal:PanelBottomNormal",
  "NormalNC:PanelBottomNormal",
  "SignColumn:PanelBottomNormal",
  "CursorLine:PanelBottomCursorLine",
  "CursorLineNr:PanelBottomCursorLineNr",
  "LineNr:QuickFixLineNr",
  "WinSeparator:QuickFixWinSeparator",
  "Delimiter:QuickFixWinDelimiter",
  "EndOfBuffer:PanelBottomNormal",
}, ",")

local winhighlight_note_panel = table.concat({
  "Normal:NormalNote",
  "NormalNC:NormalNote",
  "ColorColumn:NormalNote",
  "EndOfBuffer:NormalNote",
  "SignColumn:NormalNote",
  "NormalFloat:NormalNote",
  "FloatBorder:FloatBorderNote",
  "FloatTitle:TitleFloatNote",
  "CursorLine:CursorLineNote",
  "CursorLineNr:CursorLineNrNote",
  "Folded:FoldedNote",
  "Comment:ErrorMsg",
  "@Comment:CommentNote",
  "Pmenu:PmenuNote",
  "Visual:VisualNote",
  "NonText:NonTextNote",
  "LineNr:LineNrNote",
  "WinSeparator:WinSeparatorNote",
  "Delimiter:DelimiterNote",
}, ",")

local winhighlight_sidebar_panel = table.concat({
  "CursorLineNr:LineNr",
  "Normal:PanelSideNormal",
  "NormalNC:PanelSideNormal",
  "EndOfBuffer:PanelSideNormal",
  "IncSearch:NormalBoxComment",
}, ",")

local winhighlight_custom_folded = table.concat({
  "NormalFloat:Normal",
  "Folded:FoldedMarkdown",
}, ",")

autocmds.winhighlight_filetype_blacklist = {
  ["CommandTMatchListing"] = true,
  ["CommandTPrompt"] = true,
  ["CommandTTitle"] = true,
  ["Glance"] = true,
  ["NeogitCommitSelectView"] = true,
  ["NeogitCommitView"] = true,
  ["NeogitLogView"] = true,
  ["NeogitStatus"] = true,
  ["Outline"] = true,
  ["alpha"] = true,
  ["dashboard"] = true,
  ["oil"] = true,
  ["fugitiveblame"] = true,
  ["grug-far"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["neo-tree"] = true,
  ["noice"] = true,
  ["octo"] = true,
  ["packer"] = true,
  ["qf"] = true,
  ["rgflow"] = true,
  ["sagahover"] = true,
  ["sagasignature"] = true,
  ["startup"] = true,
  ["trouble"] = true,
  ["tsplayground"] = true,
  ["undotree"] = true,
}

-- Don't use colorcolumn when these filetypes get focus (we want them to appear
-- full-width irrespective of 'textwidth').
autocmds.colorcolumn_filetype_blacklist = {
  ["DiffviewFileHistory"] = true,
  ["Glance"] = true,
  ["NeogitCommitSelectView"] = true,
  ["NeogitStatus"] = true,
  ["TelescopePrompt"] = true,
  ["Trouble"] = true,
  ["alpha"] = true,
  ["capture"] = true,
  ["command-t"] = true,
  ["dap-repl"] = true,
  ["dap-variables"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
  ["dashboard"] = true,
  ["diff"] = true,
  ["dirvish"] = true,
  ["floggraph"] = true,
  ["fugitive"] = true,
  ["fugitiveblame"] = true,
  ["git"] = true,
  ["gitcommit"] = true,
  ["help"] = true,
  ["lazy"] = true,
  ["man"] = true,
  ["mason"] = true,
  ["mind"] = true,
  ["noice"] = true,
  ["octo"] = true,
  ["orgagenda"] = true,
  ["packer"] = true,
  ["qf"] = true,
  ["sagahover"] = true,
  ["sagasignature"] = true,
  ["scratch"] = true,
  ["startup"] = true,
  ["undotree"] = true,
}

autocmds.number_blacklist = {
  ["qf"] = false,
  ["Outline"] = false,
  ["orgagenda"] = false,
  ["BufTerm"] = false,
}

autocmds.bottom_panel = {
  ["qf"] = true,
}

autocmds.notes = {
  ["org"] = true,
  ["octo"] = true,
  ["codecompanion"] = true,
  ["markdown"] = true,
}

autocmds.side_panel = {
  ["Outline"] = true,
  ["aerial"] = true,
  ["dbui"] = true,

  ["neotest-summary"] = true,

  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
  ["dapui_scopes"] = true,
  ["dapui_breakpoints"] = true,
  ["dap-repl"] = true,
}

autocmds.blacklist_hl_folded = {
  ["org"] = true,
  ["git"] = true,
  ["codecompanion"] = true,
}

autocmds.cursorline_blacklist = {
  ["CommandTMatchListing"] = true,
  ["CommandTPrompt"] = true,
  ["CommandTTitle"] = true,
  ["NeogitCommitSelectView"] = true,
  ["NeogitCommitView"] = true,
  ["NeogitStatus"] = true,
  ["NvimTree"] = true,
  ["Outline"] = true,
  ["TelescopePrompt"] = true,
  ["aerial"] = true,
  ["alpha"] = true,
  ["command-t"] = true,
  ["dap-repl"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_console"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
  ["diff"] = true,
  ["help"] = true,
  ["mason"] = true,
  ["noice"] = true,
  ["packer"] = true,
  ["rgflow"] = true,
  ["snacks_notif_history"] = true,
  ["trouble"] = true,
  ["tsplayground"] = true,
  ["undotree"] = true,
}

autocmds.mkview_filetype_blacklist = {
  ["diff"] = true,
  ["gitcommit"] = true,
  ["hgcommit"] = true,
  ["undotree"] = true,
  ["packer"] = true,
  ["NvimTree"] = true,
  ["Outline"] = true,
  ["alpha"] = true,
  ["dap-repl"] = true,
  ["dapui_console"] = true,
  ["dapui_watches"] = true,
  ["dapui_stacks"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["mason"] = true,
}

local colorcolumn_width

local focus_window = function()
  local filetype, buftype = RUtils.buf.get_bo_buft()

  if filetype ~= "" and autocmds.winhighlight_filetype_blacklist[filetype] ~= true then
    wo.winhighlight = ""
  end

  -- Dont dim pada floating window, seperti TelescopePrompt
  if autocmds.colorcolumn_filetype_blacklist[filetype] == true or api.nvim_win_get_config(0).relative ~= "" then
    wo.colorcolumn = "255"

    if buftype == "" then
      return
    end
  else
    colorcolumn_width = 200 -- 120
    focused_colorcolumn = RUtils.tryjoin_table_with_delimeter(tryrange(colorcolumn_width, 256), ",")
    wo.colorcolumn = focused_colorcolumn
  end
end

local blurred_window = function()
  local filetype, _ = RUtils.buf.get_bo_buft()
  local is_float = vim.api.nvim_win_get_config(0).relative ~= ""

  if is_float then
    return
  end

  if filetype == "" and api.nvim_win_get_config(0).relative == "win" then
    wo.winhighlight = ""
    return
  end

  local is_winhighlight_disabled = false

  if autocmds.blacklist_hl_folded[filetype] then
    wo.winhighlight = winhighlight_custom_folded
    is_winhighlight_disabled = true
  end

  if autocmds.bottom_panel[filetype] then
    wo.winhighlight = winhighlight_bottom_panel
    is_winhighlight_disabled = true
  end

  if autocmds.notes[filetype] then
    wo.winhighlight = winhighlight_note_panel
    is_winhighlight_disabled = true
  end

  if autocmds.side_panel[filetype] then
    wo.winhighlight = winhighlight_sidebar_panel
    is_winhighlight_disabled = true
  end

  if is_winhighlight_disabled or autocmds.winhighlight_filetype_blacklist[filetype] then
    return
  end

  wo.winhighlight = ""
end

-- http://vim.wikia.com/wiki/Make_views_automatic
-- local mkview = function()
--     if should_mkview() then
--         local success, err = pcall(function()
--             if vim.fn.haslocaldir() == 1 then
--                 -- We never want to save an :lcd command, so hack around it...
--                 vim.cmd "cd -"
--                 vim.cmd "mkview"
--                 vim.cmd "lcd -"
--             else
--                 vim.cmd "mkview"
--             end
--         end)
--         if not success then
--             if err ~= nil then
--                 if
--                     err:find "%f[%w]E32%f[%W]" == nil -- No file name; could be no buffer (eg. :checkhealth)
--                     and err:find "%f[%w]E186%f[%W]" == nil -- No previous directory: probably a `git` operation.
--                     and err:find "%f[%w]E190%f[%W]" == nil -- Could be name or path length exceeding NAME_MAX or PATH_MAX.
--                     and err:find "%f[%w]E5108%f[%W]" == nil
--                 then
--                     error(err)
--                 end
--             end
--         end
--     end
-- end

local saved_cursorline_hl = nil
local color_cursorline_bright
local color_cursorlinenr_bright

local hi_cursorline = "highlight CursorLine"
local hi_cursorlinenr = "highlight CursorLineNr"

local function save_cursorline_hl()
  if not saved_cursorline_hl then
    local hl = H.h "CursorLine"
    local hlbg = H.h "PanelBottomCursorLine"

    local more_bright = 0.1

    color_cursorline_bright = H.tint(hlbg.bg, more_bright)
    color_cursorlinenr_bright = tostring(hlbg.bg)

    if hl then
      saved_cursorline_hl = hl
    end
  end
end

local function set_bright_cursorline()
  vim.cmd(hi_cursorline .. " guibg=" .. color_cursorline_bright)
  vim.cmd(hi_cursorlinenr .. " guibg=" .. color_cursorlinenr_bright)
end

local function restore_cursorline()
  if saved_cursorline_hl then
    local hl_cmd
    if saved_cursorline_hl.fg then
      hl_cmd = hi_cursorline .. " guifg=" .. saved_cursorline_hl.fg
    end
    if saved_cursorline_hl.bg then
      hl_cmd = hi_cursorline .. " guibg=" .. saved_cursorline_hl.bg
    end
    if saved_cursorline_hl.sp then
      hl_cmd = hi_cursorline .. " guisp=" .. saved_cursorline_hl.sp
    end
    if saved_cursorline_hl.gui then
      hl_cmd = hi_cursorline .. " gui=" .. saved_cursorline_hl.gui
    end
    vim.cmd(hl_cmd)
  end
end

vim.g.is_quickfix_cursorline_active = true

---@param active boolean
local set_cursorline = function(active)
  local filetype, buftype = RUtils.buf.get_bo_buft()
  local is_float = vim.api.nvim_win_get_config(0).relative ~= ""

  if is_float or filetype == "" or vim.wo.diff then
    wo.cursorline = false
    return
  end

  if (buftype == "quickfix" and filetype == "qf") or filetype == "orgagenda" then
    vim.wo.cursorline = active
    save_cursorline_hl()
    set_bright_cursorline()
    return
  end

  if not autocmds.cursorline_blacklist[filetype] then
    if not vim.g.is_quickfix_cursorline_active then
      vim.wo.cursorline = false
    else
      vim.wo.cursorline = active
    end

    if saved_cursorline_hl then
      restore_cursorline()
    end
  else
    vim.wo.cursorline = false
  end
end

autocmds.buf_enter = function()
  set_cursorline(true)
  focus_window()
  blurred_window()
end

autocmds.focus_gained = function()
  set_cursorline(true)
  blurred_window()
end

autocmds.focus_lost = function()
  set_cursorline(false)
  blurred_window()
end

autocmds.win_enter = function()
  -- blurred_window()
  -- set_cursorline(true)
end

autocmds.win_leave = function()
  set_cursorline(true)
  blurred_window()
end

return autocmds
