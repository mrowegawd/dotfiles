---@class r.utils.lazydocker
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.open(...)
  end,
})

M.theme_path = vim.fn.stdpath "cache" .. "/lazydocker/config.yml"

-- Opens lazydocker
function M.open(opts)
  if vim.g.lazygit_theme ~= nil then
    RUtils.deprecate("vim.g.lazygit_theme", "vim.g.lazygit_config")
  end

  opts = vim.tbl_deep_extend("force", {}, {
    esc_esc = false,
    ctrl_hjkl = false,
  }, opts or {})

  local cmd = { "lazydocker" }
  vim.list_extend(cmd, opts.args or {})

  if vim.g.lazygit_config then
    if RUtils.lazygit.dirty then
      RUtils.lazygit.update_config()
    end

    if not M.config_dir then
      local Process = require "lazy.manage.process"
      local ok, lines = pcall(Process.exec, { "lazygit", "-cd" })
      if ok then
        M.config_dir = lines[1]
        vim.env.LG_CONFIG_FILE = M.config_dir .. "/config.yml" .. "," .. M.theme_path
      else
        ---@diagnostic disable-next-line: cast-type-mismatch
        ---@cast lines string
        RUtils.error(
          { "Failed to get **lazygit** config directory.", "Will not apply **lazygit** config.", "", "# Error:", lines },
          { title = "lazygit" }
        )
      end
    end
  end

  return RUtils.terminal(cmd, opts)
end

return M
