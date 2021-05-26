local colors = {}

-- colors.vimbg = function(name)

--   local idnum = api.nvim_call_function("hlID", { name })
--   local col = api.nvim_call_function("synIDattr", { idnum, "bg" })
--   if col ~= col then
--     return col
--   end
--   return nil

-- end

-- local bg = colors.vimbg('StatusLine')
-- print(bg)

colors.alduin = {
  bg = '#121212',
  fg = '#dfdfaf',
  yellow = '#af875f',
  green = '#87875f',
  magenta = '#af8787',
  blue = '#878787',
  red = '#af5f5f',
  cyan = '#87afaf',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1',
}

colors.gruvbox = {
  bg = '#504945',
  fg = '#d5c4a1',
  yellow = '#fabd2f',
  green = '#b8bb26',
  magenta = '#d3869b',
  blue = '#83a598',
  red = '#fb4934',
  cyan = '#8ec07c',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1',
}

colors.nord = {
  bg = '#3B4252',
  fg = '#e5e9f0',
  yellow = '#5e81ac',
  green = '#bf616a',
  magenta = '#a3be8c',
  blue = '#ebcb8b',
  red = '#88c0d0',
  cyan = '#d08770',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1'
}

colors.solarized_dark = {
  bg = '#586e75',
  fg = '#e5e9f0',
  yellow = '#b58900',
  green = '#859900',
  magenta = '#d33682',
  blue = '#268bd2',
  red = '#dc322f',
  cyan = '#2aa198',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1'
}

colors.gotham256 = {
  bg = '#091f2e',
  fg = '#98d1ce',
  yellow = '#edb54b',
  green = '#26a98b',
  magenta = '#4e5165',
  blue = '#195465',
  red = '#c33027',
  cyan = '#33859d',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1'
}

colors.tomorrow_night = {
  bg = '#373b41',
  fg = '#c5c8c6',
  yellow = '#e6c547',
  green = '#b5bd68',
  magenta = '#b294bb',
  blue = '#81a2be',
  red = '#cc6666',
  cyan = '#70c0ba',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1'
}

colors.onedark = {
  bg = '#282c34',
  fg = '#abb2bf',
  yellow = '#d19a66',
  green = '#98c379',
  magenta = '#c678dd',
  blue = '#61afef',
  red = '#e06c75',
  cyan = '#56b6c2',

  orange = '#b8bb26',
  darkblue = '#081633',
  violet = '#a9a1e1'
}

return colors
