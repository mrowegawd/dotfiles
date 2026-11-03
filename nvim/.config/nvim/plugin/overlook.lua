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

local function load_peek()
  lazy("vim-pack").load_now "overlook.nvim"
end

local function get_api()
  load_peek()
  return lazy "overlook.api"
end

local cmds = {
  --stylua: ignore
  { "<Leader>cpp", function() get_api().peek_definition() end, "definition" },
  --stylua: ignore
  { "<Leader>cpC", function() get_api().close_all() end, "close all" },
  --stylua: ignore
  { "<Leader>cpc", function() get_api().peek_cursor() end, "cursor" },
  --stylua: ignore
  { "<Leader>cpr", function() get_api().restore_popup() end, "restore popup" },
  --stylua: ignore
  { "<Leader>cpR", function() get_api().restore_all_popups() end, "restore all popup" },
}

for _, cmd in ipairs(cmds) do
  UtilKey.nnoremap(cmd[1], function()
    load_peek()
    cmd[2]()
  end, { desc = ("Peek: %s [overlook.nvim]"):format(cmd[3]) })
end
