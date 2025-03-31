local cmd = vim.cmd

---------------------------------
-- LSP
---------------------------------
RUtils.cmd.augroup("LSPUserBehaviour", {
  event = "LspDetach",
  command = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.attached_buffers then
      return
    end
    for buf_id in pairs(client.attached_buffers) do
      if buf_id ~= args.buf then
        return
      end
    end
    client:stop()
  end,
})

---------------------------------
-- BUFFER MAPPING
---------------------------------
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
    if vim.api.nvim_buf_is_valid(event.buf) then
      vim.keymap.set("n", "q", function()
        vim.cmd "close"
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end
  end,
})

---------------------------------
-- WINDOW
---------------------------------
RUtils.cmd.augroup("WindowBehaviour", {
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
  -- Untuk handle color `cursorline` dan `signcolumn`  pada `toggleterm.nvim`
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
})

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

---------------------------------
-- MISC
---------------------------------
RUtils.cmd.augroup("WrapFiletype", {
  event = "FileType",
  pattern = { "typescriptreact", "typescript" },
  command = function()
    vim.opt_local.wrap = true
  end,
}, {
  event = "FileType",
  pattern = "lazy",
  command = function()
    local new_value = not vim.diagnostic.config().virtual_lines
    if not new_value then
      vim.diagnostic.config { virtual_lines = new_value }
    end
  end,
})

RUtils.cmd.augroup("LargeFileSettings", {
  event = "BufRead",
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

RUtils.cmd.augroup("DisableJsonConceal", {
  event = { "FileType" },
  pattern = { "json", "jsonc" },
  command = function()
    vim.opt_local.conceallevel = 0
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

RUtils.cmd.augroup("CheckOutsideTime", {
  event = "FocusGained",
  pattern = "*",
  -- command = "if getcmdwintype() == '' | checktime | endif",
  command = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd "checktime"
    end
  end,
}, {
  event = "BufEnter",
  pattern = "*",
  -- command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
  command = function()
    if vim.bo.buftype == "" and not vim.bo.modified and vim.fn.expand "%" ~= "" then
      vim.cmd("checktime " .. vim.fn.expand "<abuf>")
    end
  end,
})

RUtils.cmd.augroup("GetErrorMessageNvimWhenQuit", {
  -- To check error when quit from nvim, commented when you not using it
  -- https://www.reddit.com/r/neovim/comments/10magvp/how_to_see_messages_that_are_displayed_when
  event = "VimLeave",
  pattern = "*",
  command = function()
    vim.cmd "redir! > /tmp/nvim_msgs.txt"
  end,
})

RUtils.cmd.augroup("OpenMediaImagePngGifNvim", {
  event = "BufEnter",
  pattern = { "*.png", "*.jpg", "*.gif" },
  command = function()
    local file_path = vim.fn.expand "%"
    vim.fn.system("bspc rule -a \\* -o state=tiled focus=true && sxiv -a " .. file_path)
    vim.cmd "bw"
  end,
}, {
  event = "BufEnter",
  pattern = "*.mp4",
  command = function()
    local file_path = vim.fn.expand "%"
    vim.fn.system("bspc rule -a \\* -o state=tiled focus=true && mpv " .. file_path)
    vim.cmd "bw"
  end,
})

---------------------------------
-- COPY PASTE
---------------------------------
RUtils.cmd.augroup("SetNopaste", {
  event = { "InsertLeave" },
  pattern = "*",
  command = "set nopaste",
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
