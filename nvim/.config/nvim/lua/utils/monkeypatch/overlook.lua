local api = vim.api
local M = {}

local EDITOR_RELATIVE_FT = { qf = true, help = true, orgagenda = true }
local DEFAULT_RATIO = { width = 0.70, height = 0.70 }

local state = {
  force = false,
  width_ratio = DEFAULT_RATIO.width,
  height_ratio = DEFAULT_RATIO.height,
}

local function is_temporary(popup)
  return popup ~= nil and (popup.temporary == true or (popup.opts ~= nil and popup.opts.temporary == true))
end

---Patch `Popup.new` (once, permanently).
---Two reasons:
---  1. overlook anchors the first popup to the host window and has no option to
---     change that. For small hosts (qf, help, orgagenda) and for zoom mode,
---     re-anchor it to the editor and center it.
---  2. Mark popups as `temporary` (explicit, zoom mode, or child of a temporary
---     popup) so `patch_stack` keeps them out of the restore trash.
local function patch_popup_new()
  local Popup = require "overlook.popup"
  if Popup.__patched_new then
    return
  end
  Popup.__patched_new = true

  local orig_new = Popup.new

  ---@diagnostic disable-next-line: duplicate-set-field
  Popup.new = function(popup_opts, ctx)
    local p = orig_new(popup_opts, ctx)
    if not p then
      return p
    end

    -- temporary: diminta eksplisit, mode zoom, atau anak dari popup temporary
    ---@diagnostic disable-next-line: undefined-field
    if state.force or (popup_opts and popup_opts.temporary) or is_temporary(ctx and ctx.prev) then
      p.temporary = true
      if p.opts then
        p.opts.temporary = true
      end
    end

    if not p.is_first_popup then
      return p
    end

    local root_winid = p.root_winid
    if not root_winid or not api.nvim_win_is_valid(root_winid) then
      return p
    end

    if not state.force then
      local root_buf = api.nvim_win_get_buf(root_winid)
      if not EDITOR_RELATIVE_FT[vim.bo[root_buf].filetype] then
        return p
      end
    end

    local Config = require("overlook.config").get()
    local tabline = vim.o.showtabline == 2 and 1 or 0
    local editor_height = vim.o.lines - vim.o.cmdheight - tabline
    local editor_width = vim.o.columns
    local border_overhead = Config.ui.border ~= "none" and 2 or 0

    local height = math.max(Config.ui.min_height, math.floor(editor_height * state.height_ratio) - border_overhead)
    local width = math.max(Config.ui.min_width, math.floor(editor_width * state.width_ratio))

    p.win_config = vim.tbl_extend("force", p.win_config, {
      relative = "editor",
      win = nil,
      row = math.max(0, math.floor((editor_height - height) / 2)),
      col = math.max(0, math.floor((editor_width - width) / 2)),
      width = width,
      height = height,
    })
    return p
  end
end

local function patch_stack()
  local Stack = require "overlook.stack"
  if Stack.__patched_skip_temporary then
    return
  end
  ---@diagnostic disable-next-line: inject-field
  Stack.__patched_skip_temporary = true

  local orig_push = Stack.push
  local orig_pop = Stack.pop
  local orig_remove_by_winid = Stack.remove_by_winid

  ---@diagnostic disable-next-line: duplicate-set-field
  Stack.push = function(self, popup)
    if is_temporary(popup) then
      table.insert(self.items, popup) -- jangan kosongkan trash
      return
    end
    return orig_push(self, popup)
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  Stack.pop = function(self)
    if is_temporary(self:top()) then
      return table.remove(self.items) -- buang, jangan di-trash
    end
    return orig_pop(self)
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  Stack.remove_by_winid = function(self, winid)
    for i = #self.items, 1, -1 do
      local item = self.items[i]
      if item.winid == winid and is_temporary(item) then
        return table.remove(self.items, i)
      end
    end
    return orig_remove_by_winid(self, winid)
  end
end

---Idempotent; aman dipanggil berkali-kali.
function M.setup()
  patch_popup_new()
  patch_stack()
end

---Jalankan `fn` dalam mode zoom (editor-relative + temporary).
---State SELALU di-reset setelah `fn`, bahkan kalau error.
---@param ratio { width: number, height: number }
---@param fn fun()
function M.with_zoom(ratio, fn)
  state.force = true
  state.width_ratio = ratio.width
  state.height_ratio = ratio.height

  local ok, err = pcall(fn)

  state.force = false
  state.width_ratio = DEFAULT_RATIO.width
  state.height_ratio = DEFAULT_RATIO.height

  if not ok then
    error(err, 0)
  end
end

return M
