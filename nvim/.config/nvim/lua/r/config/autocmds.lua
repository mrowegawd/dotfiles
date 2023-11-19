local fn, api, cmd = vim.fn, vim.api, vim.cmd

local Util = require "r.utils"

-- wrap and check for spell in text filetypes
Util.cmd.augroup("Wrap_spell", {
  event = { "FileType" }, -- map q to close command window on quit
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  command = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Turn off paste mode when leaving insert
Util.cmd.augroup("SetNopaste", {
  event = { "InsertLeave" },
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
Util.cmd.augroup("DisableJsonConceal", {
  event = { "FileType" },
  pattern = { "json", "jsonc", "markdown" },
  command = function()
    vim.opt_local.conceallevel = 0
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
    "noice",
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
    -- "help",
    "qf",
    "NeogitCommitMessage",
    "NeogitPopup",
    -- "Trouble",
  },
  command = function()
    cmd "wincmd J"
    if vim.bo[0].filetype == "NeogitCommitMessage" then
      cmd [[resize 20]]
    end
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

Util.cmd.augroup("WindowDim", {
  event = { "BufRead" },
  pattern = { "*" },
  command = function()
    Util.windowdim.buf_enter()
  end,
}, {
  event = { "BufEnter" },
  pattern = { "*" },
  command = function()
    Util.windowdim.buf_enter()
  end,
}, {
  event = { "FocusGained" },
  pattern = "*",
  command = function()
    Util.windowdim.focus_gained()
  end,
}, {
  event = { "FocusLost" },
  pattern = "*",
  command = function()
    Util.windowdim.focus_lost()
  end,
}, {
  event = { "WinEnter" },
  pattern = "*",
  command = function()
    Util.windowdim.win_enter()
  end,
}, {
  event = { "WinLeave" },
  pattern = "*",
  command = function()
    Util.windowdim.win_leave()
  end,
})

-- local obs = false
-- local function set_scrolloff(winid)
--   if obs then
--     vim.wo[winid].scrolloff = math.floor(math.max(4, vim.api.nvim_win_get_height(winid) / 2))
--   else
--     vim.wo[winid].scrolloff = 1 + math.floor(vim.api.nvim_win_get_height(winid) / 2)
--   end
-- end

-- Util.cmd.augroup("SetScrollOff", {
--   event = { "BufEnter", "WinEnter", "WinNew", "VimResized" },
--   -- desc = "Always keep the cursor vertically centered",
--   pattern = "*",
--   command = function()
--     set_scrolloff(0)
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

-- Util.cmd.augroup("UnwareCursorLine", {
--   event = { "CmdlineEnter" },
--   pattern = { "*" },
--   command = function()
--     cmd [[set nocursorline]]
--   end,
-- }, {
--   event = { "CmdlineLeave" },
--   pattern = { "*" },
--   command = function()
--     cmd [[set cursorline]]
--   end,
-- }, {
--   -- vim.api.nvim_create_autocmd("ModeChanged
--   event = { "ModeChanged" },
--   pattern = "*:c",
--   command = function()
--     cmd [[set nocursorline]]
--   end,
-- })

-- vim.api.nvim_create_autocmd("CmdlineEnter", {
--   group = group,
--   callback = function()
--     if State.is_search() and M.enabled then
--       M.start()
--       M.set_op(vim.fn.mode() == "v")
--     end
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
Util.cmd.augroup("AutoResizeWindowssf", {
  event = { "BufNew", "BufRead" },
  pattern = "*",
  command = "tabdo wincmd =",
})

-- vim.cmd [[
--   :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
-- ]]
