-- Taken from Snacks plugins
local Snacks = require "snacks"
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(t)
    return t.get()
  end,
})

M.meta = {
  desc = "Pretty status column",
  needs_setup = true,
}

-- Numbers in Neovim are weird
-- They show when either number or relativenumber is true
local LINE_NR = "%=%{%(&number || &relativenumber) && v:virtnum == 0 ? ("
  .. (vim.fn.has "nvim-0.11" == 1 and '"%l"' or 'v:relnum == 0 ? (&number ? "%l" : "%r") : (&relativenumber ? "%r" : "%l")')
  .. ') : ""%} '

---@type (fun(buf:number, lnum:number, vnum:number, win:number):Sign[]?)[]
M.virtual = {}

---@alias Sign {name:string, text:string, texthl:string, priority:number}
---

local config = {
  left = { "mark", "sign" }, -- priority of signs on the left (high to low)
  right = { "fold", "git" }, -- priority of signs on the right (high to low)
  folds = {
    open = false, -- show open fold icons
    git_hl = false, -- use Git Signs hl for fold icons
  },
  git = {
    -- patterns to match Git signs
    patterns = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50, -- refresh at most every 50ms
}

-- Cache for signs per buffer and line
local sign_cache = {}
local cache = {} ---@type table<string,string>
local icon_cache = {} ---@type table<string,string>

local fold_icon = vim.opt.fillchars:get().foldclose or ""
-- local fold_icon = "⚡"
local text_strchars = 2

local did_setup = false

---@private
function M.setup()
  if did_setup then
    return
  end
  did_setup = true
  Snacks.util.set_hl({
    Mark = "DiagnosticHint",
  }, { prefix = "SnacksStatusColumn", default = true })
  local timer = assert((vim.uv or vim.loop).new_timer())
  timer:start(config.refresh, config.refresh, function()
    sign_cache = {}
    cache = {}
  end)
end

---@private
---@param name string
function M.is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end
end

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@private
---@return table<number, snacks.statuscolumn.Sign[]>
---@param buf number
function M.buf_signs(buf)
  -- Get regular signs
  ---@type Sign[]
  local signs = {}

  if vim.fn.has "nvim-0.10" == 0 then
    -- Only needed for Neovim <0.10
    -- Newer versions include legacy signs in nvim_buf_get_extmarks
    for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*" })[1].signs) do
      local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as snacks.statuscolumn.Sign]]
      if ret then
        ret.priority = sign.priority
        ret.type = M.is_git_sign(sign.name) and "git" or "sign"
        signs[sign.lnum] = signs[sign.lnum] or {}
        table.insert(signs[sign.lnum], ret)
      end
    end
  end

  -- Get extmark signs
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
  for _, extmark in pairs(extmarks) do
    local lnum = extmark[2] + 1
    signs[lnum] = signs[lnum] or {}
    local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
    table.insert(signs[lnum], {
      name = name,
      type = M.is_git_sign(name) and "git" or "sign",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    })
  end

  -- Add marks
  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.mark:match "[a-zA-Z]" then
      local lnum = mark.pos[2]
      signs[lnum] = signs[lnum] or {}
      table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "Boolean", type = "mark" })
    end
  end

  return signs
end

-- Returns a list of regular and extmark signs sorted by priority (high to low)
---@private
---@param win number
---@param buf number
---@param lnum number
function M.line_signs(win, buf, lnum)
  local buf_signs = sign_cache[buf]
  if not buf_signs then
    buf_signs = M.buf_signs(buf)
    sign_cache[buf] = buf_signs
  end
  local signs = buf_signs[lnum] or {}

  -- Get fold signs
  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(lnum) >= 0 then
      signs[#signs + 1] = { text = fold_icon, texthl = "FoldedSign", type = "fold" }
    elseif config.folds.open and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">" then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
    end
  end)

  -- Sort by priority
  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)
  return signs
end

---@private
function M.icon(sign)
  if not sign then
    return "  "
  end
  local key = (sign.text or "") .. (sign.texthl or "")
  if icon_cache[key] then
    return icon_cache[key]
  end
  local text = vim.fn.strcharpart(sign.text or "", 0, 2) ---@type string
  text = text .. string.rep(" ", text_strchars - vim.fn.strchars(text))
  icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
  return icon_cache[key]
end

---@return string
function M._get()
  if not did_setup then
    M.setup()
  end
  local win = vim.g.statusline_winid
  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
  local components = { "", LINE_NR, "" } -- left, middle, right

  if show_signs then
    local buf = vim.api.nvim_win_get_buf(win)
    local is_file = vim.bo[buf].buftype == ""
    local signs = M.line_signs(win, buf, vim.v.lnum)

    if #signs > 0 then
      local signs_by_type = {} ---@type table<snacks.statuscolumn.Sign.type,snacks.statuscolumn.Sign>
      for _, s in ipairs(signs) do
        signs_by_type[s.type] = signs_by_type[s.type] or s
      end

      ---@param types snacks.statuscolumn.Sign.type[]
      local function find(types)
        for _, t in ipairs(types) do
          if signs_by_type[t] then
            return signs_by_type[t]
          end
        end
      end

      local left_c = type(config.left) == "function" and config.left(win, buf, vim.v.lnum) or config.left --[[@as snacks.statuscolumn.Component[] ]]
      local right_c = type(config.right) == "function" and config.right(win, buf, vim.v.lnum) or config.right --[[@as snacks.statuscolumn.Component[] ]]
      local left, right = find(left_c), find(right_c)

      if config.folds.git_hl then
        local git = signs_by_type.git
        if git and left and left.type == "fold" then
          left.texthl = git.texthl
        end
        if git and right and right.type == "fold" then
          right.texthl = git.texthl
        end
      end
      components[1] = left and M.icon(left) or "  " -- left
      components[3] = is_file and (right and M.icon(right) or "  ") or "" -- right
    else
      components[1] = "  "
      components[3] = is_file and "  " or ""
    end
  end

  return table.concat(components, "")
end

function M.get()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  -- local key = ("%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum and 1 or 0)
  -- Dont draw sign for virtual lines
  -- https://github.com/folke/snacks.nvim/pull/511#issue-2790796444
  local key = ("%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum)
  if cache[key] then
    return cache[key]
  end
  local ok, ret = pcall(M._get)
  if ok then
    cache[key] = ret
    return ret
  end
  return ""
end

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    -- as long as we don't have a filetype, don't bother
    -- checking if treesitter is available (it won't)
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    if vim.bo[buf].filetype:find "dashboard" then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

function M.foldtext()
  -- local line = vim.fn.getline(vim.v.foldstart)
  -- local line_count = vim.v.foldend - vim.v.foldstart + 1
  -- return " ⚡ " .. line .. ": " .. line_count .. " lines"
  return vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1]
end

return M
