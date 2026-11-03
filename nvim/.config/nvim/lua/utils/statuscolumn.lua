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

---@alias utils.statuscolumn.Component "mark"|"sign"|"fold"|"git"
---@alias utils.statuscolumn.Components utils.statuscolumn.Component[]|fun(win:number,buf:number,lnum:number):utils.statuscolumn.Component[]
---@alias utils.statuscolumn.Wanted table<utils.statuscolumn.Component, boolean>
---@alias utils.statuscolumn.Sign {
---  text?: string,
---  texthl?: string,
---  priority?: number,
---  order?: number,
---  type: utils.statuscolumn.Component }

---@class utils.statuscolumn.Config
---@field left utils.statuscolumn.Components
---@field right utils.statuscolumn.Components
---@field widths { left: integer, right: integer }
---@field folds { open: boolean, git_hl: boolean, hl: string, icons: { open: string, close: string }, disabled_filetypes: string[] }
---@field git { patterns: string[] }
local config = {
  -- Left column: git signs, kept separate from bookmarks and other signs.
  left = { "git" },
  -- Right column: fold, sign, and mark. Order determines which component wins a slot.
  right = { "fold", "sign", "mark" },
  -- Slot widths in display cells. Keep the left slot at 2 to fit wide icons like emoji.
  widths = { left = 1, right = 2 },

  folds = {
    open = false, -- Show an icon for open folds.
    git_hl = false, -- Use the git sign highlight for fold icons.
    hl = "FoldedSign",
    icons = { open = "", close = "" },
    disabled_filetypes = { "neo-tree", "alpha", "dashboard" },
  },

  git = {
    patterns = { "GitSign", "MiniDiffSign" },
  },
}

local CLICK = "%@v:lua.require'utils.statuscolumn'.click_fold@"
local GIT_ONLY = { "git" }

---@type table<number, table<number, utils.statuscolumn.Sign[]>>
local sign_cache = {} -- Cleared after the current redraw.
---@type { open: string, close: string }?
local fold_chars
---@type table<string, string>
local icon_cache = {}
---@type table<string, boolean>
local disabled_ft = {}
local wanted_cache = {}

local clear_scheduled = false
local error_reported = false

local function rebuild_disabled()
  disabled_ft = {}
  for _, ft in ipairs(config.folds.disabled_filetypes or {}) do
    disabled_ft[ft] = true
  end
end

rebuild_disabled()

---Clear redraw caches once the current redraw has finished.
local function schedule_clear()
  if clear_scheduled then
    return
  end

  clear_scheduled = true

  vim.schedule(function()
    sign_cache = {}
    fold_chars = nil
    clear_scheduled = false
  end)
end

---@param opts? table
function M.setup(opts)
  if not opts then
    return
  end

  -- Deep extend treats lists like maps, so replace list options explicitly.
  local left, right = opts.left, opts.right
  local patterns = opts.git and opts.git.patterns
  local disabled = opts.folds and opts.folds.disabled_filetypes

  config = vim.tbl_deep_extend("force", config, opts)

  if left then
    config.left = left
  end

  if right then
    config.right = right
  end

  if patterns then
    config.git.patterns = patterns
  end

  if disabled then
    config.folds.disabled_filetypes = disabled
  end

  icon_cache = {}
  rebuild_disabled()
end

---@param name string
---@return boolean
local function is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end

  return false
end

---Collect all signs and marks in a buffer (requires Neovim >= 0.10).
---@private
---@param buf number
---@return table<number, utils.statuscolumn.Sign[]>
function M.buf_signs(buf)
  local signs = {}
  local count = 0

  local function add(lnum, sign)
    if lnum < 1 then
      return
    end

    count = count + 1
    sign.order = count -- Preserve insertion order when priorities tie.

    local list = signs[lnum]

    if not list then
      list = {}
      signs[lnum] = list
    end

    list[#list + 1] = sign
  end

  -- Extmark signs, including git changes, diagnostics, and bookmarks.
  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, {
    details = true,
    type = "sign",
  })

  for _, extmark in ipairs(extmarks) do
    local details = extmark[4]

    -- Ignore signs without text; they only provide line or number highlights.
    if details and details.sign_text then
      local name = details.sign_hl_group or details.sign_name or ""

      add(extmark[2] + 1, {
        text = details.sign_text,
        texthl = details.sign_hl_group,
        priority = details.priority,
        type = is_git_sign(name) and "git" or "sign",
      })
    end
  end

  -- Local marks a-z. getmarklist(buf) reports pos[1] as 0, not the buffer number.
  for _, mark in ipairs(vim.fn.getmarklist(buf)) do
    local char = mark.mark:sub(2, 2)

    if char:match "%a" then
      add(mark.pos[2], { text = char, texthl = "Boolean", type = "mark" })
    end
  end

  -- Global marks A-Z that point to this buffer.
  for _, mark in ipairs(vim.fn.getmarklist()) do
    local char = mark.mark:sub(2, 2)

    if mark.pos[1] == buf and char:match "%a" then
      add(mark.pos[2], { text = char, texthl = "Boolean", type = "mark" })
    end
  end

  return signs
end

local function nonempty(s)
  return s ~= nil and s ~= "" and s or nil
end

local function get_fold_chars()
  if not fold_chars then
    local fc = vim.opt.fillchars:get() or {}
    local icons = config.folds.icons or {}

    fold_chars = {
      open = nonempty(icons.open) or nonempty(fc.foldopen) or "v",
      close = nonempty(icons.close) or nonempty(fc.foldclose) or ">",
    }

    schedule_clear()
  end

  return fold_chars
end

-- Reuse these locals to avoid allocating a table or closure for every line.
local f_lnum, f_level, f_closed, f_prev

local function read_fold()
  f_level, f_closed, f_prev = vim.fn.foldlevel(f_lnum), false, 0

  if f_level > 0 then
    f_closed = vim.fn.foldclosed(f_lnum) == f_lnum

    if not f_closed and config.folds.open and f_lnum > 1 then
      f_prev = vim.fn.foldlevel(f_lnum - 1)
    end
  end
end

---foldlevel() and foldclosed() use the current window, which may differ
---from the window being drawn. Read the fold state in the target window instead.
---@return number level, boolean closed, number previous_level
local function fold_state(win, lnum)
  f_lnum = lnum

  if win == vim.api.nvim_get_current_win() then
    read_fold()
  else
    vim.api.nvim_win_call(win, read_fold)
  end

  return f_level, f_closed, f_prev
end

---@private
---@param win number
---@param buf number
---@param lnum number
---@param wanted utils.statuscolumn.Wanted
---@param can_signs boolean
---@param can_folds boolean
---@return utils.statuscolumn.Sign[]
function M.line_signs(win, buf, lnum, wanted, can_signs, can_folds)
  local signs = {}

  if can_signs then
    local buf_signs = sign_cache[buf]

    if not buf_signs then
      buf_signs = M.buf_signs(buf)
      sign_cache[buf] = buf_signs
      schedule_clear()
    end

    local list = buf_signs[lnum]

    if list then
      for i = 1, #list do
        local sign = list[i]

        if wanted[sign.type] then
          signs[#signs + 1] = sign
        end
      end
    end
  end

  if can_folds and wanted.fold and lnum > 0 then
    local level, closed, previous = fold_state(win, lnum)

    if level > 0 then
      local chars = get_fold_chars()
      local text

      if closed then
        text = chars.close
      elseif config.folds.open and level > previous then
        text = chars.open
      end

      if text and text ~= "" then
        signs[#signs + 1] = { text = text, texthl = config.folds.hl, type = "fold", priority = 10 }
      end
    end
  end

  if #signs > 1 then
    table.sort(signs, function(a, b)
      local pa, pb = a.priority or 0, b.priority or 0

      if pa ~= pb then
        return pa > pb
      end

      return (a.order or 0) < (b.order or 0)
    end)
  end

  return signs
end

---Render a sign within exactly `w` display cells.
---@private
---@param sign? utils.statuscolumn.Sign
---@param w integer
---@return string
function M.icon(sign, w)
  if not sign then
    return string.rep(" ", w)
  end

  local text = sign.text or ""
  local texthl = sign.texthl or ""
  local key = text .. "\0" .. texthl .. "\0" .. w
  local cached = icon_cache[key]

  if cached then
    return cached
  end

  local cells = vim.fn.strdisplaywidth(text)

  while cells > w do
    text = vim.fn.strcharpart(text, 0, vim.fn.strchars(text) - 1)
    cells = vim.fn.strdisplaywidth(text)
  end

  if cells < w then
    text = text .. string.rep(" ", w - cells)
  end

  text = (text:gsub("%%", "%%%%")) -- Escape '%' for statusline formatting.

  local icon = texthl ~= "" and ("%#" .. texthl .. "#" .. text .. "%*") or text

  icon_cache[key] = icon

  return icon
end

local function resolve(components, win, buf, lnum)
  if type(components) == "function" then
    return components(win, buf, lnum)
  end

  return components
end

---Build and cache the set of wanted component types for the current lists.
local function get_wanted(left_c, right_c)
  local c = wanted_cache

  if c.left ~= left_c or c.right ~= right_c then
    local wanted = {}

    for _, component in ipairs(left_c) do
      wanted[component] = true
    end

    for _, component in ipairs(right_c) do
      wanted[component] = true
    end

    c.left, c.right, c.wanted = left_c, right_c, wanted
  end

  return c.wanted
end

---Pick the highest-priority sign matching the component order.
local function pick(types, signs)
  for _, component in ipairs(types) do
    for i = 1, #signs do
      if signs[i].type == component then
        return signs[i]
      end
    end
  end
end

---Leave unused slots empty instead of reserving their width.
local function slot(list, sign, width)
  if #list == 0 then
    return ""
  end

  return M.icon(sign, width)
end

---@private
---@param win number
---@return string
function M._get(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local wo = vim.wo[win]

  local nu, rnu = wo.number, wo.relativenumber
  local lnum, virtnum = vim.v.lnum, vim.v.virtnum
  local normal = vim.bo[buf].buftype == ""

  -- Only render signs and folds where the window supports them.
  -- Wrapped and virtual lines get padding instead of signs or line numbers.
  local can_signs = normal and wo.signcolumn ~= "no"
  local can_folds = normal and not disabled_ft[vim.bo[buf].filetype]

  if not (can_signs or can_folds or nu or rnu) then
    return ""
  end

  -- Calculate the number width explicitly so columns stay aligned across windows.
  local number = ""

  if nu or rnu then
    local digits = math.max(wo.numberwidth - 1, #tostring(vim.api.nvim_buf_line_count(buf)))

    if virtnum == 0 then
      local num = lnum

      if rnu and not (nu and vim.v.relnum == 0) then
        num = vim.v.relnum
      end

      number = string.format("%" .. digits .. "d", num)
    else
      number = string.rep(" ", digits)
    end
  end

  local signs_part = ""

  if can_signs or can_folds then
    local left_c = resolve(config.left, win, buf, lnum)
    local right_c = resolve(config.right, win, buf, lnum)
    local left, right

    if virtnum == 0 then
      local signs = M.line_signs(win, buf, lnum, get_wanted(left_c, right_c), can_signs, can_folds)

      left, right = pick(left_c, signs), pick(right_c, signs)

      if config.folds.git_hl then
        local git = pick(GIT_ONLY, signs)

        if git then
          -- Copy the fold sign before changing its highlight.
          if left and left.type == "fold" then
            left = vim.tbl_extend("force", left, { texthl = git.texthl })
          end

          if right and right.type == "fold" then
            right = vim.tbl_extend("force", right, { texthl = git.texthl })
          end
        end
      end
    end

    signs_part = slot(left_c, left, config.widths.left) .. slot(right_c, right, config.widths.right)
  end

  return CLICK .. signs_part .. number .. " %T"
end

---@return string
function M.get()
  local win = vim.g.statusline_winid

  if not win or not vim.api.nvim_win_is_valid(win) then
    return ""
  end

  local ok, ret = pcall(M._get, win)

  if ok then
    return ret
  end

  -- Report the first error instead of silently swallowing it.
  if not error_reported then
    error_reported = true

    vim.schedule(function()
      vim.notify("statuscolumn error: " .. tostring(ret), vim.log.levels.ERROR)
    end)
  end

  return ""
end

function M.click_fold()
  local pos = vim.fn.getmousepos()

  if not pos.winid or pos.winid == 0 or pos.line == 0 or not vim.api.nvim_win_is_valid(pos.winid) then
    return
  end

  if pos.line > vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(pos.winid)) then
    return
  end

  vim.api.nvim_win_call(pos.winid, function()
    vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 0 })

    if vim.fn.foldlevel(pos.line) > 0 then
      ---@diagnostic disable-next-line: param-type-mismatch
      pcall(vim.cmd, "normal! za")
    end
  end)
end

return M
