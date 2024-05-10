---@class r.utils.async
local M = {}

function M.run_jobstart(command, on_stdout)
  vim.fn.jobstart(command, {
    on_stdout = on_stdout,
    on_stderr = on_stdout,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

function M.start()
  coroutine.wrap(function()
    print "test"
  end)()
end

return M
