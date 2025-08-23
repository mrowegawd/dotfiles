local cmd = vim.cmd

---- Only show cursorline in the current window and save last visited window id
local cline_acg = vim.api.nvim_create_augroup("cline", { clear = true })
vim.api.nvim_create_autocmd("WinLeave", {
  group = cline_acg,
  callback = function()
    _G.LastWinId = vim.fn.win_getid()
  end,
})

---------------------------------
-- LSP
---------------------------------
RUtils.cmd.augroup("LSPUserBehaviour", {
  event = "LspDetach",
  command = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or not client.attached_buffers then
      return
    end
    for buf_id in pairs(client.attached_buffers) do
      if buf_id ~= event.buf then
        return
      end
    end
    client:stop()
  end,
}, {
  event = "LspAttach", -- remove copilot client (and document_color), so fuck it!
  command = function(event)
    vim.lsp.document_color.enable(false, event.buf) -- Not needed atm

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "copilot" then
      -- vim.notify("Copilot has been detached", vim.log.levels.WARN)
      client:stop()
    end
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
    -- "help",
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
    "org",
  },
  command = function(event)
    -- Do not use the 'q' key as a keymap for this filetype IF they window is floating
    local is_float = vim.api.nvim_win_get_config(0).relative ~= ""
    local exclude_ft = { "org" }
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) and is_float then
      return
    end

    vim.bo[event.buf].buflisted = false
    if vim.api.nvim_buf_is_valid(event.buf) and (#vim.api.nvim_list_wins() > 1) then
      for _, x in pairs { "q", "<c-q>" } do
        vim.keymap.set("n", x, function()
          if vim.bo[event.buf].filetype == "qf" then
            local cmd_qf = "cclose"
            if RUtils.qf.is_loclist() then
              cmd_qf = "lclose"
            end
            vim.fn.win_gotoid(_G.LastWinId)
            vim.cmd(cmd_qf)
            return
          end
          pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end, {
          buffer = event.buf,
          silent = true,
          desc = "Quit buffer",
        })
      end
    end
  end,
})

---------------------------------
-- WINDOW
---------------------------------
RUtils.cmd.augroup("WindowBehaviour", {
  event = "FileType",
  pattern = {
    "orgagenda",
    "capture",
    "gitcommit",
    -- "qf",
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
  event = "FileType",
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
  event = { "BufRead", "BufEnter" },
  pattern = "*",
  command = function()
    if vim.bo.filetype == "codecompanion" then
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      -- vim.wo.winhighlight = "Normal:Pmenu,FloatBorder:CmpDocFloatBorder,CursorLine:CursorLine,Search:None"
    end
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

local filetypes_with_auto_folding = { "org" } -- filetypes that trigger auto folding, markdown

RUtils.cmd.augroup("AutoFoldOnBufferEvents", {
  event = { "BufEnter", "BufRead" },
  pattern = "*",
  command = function(event)
    if vim.tbl_contains(filetypes_with_auto_folding, vim.bo[event.buf].filetype) then
      vim.cmd [[normal! zMzvzz]]
    end
  end,
})

RUtils.cmd.augroup("WindowDim", {
  event = { "BufRead" },
  pattern = { "*" },
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles", "codecompanion" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.buf_enter()
  end,
}, {
  event = { "BufEnter" },
  pattern = { "*" },
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles", "codecompanion" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.buf_enter()
  end,
}, {
  event = { "VimEnter", "FocusGained", "WinEnter" },
  pattern = "*",
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles", "codecompanion" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.focus_gained()
  end,
}, {
  event = { "FocusLost" },
  pattern = "*",
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles", "codecompanion" }, vim.bo.filetype) then
      return
    end
    RUtils.windowdim.focus_lost()
  end,
}, {
  event = { "WinLeave" },
  pattern = "*",
  command = function()
    if vim.tbl_contains({ "Avante", "AvanteInput", "AvanteSelectedFiles", "codecompanion" }, vim.bo.filetype) then
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
    (vim.hl or vim.highlight).on_yank {
      timeout = 200,
      on_visual = true,
      higroup = "IncSearch",
    }
  end,
})

RUtils.cmd.augroup("LocateLastPosition", {
  -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(event)
    local exclude = { "gitcommit", "Glance", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage", "qf" }
    local buf = event.buf
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

RUtils.cmd.augroup("OpenFileImages", {
  event = "BufEnter",
  pattern = { "*.png", "*.jpg" },
  command = function()
    vim.system { "sxiv", "-a", vim.fn.expand "%" }
  end,
}, {
  event = "BufEnter",
  pattern = { "*.mp4", "*.gif", "*.mp3" },
  command = function()
    vim.system { "mpv", vim.fn.expand "%" }
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
