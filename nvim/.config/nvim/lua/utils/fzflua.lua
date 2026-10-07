local M = {}

local border = require("icons").border
local UtilCmd = require "utils.cmd"
local Log = require "utils.log"

local Fzflua

local function setup_fzflua()
  if Fzflua then
    return Fzflua
  end
  Fzflua = require "fzf-lua"
  return Fzflua
end

local function get_extracted_cmds(fzf_lua_, content_lines, only_key, is_dock)
  is_dock = is_dock or false
  only_key = only_key or false

  local pad = 1
  local padding_line = 1
  for idx, _ in pairs(content_lines) do
    local split_idx = vim.split(idx, "-")
    if pad < #split_idx[1] then
      pad = #split_idx[1]
    end
    local len_str = vim.fn.strdisplaywidth(idx)
    if padding_line < len_str then
      padding_line = len_str
    end
  end

  local lines = {}

  local str_cmds
  for idx, _ in pairs(content_lines) do
    if only_key then
      local str_x_hl = fzf_lua_.utils.ansi_from_hl("GitSignsAdd", idx)
      str_cmds = string.format("%s", str_x_hl)
    else
      local str_x = vim.split(idx, "-")
      local str_x_hl = fzf_lua_.utils.ansi_from_hl("GitSignsAdd", str_x[1])

      if is_dock then
        str_cmds = string.format("%-" .. (pad + 25) .. "s        %s", str_x_hl, str_x[2])
      else
        str_cmds = string.format("%-" .. (pad + 25) .. "s - %s", str_x_hl, str_x[2])
      end
    end
    table.insert(lines, str_cmds)
  end

  table.sort(lines)

  return lines, padding_line
end

local dropdown = function(opts)
  opts = opts or {}

  local fzf_tbl = {
    no_header = opts.no_header, -- disable default header
    prompt = M.padding_prompt(),
    fzf_opts = {
      ["--layout"] = "reverse", -- "reverse" or "default"
      ["--multi"] = true,
    },
    ---@diagnostic disable: missing-fields
    ---@type fzf-lua.config.Winopts
    winopts = {
      border = border.rectangle,
      title_pos = opts.winopts.title and "center" or nil,
      height = 20,
      width = math.floor(vim.o.columns / 2 + 8),
      col = 0.50,
      backdrop = 100,
      fullscreen = false,
      preview = {
        hidden = false,
        layout = "vertical",
        vertical = "up:50%",
        winopts = { number = true },
      },
    },
  }
  return vim.tbl_deep_extend("force", fzf_tbl, opts)
end

---@diagnostic disable: missing-fields
---@param opts fzf-lua.config.Defaults
function M.layout_pojokan(opts)
  local lines = vim.api.nvim_get_option_value("lines", { scope = "global" })
  local win_height = math.ceil(lines * 0.5)
  return dropdown(vim.tbl_deep_extend("force", {
    ---@type fzf-lua.config.Winopts
    winopts = {
      width = math.floor(math.min(60, vim.o.columns / 2)),
      height = win_height - 10,
      col = 0.85,
      row = 0.70,
    },
  }, opts))
end

---@param is_expand? boolean
function M.padding_prompt(is_expand)
  is_expand = is_expand or false
  local padding = "  "

  if is_expand then
    return padding .. " "
  end

  return padding
end

function M.open_cmd_bulk_center(commands, opts)
  Fzflua = setup_fzflua()

  local content_lines, padding_line = get_extracted_cmds(Fzflua, commands)

  local editor_cols = vim.o.columns
  local editor_lines = vim.o.lines

  local width = math.min((padding_line + 20) / editor_cols, 0.7)
  width = math.max(width, 0.25)

  local height = math.min((#content_lines + 5) / editor_lines, 0.6)
  height = math.max(height, 0.15)

  Fzflua.fzf_exec(
    content_lines,
    M.layout_pojokan(vim.tbl_deep_extend("force", {
      winopts = {
        title = opts.title and opts.title or "",
        height = height,
        width = width,
        col = 0.50,
        row = 0.50,
      },
      actions = {
        ["default"] = function(selected, _)
          if not selected then
            return
          end

          local sel = selected[1]
          if not sel then
            return
          end

          local display_str = Fzflua.utils.strip_ansi_coloring(sel)
          local display_str_split = vim.split(display_str, "-")

          local build_idx_cmd = UtilCmd.strip_whitespaces(display_str_split[1])
            .. " - "
            .. UtilCmd.strip_whitespaces(display_str_split[2])

          if commands[build_idx_cmd] then
            commands[build_idx_cmd]()
            return
          end

          Log.warn("Selection does not match!\n--> " .. vim.inspect(commands))
        end,
      },
    }, opts))
  )
end

return M
