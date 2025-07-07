---@class r.utils.maim
local M = {}

-- Taken from: kiran94/maim.nvim
local executable = "maim"
local file_options = "-s"

local build_dir_img = function(input_png)
  assert(input_png ~= nil, "output_path must be a provided")
  assert(type(input_png) == "string", "output_path must be a string")

  local image_subdir, filetype_label
  if vim.bo.filetype == "norg" then
    image_subdir = "img"
    filetype_label = "norg"
  elseif vim.bo.filetype == "markdown" then
    image_subdir = "assets"
    filetype_label = "markdown"
  else
    RUtils.warn("unsupported filetype (" .. vim.bo.filetype .. ")", { title = "Maim: Insert Image" })
    return
  end

  local buffer_path = vim.api.nvim_buf_get_name(0)
  local buffer_directory = vim.fs.dirname(buffer_path)
  local image_directory_path = buffer_directory .. "/" .. image_subdir

  RUtils.file.create_dir(image_directory_path) -- will create dir if not exists

  local relative_image_path = "./" .. image_subdir .. "/" .. input_png
  local absolute_image_path = image_directory_path .. "/" .. input_png
  local maim_command = executable .. " " .. file_options .. " " .. absolute_image_path
  local image_insert_syntax = ".image " .. relative_image_path

  if filetype_label == "markdown" then
    relative_image_path = "./" .. image_subdir .. "/" .. input_png
    maim_command = executable .. " " .. file_options .. " " .. absolute_image_path
    image_insert_syntax = "![" .. input_png .. "](" .. relative_image_path .. ")" -- markdown
  end

  if RUtils.file.exists(absolute_image_path) then
    RUtils.warn "image name already exists"
    return
  end

  print(maim_command)
  vim.fn.systemlist(maim_command)

  return image_insert_syntax
end

M.insert = function()
  vim.ui.input({
    prompt = "Name Image: ",
  }, function(input)
    if input == nil or (input ~= nil and #input == 0) then
      return
    end

    input = input:gsub("%s", "_")
    input = input:gsub("%.", "_")
    local input_png = input .. ".png"
    local add_string_img = build_dir_img(input_png)
    if add_string_img then
      vim.cmd("normal A" .. add_string_img)
    end
  end)
end

return M
