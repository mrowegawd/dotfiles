local M = {}

local autocmd_keys = {
  "event",
  "buffer",
  "pattern",
  "desc",
  "command",
  "group",
  "once",
  "nested",
}
local function foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

local function fold(callback, list, accum)
  accum = accum or {}
  for k, v in pairs(list) do
    accum = callback(accum, v, k)
    assert(accum ~= nil, "The accumulator must be returned on each iteration")
  end
  return accum
end

local function validate_autocmd(name, command)
  local incorrect = fold(function(accum, _, key)
    if not vim.tbl_contains(autocmd_keys, key) then
      table.insert(accum, key)
    end
    return accum
  end, command, {})

  if #incorrect > 0 then
    vim.schedule(function()
      local msg = "Incorrect keys: " .. table.concat(incorrect, ", ")
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.notify(msg, "error", { title = string.format("Autocmd: %s", name) })
    end)
  end
end

local function augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, string.format("You must specify at least one autocommand for %s", name))
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end
local function pcall(msg, func, ...)
  local L = vim.log.levels
  local args = { ... }
  if type(msg) == "function" then
    local arg = func
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and string.format("%s:\n%s\n%s", msg, vim.inspect(args), err) or err)
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
end

local attrs = {
  fg = true,
  bg = true,
  sp = true,
  blend = true,
  bold = true,
  italic = true,
  standout = true,
  underline = true,
  undercurl = true,
  underdouble = true,
  underdotted = true,
  underdashed = true,
  strikethrough = true,
  reverse = true,
  nocombine = true,
  link = true,
  default = true,
}
local function get_hl_as_hex(opts, ns)
  ns, opts = ns or 0, opts or {}
  opts.link = opts.link ~= nil and opts.link or false
  local hl = vim.api.nvim_get_hl(ns, opts)
  hl.fg = hl.fg and ("#%06x"):format(hl.fg)
  hl.bg = hl.bg and ("#%06x"):format(hl.bg)
  hl.sp = hl.sp and ("#%06x"):format(hl.sp)
  return hl
end

-- local function get_hl_as_hex(opts, ns)
--   ns, opts = ns or 0, opts or {}
--   opts.link = opts.link ~= nil and opts.link or false
--   local hl = vim.api.nvim_get_hl(ns, opts)
--   hl.fg = hl.fg and ("#%06x"):format(hl.fg)
--   hl.bg = hl.bg and ("#%06x"):format(hl.bg)
--   return hl
-- end

function M.h(name)
  return get_hl_as_hex { name = name }
end

-- Converts a hex color string to RGB values (0-255)
-- local function hex_to_rgb(hex)
--   hex = hex:gsub("#", "")
--   return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
-- end

local hex_to_rgb = function(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"

  if hex_str == "NONE" then
    hex_str = "#000000" -- create base hex
  end

  hex_str = string.lower(hex_str)
  assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local red, green, blue = string.match(hex_str, pat)
  return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

-- Converts RGB values (0-255) to a hex color string
local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

-- Clamp value between 0 and 255
local function clamp(val)
  return math.max(0, math.min(255, math.floor(val + 0.5)))
end

-- Darken a color by a percentage (0.0 to 1.0)
function M.darkenun(color, amount)
  local r, g, b = hex_to_rgb(color)
  r = clamp(r * (1 - amount))
  g = clamp(g * (1 - amount))
  b = clamp(b * (1 - amount))
  return rgb_to_hex(r, g, b)
end

-- Lighten a color by a percentage (0.0 to 1.0)
function M.lighten(color, amount)
  local r, g, b = hex_to_rgb(color)
  r = clamp(r + (255 - r) * amount)
  g = clamp(g + (255 - g) * amount)
  b = clamp(b + (255 - b) * amount)
  return rgb_to_hex(r, g, b)
end

--- Change the brightness of a color, negative numbers darken and positive ones brighten
---see:
--- 1. https://stackoverflow.com/q/5560248
--- 2. https://stackoverflow.com/a/37797380
function M.tint(color, percent)
  assert(color and percent, "cannot alter a color without specifying a color and percentage")
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6), 16)
  if not r or not g or not b then
    return "NONE"
  end
  local blend = function(component)
    component = math.floor(component * (1 + percent))
    return math.min(math.max(component, 0), 255)
  end
  return string.format("#%02x%02x%02x", blend(r), blend(g), blend(b))
end

---@param fg string forecrust color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(fg, bg, alpha)
  bg = hex_to_rgb(bg)
  fg = hex_to_rgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.darken(hex, amount, bg)
  return M.blend(hex, bg, math.abs(amount))
end

local hexChars = "0123456789abcdef"
local function rgb2Hex(rgb)
  local hexadecimal = "#"

  for _, value in pairs(rgb) do
    local hex = ""

    while value > 0 do
      local index = math.fmod(value, 16) + 1
      value = math.floor(value / 16)
      hex = string.sub(hexChars, index, index) .. hex
    end

    if string.len(hex) == 0 then
      hex = "00"
    elseif string.len(hex) == 1 then
      hex = "0" .. hex
    end

    hexadecimal = hexadecimal .. hex
  end

  return hexadecimal
end

function M.increase_saturation(hex, percentage)
  local rgb = hex_to_rgb(hex)

  local saturation_float = percentage

  table.sort(rgb)
  local rgb_intensity = {
    min = rgb[1] / 255,
    mid = rgb[2] / 255,
    max = rgb[3] / 255,
  }

  if rgb_intensity.max == rgb_intensity.min then
    -- all colors have same intensity, which means
    -- the original color is gray, so we can't change saturation.
    return hex
  end

  local new_intensities = {}
  new_intensities.max = rgb_intensity.max
  new_intensities.min = rgb_intensity.max * (1 - saturation_float)

  if rgb_intensity.mid == rgb_intensity.min then
    new_intensities.mid = new_intensities.min
  else
    local intensity_proportion = (rgb_intensity.max - rgb_intensity.mid) / (rgb_intensity.mid - rgb_intensity.min)
    new_intensities.mid = (intensity_proportion * new_intensities.min + rgb_intensity.max) / (intensity_proportion + 1)
  end

  for i, v in pairs(new_intensities) do
    new_intensities[i] = math.floor(v * 255)
  end
  table.sort(new_intensities)
  return (rgb2Hex { new_intensities.max, new_intensities.min, new_intensities.mid })
end

local err_warn = vim.schedule_wrap(function(group, attribute)
  vim.notify(
    string.format("failed to get highlight [%s] for attribute %s\n%s", group, attribute, debug.traceback()),
    "ERROR",
    {
      title = string.format("Highlight - get(%s)", group),
    }
  ) -- stylua: ignore
end)

---Get the value a highlight group whilst handling errors, fallbacks as well as returning a gui value
---If no attribute is specified return the entire highlight table
---in the right format
function M.get(group, attribute, fallback)
  assert(group, "cannot get a highlight without specifying a group name")
  local data = get_hl_as_hex { name = group }
  if not attribute then
    return data
  end

  assert(attrs[attribute], ("the attribute passed in is invalid: %s"):format(attribute))
  local color = data[attribute] or fallback
  if not color then
    if vim.v.vim_did_enter == 0 then
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          err_warn(group, attribute)
        end,
      })
    else
      vim.schedule(function()
        err_warn(group, attribute)
      end)
    end
    return "NONE"
  end
  return color
end

local function resolve_from_attribute(hl, attr)
  if type(hl) ~= "table" or not hl.from then
    return hl
  end
  local colour = M.get(hl.from, hl.attr or attr)
  if hl.alter then
    colour = M.tint(colour, hl.alter)
  end
  return colour
end

--- Sets a neovim highlight with some syntactic sugar. It takes a highlight table and converts
--- any highlights specified as `GroupName = {fg = { from = 'group'}}` into the underlying colour
--- by querying the highlight property of the from group so it can be used when specifying highlights
--- as a shorthand to derive the right colour.
--- For example:
--- ```lua
---   M.set({ MatchParen = {fg = {from = 'ErrorMsg'}}})
--- ```
--- This will take the foreground colour from ErrorMsg and set it to the foreground of MatchParen.
--- NOTE: this function must NOT mutate the options table as these are re-used when the colorscheme is updated
---
function M.set(ns, name, opts)
  if type(ns) == "string" and type(name) == "table" then
    opts, name, ns = name, ns, 0
  end

  vim.validate { opts = { opts, "table" }, name = { name, "string" }, ns = { ns, "number" } }

  local hl = opts.clear and {} or get_hl_as_hex { name = opts.inherit or name }
  for attribute, hl_data in pairs(opts) do
    local new_data = resolve_from_attribute(hl_data, attribute)
    if attrs[attribute] then
      hl[attribute] = new_data
    end
  end

  pcall(string.format('setting highlight "%s"', name), vim.api.nvim_set_hl, ns, name, hl)
end

---Apply a list of highlights
function M.all(hls, namespace)
  foreach(function(hl)
    M.set(namespace or 0, next(hl))
  end, hls)
end

function M.set_winhl(name, win_id, hls)
  local namespace = vim.api.nvim_create_namespace(name)
  M.all(hls, namespace)
  vim.api.nvim_win_set_hl_ns(win_id, namespace)
end

-------------------------------------------------------------------------------
-- Plugin highlights
-------------------------------------------------------------------------------
-- Takes the overrides for each theme and merges the lists, avoiding duplicates
-- and ensuring - priority is given to specific themes rather than the fallback
local function add_theme_overrides(theme)
  local res, seen = {}, {}
  local list = vim.list_extend(theme[vim.g.colors_name] or {}, theme["*"] or {})
  for _, hl in ipairs(list) do
    local n = next(hl)
    if not seen[n] then
      res[#res + 1] = hl
    end
    seen[n] = true
  end
  return res
end

---Apply highlights for a plugin and refresh on colorscheme change
function M.plugin(name, opts)
  -- Options can be specified by theme name so check if they have been or
  -- there is a general definition otherwise use the opts as is
  if opts.theme then
    opts = add_theme_overrides(opts.theme)
    if not next(opts) then
      return
    end
  end

  vim.schedule(function()
    M.all(opts)
  end)
  augroup(string.format("%sHighlightOverrides", name:gsub("^%l", string.upper)), {
    event = "ColorScheme",
    command = function()
      vim.schedule(function()
        M.all(opts)
      end)
    end,
  })
end

return M
