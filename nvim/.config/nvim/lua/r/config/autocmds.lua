local cmd = vim.cmd

-- WARN: command dibawah ini terdapat error
-- vim.opt.foldopen:remove { "search" } -- no auto-open when searching, since the following snippet does that better
-- vim.keymap.set("n", "<c-g>", "zn/", { desc = "Search & Pause Folds" })
--
-- vim.on_key(function(char)
--   local key = vim.fn.keytrans(char)
--   local searchKeys = { "n", "N", "*", "#", "/", "?" }
--
--   local searchConfirmed = (key == "<CR>" and vim.fn.getcmdtype():find "[/?]" ~= nil)
--   if not (searchConfirmed or vim.fn.mode() == "n") then
--     return
--   end
--
--   local searchKeyUsed = searchConfirmed or (vim.tbl_contains(searchKeys, key))
--   local pauseFold = vim.opt.foldenable:get() and searchKeyUsed
--   local unpauseFold = not (vim.opt.foldenable:get()) and not searchKeyUsed
--
--   if pauseFold then
--     vim.opt.foldenable = false
--   elseif unpauseFold then
--     vim.opt.foldenable = true
--
--     vim.cmd.normal "zv" -- after closing folds, keep the *current* fold open
--   end
-- end, vim.api.nvim_create_namespace "auto_pause_folds")

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

-- Taken from: https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
-- vim.api.nvim_create_autocmd("ModeChanged", {
--   pattern = "*",
--   callback = function()
--     if
--       ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
--       and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
--       and not require("luasnip").session.jump_active
--     then
--       require("luasnip").unlink_current()
--     end
--   end,
-- })

RUtils.cmd.augroup("WrapFt", {
  event = { "FileType" },
  pattern = { "typescriptreact", "typescript" },
  command = function()
    vim.opt_local.wrap = true
  end,
}, {
  event = { "FileType" },
  pattern = { "lazy" },
  command = function()
    local new_value = not vim.diagnostic.config().virtual_lines
    if not new_value then
      vim.diagnostic.config { virtual_lines = new_value }
    end
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
  event = "FileType",
  pattern = {
    "DressingSelect",
    "PlenaryTestPopup",
    "checkhealth",
    "filetree",
    "fugitive",
    "gitsigns.blame",
    "help",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "noice",
    "notify",
    "qf",
    "query",
    "snacks_notif",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  command = function(event)
    vim.bo[event.buf].buflisted = false

    for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
      if vim.api.nvim_win_is_valid(win) and (vim.api.nvim_win_get_buf(win) == event.buf) then
        vim.schedule(function()
          vim.keymap.set("n", "q", function()
            vim.cmd "close"
            pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
          end, {
            buffer = event.buf,
            silent = true,
            desc = "Quit buffer",
          })
        end)
      end
    end
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

RUtils.cmd.augroup("LocateLastPosition", {
  -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(args)
    local exclude = { "gitcommit", "Glance", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage", "qf" }
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

RUtils.cmd.augroup(
  "WindowBehaviours",
  {
    event = { "FileType" },
    pattern = {
      "orgagenda",
      "capture",
      "gitcommit",
      "qf",
      "NeogitCommitMessage",
      "NeogitPopup",
      -- "help",
      -- "Trouble",
    },
    command = function()
      cmd "wincmd J"
      if vim.bo[0].filetype == "NeogitCommitMessage" then
        cmd [[resize 20]]
      end
    end,
  },
  {
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
  },
  -- Untuk handle color `cursorline` dan `signcolumn`  pada `toggleterm.nvim`
  {
    event = { "BufRead", "BufEnter" },
    pattern = { "*" },
    command = function()
      vim.defer_fn(function()
        if
          vim.tbl_contains({ "terminal" }, vim.bo.buftype)
          or vim.tbl_contains({ "gitcommit", "OverseerList" }, vim.bo.filetype)
        then
          vim.opt_local.cursorline = false
          vim.opt_local.signcolumn = "no"
        end
      end, 100)
    end,
  }
)

RUtils.cmd.augroup("WindowDim", {
  event = { "BufRead" },
  pattern = { "*" },
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.buf_enter()
  end,
}, {
  event = { "BufEnter" },
  pattern = { "*" },
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.buf_enter()
  end,
}, {
  event = { "VimEnter", "FocusGained", "WinEnter" },
  pattern = "*",
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.focus_gained()
  end,
}, {
  event = { "VimLeave", "FocusLost" },
  pattern = "*",
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.focus_lost()
  end,
}, {
  event = { "WinLeave" },
  pattern = "*",
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.win_leave()
  end,
})
-- {
--   event = { "FocusLost" },
--   pattern = "*",
--   command = function()
--     vim.cmd [[set statusline=]]
--   end,
-- }, {
--   event = { "FocusGained" },
--   pattern = "*",
--   command = function()
--     vim.cmd [[set statusline=%{%v:lua.require'heirline'.eval_statusline()%}]]
--   end,
-- }

local aug = vim.api.nvim_create_augroup("CheckOutsideTime", {})
vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Reload files from disk when we focus vim",
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
  group = aug,
})
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Every time we enter an unmodified buffer, check if it changed on disk",
  pattern = "*",
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
  group = aug,
})

-- Copy/Paste when using ssh on a remote server
-- Only works on Neovim >= 0.10.0
if vim.clipboard and vim.clipboard.osc52 then
  RUtils.cmd.augroup("SSH_clipboard", {
    event = { "VimEnter" },
    command = function()
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
  " :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
  :autocmd BufEnter *.png,*.jpg,*gif :silent exec "!bspc rule -a \\* -o state=tiled focus=true && sxiv -a ///".expand("%") | :bw
]]

vim.cmd [[
  " :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
  :autocmd BufEnter *.mp4 :silent exec "!bspc rule -a \\* -o state=tiled focus=true && mpv ///".expand("%") | :bw
]]

-- To check error when quit from nvim
-- commented when you not using it
-- taken from info:   https://www.reddit.com/r/neovim/comments/10magvp/how_to_see_messages_that_are_displayed_when
vim.api.nvim_create_autocmd({ "QuitPre" }, {
  callback = function()
    vim.cmd "redir! > /tmp/nvim_msgs.txt"
  end,
})
