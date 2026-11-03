local M = {}

M.themes = {}

-- ├────────────────────────────────┤ ef-dream ├────────────────────────────────┤
M.themes["ef-dream"] = {
  syntax = {
    comment = "#8d89a6",
    keyword = "#d0a8ff",
    identifier = "#e8d9d0",
    variable = "#e8d9d0",
    variable_use = "#dccdc4",
    string = "#a6d98c",
    docstring = "#8fae88",
    type = "#e5c07a",
    constant = "#ff9e7a",
    fnname = "#7cc4ff",
    fnname_call = "#a5cbe6",
    builtin = "#ff8fb8",
    preprocessor = "#5fd0b0",
    rx_backslash = "#5fd0b0",
    rx_construct = "#ff9e7a",
  },
  term = {
    background = "#232025",
    foreground = "#efd5c5",
    cursor = "#f3c09a",
    cursor_text = "#232025",
    selection_bg = "#544a50",
    selection_fg = "#efd5c5",
    url = "#7cc4ff",
    border_active = "#675072",
    border_inactive = "#3a373c",
    tab_active_bg = "#675072",
    tab_active_fg = "#fedeff",
    tab_inactive_bg = "#3a373c",
    tab_inactive_fg = "#8f8886",
  },
  ansi = {
    "#322f34",
    "#ff6f6f",
    "#8bd26b",
    "#e5c07a",
    "#6fb8ff",
    "#d0a8ff",
    "#5fd0d0",
    "#d9cbc2",
    "#787280",
    "#ff9a9a",
    "#a6d98c",
    "#f2d79a",
    "#9ccfff",
    "#e3c6ff",
    "#9fe6e6",
    "#fff0e6",
  },
}

-- ├───────────────────────────────┤ ef-cherie ├────────────────────────────┤
M.themes["ef-cherie"] = {
  syntax = {
    comment = "#8c8089",
    keyword = "#ef80bf",
    identifier = "#e3d6d8",
    variable = "#e3d6d8",
    variable_use = "#d4c8ca",
    string = "#e5c07a",
    docstring = "#a8946f",
    type = "#8fd0e0",
    constant = "#ff9d6e",
    fnname = "#7db2ff",
    fnname_call = "#a9b8f0",
    builtin = "#c8a0ff",
    preprocessor = "#6fd4a0",
    rx_backslash = "#6fd4a0",
    rx_construct = "#ff9d6e",
  },
  term = {
    background = "#190a0f",
    foreground = "#d3cfcf",
    cursor = "#ff5aaf",
    cursor_text = "#190a0f",
    selection_bg = "#232f3f",
    selection_fg = "#d3cfcf",
    url = "#86a9ff",
    border_active = "#771a4f",
    border_inactive = "#2e2226",
    tab_active_bg = "#771a4f",
    tab_active_fg = "#ffcfdf",
    tab_inactive_bg = "#2e2226",
    tab_inactive_fg = "#808898",
  },
  ansi = {
    "#291f26",
    "#ff7359",
    "#7ccf63",
    "#e5b76f",
    "#7fa5ff",
    "#ef80bf",
    "#8fcfdf",
    "#cfc8ca",
    "#7a7078",
    "#ff9a85",
    "#a3de8c",
    "#f2d29a",
    "#a9c3ff",
    "#ff9fd3",
    "#b5e6f0",
    "#f4eeee",
  },
}

-- ╒═════════════════════════════════════════════════════════════════════════════╕
--                                      APPLY
-- ╘═════════════════════════════════════════════════════════════════════════════╛

function M.apply(name, colors)
  local t = M.themes[name]
  if t then
    for k, v in pairs(t.syntax) do
      colors[k] = v
    end
  end
  return colors
end

return M
