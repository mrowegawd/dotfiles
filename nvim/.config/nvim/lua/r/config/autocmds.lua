local cmd = vim.cmd

local Util = require "r.utils"

-- Wrap and check for spell in text filetypes
Util.cmd.augroup("WrapSpell", {
  event = { "FileType" },
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  command = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})

Util.cmd.augroup("WrapFt", {
  event = { "FileType" },
  pattern = { "typescriptreact", "typescript" },
  command = function()
    vim.opt_local.wrap = true
  end,
})

Util.cmd.augroup("LargeFileSettings", {
  event = { "BufReadPre" },
  desc = "Set settings for large files.",
  command = function(info)
    if vim.b.large_file ~= nil then
      return
    end
    vim.b.large_file = false
    local stat = vim.uv.fs_stat(info.match)
    if stat and stat.size > 1000000 then
      vim.b.large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.api.nvim_create_autocmd("BufReadPost", {
        buffer = info.buf,
        once = true,
        callback = function()
          vim.opt_local.syntax = ""
          return true
        end,
      })
    end
  end,
})

Util.cmd.augroup("ReHighlightFolded", {
  event = { "BufRead", "BufEnter", "FocusGained" },
  pattern = "*",
  command = function()
    if
      vim.tbl_contains(
        { "norg", "org", "markdown" },
        vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
      )
    then
      require("r.config.highlights").plugin("markdca", {
        { Folded = { bg = "NONE", fg = { from = "@field" } } },
      })
    else
      require("r.config.highlights").plugin("markdca", {
        {
          Folded = {
            bg = { from = "Normal", attr = "bg", alter = 0.3 },
            fg = "NONE",
            underline = false,
            bold = true,
          },
        },
      })
    end
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
  pattern = { "json", "jsonc" },
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
    "DressingSelect",
    "filetree",
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
    if vim.bo[event.buf].filetype == "filetree" then
      vim.keymap.set("n", "q", "<cmd>Workspace RightPanelToggle<cr>", { buffer = event.buf, silent = true })
    else
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end
  end,
})

-- Close quick fix window if the file containing it was closed
-- Util.cmd.augroup("AutoCloseQf", {
--   event = { "BufEnter", "FocusGained" },
--   command = function()
--     if vim.bo.buftype == "quickfix" and #vim.api.nvim_list_wins() == 1 then
--       -- vim.cmd "q"
--       api.nvim_buf_delete(0, { force = true })
--     end
--   end,
-- })

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

Util.cmd.augroup("LocateLastPosition", {
  -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(args)
    local exclude = { "gitcommit", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage" }
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
})

Util.cmd.augroup("WindowBehaviours", {
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
  event = { "VimResized" },
  pattern = "*",
  command = "wincmd =",
})

vim.cmd [[
  :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
]]

-- vim.cmd [[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] > 2048000 then print("syntax off") vim.cmd("setlocal syntax=off") end]]
