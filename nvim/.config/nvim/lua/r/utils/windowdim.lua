-- Taken from and credit: https://github.com/wincent/wincent
local api, wo = vim.api, vim.wo

---@class r.utils.windowdim
local autocmds = {}

local focused_colorcolumn = RUtils.cmd.tryjoin(RUtils.cmd.tryrange(80, 256), ",")

-- local winhighlight_blurred = table.concat({
--   -- -- "IncSearch:ColorColumn",
--   "CursorLineNr:LineNr",
--   "SignColumn:ColorColumn",
--   "EndOfBuffer:ColorColumn",
--   -- "LineNr:ColorColumn",
--   "CursorLineNr:CursorLineNr",
--   "IncSearch:ColorColumn",
--   "Normal:ColorColumn",
--   "NormalNC:ColorColumn",
--   "Search:ColorColumn",
--   "SignColumn:ColorColumn",
-- }, ",")

-- local winhighlight_blurred = table.concat({
--   -- -- "IncSearch:ColorColumn",
--   "CursorLineNr:LineNr",
--   "SignColumn:ColorColumn",
--   "EndOfBuffer:ColorColumn",
--   -- "LineNr:ColorColumn",
--   "CursorLineNr:CursorLineNr",
--   "IncSearch:ColorColumn",
--   "Normal:ColorColumn",
--   "NormalNC:Normal",
--   "Search:ColorColumn",
--   "SignColumn:ColorColumn",
-- }, ",")

-- local winhighlight_blurred = table.concat({
--   "CursorLineNr:LineNr",
--   "EndOfBuffer:ColorColumn",
--   -- "IncSearch:ColorColumn",
--   "Normal:ColorColumn",
--   "NormalNC:ColorColumn",
--   "SignColumn:ColorColumn",
--   "WinBar:ColorColumn",
--   "NormalFloat:ColorColumn",
-- }, ",")

local winhighlight_buffer = table.concat({
  "Folded:FoldedMarkdown",
}, ",")

-- Jangan bikin ft ini effect windowdim
autocmds.winhighlight_filetype_blacklist = {
  ["CommandTMatchListing"] = true,
  ["CommandTPrompt"] = true,
  ["CommandTTitle"] = true,
  ["noice"] = true,
  -- ["Outline"] = true,
  ["alpha"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["dashboard"] = true,
  ["diff"] = true,
  ["Glance"] = true,
  -- ["git"] = true,
  -- ["floggraph"] = true,
  ["octo"] = true,
  ["fugitiveblame"] = true,
  ["packer"] = true,
  ["sagahover"] = true,
  ["sagasignature"] = true,
  ["startup"] = true,
  ["tsplayground"] = true,
  ["undotree"] = true,
}

-- Don't use colorcolumn when these filetypes get focus (we want them to appear
-- full-width irrespective of 'textwidth').
autocmds.colorcolumn_filetype_blacklist = {
  ["DiffviewFileHistory"] = true,
  ["NeogitCommitSelectView"] = true,
  ["NeogitStatus"] = true,
  ["TelescopePrompt"] = true,
  ["Trouble"] = true,
  ["alpha"] = true,
  ["lazy"] = true,
  ["mason"] = true,
  ["capture"] = true,
  ["command-t"] = true,
  ["git"] = true,
  ["floggraph"] = true,
  ["dap-repl"] = true,
  ["dap-variables"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
  ["noice"] = true,
  ["dashboard"] = true,
  ["diff"] = true,
  ["dirvish"] = true,
  ["fugitive"] = true,
  ["Glance"] = true,
  ["fugitiveblame"] = true,
  ["gitcommit"] = true,
  ["help"] = true,
  ["man"] = true,
  ["mind"] = true,
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

autocmds.ignore_cursorline = {
  ["Outline"] = true,
}

autocmds.winhi_filetype = {
  ["markdown"] = true,
  ["md"] = true,
  ["orgagenda"] = true,
  ["org"] = true,
  ["git"] = true,
}

autocmds.cursorline_blacklist = {
  ["CommandTMatchListing"] = true,
  ["CommandTPrompt"] = true,
  ["CommandTTitle"] = true,
  ["NvimTree"] = true,
  ["Outline"] = false,
  ["TelescopePrompt"] = true,
  ["alpha"] = true,
  ["command-t"] = true,
  ["dap-repl"] = true,
  ["dapui_breakpoints"] = true,
  ["dapui_console"] = true,
  ["dapui_scopes"] = true,
  ["dapui_stacks"] = true,
  ["dapui_watches"] = true,
  ["mason"] = true,
  ["orgagenda"] = true,
  ["packer"] = true,
  ["qf"] = true,
  ["markdown"] = true,
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

  if autocmds.winhighlight_filetype_blacklist[filetype] ~= true then
    wo.winhighlight = ""
  end

  if
    autocmds.colorcolumn_filetype_blacklist[filetype] == true
    -- Dont dim pada floating window, seperti TelescopePrompt
    or api.nvim_win_get_config(0).relative ~= ""
  then
    wo.colorcolumn = "255"

    if buftype == "" then
      return
    end
  else
    -- local ft = api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
    -- if ft == "markdown" or ft == "org" then
    colorcolumn_width = 200 -- 120
    -- colorcolumn_width = 200 -- 120
    -- end
    focused_colorcolumn = RUtils.cmd.tryjoin(RUtils.cmd.tryrange(colorcolumn_width, 256), ",")
    wo.colorcolumn = focused_colorcolumn
  end
end

local winhl_window = function()
  local filetype, _ = RUtils.buf.get_bo_buft()
  if autocmds.winhi_filetype[filetype] and api.nvim_win_get_config(0).relative ~= "win" then
    wo.winhighlight = winhighlight_buffer
  end
end

-- local blur_window = function()
--   local filetype, _ = RUtils.buf.get_bo_buft()
--
--   if
--     filetype == ""
--     or autocmds.winhighlight_filetype_blacklist[filetype] ~= true and api.nvim_win_get_config(0).relative ~= "win"
--   then
--     wo.winhighlight = winhighlight_blurred
--   end
-- end

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

local set_cursorline = function(active)
  local filetype, _ = RUtils.buf.get_bo_buft()
  if autocmds.cursorline_blacklist[filetype] ~= true then
    -- nvim_win_get_config.relative utk detect float window, output boolean
    if not api.nvim_win_get_config(0).relative then
      wo.cursorline = active
    end
  else
    wo.cursorline = false
  end
end

autocmds.buf_enter = function()
  set_cursorline(true)
  focus_window()
  winhl_window()
end

autocmds.focus_gained = function()
  set_cursorline(true)
  winhl_window()
end

autocmds.focus_lost = function()
  set_cursorline(true)
end

autocmds.win_enter = function()
  set_cursorline(true)
  winhl_window()
end

autocmds.win_leave = function()
  set_cursorline(true)
  -- blur_window()
end

return autocmds
