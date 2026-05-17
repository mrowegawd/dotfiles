local M = {}

-------------------------------------------------------------------------------
-- Notify helpers
-------------------------------------------------------------------------------

--- Centralized notify wrapper — all errors go through here for consistency.
---@param msg   string  message body
---@param level number  vim.log.levels.*
---@param title string  notification title
local function notify(msg, level, title)
  vim.schedule(function()
    vim.notify(msg, level, { title = title })
  end)
end

local function notify_err(msg, title)
  notify(msg, vim.log.levels.ERROR, title or "highlights.lua")
end

local function notify_warn(msg, title)
  notify(msg, vim.log.levels.WARN, title or "highlights.lua")
end

-------------------------------------------------------------------------------
-- Autocmd helpers
-------------------------------------------------------------------------------

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
    assert(accum ~= nil, "fold: callback must return the accumulator on every iteration")
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
    notify_warn(
      string.format(
        "Autocmd '%s' has unrecognized keys: [%s]\nValid keys are: %s",
        name,
        table.concat(incorrect, ", "),
        table.concat(autocmd_keys, ", ")
      ),
      "Autocmd: validate"
    )
  end
end

local function augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "augroup: 'User' is a reserved name and cannot be used as an augroup name")
  assert(#commands > 0, string.format("augroup '%s': at least one autocommand must be provided", name))

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

--- Run a function with xpcall and display an informative error on failure.
---@param context string   human-readable description of what is being attempted
---@param func    function
---@param ...     any      arguments forwarded to func
local function safe_call(context, func, ...)
  local args = { ... }
  return xpcall(func, function(err)
    local trace = debug.traceback(err, 2)
    notify_err(
      string.format("[safe_call] Failed while: %s\nArguments: %s\n\nTraceback:\n%s", context, vim.inspect(args), trace),
      "Highlight Error"
    )
  end, ...)
end

-------------------------------------------------------------------------------
-- Color utilities
-------------------------------------------------------------------------------

--- Valid highlight attributes accepted by nvim_set_hl.
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

--- Read a highlight group and convert numeric colors to hex strings (#rrggbb).
--- Silent variant — never emits warnings. Used by M.set() when inheriting from
--- a group that may not exist yet (e.g. a brand-new group being defined for
--- the first time). An empty result here is perfectly normal.
local function get_hl_as_hex(opts, ns)
  ns = ns or 0
  opts = opts or {}
  opts.link = opts.link ~= nil and opts.link or false

  local hl = vim.api.nvim_get_hl(ns, opts)
  hl.fg = hl.fg and ("#%06x"):format(hl.fg)
  hl.bg = hl.bg and ("#%06x"):format(hl.bg)
  hl.sp = hl.sp and ("#%06x"):format(hl.sp)
  return hl
end

--- Strict variant of get_hl_as_hex — warns when the group does not exist.
--- Used by M.get() and M.h() where the caller explicitly requested a group
--- by name, so an empty result is most likely a bug (typo, colorscheme not
--- loaded yet, etc.).
local function get_hl_as_hex_strict(opts, ns)
  local hl = get_hl_as_hex(opts, ns)

  -- nvim_get_hl silently returns {} for unknown groups instead of erroring.
  -- Emit a warning so that typos and unloaded colorschemes are surfaced early.
  if vim.tbl_isempty(hl) and opts and opts.name then
    notify_warn(
      string.format(
        "highlight group '%s' was not found or is not yet defined.\n"
          .. "  Make sure the colorscheme is loaded before accessing this group.",
        opts.name
      ),
      "Highlight: get_hl_as_hex"
    )
  end

  return hl
end

--- Convert a hex string ("#rrggbb") to an {r, g, b} table (values 0–255).
--- "NONE" and nil are treated as black.
local function hex_to_rgb(hex_str)
  if not hex_str or hex_str == "NONE" then
    return { 0, 0, 0 }
  end
  local original = hex_str
  hex_str = hex_str:lower()
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  if not hex_str:find(pat) then
    error(
      string.format(
        "hex_to_rgb: invalid color format '%s'\n"
          .. "  Expected format: #rrggbb (e.g. #ff0000, #1a2b3c)\n"
          .. "  Got: '%s'",
        original,
        original
      ),
      2
    )
  end
  local r, g, b = hex_str:match(pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

--- Convert r, g, b integers (0–255) to a lowercase hex string.
local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

--- Clamp a value to the [0, 255] range.
local function clamp(val)
  return math.max(0, math.min(255, math.floor(val + 0.5)))
end

--- Perceived luminance on a 0–255 scale.
local function luminance(rgb)
  return 0.299 * rgb[1] + 0.587 * rgb[2] + 0.114 * rgb[3]
end

-------------------------------------------------------------------------------
-- Public color manipulation functions
-------------------------------------------------------------------------------

--- Brighten a color toward white.
--- amount = 0.0 → no change, 1.0 → white
---@param color  string hex color
---@param amount number 0.0 – 1.0
function M.lighten(color, amount)
  assert(type(color) == "string", "lighten: 'color' must be a hex string, got: " .. type(color))
  assert(type(amount) == "number", "lighten: 'amount' must be a number, got: " .. type(amount))
  local c = hex_to_rgb(color)
  return rgb_to_hex(
    clamp(c[1] + (255 - c[1]) * amount),
    clamp(c[2] + (255 - c[2]) * amount),
    clamp(c[3] + (255 - c[3]) * amount)
  )
end

--- Darken a color toward black.
--- amount = 0.0 → no change, 1.0 → black
---@param color  string hex color
---@param amount number 0.0 – 1.0
function M.darken_pct(color, amount)
  assert(type(color) == "string", "darken_pct: 'color' must be a hex string, got: " .. type(color))
  assert(type(amount) == "number", "darken_pct: 'amount' must be a number, got: " .. type(amount))
  local c = hex_to_rgb(color)
  return rgb_to_hex(clamp(c[1] * (1 - amount)), clamp(c[2] * (1 - amount)), clamp(c[3] * (1 - amount)))
end

--- Adjust brightness by a signed percentage.
---   percent < 0 → darken  (e.g. -0.2 = 20% darker)
---   percent > 0 → brighten (e.g.  0.2 = 20% brighter)
---@param color   string hex color
---@param percent number signed float
function M.tint(color, percent)
  assert(type(color) == "string", "tint: 'color' must be a hex string, got: " .. type(color))
  assert(type(percent) == "number", "tint: 'percent' must be a number, got: " .. type(percent))
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  if not r or not g or not b then
    notify_warn(
      string.format(
        "tint: could not parse color '%s'.\n" .. "  Expected format: #rrggbb (e.g. #ff0000)\n" .. "  Returning 'NONE'.",
        color
      ),
      "Highlight: tint"
    )
    return "NONE"
  end
  return string.format("#%02x%02x%02x", clamp(r * (1 + percent)), clamp(g * (1 + percent)), clamp(b * (1 + percent)))
end

--- Blend two hex colors together.
---   alpha = 1.0 → pure fg color
---   alpha = 0.0 → pure bg color
---@param fg    string hex foreground color
---@param bg    string hex background color
---@param alpha number 0.0 – 1.0
---@return string blended hex color
function M.blend(fg, bg, alpha)
  assert(type(fg) == "string", "blend: 'fg' must be a hex string, got: " .. type(fg))
  assert(type(bg) == "string", "blend: 'bg' must be a hex string, got: " .. type(bg))
  assert(type(alpha) == "number", "blend: 'alpha' must be a number, got: " .. type(alpha))
  alpha = math.max(0.0, math.min(1.0, alpha))
  local f = hex_to_rgb(fg)
  local b = hex_to_rgb(bg)
  return string.format(
    "#%02x%02x%02x",
    clamp(alpha * f[1] + (1 - alpha) * b[1]),
    clamp(alpha * f[2] + (1 - alpha) * b[2]),
    clamp(alpha * f[3] + (1 - alpha) * b[3])
  )
end

--- Blend a color toward a background (legacy alias for M.blend).
---@param hex    string hex source color
---@param amount number 0.0 – 1.0
---@param bg     string hex background color
function M.darken(hex, amount, bg)
  assert(type(hex) == "string", "darken: 'hex' must be a hex string, got: " .. type(hex))
  assert(type(bg) == "string", "darken: 'bg' must be a hex string, got: " .. type(bg))
  assert(type(amount) == "number", "darken: 'amount' must be a number, got: " .. type(amount))
  return M.blend(hex, bg, math.abs(amount))
end

--- Blend a color toward an explicit target color.
---   amount = 1.0 → fully source color
---   amount = 0.0 → fully target color
---
--- Unlike `opacity` (which derives the background from a highlight group),
--- `transparency` accepts any hex color as the blend target.
---
---@param color  string hex source color
---@param target string hex target color to blend toward
---@param amount number 0.0 – 1.0
---@return string blended hex color
function M.transparency(color, target, amount)
  assert(type(color) == "string", "transparency: 'color' must be a hex string, got: " .. type(color))
  assert(type(target) == "string", "transparency: 'target' must be a hex string, got: " .. type(target))
  assert(type(amount) == "number", "transparency: 'amount' must be a number (0.0–1.0), got: " .. type(amount))
  return M.blend(color, target, amount)
end

--- Push a color away from mid-gray based on its perceived luminance.
---   Dark colors are pushed toward white.
---   Light colors are pushed toward black.
---   amount = 0.0 → no change, 1.0 → maximum push
---@param color  string hex color
---@param amount number 0.0 – 1.0
---@return string adjusted hex color
function M.contrast(color, amount)
  assert(type(color) == "string", "contrast: 'color' must be a hex string, got: " .. type(color))
  assert(type(amount) == "number", "contrast: 'amount' must be a number (0.0–1.0), got: " .. type(amount))
  amount = math.max(0.0, math.min(1.0, amount))
  local c = hex_to_rgb(color)
  local lum = luminance(c)
  local r, g, b
  if lum < 128 then
    -- dark color → push toward white
    r = clamp(c[1] + (255 - c[1]) * amount)
    g = clamp(c[2] + (255 - c[2]) * amount)
    b = clamp(c[3] + (255 - c[3]) * amount)
  else
    -- light color → push toward black
    r = clamp(c[1] * (1 - amount))
    g = clamp(c[2] * (1 - amount))
    b = clamp(c[3] * (1 - amount))
  end
  return rgb_to_hex(r, g, b)
end

--- Increase the saturation of a color.
---@param hex        string hex color
---@param percentage number 0.0 – 1.0  (1.0 = fully saturated, 0.0 = gray)
function M.increase_saturation(hex, percentage)
  assert(type(hex) == "string", "increase_saturation: 'hex' must be a string, got: " .. type(hex))
  assert(type(percentage) == "number", "increase_saturation: 'percentage' must be a number, got: " .. type(percentage))

  local rgb = hex_to_rgb(hex)
  local orig = { rgb[1], rgb[2], rgb[3] }
  local sorted = { rgb[1], rgb[2], rgb[3] }
  table.sort(sorted)

  local mn = sorted[1] / 255
  local mid = sorted[2] / 255
  local mx = sorted[3] / 255

  if mx == mn then
    -- color is already gray; saturation cannot be changed
    return hex
  end

  local new_max = mx
  local new_min = mx * (1 - percentage)
  local new_mid
  if mid == mn then
    new_mid = new_min
  else
    local prop = (mx - mid) / (mid - mn)
    new_mid = (prop * new_min + mx) / (prop + 1)
  end

  local new_sorted = {
    math.floor(new_min * 255),
    math.floor(new_mid * 255),
    math.floor(new_max * 255),
  }

  -- Restore values back into their original R/G/B channel positions.
  local orig_idx = { 1, 2, 3 }
  table.sort(orig_idx, function(a, b)
    return orig[a] < orig[b]
  end)

  local result = {}
  for rank, ch in ipairs(orig_idx) do
    result[ch] = new_sorted[rank]
  end

  return rgb_to_hex(result[1], result[2], result[3])
end

-------------------------------------------------------------------------------
-- Highlight get / set
-------------------------------------------------------------------------------

--- Emit an error when a highlight attribute is missing from a group.
local err_warn = vim.schedule_wrap(function(group, attribute)
  notify_err(
    string.format(
      "Highlight group '%s' has no attribute '%s'.\n"
        .. "  Make sure the colorscheme is loaded and the group is defined.\n\n"
        .. "Traceback:\n%s",
      group,
      attribute,
      debug.traceback()
    ),
    string.format("Highlight: get('%s')", group)
  )
end)

--- Thin wrapper: return the hex highlight table for a group.
function M.h(name)
  assert(type(name) == "string", "h: 'name' must be a string, got: " .. type(name))
  return get_hl_as_hex_strict { name = name }
end

--- Get a specific attribute from a highlight group.
--- If `attribute` is nil, the entire highlight table is returned.
---@param group     string   highlight group name
---@param attribute string?  attribute key ("fg", "bg", "sp", …)
---@param fallback  string?  returned when the attribute is missing
function M.get(group, attribute, fallback)
  assert(type(group) == "string", "get: 'group' must be a string, got: " .. type(group))

  local data = get_hl_as_hex_strict { name = group }
  if not attribute then
    return data
  end

  assert(
    attrs[attribute],
    string.format(
      "get: '%s' is not a valid attribute for group '%s'.\nValid attributes: %s",
      attribute,
      group,
      table.concat(vim.tbl_keys(attrs), ", ")
    )
  )

  local color = data[attribute] or fallback
  if not color then
    -- If Neovim has not finished initialising, defer the warning until LazyDone
    -- to avoid false positives for groups defined by plugins loaded later.
    if vim.v.vim_did_enter == 0 then
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          err_warn(group, attribute)
        end,
      })
    else
      err_warn(group, attribute)
    end
    return "NONE"
  end
  return color
end

-------------------------------------------------------------------------------
-- resolve_from_attribute
--
-- Resolves a highlight field written in the shorthand table syntax:
--
--   { from = "GroupName", attr = "fg"|"bg"|…, … }
--
-- Supported modifiers (applied in order):
--
--   alter        number   signed tint percent  (-0.3 = 30% darker, 0.2 = 20% brighter)
--   opacity      number   blend toward a background group (0.0 = bg, 1.0 = source color)
--                         bg source: hl.bg string/table, or Normal / NormalNote / NormalAiPrompt
--   transparency number   blend toward an explicit target color (0.0 = target, 1.0 = source color)
--                         target source: hl.color hex string or { from, attr } table
--   contrast     number   push away from mid-gray (0.0 = no change, 1.0 = maximum)
-------------------------------------------------------------------------------

--- Resolve the background color used for opacity blending.
--- Priority: hl.bg (string or {from,attr}) → contextual group → Normal
---@param hl table
---@return string hex background color
local function resolve_opacity_bg(hl)
  if hl.bg then
    if type(hl.bg) == "string" then
      return hl.bg
    elseif type(hl.bg) == "table" and hl.bg.from then
      return M.get(hl.bg.from, hl.bg.attr or "bg", "#000000")
    else
      notify_warn(
        string.format(
          "opacity: 'bg' field is invalid.\n"
            .. "  Use: bg = '#rrggbb'  or  bg = { from = 'GroupName', attr = 'bg' }\n"
            .. "  Got: %s\n"
            .. "  Falling back to Normal.bg.",
          vim.inspect(hl.bg)
        ),
        "Highlight: resolve_opacity_bg"
      )
    end
  end

  -- Select the appropriate fallback group based on context flags.
  local bg_group = "Normal"
  if hl.is_note then
    bg_group = "NormalNote"
  elseif hl.is_aiprompt then
    bg_group = "NormalAiPrompt"
  end

  return M.get(bg_group, "bg", "#000000")
end

--- Resolve the target color used for transparency blending.
--- Priority: hl.color (string or {from,attr}) → Normal bg
---@param hl table
---@return string hex target color
local function resolve_transparency_target(hl)
  if type(hl.color) == "string" then
    return hl.color
  elseif type(hl.color) == "table" and hl.color.from then
    return M.get(hl.color.from, hl.color.attr or "bg", "#000000")
  end

  -- No valid `color` field provided — warn and fall back to Normal.bg.
  notify_warn(
    string.format(
      "transparency: 'color' field is missing or invalid.\n"
        .. "  Use: color = '#rrggbb'  or  color = { from = 'GroupName', attr = 'bg' }\n"
        .. "  Got: %s\n"
        .. "  Falling back to Normal.bg.",
      vim.inspect(hl.color)
    ),
    "Highlight: resolve_transparency_target"
  )
  return M.get("Normal", "bg", "#000000")
end

local function resolve_from_attribute(hl, attr)
  if type(hl) ~= "table" or not hl.from then
    return hl
  end

  -- `from` must be a string naming a highlight group.
  if type(hl.from) ~= "string" then
    notify_err(
      string.format(
        "resolve: 'from' must be a string naming a highlight group.\n"
          .. "  Got: %s (%s)\n"
          .. "  Correct usage: { from = 'Normal', attr = 'bg' }",
        vim.inspect(hl.from),
        type(hl.from)
      ),
      "Highlight: resolve_from_attribute"
    )
    return "NONE"
  end

  local colour = M.get(hl.from, hl.attr or attr)

  -- 1. alter: signed brightness tint
  --    alter = -0.3  → 30% darker
  --    alter =  0.2  → 20% brighter
  if hl.alter ~= nil then
    if type(hl.alter) ~= "number" then
      notify_warn(
        string.format(
          "alter: value must be a number, got %s (%s). Field skipped.\n"
            .. "  Example: alter = -0.2 (darker) or alter = 0.3 (brighter)",
          type(hl.alter),
          vim.inspect(hl.alter)
        ),
        "Highlight: alter"
      )
    else
      colour = M.tint(colour, hl.alter)
    end
  end

  -- 2. opacity: blend toward a background highlight group
  --    1.0 → fully source color
  --    0.0 → fully background color
  if hl.opacity ~= nil then
    if type(hl.opacity) ~= "number" or hl.opacity < 0 or hl.opacity > 1 then
      notify_warn(
        string.format(
          "opacity: value must be a number between 0.0 and 1.0, got %s (%s). Field skipped.\n"
            .. "  0.0 = fully background, 1.0 = fully source color\n"
            .. "  Example: opacity = 0.7",
          type(hl.opacity),
          vim.inspect(hl.opacity)
        ),
        "Highlight: opacity"
      )
    else
      local bg = resolve_opacity_bg(hl)
      colour = M.blend(colour, bg, hl.opacity)
    end
  end

  -- 3. transparency: blend toward an explicit target color
  --    1.0 → fully source color
  --    0.0 → fully target color
  --    Requires the `color` field: a hex string or { from = "Group", attr = "bg" }
  if hl.transparency ~= nil then
    if type(hl.transparency) ~= "number" or hl.transparency < 0 or hl.transparency > 1 then
      notify_warn(
        string.format(
          "transparency: value must be a number between 0.0 and 1.0, got %s (%s). Field skipped.\n"
            .. "  0.0 = fully target color, 1.0 = fully source color\n"
            .. "  Example: transparency = 0.5, color = '#1a1a2e'",
          type(hl.transparency),
          vim.inspect(hl.transparency)
        ),
        "Highlight: transparency"
      )
    else
      local target = resolve_transparency_target(hl)
      colour = M.blend(colour, target, hl.transparency)
    end
  end

  -- 4. contrast: push away from mid-gray based on luminance
  --    0.0 → no change
  --    1.0 → maximum push (dark → white, light → black)
  if hl.contrast ~= nil then
    if type(hl.contrast) ~= "number" or hl.contrast < 0 or hl.contrast > 1 then
      notify_warn(
        string.format(
          "contrast: value must be a number between 0.0 and 1.0, got %s (%s). Field skipped.\n"
            .. "  0.0 = no change, 1.0 = maximum push away from mid-gray\n"
            .. "  Example: contrast = 0.4",
          type(hl.contrast),
          vim.inspect(hl.contrast)
        ),
        "Highlight: contrast"
      )
    else
      colour = M.contrast(colour, hl.contrast)
    end
  end

  return colour
end

-------------------------------------------------------------------------------
-- M.set / M.all / M.plugin
-------------------------------------------------------------------------------

--- Set a highlight group, automatically resolving any `{ from = … }` fields.
---
--- Examples:
---   M.set({ MatchParen = { fg = { from = "ErrorMsg" } } })
---   M.set({ Foo = { fg = { from = "Comment", alter = -0.2, opacity = 0.7 } } })
---   M.set({ Bar = { fg = { from = "Keyword", transparency = 0.5, color = "#1a1a2e" } } })
---   M.set({ Baz = { fg = { from = "String",  contrast = 0.4 } } })
---
--- NOTE: this function must NOT mutate the opts table — opts are reused when the colorscheme changes.
function M.set(ns, name, opts)
  -- Allow M.set(name, opts) with an implicit ns = 0.
  if type(ns) == "string" and type(name) == "table" then
    opts, name, ns = name, ns, 0
  end

  vim.validate {
    opts = { opts, "table" },
    name = { name, "string" },
    ns = { ns, "number" },
  }

  local hl = opts.clear and {} or get_hl_as_hex { name = opts.inherit or name }

  for attribute, hl_data in pairs(opts) do
    local new_data = resolve_from_attribute(hl_data, attribute)
    if attrs[attribute] then
      hl[attribute] = new_data
    end
  end

  safe_call(string.format("nvim_set_hl for group '%s' (ns=%d)", name, ns), vim.api.nvim_set_hl, ns, name, hl)
end

--- Apply a list of highlight definitions.
---@param hls       table[]  list of { GroupName = opts } tables
---@param namespace number?  nvim namespace (default 0)
function M.all(hls, namespace)
  foreach(function(hl)
    M.set(namespace or 0, next(hl))
  end, hls)
end

--- Apply highlights scoped to a specific window via a namespace.
function M.set_winhl(name, win_id, hls)
  local namespace = vim.api.nvim_create_namespace(name)
  M.all(hls, namespace)
  vim.api.nvim_win_set_hl_ns(win_id, namespace)
end

--- Merge theme-specific highlight overrides with the wildcard "*" entries.
--- Entries for the active colorscheme take priority over wildcard entries.
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

--- Register highlights for a plugin and re-apply them on every ColorScheme change.
---@param name string  plugin name (used as the augroup name)
---@param opts table   list of highlight definitions, or { theme = { … } }
function M.plugin(name, opts)
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

-------------------------------------------------------------------------------
-- Git diff color helper
-------------------------------------------------------------------------------

function M.get_git_fg_or_bg(hl_group)
  local blend_map = {
    DiffChange = "#FAB005",
    DiffAdd = "#10B981",
    DiffDelete = "#be5046",
  }

  local blend_color = blend_map[hl_group]
  if not blend_color then
    notify_warn(
      string.format(
        "get_git_fg_or_bg: unknown hl_group '%s'.\n" .. "  Supported groups: %s\n" .. "  Falling back to #be5046.",
        hl_group,
        table.concat(vim.tbl_keys(blend_map), ", ")
      ),
      "Highlight: get_git_fg_or_bg"
    )
    blend_color = "#be5046"
  end

  local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
  if hl.fg then
    return M.blend(("#%06x"):format(hl.fg), blend_color, 0.2)
  end
  if hl.bg then
    return M.blend(("#%06x"):format(hl.bg), blend_color, 0.2)
  end

  notify_warn(
    string.format(
      "get_git_fg_or_bg: group '%s' has neither fg nor bg.\n" .. "  Returning blend_color ('%s') directly.",
      hl_group,
      blend_color
    ),
    "Highlight: get_git_fg_or_bg"
  )
  return blend_color
end

return M
