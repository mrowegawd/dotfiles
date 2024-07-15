-- Taken from https://github.com/zhamlin/tiler.vim

local fmt = string.format
local api = vim.api
local fn = vim.fn

---@class r.utils.tiling
local M = {}

local tab_layouts = {}

local tile_layout = "right"
local tile_layouts_stack = { right = "K", left = "J", top = "L", bottom = "H" }

local state = {}
state.active = false
state.active_winid = 0
state.active_overlays = {}

state.found_stay_wins = {}
state.found_close_wins = {}
state.found_main_wins = {}

local expand_tree = false

local master_win = 1

local activate_tiling_autocmds = function()
  vim.cmd [[
  augroup TilingAutocmds
  au!
  au FileType * call setbufvar('%', 'ft', &ft)
  au WinEnter,VimEnter,FileType * silent call v:lua.require'config.tiling'.handle_event("enter")
  au WinClosed,WinLeave * call v:lua.require'config.tiling'.handle_event("leave")
  augroup END
]]
end

local deactivate_tiling_autocmds = function()
  vim.cmd [[
    augroup TilingAutocmds
    au!
    augroup END
]]
end

local wins_stay_left_screen = { "Outline", "NvimTree", "neo-tree" }
local wins_stay_up_screen = { "qf", "scratch", "Trouble", "fugitive" }

local wins_stay_on_screen = {
  Outline = {
    position = "H",
    resize = "vertical resize 30",
  },
  NvimTree = {
    position = "H",
    resize = "vertical resize 30",
  },
  ["neo-tree"] = {
    position = "H",
    resize = "vertical resize 30",
  },
  qf = {
    position = "K",
    resize = "resize 10",
  },
  scratch = {
    position = "K",
    resize = "resize 10",
  },
  Trouble = {
    position = "K",
    resize = "resize 10",
  },
  fugitive = {
    position = "K",
    resize = "resize 10",
  },
}

local wins_main_table = {
  "toggleterm",
  "neotree",
  "sidebar",
  "undotree",
  "fugitive",
  "spectre_panel",
  "orgagenda",
  "alpha",
}

local aucmd_win_stay_left = {}
local aucmd_win_stay_up = {}

local function __indexOf(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

local __winmaxheight = function()
  local height = api.nvim_get_option "lines" - api.nvim_get_option "cmdheight"

  -- subtract one from height if tabbar is visible
  if
    (fn.tabpagenr "$" > 1 and api.nvim_get_option "showtabline")
    or (fn.tabpagenr "$" > 1 and api.nvim_get_option "laststatus")
    or api.nvim_get_option "showtabline" > 1
  then
    height = height - 1
  end

  -- -- subtract one from height if statusline is visible
  -- if
  --     (fn.winnr "$" > 1 and api.nvim_get_option "laststatus")
  --     or api.nvim_get_option "laststatus" > 1
  -- then
  --     height = height - 1
  -- end

  return height
end

local __get_tab_layout = function()
  local curtab = vim.api.nvim_get_current_tabpage()

  if tab_layouts[curtab] == nil then
    tab_layouts[curtab] = tile_layout
  end
  return tab_layouts[curtab]
end

-- local __removeDuplicatesTbl = function(tbl)
--     local newArray = {}
--     local checkerTbl = {}
--     for _, element in ipairs(tbl) do
--         if not checkerTbl[element["ft"]] then
--             checkerTbl[element["ft"]] = true
--             table.insert(newArray, element)
--         end
--     end
--     return newArray
-- end

local __change_buffers = function()
  local curbufnum = api.nvim_get_current_buf()
  vim.cmd(fmt([[%d wincmd w]], master_win))
  vim.cmd(fmt("b %d", curbufnum))
end

local __resize_master = function()
  local width_primer_win = vim.o.columns * 0.65
  if expand_tree then
    width_primer_win = 80
  end
  vim.cmd(fmt("vertical resize %d", width_primer_win))
  expand_tree = false
end

-- local __winid_from_tab_buf = function(tabnr, bufnr)
--     for _, w in ipairs(api.nvim_tabpage_list_wins(tabnr)) do
--         if bufnr == api.nvim_win_get_buf(w) then
--             return w
--         end
--     end
--     return nil
-- end

local __loop_wins = function(tbl_loop, tbl_output, winft, winid)
  for i = 1, #tbl_loop do
    if tbl_loop[i] == winft then
      table.insert(tbl_output, { winid = winid, ft = winft })
    end
  end
end

local __scan_wins = function()
  aucmd_win_stay_left = {}
  aucmd_win_stay_up = {}

  for _, winid in pairs(api.nvim_tabpage_list_wins(0)) do
    local winbufnr = fn.winbufnr(api.nvim_win_get_number(winid))

    if winbufnr > 0 then
      local winft = api.nvim_buf_get_option(winbufnr, "filetype")

      __loop_wins(wins_stay_up_screen, aucmd_win_stay_up, winft, winid)
      __loop_wins(wins_stay_left_screen, aucmd_win_stay_left, winft, winid)
    end
  end
end

local __window_move = function(direction, i)
  vim.cmd(string.format("silent %d wincmd w", i))
  vim.cmd(string.format("silent wincmd %s", direction))
end

-- local __get_dat = function(tbl, ft)
--     local foundFt = false
--     for i = 1, #tbl do
--         if ft == tbl[i] then
--             foundFt = true
--         end
--     end

--     return foundFt
-- end

local __tbl_ft_stay_on_screen = function()
  local exTbl = {}
  for k, _ in pairs(wins_stay_on_screen) do
    table.insert(exTbl, k)
  end
  return exTbl
end

-- local get_master_layouts = function()
--     local current_tab = fn.tabpagenr()
--     if not window_layout[current_tab] then
--         window_layout[current_tab] = {}
--     end
--     return window_layout[current_tab]
-- end

-- local set_master_layouts = function(layout)
--     window_layout[fn.tabpagenr()] = layout
-- end

-- -- local get_master = function()
-- --     return fn.win_id2win(fn.get(get_master_layouts(), 0))
-- -- end

-- local match_popups = function(bufname, filetype)
--     local popups = {}

--     -- check if popup windows match with our popups_windows_match
--     for k, v in pairs(popups_windows_match) do
--         if __has_key(v, "filetype") and v.filetype == filetype then
--             popups[k] = v
--         end

--         if __has_key(v, "name") and v.name == bufname then
--             popups[k] = v
--         end
--     end
--     return popups
-- end

-- local verify_tile_order = function(popups)
--     local winid = get_master_layouts()

--     if #winid + #popups ~= fn.winnr "$" then
--         winid = fn.reverse(
--             fn.sort(fn.map(fn.range(1, fn.winnr "$"), "win_getid(v:val)"))
--         )
--         winid = fn.insert(
--             fn.filter(winid, string.format("v:val != %s", curwinid)),
--             curwinid
--         )
--     end
--     set_master_layouts(fn.filter(winid, "v:val != 0"))
-- end

local arrange_window = function()
  local layout = __get_tab_layout()

  for i = 1, fn.winnr "$" do
    if
      ((layout == "left" or layout == "right") and fn.winwidth(i) ~= vim.o.columns)
      or ((layout == "top" or layout == "bottom") and fn.winwidth(i) ~= __winmaxheight())
    then
      __window_move(tile_layouts_stack[layout], i)
      return -1
    end
  end
  return 1
end

local stack_windows = function()
  local counter = 0
  while arrange_window() < 0 do
    counter = counter + 1
    if counter > 50 then
      RUtils.warn "infinite loop, probably an issue with getting max height or width"
      break
    end
  end
end

-- local find_popups = function()
--     local popups = {}

--     -- Find another opened windows, like luatree, qf, symboloutline, etc
--     for i = 1, fn.winnr "$" do
--         local winbufnr = fn.winbufnr(i)

--         local winbufname = api.nvim_buf_get_name(winbufnr)
--         local winfiletype = api.nvim_buf_get_option(winbufnr, "filetype")

--         if winfiletype == "toggleterm" then
--             vim.cmd [[ToggleTerm]]
--         end

--         local founded_popups = match_popups(winbufname, winfiletype)

--         if __get_table_size(founded_popups) > 0 then
--             table.insert(popups, founded_popups)
--         end
--     end

--     return popups
-- end

local winds_find = function(input_tbl, output_tbl)
  for k, winid in pairs(api.nvim_tabpage_list_wins(0)) do
    local winbufnr = fn.winbufnr(api.nvim_win_get_number(winid))

    if winbufnr > 0 then
      local winft = vim.api.nvim_get_option_value("filetype", { buf = winbufnr })

      for i = 1, #input_tbl do
        if winft == input_tbl[i] then
          table.insert(output_tbl, {
            ft = winft,
            winnumber = winbufnr,
            winid = winid,
            winposition = k,
          })
        end
      end
    end
  end
end

local get_autojump = function()
  state.found_stay_wins = {}

  winds_find(__tbl_ft_stay_on_screen(), state.found_stay_wins)

  local tot_wins = #state.found_stay_wins + 1

  state.found_main_wins = {
    winbufnr = fn.winbufnr(tot_wins),
  }

  if tot_wins > 2 then
    expand_tree = true
  end

  for _, v in ipairs(state.found_stay_wins) do
    if __indexOf(wins_stay_left_screen, v.ft) ~= nil then
      expand_tree = true
      break
    end
  end

  vim.cmd(fmt("%d wincmd w", tot_wins))
end

local tile_reorder = function()
  stack_windows()

  vim.cmd "split"
  vim.cmd "wincmd H"

  -- NOTE: butuh loop ini untuk current cursor jika sama dengan wins_stay_left_screen
  for _, v in pairs(wins_stay_left_screen) do
    if vim.bo.filetype == v then
      vim.cmd(fmt([[b %s]], api.nvim_buf_get_name(state.found_main_wins.winbufnr)))
    end
  end

  local newTbl = {}
  for winidx, winid in pairs(api.nvim_tabpage_list_wins(0)) do
    local winbufnr = fn.winbufnr(api.nvim_win_get_number(winid))
    if winbufnr > 0 then
      table.insert(newTbl, {
        winft = api.nvim_get_option_value("filetype", { buf = winbufnr }),
        winidx = winidx,
      })
    end
  end

  for _, val in pairs(newTbl) do
    for ft, opts in pairs(wins_stay_on_screen) do
      if val.winft == "scratch" then
        vim.cmd [[ScratchPreview]]
        vim.cmd [[ScratchPreview]]
      else
        if val.winft == ft then
          vim.cmd(fmt("%d wincmd w", val.winidx))
          vim.cmd(fmt("wincmd %s", opts.position))
          vim.cmd(opts.resize)
        end
      end
    end
  end

  M.resize_window()
end

M.force_win_close = function(close_wins_table, close_all)
  state.active_overlays = {}
  close_all = close_all or false

  if not close_all then
    winds_find(close_wins_table, state.active_overlays)

    if #state.active_overlays > 0 then
      for i = 1, #state.active_overlays do
        api.nvim_win_close(state.active_overlays[i].winid, true)
      end
    end
  else
    vim.cmd "only"
  end
end

local __aucmd_win_cmd = function(tbl_wins)
  if #tbl_wins > 1 then
    -- local bufnr = api.nvim_get_current_buf()
    -- local buftype = api.nvim_buf_get_option(bufnr, "filetype")
    -- if buftype == "scratch" then
    --     return
    -- end
    if vim.api.nvim_win_is_valid(tbl_wins[2].winid) and tbl_wins[2].ft ~= tbl_wins[1].ft then
      -- as.info(
      --     "kill " .. tbl_wins[2].winid .. ", with ft: " .. tbl_wins[2].ft
      -- )
      api.nvim_win_close(tbl_wins[2].winid, true)
    end
  end
end

M.handle_event = function(_)
  if state.active then
    __scan_wins()
    -- as.warn(aucmd_win_stay_up)
    __aucmd_win_cmd(aucmd_win_stay_up)
    __aucmd_win_cmd(aucmd_win_stay_left)
  end
end

M.tiling_toggle = function()
  if state.active then
    state.active = false
    deactivate_tiling_autocmds()
    RUtils.info "[+] Tiling autocmds off.."
    return
  end
  state.active = true
  activate_tiling_autocmds()
  RUtils.info "[+] Tiling autocmds on.."
end

M.state_active = function(stat)
  state.active = stat
end

M.create_window = function()
  if api.nvim_buf_get_option(api.nvim_get_current_buf(), "filetype") == "alpha" then
    vim.cmd "Telescope find_files"
    return
  end

  if not state.active then
    -- TODO: logic nya kurang, bakal error jika debuggigng window active
    state.active = true
  end
  M.force_win_close(wins_main_table)

  get_autojump()
  deactivate_tiling_autocmds()
  tile_reorder()

  state.found_close_wins = {}
  state.found_stay_wins = {}
  activate_tiling_autocmds()
end

M.focus_window = function()
  __change_buffers()
  __resize_master()
end

M.resize_window = function()
  get_autojump()
  __resize_master()
end

return M
