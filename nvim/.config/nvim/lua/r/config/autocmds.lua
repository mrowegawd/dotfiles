local fn, api, cmd, v = vim.fn, vim.api, vim.cmd, vim.v

local Util = require "r.utils"

vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
  if v.hlsearch == 0 or api.nvim_get_mode().mode ~= "n" then
    return
  end
  Util.cmd.feedkey("<Plug>(StopHL)", "n")
end

local function hl_search()
  local col = api.nvim_win_get_cursor(0)[2]
  local curr_line = api.nvim_get_current_line()
  local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg "/", 0)
  if pcall(require, "hlslens") then
    require("hlslens").start()
  end

  if not ok then
    return
  end
  ---@diagnostic disable-next-line: deprecated
  local _, p_start, p_end = unpack(match)
  -- if the cursor is in a search result, leave highlighting on
  if col < p_start or col > p_end then
    stop_hl()
  end
end

Util.cmd.augroup("VimrcIncSearchHighlight", {
  event = { "CursorMoved" },
  command = function()
    hl_search()
  end,
}, {
  event = { "InsertEnter" },
  command = function()
    stop_hl()
  end,
}, {
  event = { "OptionSet" },
  pattern = { "hlsearch" },
  command = function()
    vim.schedule(function()
      cmd.redrawstatus()
    end)
  end,
}, {
  event = "RecordingEnter",
  command = function()
    vim.o.hlsearch = false
  end,
}, {
  event = "RecordingLeave",
  command = function()
    vim.o.hlsearch = true
  end,
})

-- wrap and check for spell in text filetypes
Util.cmd.augroup("Wrap_spell", {
  event = { "FileType" }, -- map q to close command window on quit
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  command = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Close certain filetypes by pressing q.
Util.cmd.augroup("SmartClose", {
  event = { "FileType" },
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  command = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Close quick fix window if the file containing it was closed
Util.cmd.augroup("AutoCloseQf", {
  event = { "BufEnter" },
  command = function()
    if fn.winnr "$" == 1 and vim.bo.buftype == "quickfix" then
      api.nvim_buf_delete(0, { force = true })
    end
  end,
})

-- don't execute silently in case of errors
Util.cmd.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank {
      timeout = 200,
      on_visual = true,
      higroup = "NvimInternalError",
    }
  end,
})

Util.cmd.augroup("WindowBehaviours", {
  event = { "CmdwinEnter" }, -- map q to close command window on quit
  pattern = { "*" },
  command = "nnoremap <silent><buffer><nowait> q <C-W>c",
}, {
  event = { "BufWinEnter" },
  command = function(args)
    if vim.wo.diff then
      vim.diagnostic.disable(args.buf)
    end
  end,
}, {
  event = { "BufWinLeave" },
  command = function(args)
    if vim.wo.diff then
      vim.diagnostic.enable(args.buf)
    end
  end,
}, {
  -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(args)
    local exclude = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    local buf = args.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
}, {
  event = { "FileType" },
  pattern = {
    "orgagenda",
    "capture",
    "gitcommit",
    "help",
    "Trouble",
  },
  command = function()
    cmd "wincmd J"
  end,
}, {
  event = { "FileType" },
  pattern = { "qf" },
  command = function()
    cmd "stopinsert"
  end,
}, {
  event = { "FileType" },
  pattern = { "norg", "org", "orgagenda" },
  command = function()
    vim.opt_local.foldcolumn = "0"
  end,
}, {
  event = { "FileType" },
  pattern = { "org", "orgagenda" },
  command = function()
    vim.cmd [[setlocal foldtext=OrgmodeFoldText()]]
  end,
}, {

  event = { "FileType" },
  pattern = { "norg" },
  command = function()
    vim.cmd [[setlocal foldtext=v:lua.foldtext()]]
  end,
})

Util.cmd.augroup("DisableWinBf", {
  event = { "BufRead", "BufWinEnter" },
  pattern = { "*" },
  command = function(args)
    local buf = vim.bo[args.buf].filetype

    if buf == "BufTerm" then
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  end,
})

Util.cmd.augroup("ConvertNorg", {
  event = { "BufWritePost" },
  pattern = { "*.norg" },
  command = function()
    Util.neorg_notes.convert_norg_to_markdown()
  end,
})

Util.cmd.augroup("CheckOutsideTime", {
  -- automatically check for changed files outside vim
  event = {
    "WinEnter",
    "BufWinEnter",
    "BufWinLeave",
    "BufRead",
    "BufEnter",
    "FocusGained",
  },
  command = "silent! checktime",
})

-- Util.cmd.augroup("WindowDim", {
--   event = { "BufRead" },
--   pattern = { "*" },
--   command = function()
--     Util.windowdim.buf_enter()
--   end,
-- }, {
--   event = { "BufEnter" },
--   pattern = { "*" },
--   command = function()
--     Util.windowdim.buf_enter()
--   end,
-- }, {
--   event = { "FocusGained" },
--   pattern = "*",
--   command = function()
--     Util.windowdim.focus_gained()
--   end,
-- }, {
--   event = { "FocusLost" },
--   pattern = "*",
--   command = function()
--     Util.windowdim.focus_lost()
--   end,
-- }, {
--   event = { "WinEnter" },
--   pattern = "*",
--   command = function()
--     Util.windowdim.win_enter()
--   end,
-- }, {
--   event = { "WinLeave" },
--   pattern = "*",
--   command = function()
--     Util.windowdim.win_leave()
--   end,
-- })

-- Util.cmd.augroup("UnwareCursorLine", {
--   event = { "InsertLeave" },
--   pattern = { "*" },
--   command = function()
--     cmd [[set cursorline]]
--   end,
-- }, {
--   event = { "InsertEnter" },
--   pattern = { "*" },
--   command = function()
--     cmd [[set nocursorline]]
--   end,
-- })

Util.cmd.augroup("DisableStatusline", {
  event = { "FocusLost" },
  pattern = "*",
  command = function()
    cmd [[set laststatus=0]]
  end,
}, {
  event = { "BufRead", "FocusGained" },
  pattern = "*",
  command = function()
    cmd [[set laststatus=3]]
  end,
})

-- Automatically resize windows when host resizes
-- Util.cmd.augroup("AutoResizeWindows", {
--   event = { "BufNew", "BufRead" },
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.cmd [[
  :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
]]
