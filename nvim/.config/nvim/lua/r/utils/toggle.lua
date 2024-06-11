---@class r.utils.toggle
local M = {}

local function bool2str(bool)
  return bool and "on" or "off"
end

function M.option(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[2]
    else
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[1]
    end
    return RUtils.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  ---@diagnostic disable-next-line: no-unknown
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      RUtils.info("Enabled " .. option, { title = "Option" })
    else
      RUtils.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local nu = { number = true, relativenumber = true }
function M.number()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    RUtils.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    RUtils.info("Enabled line numbers", { title = "Option" })
  end
end

function M.diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

---@param buf? number
---@param value? boolean
function M.inlay_hints(buf, value)
  -- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { buf })

  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == "function" then
    ih(buf, value)
  elseif type(ih) == "table" and ih.enable then
    if value == nil then
      value = not ih.is_enabled { bufnr = buf or 0 }
    end
    ih.enable(value, { bufnr = buf })
  end
end

function M.buffer_autoformat(bufnr)
  bufnr = bufnr or 0
  local old_val = vim.b[bufnr].autoformat_enabled
  if old_val == nil then
    old_val = vim.g.autoformat_enabled
  end
  vim.b[bufnr].autoformat_enabled = not old_val
  RUtils.info(string.format("Buffer autoformatting %s", bool2str(vim.b[bufnr].autoformat_enabled)))
end

function M.background()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  vim.notify(string.format("background=%s", vim.go.background))
end

---@type {k:string, v:any}[]
M._maximized = nil
---@param state boolean?
function M.maximize(state)
  if state == (M._maximized ~= nil) then
    return
  end
  if M._maximized then
    for _, opt in ipairs(M._maximized) do
      vim.o[opt.k] = opt.v
    end
    M._maximized = nil
    vim.cmd "wincmd ="
  else
    M._maximized = {}
    local function set(k, v)
      table.insert(M._maximized, 1, { k = k, v = vim.o[k] })
      vim.o[k] = v
    end
    set("winwidth", 999)
    set("winheight", 999)
    set("winminwidth", 10)
    set("winminheight", 4)
    vim.cmd "wincmd ="
  end
  -- `QuitPre` seems to be executed even if we quit a normal window, so we don't want that
  -- `VimLeavePre` might be another consideration? Not sure about differences between the 2
  vim.api.nvim_create_autocmd("ExitPre", {
    once = true,
    group = vim.api.nvim_create_augroup("lazyvim_restore_max_exit_pre", { clear = true }),
    desc = "Restore width/height when close Neovim while maximized",
    callback = function()
      M.maximize(false)
    end,
  })
end

setmetatable(M, {
  __call = function(m, ...)
    return m.option(...)
  end,
})

return M
