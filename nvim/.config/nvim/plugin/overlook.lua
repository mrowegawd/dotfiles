local add = require("vim-pack").add

local lazy = require("utils.plugin").require_lazy

local UtilKey = lazy "utils.map"

add {
  {
    src = "WilliamHsieh/overlook.nvim",
    lazy = true,
    opts = function()
      return {
        ui = {
          size_ratio = 0.70,
          min_width = 40,
          min_height = 20,
          z_index_base = 50,
        },
       adapters = {
          peek_fzflua = {
            get = function(selection)
              local path = lazy("utils.cmd").__strip_str(selection[1])
              if not path then
                return
              end

              local lnum, col = 1, 1

              if path:match ":" then
                local parts = vim.split(path, ":")
                path = parts[1]
                lnum = tonumber(parts[2]) or lnum
                col = tonumber(parts[3]) or col
              end

              if path:match "~" then
                path = lazy("config").path.home .. path:gsub("~", "")
              end

              local bufnr = vim.fn.bufadd(path)

              return {
                target_bufnr = bufnr,
                lnum = lnum,
                col = col,
                title = path,
                win_col = 50,
                win_row = 5,
                win_width = 80,
                win_height = 25,
              }
            end,
          },
          peek_file_source = {
            get = function()
              if vim.bo.filetype ~= "orgagenda" then
                return
              end

              local item_headline = lazy("orgmode.api.agenda").get_headline_at_cursor()
              if not item_headline then
                return
              end

              local opts = { lnum = 0, col = 0 }

              ---@diagnostic disable-next-line: invisible
              local item_section = item_headline._section
              if item_section and item_section.file then
                local path = item_section.file.filename

                if path:match "~" then
                  path = lazy("config").path.home .. path:gsub("~", "")
                end

                local bufnr = vim.fn.bufadd(path)

                opts.target_bufnr = bufnr
                opts.title = path
                opts.lnum = item_headline.position.start_line
                opts.col = item_headline.position.end_col
              end

              local columns = vim.api.nvim_get_option_value("columns", { scope = "global" })
              local win_width = math.ceil(columns / 2)
              local win_height = math.floor(vim.o.lines * 0.3)
              local ui = vim.api.nvim_list_uis()[1]

              opts.win_relative = "editor"
              opts.win_row = math.floor((ui.height - win_height) / 2)
              opts.win_col = math.floor((ui.width - win_width) / 2)
              opts.win_width = 80
              opts.win_height = 30

              return opts
            end,
          },
        },
      }
    end,
  },
}

local ZOOM_RATIO = { width = 0.90, height = 0.90 }

local function load_peek()
  lazy("vim-pack").load_now "overlook.nvim"
  lazy("utils.monkeypatch.overlook").setup()
end

local function get_api()
  load_peek()
  return lazy "overlook.api"
end

local function close_host_stack()
  local instance = require("overlook.window").instances[vim.api.nvim_get_current_win()]
  if instance then
    pcall(instance.close_all, instance)
  end
end

local function peek_zoom()
  load_peek()
  close_host_stack()
  lazy("utils.monkeypatch.overlook").with_zoom(ZOOM_RATIO, function()
    require("overlook.api").peek_cursor()
  end)
end

---@param bufnr? integer
local function peek_buffer_info(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify("Invalid buffer", vim.log.levels.WARN)
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(filename, ":t")

  local function get_option(name)
    local ok, value = pcall(vim.api.nvim_get_option_value, name, {
      buf = bufnr,
    })

    return ok and value or "<unavailable>"
  end

  local function format_value(value)
    if type(value) == "string" then
      return value == "" and '""' or value
    end

    return vim.inspect(value)
  end

  local options = {
    "filetype",
    "buftype",
    "buflisted",
    "bufhidden",
    "modifiable",
    "modified",
    "readonly",
    "swapfile",
    "undofile",
    "fileformat",
    "fileencoding",
    "bomb",
    "endofline",
    "fixendofline",
    "expandtab",
    "shiftwidth",
    "tabstop",
    "softtabstop",
    "textwidth",
    "autoindent",
    "smartindent",
    "formatoptions",
    "commentstring",
    "iskeyword",
    "omnifunc",
    "indentexpr",
    "formatexpr",
  }

  local lines = {
    "BUFFER INFORMATION",
    string.rep("─", 40),
    "Name       : " .. (short_name ~= "" and short_name or "[No Name]"),
    "Path       : " .. (filename ~= "" and filename or "[No Name]"),
    "Buffer     : " .. bufnr,
    "Loaded     : " .. tostring(vim.api.nvim_buf_is_loaded(bufnr)),
    "Lines      : " .. vim.api.nvim_buf_line_count(bufnr),
    "Changed    : " .. vim.api.nvim_buf_get_changedtick(bufnr),
    "",
    "BUFFER OPTIONS",
    string.rep("─", 40),
  }

  for _, name in ipairs(options) do
    lines[#lines + 1] = string.format("%-16s : %s", name, format_value(get_option(name)))
  end

  local info_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(info_bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("filetype", "text", { buf = info_bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = info_bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = info_bufnr })

  close_host_stack()
  require("utils.monkeypatch.overlook").with_zoom(ZOOM_RATIO, function()
    require("overlook.window").open_popup {
      target_bufnr = info_bufnr,
      lnum = 1,
      col = 0,
      title = " Buffer Info: " .. (short_name ~= "" and short_name or "[No Name]"),
      temporary = true,
    }
  end)
end

local cmds = {
  --stylua: ignore
  { "<Leader>pd", function() get_api().peek_definition() end, "definition" },
  --stylua: ignore
  { "<Leader>pC", function() get_api().close_all() end, "close all" },
  -- stylua: ignore
  { "<Leader>pp", function() get_api().peek_cursor() end, "cursor" },
  --stylua: ignore
  { "<Leader>pr", function() get_api().restore_popup() end, "restore last popup" },
  --stylua: ignore
  { "<Leader>pR", function() get_api().restore_all_popups() end, "restore all popups" },
  --stylua: ignore
  { "<Leader>pb", peek_buffer_info, "buffer info & options" },
  --stylua: ignore
  { "<Leader>pa", peek_zoom, "zoom" },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], function()
    load_peek()
    cmd[2]()
  end, { desc = ("Peek: %s [overlook.nvim]"):format(cmd[3]) })
end
