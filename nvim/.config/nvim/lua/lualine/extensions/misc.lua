local M = {}

local fmt, api = string.format, vim.api

local hg = require "r.settings.highlights"

-- local clock = function()
--     return " " .. os.date "%H:%M"
-- end

local toggle_number = 1

local function qflabel()
  return RUtils.qf.is_loclist() and "Location List" or "Quickfix List"
end

local function ft_()
  return vim.bo.filetype
end

local function title()
  if vim.bo.filetype ~= "qf" then
    return ""
  end

  if RUtils.qf.is_loclist()() then
    return vim.fn.getloclist(0, { title = 0 }).title
  end

  return fmt("%s %s", vim.fn.getqflist({ id = 0 }).id, vim.fn.getqflist({ title = 0 }).title)
end

local term_plugins = function()
  local ft_buf = api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
  if ft_buf == "toggleterm" then
    local terms = require "toggleterm.terminal"
    local count_term = terms.get_all()
    if #count_term > 0 then
      return fmt("   |  ﬑  %s/%s ", toggle_number, #count_term)
    end
  elseif ft_buf == "BufTerm" then
    return "bufterm"
  else
    return ""
  end
end

local function label()
  local ft = {
    ["NvimTree"] = "file Manager",
    ["Outline"] = "outline",
    ["TelescopePrompt"] = "telescope prompt",
    ["aerial"] = "aerial",
    ["alpha"] = "",
    ["fzf"] = "fzf",
    ["fugitive"] = "fugitive status",
    ["floggraph"] = "floggraph",
    ["Trouble"] = "trouble",
    ["neo-tree"] = "file Manager",
    ["qf"] = qflabel,
    ["toggleterm"] = term_plugins,
    ["BufTerm"] = term_plugins,
    ["undotree"] = "undotree",
    ["orgagenda"] = "orgagenda",
    ["OverseerList"] = "overseer list",
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
    -- { clock, color = { fg = "white", gui = "bold" } },
  },
  lualine_x = {
    {
      title,
      color = {
        fg = hg.get("Normal", "bg"),
        bg = hg.get("Title", "fg"),
        gui = "bold",
      },
    },
  },
}

M.inactive_sections = {
  lualine_c = {
    {
      label,
      color = {
        fg = hg.get("LineNr", "fg"),
        bg = hg.get("Normal", "bg"),
      },
    },
  },
  lualine_x = {
    {
      ft_,
      color = {
        fg = hg.get("LineNr", "fg"),
        bg = hg.get("Normal", "bg"),
      },
    },
  },
}

M.filetypes = {
  "BufTerm",
  "NvimTree",
  "Outline",
  "OverseerList",
  "TelescopePrompt",
  "Trouble",
  "aerial",
  "floaterm",
  "floggraph",
  "fugitive",
  "neo-tree",
  "orgagenda",
  "fzf",
  "qf",
  "quickfix",
  "toggleterm",
  "undotree",
}

return M
