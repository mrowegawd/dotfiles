local cmd = vim.cmd

local UtilAugroup = require("utils.map").augroup

-- ├──────────────────────────────────┤ LSP ├───────────────────────────────┤

UtilAugroup("LSPUserBehaviour", {
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
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and vim.tbl_contains({ "copilot", "obsidian-ls" }, client.name) then
      client:stop()

      -- Disable LSP keymap of obsidian
      -- https://github.com/orgs/obsidian-nvim/discussions/538#discussioncomment-15137065
      if client.name == "obsidian-ls" then
        client.server_capabilities.definitionProvider = true
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.implementationProvider = false
        client.server_capabilities.renameProvider = false

        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end
  end,
}, {
  event = "BufReadPre",
  pattern = {
    "*/node_modules/*",
    "*/.venv/*",
  },
  desc = "Disable inlay hint file patterns",
  command = function()
    local inlay_hint = vim.lsp.inlay_hint
    inlay_hint.enable(false, inlay_hint.get { bufnr = 0 })
  end,
})

-- ├─────────────────────────────┤ BUFFER MAPPING ├─────────────────────────────┤

UtilAugroup("SmartClose", {
  event = "FileType",
  pattern = {
    "DressingSelect",
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "filetree",
    "fugitive",
    "fugitiveblame",
    "gitsigns.blame",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "noice",
    "notify",
    -- "org",
    "qf",
    "query",
    "OverseerOutput",
    "snacks_notif",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  command = function(event)
    vim.bo[event.buf].buflisted = false
    if vim.api.nvim_buf_is_valid(event.buf) and (#vim.api.nvim_list_wins() > 1) then
      for _, x in pairs { "q", "<c-q>" } do
        vim.keymap.set("n", x, function()
          if vim.bo[event.buf].filetype == "qf" then
            local cmd_qf = "cclose"
            -- if RUtils.qf.is_loclist() then
            --   cmd_qf = "lclose"
            -- end
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

-- ├─────────────────────────────────┤ WINDOW ├─────────────────────────────────┤

local resize_window = { "orgagenda", "NeogitCommitMessage" }

UtilAugroup(
  "WindowBehaviour",
  {
    event = "FileType",
    pattern = {
      "NeogitCommitMessage",
      "NeogitPopup",
      "capture",
      "gitcommit",
      "orgagenda",
    },
    command = function()
      cmd "wincmd J"
      if vim.tbl_contains(resize_window, vim.bo[0].filetype) then
        cmd [[resize 20]]
      end
    end,
  },
  {
    event = "WinLeave",
    command = function()
      _G.LastWinId = vim.fn.win_getid()
    end,
    desc = "Only show cursorline in the current window and save last visited window id",
  },
  {
    event = "QuitPre",
    command = function()
      if vim.fn.getcmdwintype() ~= "" then
        return
      end

      if vim.bo.filetype == "qf" then
        return
      end

      vim.cmd "silent! lclose"
      vim.cmd "silent! cclose"
    end,
    desc = "Auto-close loclist and quickfix when quitting a window",
  },
  {
    event = { "QuitPre", "BufDelete" },
    command = function()
      if vim.fn.getcmdwintype() ~= "" then
        return
      end
      if vim.bo.filetype ~= "qf" then
        vim.cmd.lclose { mods = { silent = true } }
      end
    end,
    desc = "Auto-close loclist when quitting a window",
  },
  {
    event = "FileType",
    pattern = { "gitcommit", "NeogitCommitMessage", "orgagenda" },
    command = function()
      vim.opt_local.spell = true
      vim.opt_local.wrap = true
      vim.opt_local.spelllang = { "en_us", "id" }
      vim.opt_local.conceallevel = 2
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
    end,
  },
  {
    event = { "BufRead", "BufEnter" },
    pattern = "*",
    command = function(ctx)
      local buf = ctx.buf

      if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      local buftype = vim.bo[buf].buftype
      local filetype = vim.bo[buf].filetype

      if filetype == "codecompanion" then
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end

      if buftype ~= "terminal" and filetype ~= "gitcommit" and filetype ~= "OverseerList" then
        return
      end

      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = "no"
      end, 100)
    end,
  }
  --   {
  --   event = { "WinEnter", "BufEnter" },
  --   pattern = "*",
  --   command = function(ctx)
  --     local buf = ctx.buf
  --     if not buf or not vim.api.nvim_buf_is_valid(buf) then
  --       return
  --     end
  --
  --     local ft = vim.bo[buf].filetype
  --     if vim.tbl_contains({ "markdown", "org", "orgagenda" }, ft) then
  --       RUtils.notes.swith_note_mode(ft)
  --     end
  --   end,
  -- }
)

-- ├──────────────────────────────────┤ MISC ├──────────────────────────────────┤

UtilAugroup("DisableBigFiles", {
  event = "FileType",
  pattern = "bigfile",
  command = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or ""
    end)
  end,
})

UtilAugroup(
  "WrapFiletype",
  {
    event = "FileType",
    pattern = { "typescriptreact", "typescript" },
    command = function()
      vim.opt_local.wrap = true
    end,
  },
  -- {
  --
  --   event = "FileType",
  --   pattern = { "markdown", "orgagenda", "org" },
  --   command = function(ctx)
  --     vim.schedule(function()
  --       local buf = ctx.buf
  --       if not buf or not vim.api.nvim_buf_is_valid(buf) then
  --         return
  --       end
  --       RUtils.notes.swith_note_mode(vim.bo[buf].filetype)
  --       require("r.keymaps.note").note_mappings_ft(buf)
  --     end)
  --   end,
  -- },
  {
    event = "FileType",
    pattern = "lazy",
    command = function()
      local new_value = not vim.diagnostic.config().virtual_lines
      if not new_value then
        vim.diagnostic.config { virtual_lines = new_value }
      end
    end,
  }
)

UtilAugroup("DisableJsonConceal", {
  event = { "FileType" },
  pattern = { "json", "jsonc" },
  command = function()
    vim.opt_local.conceallevel = 0
  end,
})

UtilAugroup("TextYankHighlight", {
  event = { "TextYankPost" },
  command = function()
    vim.hl.hl_op { higroup = "Visual", timeout = 500 }
  end,
})

UtilAugroup("LocateLastPosition", { -- Go to last loc when opening a buffer
  event = { "BufReadPost" },
  command = function(event)
    local exclude = { "gitcommit", "Glance", "gitrebase", "svn", "hgcommit", "NeogitCommitMessage", "qf" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

UtilAugroup("CheckOutsideTime", {
  event = { "FocusGained", "BufEnter" },
  pattern = "*",
  command = function(event)
    if vim.bo[event.buf].buftype ~= "" then
      return
    end

    if vim.bo[event.buf].modified then
      return
    end

    if vim.api.nvim_buf_get_name(event.buf) == "" then
      return
    end

    vim.cmd.checktime {
      args = { event.buf },
      mods = { silent = true },
    }
  end,
})

-- To check error when quit from nvim, commented when you not using it
-- UtilAugroup("GetErrorMessageNvimWhenQuit", {
--   -- https://www.reddit.com/r/neovim/comments/10magvp/how_to_see_messages_that_are_displayed_when
--   event = "VimLeave",
--   pattern = "*",
--   command = function()
--     vim.cmd "redir! > /tmp/nvim_msgs.txt"
--   end,
-- })

-- ├──────────────────────────┤ OPEN IMAGE AND MEDIA ├──────────────────────────┤

local last_media_buf_opened

local function open_external(event, command)
  local buf = event.buf
  local file = vim.api.nvim_buf_get_name(buf)
  local win = vim.api.nvim_get_current_win()
  local previous = last_media_buf_opened

  if file == "" then
    return
  end

  vim.system { command, file }

  vim.schedule(function()
    if not vim.api.nvim_win_is_valid(win) then
      return
    end

    -- Restore the buffer that was active before opening
    -- the external file.
    if previous and vim.api.nvim_buf_is_valid(previous) then
      vim.api.nvim_win_set_buf(win, previous)
    else
      vim.cmd "enew"
    end

    -- Delete only the temporary image/video buffer.
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)
end

UtilAugroup("OpenFileImages", {
  event = "BufEnter",
  pattern = { "*.png", "*.jpg", "*.jpeg" },
  command = function(event)
    open_external(event, "sxiv")
  end,
}, {
  event = "BufEnter",
  pattern = { "*.mp4", "*.gif", "*.mp3" },
  command = function(event)
    open_external(event, "mpv")
  end,
})

UtilAugroup("TrackLastBuffer", {
  event = "BufLeave",
  pattern = "*",
  command = function(event)
    if vim.api.nvim_buf_is_valid(event.buf) then
      last_media_buf_opened = event.buf
    end
  end,
})

-- ├───────────────────────────────┤ COPY PASTE ├───────────────────────────────┤

UtilAugroup("SetNopaste", {
  event = { "InsertLeave" },
  pattern = "*",
  command = "set nopaste",
})

-- Copy/Paste when using ssh on a remote server
-- Only works on Neovim >= 0.10.0
if vim.clipboard and vim.clipboard.osc52 then
  UtilAugroup("SSH_clipboard", {
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
