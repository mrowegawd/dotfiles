local Util = require "r.utils"

local M = {}

---@class Decorations
local Preset = {}

---@param o Decorations
function Preset:new(o)
  assert(o, "a preset must be defined")
  self.__index = self
  return setmetatable(o, self)
end

--- WARNING: deep extend does not copy lua meta methods
function Preset:with(o)
  return vim.tbl_deep_extend("force", self, o)
end

local presets = {
  statusline_only = Preset:new {
    number = false,
    winbar = false,
    colorcolumn = false,
    statusline = true,
    statuscolumn = false,
  },
  minimal_editing = Preset:new {
    number = false,
    winbar = true,
    colorcolumn = false,
    statusline = "minimal",
    statuscolumn = false,
  },
  tool_panel = Preset:new {
    number = false,
    winbar = false,
    colorcolumn = false,
    statusline = "minimal",
    statuscolumn = false,
  },
  statuscolumn_only = Preset:new {
    statuscolumn = false,
  },
  statusspecial = Preset:new {
    statuscolumn = false,
    foldcolumn = "0",
  },
}

local commit_buffer = presets.minimal_editing:with { colorcolumn = "50,72", winbar = false }

local buftypes = {
  ["quickfix"] = presets.tool_panel,
  ["nofile"] = presets.tool_panel,
  ["nowrite"] = presets.tool_panel,
  ["acwrite"] = presets.tool_panel,
  ["terminal"] = presets.tool_panel,
}

--- When searching through the filetypes table if a match can't be found then search
--- again but check if there is matching lua pattern. This is useful for filetypes for
--- plugins like Neogit which have a filetype of Neogit<something>.
local filetypes = Util.cmd.p_table {
  ["startuptime"] = presets.tool_panel,
  ["checkhealth"] = presets.tool_panel,
  ["log"] = presets.tool_panel,
  ["outline"] = presets.statuscolumn_only,
  ["aerial"] = presets.statuscolumn_only,
  ["sagaoutline"] = presets.statusspecial,
  ["help"] = presets.tool_panel,
  ["^copilot.*"] = presets.tool_panel,
  ["dapui"] = presets.tool_panel,
  ["minimap"] = presets.tool_panel,
  ["Trouble"] = presets.tool_panel,
  ["tsplayground"] = presets.tool_panel,
  ["list"] = presets.tool_panel,
  ["netrw"] = presets.tool_panel,
  ["flutter.*"] = presets.tool_panel,
  ["NvimTree"] = presets.tool_panel,
  ["undotree"] = presets.tool_panel,
  ["dap-repl"] = presets.tool_panel:with { winbar = "ignore" },
  ["neo-tree"] = presets.tool_panel:with { winbar = "ignore" },
  ["toggleterm"] = presets.tool_panel:with { winbar = "ignore" },
  ["neotest.*"] = presets.tool_panel,
  ["^Neogit.*"] = presets.tool_panel,
  ["query"] = presets.tool_panel,
  ["DiffviewFiles"] = presets.tool_panel,
  ["DiffviewFileHistory"] = presets.tool_panel,
  ["mail"] = presets.statusline_only,
  ["noice"] = presets.statusline_only,
  ["diff"] = presets.statusline_only,
  ["qf"] = presets.statusline_only,
  ["alpha"] = presets.tool_panel:with { statusline = false },
  ["fugitive"] = presets.statusline_only,
  ["startify"] = presets.statusline_only,
  ["man"] = presets.minimal_editing,
  ["org"] = presets.statuscolumn_only,
  ["norg"] = presets.statuscolumn_only,
  ["markdown"] = presets.statuscolumn_only,
  ["himalaya"] = presets.minimal_editing,
  ["orgagenda"] = presets.minimal_editing,
  ["gitcommit"] = commit_buffer,
  ["NeogitCommitMessage"] = commit_buffer,
}

local filenames = Util.cmd.p_table {
  ["option-window"] = presets.tool_panel,
}

M.decorations = {}

function M.decoration_get(opts)
  local ft, bt, fname, setting = opts.ft, opts.bt, opts.fname, opts.setting
  if (not ft and not bt and not fname) or not setting then
    return nil
  end
  return {
    ft = ft and filetypes[ft] and filetypes[ft][setting],
    bt = bt and buftypes[bt] and buftypes[bt][setting],
    fname = fname and filenames[fname] and filenames[fname][setting],
  }
end

function M.decorations_set_colorcolumn(bufnr, fn)
  local buf = vim.bo[bufnr]
  local decor = M.decoration_get {
    ft = buf.ft,
    bt = buf.bt,
    setting = "colorcolumn",
  }
  if decor ~= nil then
    if buf.ft == "" or buf.bt ~= "" or decor.ft == false or decor.bt == false then
      return
    end
    local ccol = decor.ft or decor.bt or ""
    local virtcolumn = not Util.cmd.falsy(ccol) and ccol or "+1"
    if vim.is_callable(fn) then
      fn(virtcolumn)
    end
  end
end

return M
