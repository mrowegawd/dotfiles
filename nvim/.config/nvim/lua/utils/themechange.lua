local M = {}

local Log = require "utils.log"

---@param contents string | table
---@param path? string
---@param is_theme? boolean
function M.send_contents_to_file(contents, path, is_theme)
  path = path or "/tmp/isi_contents_dari_nvim"
  is_theme = is_theme or false

  if require("utils.file").is_file(path) then
    vim.system { "rm", path }
    vim.system { "touch", path }
  end

  local file = io.open(path, "w")
  if not file then
    return
  end

  local msg_notify_send

  local is_done = false

  if not is_done then
    file:write "! vim: foldmethod=marker foldlevel=0 ft=xdefaults\n\n"

    if type(contents) == "table" then
      for i, x in pairs(contents) do
        if is_theme then
          for idx, j in pairs(x) do
            file:write(i .. "_" .. idx .. ": " .. j .. "\n")
          end
        else
          -- file:write(tostring(x) .. "\n")
          file:write(vim.inspect(x) .. "\n")
          is_done = true
        end
      end

      if is_theme then
        msg_notify_send = "Theme changes detected. Don't forget to reload."
      else
        msg_notify_send = string.format("Something write in path: '%s'", path)
      end
    end

    if type(contents) == "string" then
      file:write(contents .. "\n")
      msg_notify_send = string.format("Something write in path: '%s'", path)
    end
  end

  Log.warn(msg_notify_send)

  file:close()
end

function M.change_colorscheme_global()
  local H = require "utils.highlights"

  -- ─< TAB >────────────────────────────────────────────────────────────
  -- Active Tab
  -- local tab_session_fg = H.get("Winbar", "fg")
  -- local tab_session_bg = H.get("Winbar", "bg")

  local statusline_fg = H.darken(H.get("Statusline", "fg"), 0.76, H.get("Statusline", "bg"))
  local statusline_bg = H.get("Normal", "bg")

  local tab_active_fg = H.get("Winbar", "bg")
  local tab_active_bg = H.get("Winbar", "fg")

  -- Inactive Tab
  -- local tab_inactive_fg = H.tint(H.get("Comment", "fg"), 0.4)
  -- local tab_inactive_bg = H.get("NormalNote", "bg")

  local tab_inactive_fg = H.get("Winbar", "fg")
  local tab_inactive_bg = H.get("Winbar", "bg")

  -- Border Pane
  local border_active = H.tint(H.get("WinSeparator", "fg"), 0.1)
  local border_inactive = H.tint(H.get("Normal", "bg"), 0.15)

  -- ─< ZSH >────────────────────────────────────────────────────────────
  local zsh_lines = H.get("Zshlines", "fg")
  local zsh_sugest = H.get("Zshlines", "bg")

  -- ─< YAZI >───────────────────────────────────────────────────────────
  local yazi_hovered = H.get("HoveredTerminalFileManagerCursorline", "bg")

  -- ─< DUNST >──────────────────────────────────────────────────────────
  local low_fg = H.tint(H.get("WinSeparator", "fg"), 2.2)
  local low_bg = H.tint(H.get("WinSeparator", "fg"), 0.1)
  local low_frame = H.tint(H.get("WinSeparator", "fg"), 0.1)
  local normal_title_fg = H.get("Normal", "fg")

  local normal_fg = H.tint(H.get("WinSeparator", "fg"), 4)
  local normal_fg_base = H.tint(H.get("WinSeparator", "fg"), 1)
  local normal_bg = H.tint(H.get("WinSeparator", "fg"), 0.7)

  local normal_frame = H.tint(H.get("WinSeparator", "fg"), 0.7)

  local critical_fg = H.tint(H.get("diffRemoved", "fg"), 0.4)
  local critical_bg = H.tint(H.get("diffRemoved", "fg"), -0.25)
  local critical_frame = H.tint(H.get("diffRemoved", "fg"), -0.2)

  if
    vim.tbl_contains(
      { "base46-everforest", "catppuccin", "vscode", "rose-pine", "oxocarbon", "gruvbox" },
      vim.g.colorscheme
    )
  then
    normal_fg = H.tint(H.get("WinSeparator", "fg"), 1.5)
    normal_bg = H.tint(H.get("WinSeparator", "fg"), 0.05)
    normal_frame = H.tint(H.get("WinSeparator", "fg"), 0.15)
    critical_fg = H.tint(H.get("diffRemoved", "fg"), 1)
  end
  if vim.tbl_contains({ "tokyonight-storm", "tokyonight" }, vim.g.colorscheme) then
    normal_fg = H.tint(H.get("WinSeparator", "fg"), 1)
    normal_bg = H.tint(H.get("WinSeparator", "fg"), -0.1)
    normal_frame = H.tint(H.get("WinSeparator", "fg"), -0.1)
  end

  if vim.tbl_contains({ "gruvbox", "base46-everforest" }, vim.g.colorscheme) then
    normal_fg_base = H.tint(H.get("WinSeparator", "fg"), 0.4)
  end

  if vim.tbl_contains({ "zenburn" }, vim.g.colorscheme) then
    normal_fg = H.tint(H.get("WinSeparator", "fg"), 0.9)
    normal_bg = H.tint(H.get("WinSeparator", "fg"), 0.02)
    normal_frame = H.tint(H.get("WinSeparator", "fg"), 0.15)
    critical_fg = H.tint(H.get("diffRemoved", "fg"), 1)
  end

  -- ─< LAZYGIT >────────────────────────────────────────────────────────
  local lazygit_inactive_border = H.tint(H.get("WinSeparator", "fg"), 0.5)
  local lazygit_inactive_text = H.tint(H.get("WinSeparator", "fg"), 4)
  local lazygit_option_text = H.tint(H.get("Normal", "bg"), 4)

  local defined_cols = {
    fzf = {
      -- Normal
      fg = H.get("FzfLuaFilePart", "fg"),
      bg = H.get("FzfLuaNormal", "bg"),
      match_fuzzy = H.get("FzfLuaFzfMatchFuzzy", "fg"),

      -- Selection
      selection_fg = H.get("FzfLuaSel", "fg"),
      selection_bg = H.get("FzfLuaSel", "bg"),
      match = H.get("FzfLuaFzfMatch", "fg"),

      marker = H.get("MarkerFzflua", "fg"),

      gutter = H.get("FzfLuaNormal", "bg"),
      pointer = H.get("Keyword", "fg"),
      border = H.get("FzfLuaBorder", "fg"),
      header = H.get("FzfLuaHeaderText", "fg"),
    },
    tmux = {
      fg = H.tint(H.get("Normal", "fg"), -0.2),
      bg = H.get("Normal", "bg"),

      -- file manager bg ex: yazi, etc
      fm_bg = H.get("PanelSideBackground", "bg"),

      keyword = H.get("Keyword", "fg"),

      tab_active_fg = tab_active_fg,
      tab_active_bg = tab_active_bg,

      statusline_fg = statusline_fg,
      statusline_bg = statusline_bg,

      session_fg = H.get("Statusline", "fg"),
      session_bg = H.get("Statusline", "bg"),

      message_bg = H.tint(H.darken(H.get("Function", "fg"), 0.6, H.get("Normal", "bg")), 0.7),

      visual_bg = H.get("CurSearch", "bg"),

      border_active = border_active,
      border_inactive = border_inactive,
      border_inactive_status_fg = border_inactive,
    },
    kitty = {
      tab_active_fg = tab_active_fg,
      tab_active_bg = tab_active_bg,

      tab_inactive_fg = tab_inactive_fg,
      tab_inactive_bg = tab_inactive_bg,

      tab_bar_bg = H.get("Normal", "bg"),

      border_active = border_active,
      border_inactive = border_inactive,
    },
    lazygit = {
      active_border = H.get("Keyword", "fg"),

      inactive_border = lazygit_inactive_border,
      default_fg = lazygit_inactive_text,

      selected_bg = H.get("LazygitselectedLineBgColor", "bg"),

      option_txt = lazygit_option_text,
    },
    dunst = {
      low_fg = low_fg,
      low_bg = low_bg,
      low_frame = low_frame,

      normal_title_fg = normal_title_fg,

      normal_fg = normal_fg,
      normal_bg = normal_bg,
      normal_frame = normal_frame,

      critical_fg = critical_fg,
      critical_bg = critical_bg,
      critical_frame = critical_frame,

      bg = H.tint(H.get("Normal", "bg"), 0.25),
      fg = H.tint(H.get("Normal", "bg"), 0.25),
      border = H.tint(H.get("Normal", "bg"), 0.25),
    },
    zshrc = {
      lines = zsh_lines,
      sugest = zsh_sugest,
    },
    btop = {
      fg = H.tint(H.get("Normal", "fg"), -0.2),
      bg = H.get("Normal", "bg"),

      yellow_alt = H.tint(H.get("diffChanged", "fg"), -0.45),
      highlight_key = H.tint(H.get("diffRemoved", "fg"), 0.1),

      cursorline_fg = H.tint(H.get("Keyword", "fg"), 1),
      cursorline_bg = H.tint(H.get("Keyword", "fg"), -0.5),

      border_fg = H.tint(H.get("WinSeparator", "fg"), 0.25),

      title = H.tint(H.get("Keyword", "fg"), -0.2),

      inactive_text = H.tint(H.get("Normal", "fg"), -0.6),

      darken_bg = H.tint(H.get("Normal", "bg"), -0.5),
    },
    delta = {
      hunk_header_fg = H.get("diffFile", "fg"),
      hunk_header_bg = H.get("diffFile", "bg"),

      line_number_fg = H.tint(H.get("Normal", "bg"), 0.5),

      line_number_plus = H.get("NeogitDiffAdd", "fg"),
      line_number_minus = H.get("NeogitDiffDelete", "fg"),

      hunk_plus_fg = H.get("NeogitDiffAdd", "fg"),
      hunk_plus_bg = H.get("NeogitDiffAdd", "bg"),
      hunk_emp_plus_fg = H.get("NeogitDiffAddInline", "fg"),
      hunk_emp_plus_bg = H.get("NeogitDiffAddInline", "bg"),

      hunk_minus_fg = H.get("NeogitDiffDelete", "fg"),
      hunk_minus_bg = H.get("NeogitDiffDelete", "bg"),
      hunk_emp_minus_fg = H.get("NeogitDiffDeleteInline", "fg"),
      hunk_emp_minus_bg = H.get("NeogitDiffDeleteInline", "bg"),
    },
    eww = {
      bg = H.get("Normal", "bg"),

      fg = H.tint(H.get("Normal", "fg"), -0.5),
      fg2 = H.tint(H.get("diffChanged", "fg"), -0.3),

      bg_darken = H.tint(H.get("Normal", "fg"), -0.3),
      bg_alt = H.tint(H.get("Normal", "fg"), 0.3),

      red = H.darken(H.get("diffRemoved", "fg"), 0.8, H.get("Normal", "bg")),

      icon_fg = normal_fg_base,

      keyword = H.get("Keyword", "fg"),
    },
    yazi = {
      cwd = H.get("PanelSideRootName", "fg"),
      hovered = yazi_hovered,

      selected = H.darken(H.get("diffRemoved", "fg"), 0.8, H.get("Normal", "bg")),
      count_selected_bg = H.darken(H.get("diffRemoved", "fg"), 0.8, H.get("Normal", "bg")),

      find_keyword_fg = H.get("CurSearch", "fg"),
      find_keyword_bg = H.get("CurSearch", "bg"),

      copied = H.tint(H.get("diffChanged", "fg"), 0.3),
      count_copied_bg = H.tint(H.get("diffChanged", "fg"), -0.5),

      cut = H.tint(H.get("String", "fg"), 0.3),
      count_cut_bg = H.tint(H.get("String", "fg"), -0.5),

      marked_fg = H.tint(H.get("Function", "fg"), 0.1),
      marked_bg = H.tint(H.get("Function", "fg"), -0.5),

      tab_active_fg = H.get("Keyword", "fg"),
      tab_active_bg = H.get("NormalKeyword", "bg"),
      tab_inactive_fg = H.get("NormalKeyword", "bg"),
      tab_inactive_bg = H.tint(H.get("TabLine", "fg"), 0.2),

      -- statusline_normal_fg = H.get("StatusLineRightBlock", "fg"),
      -- statusline_normal_bg = H.get("StatusLineRightBlock", "bg"),
      -- statusline_normal_fg_alt = H.darken(H.get("StatusLineRightBlock", "fg"), 0.7, H.get("Normal", "bg")),
      -- statusline_normal_bg_alt = H.darken(H.get("StatusLineRightBlock", "bg"), 0.6, H.get("Normal", "bg")),

      statusline_normal_fg = H.get("Statusline", "fg"),
      statusline_normal_bg = H.get("Statusline", "bg"),
      statusline_normal_fg_alt = H.darken(H.get("Statusline", "fg"), 0.7, H.get("Normal", "bg")),
      statusline_normal_bg_alt = H.darken(H.get("Statusline", "bg"), 0.6, H.get("Normal", "bg")),

      statusline_select_fg = H.tint(H.get("Visual", "bg"), 2),
      statusline_select_bg = H.tint(H.get("Visual", "bg"), 0.4),
      statusline_select_fg_alt = H.tint(H.get("Visual", "bg"), 1),
      statusline_select_bg_alt = H.get("Visual", "bg"),

      statusline_unset_fg = H.tint(H.get("Function", "fg"), -0.5),
      statusline_unset_bg = H.tint(H.get("Function", "fg"), 0.4),
      statusline_unset_fg_alt = H.tint(H.get("Function", "fg"), -0.8),
      statusline_unset_bg_alt = H.get("Function", "fg"),

      directory = H.get("Directory", "fg"),

      menu_bg = H.get("Pmenu", "bg"),
      menu_fg = H.get("Pmenu", "fg"),
    },
    rofi = {
      foreground = normal_bg,

      background = normal_bg,
      background_alt = normal_fg,

      selected = normal_fg,
      selected_alt = H.tint(H.get("Keyword", "fg"), -0.25),

      keyword = H.get("Keyword", "fg"),

      red = H.tint(H.get("diffRemoved", "fg"), -0.3),
      green = H.tint(H.get("diffAdded", "bg"), -0.3),
    },
  }

  M.send_contents_to_file(defined_cols, "/tmp/master-colors-themes", true)
end

return M
