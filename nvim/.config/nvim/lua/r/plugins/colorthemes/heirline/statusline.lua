local M = {}

local utils = require "heirline.utils"
local conditions = require "heirline.conditions"

local highlight = require "r.config.highlights"
local col_bg_default = highlight.get("Normal", "bg")
local col_fg_default = highlight.get("Comment", "fg")

-- local LeftSlantStart = {
--     provider = "",
--     hl = { fg = "bg", bg = "bg" },
-- }
-- local LeftSlantEnd = {
--     provider = "",
--     hl = { fg = "fg", bg = "bg" },
-- }
local RightSlantStart = {
  provider = "",
  hl = { fg = "fg", bg = "bg" },
}
local RightSlantEnd = {
  provider = "",
  hl = { fg = "bg", bg = "fg" },
}

---Return the current vim mode
M.VimMode = {
  condition = conditions.is_active,
  init = function(self)
    self.mode = vim.fn.mode(1)
    self.mode_color = self.mode_colors[self.mode:sub(1, 1)]
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd "redrawstatus"
    end),
  },
  static = {
    mode_names = {
      n = "NORMAL",
      no = "NORMAL",
      nov = "NORMAL",
      noV = "NORMAL",
      ["no\22"] = "NORMAL",
      niI = "NORMAL",
      niR = "NORMAL",
      niV = "NORMAL",
      nt = "NORMAL",
      v = "VISUAL",
      vs = "VISUAL",
      V = "VISUAL",
      Vs = "VISUAL",
      ["\22"] = "VISUAL",
      ["\22s"] = "VISUAL",
      s = "SELECT",
      S = "SELECT",
      ["\19"] = "SELECT",
      i = "INSERT",
      ic = "INSERT",
      ix = "INSERT",
      R = "REPLACE",
      Rc = "REPLACE",
      Rx = "REPLACE",
      Rv = "REPLACE",
      Rvc = "REPLACE",
      Rvx = "REPLACE",
      c = "COMMAND",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "TERM",
    },
    mode_colors = {
      n = "purple",
      i = "green",
      v = "orange",
      V = "orange",
      ["\22"] = "orange",
      c = "orange",
      s = "yellow",
      S = "yellow",
      ["\19"] = "yellow",
      r = "green",
      R = "green",
      ["!"] = "red",
      t = "red",
    },
  },
  {
    provider = function(self)
      return " %2(" .. self.mode_names[self.mode] .. "%) "
    end,
    hl = function()
      return { fg = col_fg_default, bg = col_bg_default }
    end,
    on_click = {
      callback = function()
        vim.cmd "Alpha"
      end,
      name = "heirline_mode",
    },
  },
  -- {
  --     provider = "",
  --     hl = function(self)
  --         return { fg = self.mode_color, bg = "bg" }
  --     end,
  -- },
}

---Return the current git branch in the cwd
M.GitBranch = {
  -- TODO GitBranch harus inactive ketika di inactive window
  condition = conditions.is_git_repo,
  init = function(self)
    ---@diagnostic disable-next-line: undefined-field
    self.status_dict = vim.b.gitsigns_status_dict
  end,
  {
    condition = function(self)
      return not conditions.buffer_matches {
        filetype = self.filetypes,
      }
    end,
    {
      provider = function(self)
        return "  " .. (self.status_dict.head == "" and "main" or self.status_dict.head) .. " "
      end,
      -- on_click = {
      --     callback = function()
      --         om.ListBranches()
      --     end,
      --     name = "git_change_branch",
      -- },
      -- hl = { fg = "gray", bg = "blue" },
      hl = { fg = col_fg_default, bg = col_bg_default },
    },
    {
      condition = function()
        return (_G.GitStatus ~= nil and (_G.GitStatus.ahead ~= 0 or _G.GitStatus.behind ~= 0))
      end,
      update = { "User", pattern = "GitStatusChanged" },
      {
        condition = function()
          return _G.GitStatus.status == "pending"
        end,
        provider = " ",
        hl = { fg = "gray", bg = "blue" },
      },
      {
        provider = function()
          return _G.GitStatus.behind .. " "
        end,
        hl = function()
          return {
            fg = _G.GitStatus.behind == 0 and "gray" or "red",
            bg = "blue",
          }
        end,
        -- on_click = {
        --     callback = function()
        --         if _G.GitStatus.behind > 0 then
        --             om.GitPull()
        --         end
        --     end,
        --     name = "git_pull",
        -- },
      },
      {
        provider = function()
          return _G.GitStatus.ahead .. " "
        end,
        hl = function()
          return {
            fg = _G.GitStatus.ahead == 0 and "gray" or "green",
            bg = "blue",
          }
        end,
        -- on_click = {
        --     callback = function()
        --         if _G.GitStatus.ahead > 0 then
        --             om.GitPush()
        --         end
        --     end,
        --     name = "git_push",
        -- },
      },
    },
    -- LeftSlantEnd,
  },
}

---Return the filename of the current buffer
local FileBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  condition = function(self)
    return not conditions.buffer_matches {
      filetype = self.filetypes,
    }
  end,
}

local FileName = {
  provider = function()
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    if filename == "" then
      return "[No Name]"
    end
    if not conditions.width_percent_below(#filename, 0.40) then
      filename = vim.fn.pathshorten(filename)
    end
    return " " .. filename .. " "
  end,
  on_click = {
    callback = function()
      vim.cmd "FzfLua files"
    end,
    name = "find_files",
  },
  hl = function()
    return { fg = col_fg_default, bg = col_bg_default }
  end,
}

local FileFlags = {
  provider = function()
    local modified = vim.bo[0].modified
    local nomodified = vim.bo[0].readonly

    local ft_modified = ""

    if modified then
      ft_modified = " ✘ "
    elseif nomodified then
      ft_modified = "  "
    else
      ft_modified = " "
    end
    return ft_modified
  end,
  hl = { fg = "red" },
}

M.FileNameBlock = utils.insert(FileBlock, FileName, FileFlags)

---Return the LspDiagnostics from the LSP servers
M.LspDiagnostics = {
  condition = conditions.has_diagnostics and conditions.is_active,
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  on_click = {
    callback = function()
      require("telescope.builtin").diagnostics {
        layout_strategy = "center",
        bufnr = 0,
      }
    end,
    name = "heirline_diagnostics",
  },
  update = { "DiagnosticChanged", "BufEnter" },
  -- Errors
  {
    condition = function(self)
      return self.errors > 0
    end,
    hl = { fg = "red", bg = "bg" },
    {
      {
        provider = function(self)
          return " " .. vim.fn.sign_getdefined("DiagnosticSignError")[1].text .. self.errors
        end,
      },
    },
  },
  -- Warnings
  {
    condition = function(self)
      return self.warnings > 0
    end,
    hl = { fg = "yellow", bg = "bg" },
    {
      {
        provider = function(self)
          return " " .. vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text .. self.warnings
        end,
      },
    },
  },
  -- Hints
  {
    condition = function(self)
      return self.hints > 0
    end,
    hl = { fg = "gray", bg = "bg" },
    {
      {
        provider = function(self)
          return " " .. vim.fn.sign_getdefined("DiagnosticSignHint")[1].text .. self.hints
        end,
      },
    },
  },
  -- Info
  {
    condition = function(self)
      return self.info > 0
    end,
    hl = { fg = "gray", bg = "bg" },
    {
      {
        provider = function(self)
          return " " .. vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text .. self.info
        end,
      },
    },
  },
}

M.LspAttached = {
  condition = conditions.lsp_attached and conditions.is_active,
  static = {
    lsp_attached = false,
    show_lsps = {
      copilot = false,
    },
  },
  init = function(self)
    for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      if self.show_lsps[server.name] ~= false then
        self.lsp_attached = true
        return
      end
    end
  end,
  update = { "LspAttach", "LspDetach" },
  on_click = {
    callback = function()
      vim.defer_fn(function()
        vim.cmd "LspInfo"
      end, 100)
    end,
    name = "heirline_LSP",
  },
  {
    condition = function(self)
      return self.lsp_attached
    end,
    {
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        local lsp_notif = table.concat(names, " ")

        -- if conditions.width_percent_below(#lsp_notif, 0.30) then
        --     return ""
        -- end
        return " [" .. lsp_notif .. "] "
      end,
      hl = { fg = col_fg_default, bg = col_bg_default },
    },
  },
}

---Return the current line number as a % of total lines and the total lines in the file
M.Ruler = {
  condition = function(self)
    return not conditions.buffer_matches {
      filetype = self.filetypes,
    }
  end,
  {
    -- %L = number of lines in the buffer
    -- %P = percentage through file of displayed window
    provider = function()
      local rhs = ""

      if vim.fn.winwidth(0) > 80 then
        local column = vim.fn.virtcol "."
        local width = vim.fn.virtcol "$"
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local height = vim.api.nvim_buf_line_count(0)

        -- Add padding to stop RHS from changing too much as we move the cursor.
        local padding = #tostring(height) - #tostring(line)
        if padding > 0 then
          rhs = rhs .. (" "):rep(padding)
        end

        rhs = rhs .. "ℓ " -- (Literal, \u2113 "SCRIPT SMALL L").
        rhs = rhs .. line
        rhs = rhs .. "/"
        rhs = rhs .. height
        rhs = rhs .. " 𝚌 " -- (Literal, \u1d68c "MATHEMATICAL MONOSPACE SMALL C").
        rhs = rhs .. column
        rhs = rhs .. "/"
        rhs = rhs .. width
        rhs = rhs .. " "

        -- Add padding to stop rhs from changing too much as we move the cursor.
        if #tostring(column) < 2 then
          rhs = rhs .. " "
        end
        if #tostring(width) < 2 then
          rhs = rhs .. " "
        end
        return rhs
      end
    end,
    hl = { fg = col_fg_default, bg = col_bg_default },
    on_click = {
      callback = function()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(0)

        if math.floor((line / total_lines)) > 0.5 then
          vim.cmd "normal! gg"
        else
          vim.cmd "normal! G"
        end
      end,
      name = "heirline_ruler",
    },
  },
}

M.Clock = {
  condition = conditions.is_active,
  {
    provider = function()
      return " " .. os.date "%H:%M"
    end,
    hl = { fg = col_fg_default, bg = col_bg_default },
  },
}

M.MacroRecording = {
  condition = function()
    return vim.fn.reg_recording() ~= ""
  end,
  update = {
    "RecordingEnter",
    "RecordingLeave",
  },
  {
    provider = "",
    hl = { fg = "blue", bg = "bg" },
  },
  {
    provider = function()
      return " " .. vim.fn.reg_recording() .. " "
    end,
    hl = { bg = "blue", fg = "bg" },
  },
  {
    provider = "",
    hl = { fg = "bg", bg = "blue" },
  },
}

M.SearchResults = {
  condition = function()
    return vim.v.hlsearch ~= 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  {
    provider = "",
    hl = function()
      return { fg = utils.get_highlight("Substitute").bg, bg = "bg" }
    end,
  },
  {
    provider = function(self)
      local search = self.search

      return string.format(" %d/%d ", search.current, math.min(search.total, search.maxcount))
    end,
    hl = function()
      return { bg = utils.get_highlight("Substitute").bg, fg = "bg" }
    end,
  },
  {
    provider = "",
    hl = function()
      return { bg = utils.get_highlight("Substitute").bg, fg = "bg" }
    end,
  },
}

---Return the status of the current session
M.Session = {
  update = { "User", pattern = "PersistedStateChange" },
  {
    condition = function(self)
      return not conditions.buffer_matches {
        filetype = self.filetypes,
      }
    end,
    RightSlantStart,
    {
      provider = function()
        if vim.g.persisting then
          return "   "
        else
          return "   "
        end
      end,
      hl = { fg = "gray", bg = "blue" },
      on_click = {
        callback = function()
          vim.cmd "SessionToggle"
        end,
        name = "toggle_session",
      },
    },
    RightSlantEnd,
  },
}

M.Overseer = {
  condition = function()
    local ok, _ = pcall(require, "overseer")
    if ok then
      return true
    end
  end,
  init = function(self)
    self.overseer = require "overseer"
    self.tasks = self.overseer.task_list
    self.STATUS = self.overseer.constants.STATUS
  end,
  static = {
    symbols = {
      ["FAILURE"] = "  ",
      ["CANCELED"] = "  ",
      ["SUCCESS"] = "  ",
      ["RUNNING"] = " 省",
    },
    colors = {
      ["FAILURE"] = "red",
      ["CANCELED"] = "gray",
      ["SUCCESS"] = "green",
      ["RUNNING"] = "yellow",
    },
  },
  {
    condition = function(self)
      return #self.tasks.list_tasks() > 0
    end,
    {
      provider = function(self)
        local tasks_by_status = self.overseer.util.tbl_group_by(self.tasks.list_tasks { unique = true }, "status")

        for _, status in ipairs(self.STATUS.values) do
          local status_tasks = tasks_by_status[status]
          if self.symbols[status] and status_tasks then
            self.color = self.colors[status]
            return self.symbols[status]
          end
        end
      end,
      hl = function(self)
        return { fg = self.color }
      end,
      on_click = {
        callback = function()
          require("neotest").run.run_last()
        end,
        name = "run_last_test",
      },
    },
  },
}

M.Dap = {
  condition = function()
    local session = require("dap").session()
    return session ~= nil
  end,
  provider = function()
    return "  "
  end,
  on_click = {
    callback = function()
      require("dap").continue()
    end,
    name = "dap_continue",
  },
  hl = { fg = "red" },
}

-- Show plugin updates available from lazy.nvim
M.Lazy = {
  condition = function(self)
    return not conditions.buffer_matches {
      filetype = self.filetypes,
    } and require("lazy.status").has_updates()
  end,
  provider = function()
    -- return "  " .. require("lazy.status").updates() .. " "
    return " " .. require("lazy.status").updates() .. " "
  end,
  on_click = {
    callback = function()
      require("lazy").update()
    end,
    name = "update_plugins",
  },
  hl = { fg = col_fg_default },
}

--- Return information on the current buffers filetype
local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (" " .. self.icon .. " ")
  end,
  on_click = {
    callback = function()
      vim.ui.input({ prompt = "Change filetype to: " }, function(new_ft)
        if new_ft ~= nil then
          vim.bo.filetype = new_ft
        end
      end)
    end,
    name = "change_ft",
  },
  hl = { fg = "gray", bg = "blue" },
}

local FileType = {
  provider = function()
    return string.lower(vim.bo.filetype) .. " "
  end,
  on_click = {
    callback = function()
      vim.ui.input({ prompt = "Change filetype to: " }, function(new_ft)
        if new_ft ~= nil then
          vim.bo.filetype = new_ft
        end
      end)
    end,
    name = "change_ft",
  },
  hl = { fg = col_fg_default, bg = col_bg_default },
}

M.FileType = utils.insert(FileIcon, FileType)

--- Return information on the current file's encoding
M.FileEncoding = {
  condition = function(self)
    return not conditions.buffer_matches {
      filetype = self.filetypes,
    }
  end,
  RightSlantStart,
  {
    provider = function()
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
      return " " .. enc .. " "
    end,
    hl = {
      fg = "gray",
      bg = "blue",
    },
  },
  RightSlantEnd,
}

return M
