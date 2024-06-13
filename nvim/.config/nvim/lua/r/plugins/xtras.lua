local Config = require "r.config"

-- Some extras need to be loaded before others
local prios = {
  ["r.plugins.extras.test.core"] = 1,
  ["r.plugins.extras.dap.core"] = 1,
  ["r.plugins.extras.ui.edgy"] = 2,
  ["r.plugins.extras.lang.typescript"] = 5,
  ["r.plugins.extras.formatting.prettier"] = 10,
  -- default priority is 50
  ["r.plugins.extras.editor.aerial"] = 100,
  ["r.plugins.extras.editor.outline"] = 100,
}

---@type string[]
local extras = RUtils.dedup(Config.json.data.extras)

local version = vim.version()
local v = version.major .. "_" .. version.minor

local compat = { "0_9" }

if vim.tbl_contains(compat, v) then
  extras[#extras + 1] = "r.plugins.compat.nvim-" .. v
end

table.sort(extras, function(a, b)
  local pa = prios[a] or 50
  local pb = prios[b] or 50
  if pa == pb then
    return a < b
  end
  return pa < pb
end)

---@param extra string
return vim.tbl_map(function(extra)
  return { import = extra }
end, extras)
