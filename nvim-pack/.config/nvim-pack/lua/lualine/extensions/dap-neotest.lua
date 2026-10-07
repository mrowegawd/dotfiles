local M = {}

local fmt = string.format
local hg = require "r.settings.highlights"

local function title()
  if vim.bo.filetype ~= "qf" then
    return ""
  end

  if RUtils.qf.is_loclist() then
    return vim.fn.getloclist(0, { title = 0 }).title
  end

  return fmt("Id:%s Title:%s", vim.fn.getqflist({ id = 0 }).id, vim.fn.getqflist({ title = 0 }).title)
end

local function label()
  local ft = {
    ["dap-repl"] = "dap-repl",
    ["dapui_breakpoints"] = "dapui_breakpoints",
    ["dapui_console"] = "dapui_console",
    ["dapui_scopes"] = "dapui_scopes",
    ["dapui_stacks"] = "dapui_stacks",
    ["dapui_watches"] = "dapui_watches",
  }

  local set_label = ft[vim.bo.filetype]

  local fmt_string = ""
  if set_label then
    if type(set_label) == "function" then
      local cat_string = set_label()
      if type(cat_string) == "string" then
        fmt_string = cat_string
      end
    else
      -- vim.notify(set_label)
      fmt_string = set_label
    end
  end

  fmt_string = string.upper(fmt_string)

  return fmt_string
end

M.sections = {
  lualine_c = {
    {
      label,
      color = {
        bg = hg.get("Directory", "fg"),
        fg = hg.get("Normal", "bg"),
        gui = "bold",
      },
    },
    {
      title,
      color = {
        fg = hg.get("Normal", "bg"),
        bg = hg.get("Title", "fg"),
        gui = "bold",
      },
    },
    -- { clock, color = { fg = "white", gui = "bold" } },
  },
  lualine_x = {},
}

M.inactive_sections = {
  lualine_x = {},
  lualine_c = {
    {
      label,
      color = {
        fg = hg.get("LineNr", "fg"),
        bg = hg.get("Normal", "bg"),
      },
    },
  },
}

M.filetypes = {
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
}

return M
