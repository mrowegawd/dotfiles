local M = {}

local function send_notify(msg, levels)
  vim.notify(msg, levels)
end

function M.warn(msg)
  send_notify(msg, vim.log.levels.WARN)
end

function M.error(msg)
  send_notify(msg, vim.log.levels.ERROR)
end

function M.info(msg)
  send_notify(msg, vim.log.levels.INFO)
end

return M
