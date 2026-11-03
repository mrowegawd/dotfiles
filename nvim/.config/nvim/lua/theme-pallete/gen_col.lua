local dir = debug.getinfo(1, "S").source:match "^@(.*/)" or "./"
local P = dofile(dir .. "vscode_coder.lua")
local out = (arg and arg[1]) or "."
local T, A = P.term, P.ansi
local id = "vscode-coder"
local header = id .. " (generated oleh gen.lua)"

local function write(name, text)
  local f = assert(io.open(out .. "/" .. name, "w"))
  f:write(text)
  f:close()
  print("tulis: " .. out .. "/" .. name)
end

-- Ghostty
local g = {
  "# " .. header,
  "background = " .. T.background,
  "foreground = " .. T.foreground,
  "cursor-color = " .. T.cursor,
  "cursor-text = " .. T.cursor_text,
  "selection-background = " .. T.selection_bg,
  "selection-foreground = " .. T.selection_fg,
}
for i = 0, 15 do
  g[#g + 1] = ("palette = %d=%s"):format(i, A[i + 1])
end
write("ghostty-" .. id, table.concat(g, "\n") .. "\n")

-- Kitty
local k = {
  "# " .. header,
  "background " .. T.background,
  "foreground " .. T.foreground,
  "cursor " .. T.cursor,
  "cursor_text_color " .. T.cursor_text,
  "selection_background " .. T.selection_bg,
  "selection_foreground " .. T.selection_fg,
  "url_color " .. T.url,
  "active_border_color " .. T.border_active,
  "inactive_border_color " .. T.border_inactive,
  "active_tab_background " .. T.tab_active_bg,
  "active_tab_foreground " .. T.tab_active_fg,
  "inactive_tab_background " .. T.tab_inactive_bg,
  "inactive_tab_foreground " .. T.tab_inactive_fg,
}
for i = 0, 15 do
  k[#k + 1] = ("color%d %s"):format(i, A[i + 1])
end
write("kitty-" .. id .. ".conf", table.concat(k, "\n") .. "\n")

-- Xresources
local x = {
  "! " .. header,
  "*.foreground: " .. T.foreground,
  "*.background: " .. T.background,
  "*.cursorColor: " .. T.cursor,
}
for i = 0, 15 do
  x[#x + 1] = ("*.color%d: %s"):format(i, A[i + 1])
end
write("Xresources-" .. id, table.concat(x, "\n") .. "\n")
