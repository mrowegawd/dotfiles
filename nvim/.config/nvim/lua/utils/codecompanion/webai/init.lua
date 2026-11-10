local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local config = lazy "utils.codecompanion.webai.config"

local function plugin_root()
  local src = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(src, ":h:h:h")
end

local function sidecar_script()
  return config.sidecar_script or (plugin_root() .. "/python/sidecar.py")
end

local function base_url()
  return ("http://%s:%d"):format(config.host, config.port)
end

local function is_healthy()
  local out = vim.fn.system { "curl", "-s", "-m", "2", base_url() .. "/health" }
  return vim.v.shell_error == 0 and out:find('"ok":true', 1, true) ~= nil
end

local function cdp_alive()
  local out = vim.fn.system {
    "curl",
    "-s",
    "-m",
    "2",
    ("http://127.0.0.1:%d/json/version"):format(config.cdp_port),
  }
  return vim.v.shell_error == 0 and out:find("webSocketDebuggerUrl", 1, true) ~= nil
end

local function launch_browser()
  local script = plugin_root() .. "/python/launch-browser.sh"
  if vim.fn.filereadable(script) == 0 then
    Log.warn("launch-browser.sh tidak ditemukan: " .. script)
    return
  end
  Log.info "Menjalankan Chrome dengan CDP..."
  vim.fn.jobstart({ script }, { detach = true })
  -- tunggu CDP siap (max 15 detik)
  vim.wait(15000, cdp_alive, 500)
end

-- function M.start_sidecar()
--   -- pastikan Chrome hidup dulu
--   -- ... sisanya (spawn sidecar) tetap
-- end

function M.start_sidecar()
  if not cdp_alive() then
    launch_browser()
    if not cdp_alive() then
      Log.error "Chrome gagal start dengan CDP. Cek launch-browser.sh."
      return false
    end
  end

  if is_healthy() then
    return true
  end

  local script = sidecar_script()
  if vim.fn.filereadable(script) == 0 then
    Log.error("sidecar tidak ditemukan: " .. script)
    return false
  end

  Log.info "Menjalankan sidecar..."
  vim.fn.jobstart({ config.python_cmd, script }, {
    detach = true,
    cwd = vim.fn.fnamemodify(script, ":h"),
    env = {
      WEB_AI_HOST = config.host,
      WEB_AI_PORT = tostring(config.port),
      WEB_AI_CDP_PORT = tostring(config.cdp_port),
      WEB_AI_PROVIDER = config.provider,
      WEB_AI_NEW_CHAT = config.new_chat and "true" or "false",
    },
  })
  vim.wait(15000, is_healthy, 300)
  if not is_healthy() then
    Log.error("sidecar gagal start. Cek: python3 " .. script)
    return false
  end
  return true
end

function M.health()
  local parts = {}
  parts[#parts + 1] = "sidecar: " .. (is_healthy() and "OK" or "OFFLINE")
  parts[#parts + 1] = "chrome CDP (:" .. config.cdp_port .. "): " .. (cdp_alive() and "OK" or "OFFLINE")
  Log.info(table.concat(parts, " | "))
end

function M.url()
  return base_url()
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  package.loaded["utils.codecompanion.webai.config"] = config
  if config.auto_start then
    vim.schedule(function()
      M.start_sidecar()
    end)
  end
end

return M
