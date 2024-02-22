local cmd = vim.cmd

local Util = require "r.utils"

Util.cmd.augroup("WrapSpell", {
  event = { "FileType" },
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage", "norg" },
  command = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = false
    vim.opt_local.spelllang = { "en_us", "id" }
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

Util.cmd.augroup("TerminalDefaults", {
  event = { "TermOpen" },
  pattern = "*",
  command = function()
    vim.defer_fn(function()
      if vim.bo.buftype == "terminal" then
        vim.cmd [[startinsert]]
      end
    end, 100)
  end,
})

Util.cmd.augroup("LargeFileSettings", {
  event = { "BufRead" },
  desc = "Set settings for large files.",
  command = function(ctx)
    local buf = ctx.buf

    if Util.buf.is_big_file(ctx.buf) then
      vim.b[buf].is_big_file = true
      vim.b[buf].copilot_enabled = false
      vim.b[buf].autoformat_disable = true
      vim.b[buf].minicursorword_disable = true
      vim.b[buf].diagnostic_disable = true
      vim.b[buf].lsp_disable = true

      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""

      vim.api.nvim_create_augroup("disable_syntax_on_buf_" .. buf, { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = "disable_syntax_on_buf_" .. buf,
        buffer = buf,
        once = true,
        callback = vim.schedule_wrap(function()
          local current_buf = vim.api.nvim_get_current_buf()
          if current_buf == buf then
            vim.bo[buf].syntax = ""
          end
        end),
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
      require("r.settings.highlights").plugin("markdca", {
        { Folded = { bg = "NONE", fg = { from = "Boolean" } } },
      })
    else
      require("r.settings.highlights").plugin("markdca", {
        theme = {
          ["*"] = {
            {
              Folded = {
                bg = { from = "Normal", attr = "bg", alter = 0.5 },
                fg = { from = "Normal", attr = "bg", alter = 1.6 },
                underline = false,
                bold = true,
              },
            },
          },
          ["farout"] = {
            {
              Folded = {
                bg = { from = "Normal", attr = "bg", alter = 2 },
                fg = { from = "Normal", attr = "bg", alter = 4 },
                underline = false,
                bold = true,
              },
            },
          },

          ["catppuccin-latte"] = {
            {
              Folded = {
                bg = { from = "Normal", attr = "bg", alter = -0.1 },
                fg = { from = "Normal", attr = "bg", alter = -0.3 },
                underline = false,
                bold = true,
              },
            },
          },
        },
      })
    end
  end,
})

Util.cmd.augroup("SetNopaste", {
  event = { "InsertLeave" },
  pattern = "*",
  command = "set nopaste",
})

Util.cmd.augroup("DisableJsonConceal", {
  event = { "FileType" },
  pattern = { "json", "jsonc" },
  command = function()
    vim.opt_local.conceallevel = 0
  end,
})

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

-- Util.cmd.augroup("DisableHiBGNormal", {
--   event = { "BufReadPost" },
--   pattern = "*",
--   command = function()
--     if os.getenv "TERMINAL" == "wezterm" then
--       cmd "hi Normal guibg=NONE"
--     end
--   end,
--   once = true,
-- })

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
  event = { "FocusGained", "TermClose", "TermLeave" },
  command = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

-- Util.cmd.augroup(
--   "WindowDim",
--   -- {
--   --   event = { "BufRead" },
--   --   pattern = { "*" },
--   --   command = function()
--   --     Util.windowdim.buf_enter()
--   --   end,
--   -- }, {
--   --   event = { "BufEnter" },
--   --   pattern = { "*" },
--   --   command = function()
--   --     Util.windowdim.buf_enter()
--   --   end,
--   -- },
--   {
--     event = { "VimEnter", "FocusGained", "WinEnter" },
--     pattern = "*",
--     command = function()
--       Util.windowdim.focus_gained()
--     end,
--   },
--   {
--     event = { "VimLeave", "FocusLost", "WinLeave" },
--     pattern = "*",
--     command = function()
--       Util.windowdim.focus_lost()
--     end,
--   }
--   -- {
--   --   event = { "WinEnter" },
--   --   pattern = "*",
--   --   command = function()
--   --     Util.windowdim.win_enter()
--   --   end,
--   -- },
--   -- {
--   --   event = { "WinLeave" },
--   --   pattern = "*",
--   --   command = function()
--   --     Util.windowdim.win_leave()
--   --   end,
--   -- }
-- )

vim.cmd [[
  :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
]]

-- vim.cmd [[autocmd FileType * silent! lua if vim.fn.wordcount()['bytes'] > 2048000 then print("syntax off") vim.cmd("setlocal syntax=off") end]]
