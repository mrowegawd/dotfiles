local fmt, notify, api, L = string.format, vim.notify, vim.api, vim.log.levels

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
      vim.notify(msg, "error", { title = fmt("Autocmd: %s", name) })
    end)
  end
end

local function augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, fmt("You must specify at least one autocommand for %s", name))
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    api.nvim_create_autocmd(autocmd.event, {
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

local err_warn = vim.schedule_wrap(function(group, attribute)
  notify(fmt("failed to get highlight %s for attribute %s\n%s", group, attribute, debug.traceback()), "ERROR", {
    title = fmt("Highlight - get(%s)", group),
  }) -- stylua: ignore
end)

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
  return fmt("#%02x%02x%02x", blend(r), blend(g), blend(b))
end

local function get_hl_as_hex(opts, ns)
  ns, opts = ns or 0, opts or {}
  opts.link = opts.link ~= nil and opts.link or false
  local hl = api.nvim_get_hl(ns, opts)
  hl.fg = hl.fg and ("#%06x"):format(hl.fg)
  hl.bg = hl.bg and ("#%06x"):format(hl.bg)
  return hl
end

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
      api.nvim_create_autocmd("User", {
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

local function pcall(msg, func, ...)
  local args = { ... }
  if type(msg) == "function" then
    local arg = func
    args, func, msg = { arg, unpack(args) }, msg, nil
  end
  return xpcall(func, function(err)
    msg = debug.traceback(msg and fmt("%s:\n%s\n%s", msg, vim.inspect(args), err) or err)
    vim.schedule(function()
      vim.notify(msg, L.ERROR, { title = "ERROR" })
    end)
  end, unpack(args))
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

  pcall(fmt('setting highlight "%s"', name), api.nvim_set_hl, ns, name, hl)
end

local function foreach(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

---Apply a list of highlights
function M.all(hls, namespace)
  foreach(function(hl)
    M.set(namespace or 0, next(hl))
  end, hls)
end

function M.set_winhl(name, win_id, hls)
  local namespace = api.nvim_create_namespace(name)
  M.all(hls, namespace)
  api.nvim_win_set_hl_ns(win_id, namespace)
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
  M.all(opts)

  -- capitalise the name for autocommand convention sake
  augroup(fmt("%sHighlightOverrides", name:gsub("^%l", string.upper)), {
    event = "ColorScheme",
    command = function()
      -- Defer resetting these highlights to ensure they apply after other overrides
      vim.defer_fn(function()
        M.all(opts)
      end, 1)
    end,
  })
end

-- M.highlight = {
--   get = get,
--   set = set,
--   all = all,
--   tint = tint,
--   plugin = plugin,
--   set_winhl = set_winhl,
-- }

return M
