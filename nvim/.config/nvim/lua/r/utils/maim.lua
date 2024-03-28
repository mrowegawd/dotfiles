---@class r.utils.maim
local M = {}

-- Taken from: kiran94/maim.nvim
local executable = "maim"
local file_options = "-s"

M.build_dir_img = function(input_png)
  assert(input_png ~= nil, "output_path must be a provided")
  assert(type(input_png) == "string", "output_path must be a string")

  local img_dir_path, img_for
  if vim.bo.filetype == "norg" then
    img_dir_path = "img"
    img_for = "norg"
  elseif vim.bo.filetype == "markdown" then
    img_dir_path = "assets"
    img_for = "markdown"
  else
    RUtils.warn("unsupported filetype (" .. vim.bo.filetype .. ")", { title = "Maim: Insert Image" })
    return
  end

  local current_buffer = vim.api.nvim_buf_get_name(0)
  local current_directory = vim.fs.dirname(current_buffer)
  local fullpath = current_directory .. "/" .. img_dir_path
  RUtils.file.create_dir(fullpath) -- will create dir if not exists

  local locate_img_path = "./" .. img_dir_path .. "/" .. input_png -- neorg
  fullpath = fullpath .. "/" .. input_png
  local command = executable .. " " .. file_options .. " " .. fullpath
  local add_string_img = ".image " .. locate_img_path
  if img_for == "markdown" then
    locate_img_path = "./" .. img_dir_path .. "/" .. input_png
    command = executable .. " " .. file_options .. " " .. fullpath
    add_string_img = "![" .. input_png .. "](" .. locate_img_path .. ")" -- markdown
  end

  if RUtils.file.exists(fullpath) then
    RUtils.warn "image name already exists"
    return
  end

  vim.fn.systemlist(command)

  return add_string_img
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
    local add_string_img = M.build_dir_img(input_png)
    if add_string_img then
      vim.cmd("normal A" .. add_string_img)
    end
  end)
end

return M
