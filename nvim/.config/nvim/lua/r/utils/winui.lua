---@class r.utils.winui
local M = {}

function M.open_float_preview()
  -- BUFFERS
  local input_buf = vim.api.nvim_create_buf(false, true)
  local preview_buf = vim.api.nvim_create_buf(false, true)

  -- DIMENSI
  local width = math.floor(vim.o.columns * 0.4)
  local height = math.floor(vim.o.lines * 0.3)

  -- FLOAT INPUT
  local input_win = vim.api.nvim_open_win(input_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = 2,
    col = 2,
    style = "minimal",
    border = "rounded",
    title = " INPUT ",
  })

  -- FLOAT PREVIEW
  local preview_win = vim.api.nvim_open_win(preview_buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = 2,
    col = width + 6,
    style = "minimal",
    border = "rounded",
    title = " PREVIEW ",
  })

  -- SYNC LIVE DENGAN vim.schedule
  vim.api.nvim_buf_attach(input_buf, false, {
    on_lines = function()
      vim.schedule(function()
        local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
      end)
    end,
  })
end

return M
