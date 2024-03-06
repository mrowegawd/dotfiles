local M = {}

local fcs = vim.opt.fillchars:get()
local v = vim.v

local space, big_spaces = " ", ""
local separator = "│"

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
  -- Get regular signs
  ---@type Sign[]
  local signs = {}

  if vim.fn.has "nvim-0.10" == 0 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as Sign]]
      if ret then
        ret.priority = sign.priority
        signs[#signs + 1] = ret
      end
    end
  end

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
      return { text = mark.mark:sub(2), texthl = "MyMark" }
    end
  end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len, spaces)
  spaces = spaces or " "
  sign = sign or {}
  len = len or 2
  local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
  text = text .. string.rep(spaces, len - vim.fn.strchars(text))
  return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)

  local line_count = vim.v.foldend - vim.v.foldstart + 1

  return " ⚡ " .. line .. ": " .. line_count .. " lines"
end

function M.statuscolumn()
  -- local lnum, relnum, virtnum = v.lnum, v.relnum, v.virtnum
  local lnum = v.lnum
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""
  local show_signs = vim.wo[win].signcolumn ~= "no"

  local height = vim.api.nvim_buf_line_count(0)
  local totalSpaces = #tostring(height)
  big_spaces = string.rep(" ", totalSpaces)

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
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
        fold = { text = space, texthl = "FoldColumn" }
      else
        fold = { text = vim.fn.foldclosed(lnum) == -1 and fcs.foldopen or fcs.foldclose, texthl = "FoldColumn" }
      end
    end)

    -- Left: mark or non-git sign
    components[1] = " "

    -- Right: number or fold
    components[2] = is_file and M.icon(left or right) or big_spaces .. " "

    if not vim.tbl_contains({ "norg", "markdown", "gitcommit" }, vim.bo.filetype) then
      components[4] = M.icon({ text = separator, texthl = "MySeparator" }, 1, big_spaces)
      -- components[5] = M.icon(M.get_mark(buf, vim.v.lnum) or fold) or big_spaces
    else
      components[4] = " "
      -- components[5] = " "
    end
    components[5] = M.icon(fold) or big_spaces
  end

  -- Numbers in Neovim are weird
  -- They show when either number or relativenumber is true
  local is_num = vim.wo[win].number
  local is_relnum = vim.wo[win].relativenumber
  if is_num and is_relnum then
    if vim.v.virtnum > 0 then
      -- components[3] = ("%="):rep(math.floor(math.ceil(math.log10(vim.v.lnum))))
      components[3] = ("%="):rep(math.floor(math.ceil(math.log10(vim.v.lnum)))) .. separator .. " "
    elseif v.virtnum < 0 then
      if not vim.tbl_contains({ "norg", "org", "markdown", "octo" }, vim.bo.filetype) then
        components[3] = "%=" .. separator .. " "
      end
    else
      components[3] = '%=%{v:relnum?(v:virtnum>0?"":v:relnum):v:lnum} '
    end
  elseif is_num and not is_relnum then
    components[3] = '%=%{v:virtnum>0?"":v:lnum} '
    -- components[3] = ("%="):rep(math.floor(math.ceil(math.log10(vim.v.lnum)))) .. separator .. " "
  elseif is_relnum and not is_num then
    components[3] = '%=%{v:virtnum>0?"":v:relnum} '
    -- components[3] = ("%="):rep(math.floor(math.ceil(math.log10(vim.v.lnum)))) .. separator .. " "
  else
    components[3] = ""
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

M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.loop.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then
    return "0"
  end

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= "" then
    return "0"
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

return M
