local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                   HELPERS                                   ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---@param t table
local function sorted_pairs(t)
  local keys = vim.tbl_keys(t)
  table.sort(keys, function(a, b)
    return tostring(a) < tostring(b)
  end)
  local i = 0
  return function()
    i = i + 1
    local k = keys[i]
    if k ~= nil then
      return k, t[k]
    end
  end
end

---@param contents string | table
---@param path? string
---@param is_theme? boolean
function M.send_contents_to_file(contents, path, is_theme)
  path = path or "/tmp/isi_contents_dari_nvim"
  is_theme = is_theme or false

  local file, err = io.open(path, "w")
  if not file then
    Log.warn(string.format("Failed to open '%s': %s", path, tostring(err)))
    return
  end

  file:write "! vim: foldmethod=marker foldlevel=0 ft=xdefaults\n\n"

  local msg

  if type(contents) == "table" then
    for key, value in sorted_pairs(contents) do
      if is_theme then
        for name, color in sorted_pairs(value) do
          file:write(string.format("%s_%s: %s\n", key, name, tostring(color)))
        end
      else
        file:write(vim.inspect(value) .. "\n")
      end
    end
    msg = is_theme and "Theme changes detected. Don't forget to reload."
      or string.format("Something write in path: '%s'", path)
  elseif type(contents) == "string" then
    file:write(contents .. "\n")
    msg = string.format("Something write in path: '%s'", path)
  else
    msg = string.format("Unsupported contents type: %s", type(contents))
  end

  file:close()
  Log.warn(msg)
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               PALETTE BUILDER                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---@return table
function M.build_colors()
  local H = lazy "utils.highlights"
  local tint, darken = H.tint, H.darken

  local cache = {}
  local function get(group, attr)
    local key = group .. ":" .. attr
    local v = cache[key]
    if v == nil then
      v = H.get(group, attr) or H.get("Normal", attr)
      cache[key] = v
    end
    return v
  end

  local function theme_is(list)
    return vim.tbl_contains(list, vim.g.colorscheme)
  end

  -- ├──────────────────────────────┤ Base palette ├──────────────────────────────┤
  local bg, fg = get("Normal", "bg"), get("Normal", "fg")
  local sep = get("WinSeparator", "fg")
  local keyword = get("Keyword", "fg")
  local func = get("Function", "fg")
  local removed = get("diffRemoved", "fg")
  local changed = get("diffChanged", "fg")

  local text_dim = tint(fg, -0.2)
  local red_muted = darken(removed, 0.8, bg)

  -- Statusline: ONE SOURCE!
  local statusline = {
    raw_fg = get("StatuslineTheme", "fg"),
    bg = get("StatuslineTheme", "bg"),
  }
  statusline.fg = darken(statusline.raw_fg, 0.7, statusline.bg)

  -- Tab
  local tab_active = { fg = get("QuickFixWinbar", "fg"), bg = get("QuickFixWinbar", "bg") }
  local tab_inactive = { fg = get("Winbar", "fg"), bg = get("Winbar", "bg") }

  -- Border pane
  local border_active = sep
  local border_inactive = tint(bg, 0.15)

  -- ├─────────────────────────────────┤ Dunst ├──────────────────────────────┤
  local low = tint(sep, 0.1)
  local normal_bg = tint(bg, 0.85)
  local normal_frame = tint(bg, 0.85)
  local normal_fg_base = tint(bg, 1.1)
  local normal_fg
  local critical_fg = tint(removed, 0.4)

  if theme_is { "base46-everforest", "catppuccin", "vscode", "rose-pine", "oxocarbon", "gruvbox" } then
    normal_bg = tint(bg, 0.05)
    normal_frame = tint(bg, 0.15)
    critical_fg = tint(removed, 1)
  end
  if theme_is { "tokyonight-storm", "tokyonight" } then
    normal_bg = tint(bg, -0.1)
    normal_frame = tint(bg, -0.1)
  end
  if theme_is { "gruvbox", "base46-everforest" } then
    normal_fg_base = tint(bg, 0.4)
  end
  if theme_is { "zenburn" } then
    normal_fg = tint(bg, 0.9)
    normal_bg = tint(bg, 0.02)
    normal_frame = tint(bg, 0.15)
    critical_fg = tint(removed, 1)
  end
  normal_fg = normal_fg or darken(fg, 0.7, normal_bg)

  -- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
  -- ╏                                   OUTPUT                                    ╏
  -- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛
  return {
    fzf = {
      fg = get("FzfLuaFilePart", "fg"),
      bg = get("FzfLuaNormal", "bg"),
      match_fuzzy = get("FzfLuaFzfMatchFuzzy", "fg"),

      selection_fg = get("FzfLuaSel", "fg"),
      selection_bg = get("FzfLuaSel", "bg"),
      match = get("FzfLuaFzfMatch", "fg"),

      marker = get("MarkerFzflua", "fg"),

      gutter = get("FzfLuaNormal", "bg"),
      pointer = keyword,
      border = get("FzfLuaBorder", "fg"),
      header = get("FzfLuaHeaderText", "fg"),
    },

    tmux = {
      fg = text_dim,
      bg = bg,
      fm_bg = get("PanelSideBackground", "bg"), -- file manager bg (yazi, dll)
      keyword = keyword,

      tab_active_fg = tab_active.fg,
      tab_active_bg = tab_active.bg,

      statusline_fg = statusline.fg,
      statusline_bg = statusline.bg,

      session_fg = statusline.raw_fg,
      session_bg = statusline.bg,

      message_bg = tint(darken(func, 0.6, bg), 0.7),
      visual_bg = get("CurSearch", "bg"),

      border_active = border_active,
      border_inactive = border_inactive,
      border_inactive_status_fg = border_inactive,
    },

    kitty = {
      tab_active_fg = tab_active.fg,
      tab_active_bg = tab_active.bg,
      tab_inactive_fg = tab_inactive.fg,
      tab_inactive_bg = tab_inactive.bg,
      tab_bar_bg = bg,

      border_active = border_active,
      border_inactive = border_inactive,
    },

    lazygit = {
      active_border = keyword,
      inactive_border = tint(sep, 0.5),
      default_fg = darken(fg, 0.6, bg),
      author_fg = get("Boolean", "fg"),
      selected_bg = get("LazygitselectedLineBgColor", "bg"),
      option_txt = darken(fg, 0.6, bg),
    },

    dunst = {
      low_fg = tint(sep, 2.2),
      low_bg = low,
      low_frame = low,

      normal_title_fg = fg,
      normal_fg = normal_fg,
      normal_bg = normal_bg,
      normal_frame = normal_frame,

      critical_fg = critical_fg,
      critical_bg = tint(removed, -0.25),
      critical_frame = tint(removed, -0.2),

      bg = tint(bg, 0.25),
      fg = tint(fg, 0.25),
      border = tint(bg, 0.25),
    },

    zshrc = {
      lines = get("Zshlines", "fg"),
      sugest = get("Zshlines", "bg"),

      prompt_fg = get("Zshprompt", "fg"),
      prompt_bg = get("Zshprompt", "bg"),
      promptbrigt_fg = get("ZshpromptBright", "fg"),
      promptbrigt_bg = get("ZshpromptBright", "bg"),
    },

    btop = {
      fg = text_dim,
      bg = bg,

      yellow_alt = tint(changed, -0.45),
      highlight_key = tint(removed, 0.1),

      cursorline_fg = tint(keyword, 1),
      cursorline_bg = tint(keyword, -0.5),

      border_fg = tint(sep, 0.25),
      title = tint(keyword, -0.2),
      inactive_text = tint(fg, -0.6),
      darken_bg = tint(bg, -0.5),
    },

    delta = {
      hunk_header_fg = get("diffFile", "fg"),
      hunk_header_bg = get("diffFile", "bg"),

      line_number_fg = tint(bg, 0.5),
      line_number_plus = get("NeogitDiffAdd", "fg"),
      line_number_minus = get("NeogitDiffDelete", "fg"),

      hunk_plus_fg = get("NeogitDiffAdd", "fg"),
      hunk_plus_bg = get("NeogitDiffAdd", "bg"),
      hunk_emp_plus_fg = get("NeogitDiffAddInline", "fg"),
      hunk_emp_plus_bg = get("NeogitDiffAddInline", "bg"),

      hunk_minus_fg = get("NeogitDiffDelete", "fg"),
      hunk_minus_bg = get("NeogitDiffDelete", "bg"),
      hunk_emp_minus_fg = get("NeogitDiffDeleteInline", "fg"),
      hunk_emp_minus_bg = get("NeogitDiffDeleteInline", "bg"),
    },

    eww = {
      bg = bg,
      fg = statusline.fg,
      fg2 = tint(changed, -0.3),

      bg_darken = tint(bg, -0.3),
      bg_alt = tint(bg, 0.3),

      red = red_muted,
      icon_fg = normal_fg_base,
      keyword = keyword,
    },

    yazi = {
      cwd = get("PanelSideRootName", "fg"),
      hovered = get("HoveredTerminalFileManagerCursorline", "bg"),

      selected = red_muted,
      count_selected_bg = red_muted,

      find_keyword_fg = get("CurSearch", "fg"),
      find_keyword_bg = get("CurSearch", "bg"),

      copied = tint(changed, 0.3),
      count_copied_bg = tint(changed, -0.5),

      cut = tint(get("String", "fg"), 0.3),
      count_cut_bg = tint(get("String", "fg"), -0.5),

      marked_fg = tint(func, 0.1),
      marked_bg = tint(func, -0.5),

      tab_active_fg = keyword,
      tab_active_bg = get("NormalKeyword", "bg"),
      tab_inactive_fg = get("NormalKeyword", "bg"),
      tab_inactive_bg = tint(get("TabLine", "fg"), 0.2),

      statusline_normal_fg = statusline.raw_fg,
      statusline_normal_bg = statusline.bg,
      statusline_normal_fg_alt = statusline.fg,
      statusline_normal_bg_alt = darken(statusline.bg, 0.6, bg),

      statusline_select_fg = tint(get("Visual", "bg"), 2),
      statusline_select_bg = tint(get("Visual", "bg"), 0.4),
      statusline_select_fg_alt = tint(get("Visual", "bg"), 1),
      statusline_select_bg_alt = get("Visual", "bg"),

      statusline_unset_fg = tint(func, -0.5),
      statusline_unset_bg = tint(func, 0.4),
      statusline_unset_fg_alt = tint(func, -0.8),
      statusline_unset_bg_alt = func,

      directory = get("Directory", "fg"),

      menu_bg = get("Pmenu", "bg"),
      menu_fg = get("Pmenu", "fg"),
    },

    rofi = {
      foreground = normal_bg,

      background = normal_bg,
      background_alt = normal_fg,

      selected = normal_fg,
      selected_alt = tint(keyword, -0.25),

      keyword = keyword,

      red = tint(removed, -0.3),
      green = tint(get("diffAdded", "bg"), -0.3),
    },
  }
end

function M.change_colorscheme_global()
  M.send_contents_to_file(M.build_colors(), "/tmp/master-colors-themes", true)
end

return M
