local Util = require "r.utils"
local M = {}

-- Taken from: kiran94/maim.nvim
local executable = "maim"
local file_options = "-s"

M.build_dir_img = function(output_path, img_dir_path, img_path)
  assert(output_path ~= nil, "output_path must be a provided")
  assert(type(output_path) == "string", "output_path must be a string")

  local current_buffer = vim.api.nvim_buf_get_name(0)
  local current_directory = vim.fs.dirname(current_buffer)
  local fullpath = current_directory .. "/" .. img_dir_path
  Util.file.create_dir(fullpath) -- will create dir if not exists

  return "./" .. img_path .. "/" .. output_path
end

M.insert = function()
  local img_dir_path, img_for
  if vim.bo.filetype == "norg" then
    img_dir_path = "img"
    img_for = "norg"
  elseif vim.bo.filetype == "markdown" then
    img_dir_path = "assets"
    img_for = "markdown"
  else
    Util.warn("unsupported filetype (" .. vim.bo.filetype .. ")", { title = "Maim: Insert Image" })
    return
  end

  vim.ui.input({
    prompt = "Name Image: ",
  }, function(input)
    if input == nil or (input ~= nil and #input == 0) then
      return
    end

    input = input:gsub("%s", "_")
    input = input:gsub("%.", "_")
    local input_png = input .. ".png"
    local command_output = M.build_dir_img(input_png, img_dir_path, img_dir_path)

    local add_string_img = ".image " .. command_output -- neorg
    if img_for == "markdown" then
      add_string_img = "![" .. input .. "](" .. command_output .. ")" -- markdown
    end

    local command = executable .. " " .. file_options .. " " .. command_output

    vim.fn.systemlist(command)

    vim.cmd("normal A" .. add_string_img)
  end)
end

return M
