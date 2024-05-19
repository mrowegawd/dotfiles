local cmd = vim.cmd

RUtils.cmd.augroup("WrapSpell", {
  event = { "FileType" },
  pattern = { "gitcommit", "NeogitCommitMessage" },
  command = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.spelllang = { "en_us", "id" }
    vim.opt_local.conceallevel = 2
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  -- Related https://github.com/neovim/neovim/issues/20726
  desc = "Disable fold inside terminal",
  callback = function()
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldenable = false
  end,
})

-- {
--   -- turn current line blame off in insert mode,
--   -- back on when leaving insert mode
--   name = 'GitSignsCurrentLineBlameInsertModeToggle',
--   {
--     { 'InsertLeave', 'InsertEnter' },
--     function()
--       local ok, gitsigns_config = pcall(require, 'gitsigns.config')
--       if not ok then
--         return
--       end
--
--       local enabled = gitsigns_config.config.current_line_blame
--       local mode = vim.fn.mode()
--       if (mode == 'i' and enabled) or (mode ~= 'i' and not enabled) then
--         pcall(vim.cmd --[[@as function]], 'Gitsigns toggle_current_line_blame')
--       end
--     end,
--   },
-- },

RUtils.cmd.augroup("WrapFt", {
  event = { "FileType" },
  pattern = { "typescriptreact", "typescript" },
  command = function()
    vim.opt_local.wrap = true
  end,
})

RUtils.cmd.augroup("TerminalDefaults", {
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

RUtils.cmd.augroup("LargeFileSettings", {
  event = { "BufRead" },
  desc = "Set settings for large files.",
  command = function(ctx)
    local buf = ctx.buf

    if RUtils.buf.is_big_file(ctx.buf) then
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

RUtils.cmd.augroup("SetNopaste", {
  event = { "InsertLeave" },
  pattern = "*",
  command = "set nopaste",
})

RUtils.cmd.augroup("DisableJsonConceal", {
  event = { "FileType" },
  pattern = { "json", "jsonc" },
  command = function()
    vim.opt_local.conceallevel = 0
  end,
})

RUtils.cmd.augroup("SmartClose", {
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
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

RUtils.cmd.augroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.highlight.on_yank {
      timeout = 200,
      on_visual = true,
      higroup = "NvimInternalError",
    }
  end,
})

-- RUtils.cmd.augroup("WindowBehaviours", {
--   event = { "FileType" },
--   pattern = { "norg", "org", "orgagenda" },
--   command = function()
--     vim.opt_local.foldcolumn = "0"
--   end,
-- }, {
--   event = { "FileType" },
--   pattern = { "org", "orgagenda" },
--   command = function()
--     -- vim.cmd [[setlocal foldtext=OrgmodeFoldText()]]
--     vim.cmd [[setlocal foldmethod=manual]]
--   end,
-- }, {
--   event = { "FileType" },
--   pattern = { "norg" },
--   command = function()
--     vim.cmd [[setlocal foldtext=v:lua.foldtext()]]
--   end,
-- })

RUtils.cmd.augroup("LocateLastPosition", {
  -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(args)
    local exclude = { "gitcommit", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage", "qf" }
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

RUtils.cmd.augroup("WindowBehaviours", {
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

RUtils.cmd.augroup("ConvertNorg", {
  event = { "BufWritePost" },
  pattern = { "*.norg" },
  command = function()
    RUtils.neorg.convert_norg_to_markdown()
  end,
})

RUtils.cmd.augroup("CheckOutsideTime", {
  -- automatically check for changed files outside vim
  event = { "FocusGained", "TermClose", "TermLeave" },
  command = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

-- Copy/Paste when using ssh on a remote server
-- Only works on Neovim >= 0.10.0
if vim.clipboard and vim.clipboard.osc52 then
  RUtils.cmd.augroup("SSH_clipboard", {
    event = { "VimEnter" },
    callback = function()
      if vim.env.SSH_CONNECTION and vim.clipboard.osc52 then
        vim.g.clipboard = {
          name = "OSC 52",
          copy = {
            ["+"] = require("vim.clipboard.osc52").copy,
            ["*"] = require("vim.clipboard.osc52").copy,
          },
          paste = {
            ["+"] = require("vim.clipboard.osc52").paste,
            ["*"] = require("vim.clipboard.osc52").paste,
          },
        }
      end
    end,
  })
end

vim.cmd [[
  :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
]]

-- RUtils.cmd.augroup("DisableHiBGNormal", {
--   event = { "BufReadPost" },
--   pattern = "*",
--   command = function()
--     if os.getenv "TERMINAL" == "wezterm" then
--     cmd "hi Normal guibg=NONE"
--     end
--   end,
--   once = true,
-- })

-- RUtils.cmd.augroup(
--   "WindowDim",
--   -- {
--   --   event = { "BufRead" },
--   --   pattern = { "*" },
--   --   command = function()
--   --     RUtils.windowdim.buf_enter()
--   --   end,
--   -- }, {
--   --   event = { "BufEnter" },
--   --   pattern = { "*" },
--   --   command = function()
--   --     RUtils.windowdim.buf_enter()
--   --   end,
--   -- },
--   {
--     event = { "VimEnter", "FocusGained", "WinEnter" },
--     pattern = "*",
--     command = function()
--       RUtils.windowdim.focus_gained()
--     end,
--   },
--   {
--     event = { "VimLeave", "FocusLost", "WinLeave" },
--     pattern = "*",
--     command = function()
--       RUtils.windowdim.focus_lost()
--     end,
--   }
--   -- {
--   --   event = { "WinEnter" },
--   --   pattern = "*",
--   --   command = function()
--   --     RUtils.windowdim.win_enter()
--   --   end,
--   -- },
--   -- {
--   --   event = { "WinLeave" },
--   --   pattern = "*",
--   --   command = function()
--   --     RUtils.windowdim.win_leave()
--   --   end,
--   -- }
-- )
