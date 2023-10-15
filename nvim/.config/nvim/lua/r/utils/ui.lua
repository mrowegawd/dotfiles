local M = {}

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
  -- Get regular signs
  ---@type Sign[]
  local signs = vim.tbl_map(function(sign)
    ---@type Sign
    local ret = vim.fn.sign_getdefined(sign.name)[1]
    ret.priority = sign.priority
    return ret
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs)

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { lnum - 1, 0 },
    { lnum - 1, -1 },
    { details = true, type = "sign" }
  )
  for _, extmark in pairs(extmarks) do
    signs[#signs + 1] = {
      name = extmark[4].sign_hl_group or "",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    }
  end

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) < (b.priority or 0)
  end)

  return signs
end

---@return Sign?
---@param buf number
---@param lnum number
function M.get_mark(buf, lnum)
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match "[a-zA-Z]" then
      return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
    end
  end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(" ", len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

function M.foldtext()
  local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
  local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
  if not ret or type(ret) == "string" then
    ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
  end
  table.insert(ret, { " " .. require("r.config").icons.misc.dots })

  if not vim.treesitter.foldtext then
    return table.concat(
      vim.tbl_map(function(line)
        return line[1]
      end, ret),
      " "
    )
  end
  return ret
end

function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local components = { "", "", "" } -- left, middle, right

  if show_signs then
    ---@type Sign?,Sign?,Sign?
    local left, right, fold
    for _, s in ipairs(M.get_signs(buf, vim.v.lnum)) do
      if s.name and s.name:find "GitSign" then
        right = s
      else
        left = s
      end
    end
    if vim.v.virtnum ~= 0 then
      left = nil
    end
    vim.api.nvim_win_call(win, function()
      if vim.fn.foldclosed(vim.v.lnum) >= 0 then
        fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded" }
      end
    end)
    -- Left: mark or non-git sign
    components[1] = M.icon(M.get_mark(buf, vim.v.lnum) or left)
    -- Right: fold icon or git sign (only if file)
    components[3] = is_file and M.icon(fold or right) or ""
  end

  -- Numbers in Neovim are weird
  -- They show when either number or relativenumber is true
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if (is_num or is_relnum) and vim.v.virtnum == 0 then
    if vim.v.relnum == 0 then
      components[2] = is_num and "%l" or "%r" -- the current line
    else
      components[2] = is_relnum and "%r" or "%l" -- other lines
    end
    components[2] = "%=" .. components[2] .. " " -- right align
  end

  return table.concat(components, "")
end

function M.fg(name)
  ---@type {foreground?:number}?
  ---@diagnostic disable-next-line: deprecated
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  ---@diagnostic disable-next-line: undefined-field
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

--- =================================

-- ---@class Decorations
-- local Preset = {}

-- ---@param o Decorations
-- function Preset:new(o)
--   assert(o, "a preset must be defined")
--   self.__index = self
--   return setmetatable(o, self)
-- end

-- --- WARNING: deep extend does not copy lua meta methods
-- function Preset:with(o)
--   return vim.tbl_deep_extend("force", self, o)
-- end

-- local presets = {
--   statusline_only = Preset:new {
--     number = false,
--     winbar = false,
--     colorcolumn = false,
--     statusline = true,
--     statuscolumn = false,
--   },
--   minimal_editing = Preset:new {
--     number = false,
--     winbar = true,
--     colorcolumn = false,
--     statusline = "minimal",
--     statuscolumn = false,
--   },
--   tool_panel = Preset:new {
--     number = false,
--     winbar = false,
--     colorcolumn = false,
--     statusline = "minimal",
--     statuscolumn = false,
--   },
--   statuscolumn_only = Preset:new {
--     statuscolumn = false,
--   },
--   statusspecial = Preset:new {
--     statuscolumn = false,
--     foldcolumn = "0",
--   },
-- }

-- local commit_buffer = presets.minimal_editing:with { colorcolumn = "50,72", winbar = false }

-- local buftypes = {
--   ["quickfix"] = presets.tool_panel,
--   ["nofile"] = presets.tool_panel,
--   ["nowrite"] = presets.tool_panel,
--   ["acwrite"] = presets.tool_panel,
--   ["terminal"] = presets.tool_panel,
-- }

-- --- When searching through the filetypes table if a match can't be found then search
-- --- again but check if there is matching lua pattern. This is useful for filetypes for
-- --- plugins like Neogit which have a filetype of Neogit<something>.
-- local filetypes = Util.cmd.p_table {
--   ["startuptime"] = presets.tool_panel,
--   ["checkhealth"] = presets.tool_panel,
--   ["log"] = presets.tool_panel,
--   ["outline"] = presets.statuscolumn_only,
--   ["aerial"] = presets.statuscolumn_only,
--   ["sagaoutline"] = presets.statusspecial,
--   ["help"] = presets.tool_panel,
--   ["^copilot.*"] = presets.tool_panel,
--   ["dapui"] = presets.tool_panel,
--   ["minimap"] = presets.tool_panel,
--   ["Trouble"] = presets.tool_panel,
--   ["tsplayground"] = presets.tool_panel,
--   ["list"] = presets.tool_panel,
--   ["netrw"] = presets.tool_panel,
--   ["flutter.*"] = presets.tool_panel,
--   ["NvimTree"] = presets.tool_panel,
--   ["undotree"] = presets.tool_panel,
--   ["dap-repl"] = presets.tool_panel:with { winbar = "ignore" },
--   ["neo-tree"] = presets.tool_panel:with { winbar = "ignore" },
--   ["toggleterm"] = presets.tool_panel:with { winbar = "ignore" },
--   ["neotest.*"] = presets.tool_panel,
--   ["^Neogit.*"] = presets.tool_panel,
--   ["query"] = presets.tool_panel,
--   ["DiffviewFiles"] = presets.tool_panel,
--   ["DiffviewFileHistory"] = presets.tool_panel,
--   ["mail"] = presets.statusline_only,
--   ["noice"] = presets.statusline_only,
--   ["diff"] = presets.statusline_only,
--   ["qf"] = presets.statusline_only,
--   ["alpha"] = presets.tool_panel:with { statusline = false },
--   ["fugitive"] = presets.statusline_only,
--   ["startify"] = presets.statusline_only,
--   ["man"] = presets.minimal_editing,
--   ["org"] = presets.statuscolumn_only,
--   ["norg"] = presets.statuscolumn_only,
--   ["markdown"] = presets.statuscolumn_only,
--   ["himalaya"] = presets.minimal_editing,
--   ["orgagenda"] = presets.minimal_editing,
--   ["gitcommit"] = commit_buffer,
--   ["NeogitCommitMessage"] = commit_buffer,
-- }

-- local filenames = Util.cmd.p_table {
--   ["option-window"] = presets.tool_panel,
-- }

-- function M.decoration_get(opts)
--   local ft, bt, fname, setting = opts.ft, opts.bt, opts.fname, opts.setting
--   if (not ft and not bt and not fname) or not setting then
--     return nil
--   end
--   return {
--     ft = ft and filetypes[ft] and filetypes[ft][setting],
--     bt = bt and buftypes[bt] and buftypes[bt][setting],
--     fname = fname and filenames[fname] and filenames[fname][setting],
--   }
-- end

return M
