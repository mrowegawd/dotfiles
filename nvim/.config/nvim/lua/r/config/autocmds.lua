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

-- NOTE: It seems this fix error invalid window from `resession.nvim'`
RUtils.cmd.augroup("ForceCloseQFToAvoidSessionError", {
  event = { "VimLeavePre", "VimLeave" },
  command = function()
    local is_qf_opened = RUtils.cmd.windows_is_opened { "qf" }
    if is_qf_opened.found then
      vim.cmd [[cclose]]
    end
  end,
})

RUtils.cmd.augroup("WrapFt", {
  event = { "FileType" },
  pattern = { "typescriptreact", "typescript" },
  command = function()
    vim.opt_local.wrap = true
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
}, {
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
}, {
  event = { "BufEnter", "BufRead" },
  pattern = "*",
  command = function()
    if (vim.bo.filetype == "" and vim.bo.buftype == "terminal") or vim.bo.filetype == "toggleterm" then
      -- vim.cmd.startinsert()

      RUtils.map.tnoremap("<esc><esc>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      RUtils.map.tnoremap("qq", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      RUtils.map.tnoremap("<c-space>", "<C-\\><C-n>", { desc = "Terminal: normal mode" })
      RUtils.map.tnoremap("<a-x>", function()
        -- RUtils.map.feedkey("<C-\\><C-n>:q!<CR>", "t")
        local buf = vim.api.nvim_get_current_buf()
        require("bufdelete").bufdelete(buf, true)
      end, { desc = "Terminal: close terminal" })

      RUtils.map.tnoremap("<a-w>", function()
        RUtils.map.feedkey("<C-\\><C-n>", "t")
        require("fzf-lua").tabs()
      end, { desc = "Terminal: show tabs [fzflua]" })
      RUtils.map.tnoremap("<c-a-l>", function()
        RUtils.map.feedkey("<C-\\><C-n><c-a-l>", "t")
      end, { desc = "Terminal: next tab" })
      RUtils.map.tnoremap("<c-a-h>", function()
        RUtils.map.feedkey("<C-\\><C-n><c-a-h>", "t")
      end, { desc = "Terminal: prev tab" })
      RUtils.map.tnoremap("<a-m>", function()
        RUtils.map.feedkey("<C-\\><C-n>sm", "t")
        if vim.bo.buftype == "terminal" then
          RUtils.map.feedkey("a", "t")
        end
      end, { desc = "Terminal: toggle zoom" })

      -- ========================
      -- Do not delete these line!
      -- ========================

      RUtils.map.tnoremap("<a-f>", function()
        RUtils.terminal.toggle_right_term()
        -- RUtils.map.feedkey("<C-\\><C-n><a-f>", "t")
      end, { desc = "Terminal: new term split" })
      RUtils.map.tnoremap("<a-N>", function()
        RUtils.map.feedkey("<C-\\><C-n><a-N>", "t")
      end, { desc = "Terminal: new tabterm" })
      RUtils.map.tnoremap("<a-CR>", function()
        RUtils.terminal.smart_split()
      end, { desc = "Terminal: new term" })
      RUtils.map.tnoremap("<Leader>bd", function()
        RUtils.map.feedkey("<C-\\><C-n><Leader>bd", "t")
      end, { desc = "Terminal: rescue buffer" })
    end
  end,
})

RUtils.cmd.augroup("WindowDim", {
  event = { "BufRead" },
  pattern = { "*" },
  command = function()
    RUtils.windowdim.buf_enter()
  end,
}, {
  event = { "BufEnter" },
  pattern = { "*" },
  command = function()
    RUtils.windowdim.buf_enter()
  end,
}, {
  event = { "VimEnter", "FocusGained", "WinEnter" },
  pattern = "*",
  command = function()
    RUtils.windowdim.focus_gained()
  end,
}, {
  event = { "VimLeave", "FocusLost", "WinLeave" },
  pattern = "*",
  command = function()
    RUtils.windowdim.focus_lost()
  end,
}, {
  event = { "WinEnter" },
  pattern = "*",
  command = function()
    RUtils.windowdim.win_enter()
  end,
}, {
  event = { "WinLeave" },
  pattern = "*",
  command = function()
    RUtils.windowdim.win_leave()
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
  :autocmd BufEnter *.png,*.jpg,*gif exec "!bspc rule -a \\* -o state=tiled focus=true && sxiv -a ///".expand("%") | :bw
]]

vim.cmd [[
  " :autocmd BufEnter *.png,*.jpg,*gif exec "!sxiv -a ".expand("%") | :bw
  :autocmd BufEnter *.mp4 exec "!bspc rule -a \\* -o state=tiled focus=true && mpv ///".expand("%") | :bw
]]
