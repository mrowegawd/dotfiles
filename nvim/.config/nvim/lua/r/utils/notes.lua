---@class r.utils.notes
local M = {}

local load_plenary_plugin = function()
  local scan = require "plenary.scandir"
  local Path = require "plenary.path"
  return Path, scan
end

local load_opts_orgmode = function()
  local plugin = require("lazy.core.config").plugins["orgmode"]
  local Plugin = require "lazy.core.plugin"
  local opts_plugin = Plugin.values(plugin, "opts", false)
  return opts_plugin
end

local get_tbl_backup_and_todos = function(scan, is_ignore_file)
  is_ignore_file = is_ignore_file or false

  local opts_plugin = load_opts_orgmode()

  local org_backup = {}
  local org_todos = {}
  for _, x in pairs(opts_plugin.org_agenda_files) do
    local path
    if string.match(x, [[%*%*]], 1) then
      path = string.gsub(x, [[%/%*%*/%*$]], "")
    else
      path = string.gsub(x, [[%/%*$]], "")
    end
    local dirs = scan.scan_dir(path)
    for _, file_path in pairs(dirs) do
      if is_ignore_file and (not string.match(file_path, "org_archive")) then
        local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org$")
        if check_org_ext then
          local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
          table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
          table.insert(org_todos, basename_file)
        end
      else
        -- include file org_archive
        local check_org_ext = string.match(RUtils.file.basename(file_path), "%.org")
        if check_org_ext then
          local basename_file = string.gsub(RUtils.file.basename(file_path), ".org$", "")
          table.insert(org_backup, { full_path = file_path, path = path, basename_file = basename_file })
          table.insert(org_todos, basename_file)
        end
      end
    end
  end

  return org_backup, org_todos
end

local function opts_fzf(title, maps)
  vim.validate {
    maps = { maps, "table" },
    tilte = { title, "string" },
  }
  return {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = function()
      local lines = vim.api.nvim_get_option_value("lines", { scope = "global" })
      local columns = vim.api.nvim_get_option_value("columns", { scope = "global" })

      local win_height = math.ceil(lines * 0.5)
      local win_width = math.ceil(columns * 0.22)
      if columns < 120 then
        win_width = 60
      end
      local col = math.ceil((columns - lines) - 10)
      local row = math.ceil(lines - win_height)
      return {
        title = RUtils.fzflua.format_title(title, "󰈙"),
        width = win_width,
        height = win_height - 10,
        row = row,
        col = col,
        preview = {
          vertical = "down:55%", -- `up|down:size`
          horizontal = "right:45%", -- `right|left:size`
        },
      }
    end,
    actions = maps.actions,
    fzf_opts = maps.fzf_opts,
  }
end

function M.grep_title(is_live_grep)
  is_live_grep = is_live_grep or false

  local _, scan = load_plenary_plugin()
  local org_backup, _ = get_tbl_backup_and_todos(scan)

  local extract_str_rg = function(tbl)
    local newtbl = {}
    for _, x in pairs(tbl) do
      newtbl[#newtbl + 1] = x.full_path
    end
    return newtbl
  end

  local regex_title = [[^\*{1,}\s[\w<`].*$]]
  local cas = extract_str_rg(org_backup)

  local rg_opts = [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
    .. table.concat(cas, " ")
    .. " -e "

  if is_live_grep then
    return require("fzf-lua").live_grep {
      no_esc = true,
      rg_glob = false,
      rg_opts = rg_opts,
      winopts = {
        title = RUtils.fzflua.format_title("Grep Orgmode", RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.fire)),
      },
    }
  end

  return require("fzf-lua").grep {
    no_esc = true,
    rg_glob = false,
    rg_opts = rg_opts,
    search = regex_title,
    winopts = {
      title = RUtils.fzflua.format_title(
        "Grep Title Orgmode",
        RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.fire)
      ),
    },
  }
end

function M.open_agenda_file_lists()
  local Path, scan = load_plenary_plugin()
  local org_backup, org_todos = get_tbl_backup_and_todos(scan, true)

  local contains_match = function(str_path, str)
    if str_path:match(str) then
      return true
    end
    return false
  end

  local opts = {
    title = RUtils.config.icons.misc.pencil .. " Orgtodo Files",
    fzf_opts = {
      ["--header"] = [[^x:deleteCleanUp]],
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
