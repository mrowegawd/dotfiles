---@class r.utils.notes
local M = {}

local scan = require "plenary.scandir"
local Path = require "plenary.path"

local function opts_fzf(title, maps)
  vim.validate {
    maps = { maps, "table" },
    tilte = { title, "string" },
  }
  return {
    prompt = "   ",
    winopts = {
      title = " " .. title .. " ",
    },
    winopts_fn = function()
      local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
      local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

      local win_height = math.ceil(lines * 0.5)
      local win_width = math.ceil(columns * 0.22)
      local col = math.ceil((columns - lines) + 15)
      local row = math.ceil(lines - win_height)
      return {
        width = win_width - 10,
        height = win_height - 10,
        row = row,
        col = col,
        preview = {
          vertical = "down:55%", -- up|down:size
          horizontal = "right:45%", -- right|left:size
        },
      }
    end,
    actions = maps.actions,
    fzf_opts = maps.fzf_opts,
  }
end

function M.open_agenda_file_lists()
  local plugin = require("lazy.core.config").plugins["orgmode"]
  local Plugin = require "lazy.core.plugin"
  local opts_plugin = Plugin.values(plugin, "opts", false)

  local org_backup = {}
  local org_todos = {}
  for _, x in pairs(opts_plugin.org_agenda_files) do
    local path
    if string.match(x, [[%*%*]], 1) then
      path = string.gsub(x, [[%/%*%*/%*$]], "")
    else
      path = string.gsub(x, [[%/%*$]], "")
    end
    -- local path = string.gsub(x, [[%/%*$]], "")
    local dirs = scan.scan_dir(path)
    for _, file_path in pairs(dirs) do
      if not string.match(file_path, "org_archive") then
        local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org$")
        if check_org_ext then
          local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
          table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
          table.insert(org_todos, basename_file)
        end
      end
    end
  end

  -- vim.ui.select(
  --   org_todos,
  --   { prompt = RUtils.config.icons.misc.pencil .. " Open OrgTodos ", kind = "pojokan" },
  --   function(choice)
  --     if choice == nil then
  --       return
  --     end
  --     for _, x in pairs(org_backup) do
  --       if choice == x.basename_file then
  --         if RUtils.file.exists(x.full_path) then
  --           return vim.cmd(":edit " .. x.full_path)
  --         else
  --           return RUtils.warn("Path not exists: " .. x.full_path, { title = "orgmode" })
  --         end
  --       end
  --     end
  --   end

  local contains_match = function(str_path, str)
    if str_path:match(str) then
      return true
    end
    return false
  end

  local opts = {
    title = RUtils.config.icons.misc.pencil .. " Orgtodo Files",
    fzf_opts = {
      ["--header"] = [[ Ctrl-x: delete and clean up]],
    },
    actions = {

      ["default"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        for _, x in pairs(org_backup) do
          if sel == x.basename_file then
            if RUtils.file.exists(x.full_path) then
              return vim.cmd("edit " .. x.full_path)
            else
              return RUtils.warn("Path not exists: " .. x.full_path, { title = "Notes" })
            end
          end
        end
      end,

      ["ctrl-v"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        for _, x in pairs(org_backup) do
          if sel == x.basename_file then
            if RUtils.file.exists(x.full_path) then
              return vim.cmd("vsplit " .. x.full_path)
            else
              return RUtils.warn("Path not exists: " .. x.full_path, { title = "Notes" })
            end
          end
        end
      end,

      ["ctrl-s"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        for _, x in pairs(org_backup) do
          if sel == x.basename_file then
            if RUtils.file.exists(x.full_path) then
              return vim.cmd("split " .. x.full_path)
            else
              return RUtils.warn("Path not exists: " .. x.full_path, { title = "Notes" })
            end
          end
        end
      end,

      -- TODO: buat delete file, delete folder kosong
      ["ctrl-x"] = function()
        local project_todo_path = RUtils.config.path.dropbox_path .. "/neorg/orgmode/project-todo"
        local dirs = scan.scan_dir(project_todo_path, { depth = 2, add_dirs = true })

        for _, file_path in pairs(dirs) do
          local is_file_org = contains_match(tostring(file_path), ".org$")
          if is_file_org then
            if vim.fn.getfsize(file_path) <= 1 then
              local p = Path:new(file_path)
              if p:exists() then
                p:rm()
              end
            end
          else
            local p = Path:new(file_path)
            if p:exists() then
              p:rmdir()
            end
          end
        end

        RUtils.info("Clean up todos path done!", { title = "Notes" })
      end,
    },
  }

  require("fzf-lua").fzf_exec(org_todos, opts_fzf(opts.title, opts))
end
return M
