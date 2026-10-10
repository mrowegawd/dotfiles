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

---@class utils.statuscolumn.FoldInfo
---@field start number Line number where deepest fold starts
---@field level number Fold level, when zero other fields are N/A
---@field llevel number Lowest level that starts in v:lnum
---@field lines number Number of lines from v:lnum to end of closed fold

---@type ffi.namespace*
local C

local function _ffi()
  if C then
    return C
  end

  local ffi = require "ffi"

  ffi.cdef [[
    typedef struct {} Error;
    typedef struct {} win_T;

    typedef struct {
      int start;
      int level;
      int llevel;
      int lines;
    } foldinfo_T;

    foldinfo_T fold_info(win_T* wp, int lnum);
    win_T *find_window_by_handle(int Window, Error *err);
  ]]

  C = ffi.C
  return C
end

---@param win number
---@param lnum number
---@return utils.statuscolumn.FoldInfo?
local function fold_info(win, lnum)
  local ok, ffi = pcall(require, "ffi")
  if not ok then
    return
  end

  local ok_c, c = pcall(_ffi)
  if not ok_c or not c then
    return
  end

  local err = ffi.new "Error"
  local wp = c.find_window_by_handle(win, err)

  if wp == nil then
    return
  end

  return c.fold_info(wp, lnum)
end

---@alias utils.statuscolumn.Component "mark"|"sign"|"fold"|"git"
---@alias utils.statuscolumn.Components utils.statuscolumn.Component[]|fun(win:number,buf:number,lnum:number):utils.statuscolumn.Component[]
---@alias utils.statuscolumn.Wanted table<utils.statuscolumn.Component, boolean>

---@class utils.statuscolumn.Config
---@field left utils.statuscolumn.Components
---@field right utils.statuscolumn.Components
---@field enabled? boolean
local config = {
  left = { "mark", "sign" },
  right = { "fold", "git" },

  folds = {
    open = false,
    git_hl = false,
  },

  git = {
    patterns = {
      "GitSign",
      "MiniDiffSign",
    },
  },

  refresh = 50,
}

---@private
---@alias utils.statuscolumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias utils.statuscolumn.Sign {
---  name?: string,
---  text?: string,
---  texthl?: string,
---  priority?: number,
---  type: utils.statuscolumn.Sign.type }

---@type table<number, table<number, utils.statuscolumn.Sign[]>>
local sign_cache = {}

---@type table<string, string>
local cache = {}

---@type table<string, string>
local icon_cache = {}

local did_setup = false

---@private
function M.setup()
  if did_setup then
    return
  end

  did_setup = true

  local timer = assert((vim.uv or vim.loop).new_timer())

  timer:start(config.refresh, config.refresh, function()
    sign_cache = {}
    cache = {}
  end)
end

---@private
---@param name string
---@return boolean
function M.is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end

  return false
end

---Get all signs for a buffer.
---@private
---@param buf number
---@param wanted utils.statuscolumn.Wanted
---@return table<number, utils.statuscolumn.Sign[]>
function M.buf_signs(buf, wanted)
  ---@type table<number, utils.statuscolumn.Sign[]>
  local signs = {}

  ---@param lnum number
  ---@param sign utils.statuscolumn.Sign
  local function add(lnum, sign)
    if not wanted[sign.type] then
      return
    end

    signs[lnum] = signs[lnum] or {}
    signs[lnum][#signs[lnum] + 1] = sign
  end

  -- Legacy signs.
  if wanted.git or wanted.sign then
    if vim.fn.has "nvim-0.10" == 0 then
      for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*" })[1].signs) do
        local defined = vim.fn.sign_getdefined(sign.name)[1]

        if defined then
          local type = M.is_git_sign(sign.name) and "git" or "sign"

          add(sign.lnum, {
            name = sign.name,
            text = defined.text,
            texthl = defined.texthl,
            priority = sign.priority,
            type = type,
          })
        end
      end
    end

    -- Extmark signs.
    local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, {
      details = true,
      type = "sign",
    })

    for _, extmark in ipairs(extmarks) do
      local lnum = extmark[2] + 1
      local details = extmark[4]

      if details then
        local name = details.sign_hl_group or details.sign_name or ""

        local type = M.is_git_sign(name) and "git" or "sign"

        add(lnum, {
          name = name,
          text = details.sign_text,
          texthl = details.sign_hl_group,
          priority = details.priority,
          type = type,
        })
      end
    end
  end

  -- Marks.
  if wanted.mark then
    local marks = vim.fn.getmarklist(buf)
    vim.list_extend(marks, vim.fn.getmarklist())

    for _, mark in ipairs(marks) do
      if mark.pos[1] == buf and mark.mark:match "[a-zA-Z]" then
        add(mark.pos[2], {
          text = mark.mark:sub(2),
          texthl = "Boolean",
          type = "mark",
        })
      end
    end
  end

  return signs
end

---@private
---@param win number
---@param buf number
---@param lnum number
---@param wanted utils.statuscolumn.Wanted
---@return utils.statuscolumn.Sign[]
function M.line_signs(win, buf, lnum, wanted)
  local buf_signs = sign_cache[buf]

  if not buf_signs then
    buf_signs = M.buf_signs(buf, wanted)
    sign_cache[buf] = buf_signs
  end

  -- IMPORTANT:
  -- Never modify the cached table directly.
  local signs = vim.list_extend({}, buf_signs[lnum] or {})

  -- Fold sign.
  if wanted.fold then
    local info = fold_info(win, lnum)

    if info and info.level > 0 then
      if info.lines > 0 then
        signs[#signs + 1] = {
          text = vim.opt.fillchars:get().foldclose or "",
          texthl = "FoldedSign",
          type = "fold",
        }
      elseif config.folds.open and info.start == lnum then
        signs[#signs + 1] = {
          text = vim.opt.fillchars:get().foldopen or "",
          texthl = "FoldedSign",
          type = "fold",
        }
      end
    end
  end

  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)

  return signs
end

---@private
---@param sign? utils.statuscolumn.Sign
---@return string
function M.icon(sign)
  if not sign then
    return "  "
  end

  local text = sign.text or ""
  local texthl = sign.texthl or ""

  local key = text .. "\0" .. texthl

  if icon_cache[key] then
    return icon_cache[key]
  end

  text = vim.fn.strcharpart(text, 0, 2)

  local width = vim.fn.strchars(text)

  if width < 2 then
    text = text .. string.rep(" ", 2 - width)
  end

  local icon = texthl ~= "" and ("%#" .. texthl .. "#" .. text .. "%*") or text

  icon_cache[key] = icon

  return icon
end

---@param components utils.statuscolumn.Components
---@param win number
---@param buf number
---@param lnum number
---@return utils.statuscolumn.Component[]
local function resolve_components(components, win, buf, lnum)
  if type(components) == "function" then
    return components(win, buf, lnum)
  end

  return components
end

---@return string
function M._get()
  if not did_setup then
    M.setup()
  end

  local win = vim.g.statusline_winid

  if not win or not vim.api.nvim_win_is_valid(win) then
    return ""
  end

  local buf = vim.api.nvim_win_get_buf(win)

  local nu = vim.wo[win].number
  local rnu = vim.wo[win].relativenumber

  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"

  local show_folds = vim.v.virtnum == 0 and vim.wo[win].foldcolumn ~= "0"

  local left_c = resolve_components(config.left, win, buf, vim.v.lnum)

  local right_c = resolve_components(config.right, win, buf, vim.v.lnum)

  ---@type utils.statuscolumn.Wanted
  local wanted = {
    sign = show_signs,
  }

  for _, component in ipairs(left_c) do
    wanted[component] = true
  end

  for _, component in ipairs(right_c) do
    wanted[component] = true
  end

  if not (show_signs or show_folds or nu or rnu) then
    return ""
  end

  local components = {
    "",
    "",
    "",
  }

  -- Number.
  if (nu or rnu) and vim.v.virtnum == 0 then
    local num

    if rnu and nu and vim.v.relnum == 0 then
      num = vim.v.lnum
    elseif rnu then
      num = vim.v.relnum
    else
      num = vim.v.lnum
    end

    components[2] = "%=" .. num
  end

  -- Signs / folds.
  if show_signs or show_folds then
    local signs = M.line_signs(win, buf, vim.v.lnum, wanted)

    if #signs > 0 then
      ---@type table<utils.statuscolumn.Sign.type, utils.statuscolumn.Sign>
      local signs_by_type = {}

      for _, sign in ipairs(signs) do
        signs_by_type[sign.type] = signs_by_type[sign.type] or sign
      end

      ---@param types utils.statuscolumn.Sign.type[]
      ---@return utils.statuscolumn.Sign?
      local function find(types)
        for _, type in ipairs(types) do
          local sign = signs_by_type[type]

          if sign then
            return sign
          end
        end
      end

      local left = find(left_c)
      local right = find(right_c)

      if config.folds.git_hl then
        local git = signs_by_type.git

        if git and left and left.type == "fold" then
          left.texthl = git.texthl
        end

        if git and right and right.type == "fold" then
          right.texthl = git.texthl
        end
      end

      -- Prefer the left component.
      local sign = left or right

      components[1] = sign and M.icon(sign) or " "
    else
      -- Quickfix does not need the extra padding.
      components[1] = vim.bo[buf].filetype == "qf" and "" or " "
    end
  end

  -- Keep one trailing space.
  components[3] = " "

  local ret = table.concat(components)

  return "%@v:lua.require'r.utils.statuscolumn'.click_fold@" .. ret .. "%T"
end

---@return string
function M.get()
  local win = vim.g.statusline_winid

  if not win or not vim.api.nvim_win_is_valid(win) then
    return ""
  end

  local buf = vim.api.nvim_win_get_buf(win)

  local key = ("%d:%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0, vim.v.relnum)

  local cached = cache[key]

  if cached then
    return cached
  end

  local ok, ret = pcall(M._get)

  if ok then
    cache[key] = ret
    return ret
  end

  return ""
end

function M.click_fold()
  local pos = vim.fn.getmousepos()

  if not pos.winid or pos.winid == 0 or pos.line == 0 then
    return
  end

  if not vim.api.nvim_win_is_valid(pos.winid) then
    return
  end

  vim.api.nvim_win_call(pos.winid, function()
    vim.api.nvim_win_set_cursor(pos.winid, {
      pos.line,
      0,
    })

    if vim.fn.foldlevel(pos.line) > 0 then
      vim.cmd "normal! za"
    end
  end)
end

return M
