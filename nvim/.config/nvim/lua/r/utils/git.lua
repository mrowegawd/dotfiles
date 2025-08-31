---@class r.utils.git
local M = {}

local outputs = {}

local fzf_lua = require "fzf-lua"

local function get_files_from_branch(branch)
  local cmd = string.format("git ls-tree -r --name-only %s", branch)
  local result = vim.fn.systemlist(cmd)
  return result
end

-- local function open_file_from_branch(branch, filepath)
--   -- local cmd = string.format("git show %s:%s", branch, filepath)
--   -- local content = vim.fn.systemlist(cmd)
--   -- if vim.v.shell_error ~= 0 then
--   --   vim.notify("Error getting file: " .. filepath, vim.log.levels.ERROR)
--   --   return
--   -- end
--   --
--   -- -- Isi konten
--   -- vim.cmd "enew"
--   -- vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
--   -- vim.bo.filetype = vim.fn.fnamemodify(filepath, ":e") -- Set filetype berdasarkan ekstensi
--   -- vim.bo.modified = false
--   -- vim.bo.readonly = true
--   -- vim.bo.bufhidden = "wipe"
--   -- vim.bo.buftype = ""
--   -- vim.b.source_branch = branch
--   -- vim.b.source_path = filepath
-- end

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃ MAPPING                                                 ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local function default_select_deleted(deleted_files)
  return function(selected, _)
    if not selected then
      return
    end

    local sel = selected[1]
    if not sel then
      return {}
    end

    local sel_str = fzf_lua.utils.strip_ansi_coloring(sel)

    local choice = nil
    for _, item in ipairs(deleted_files) do
      local display_str = fzf_lua.utils.strip_ansi_coloring(item.display)
      ---@diagnostic disable-next-line: undefined-field
      RUtils.info(display_str)
      if display_str == sel_str then
        choice = item
        break
      end
    end

    if not choice then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.warn "Choice is empty!"
      return
    end

    -- Selain dengan `DiffviewOpen`, bisa`juga memakai :Gclog -- path
    vim.cmd("DiffviewOpen " .. choice.commit .. "^.." .. choice.commit)
    ---@diagnostic disable-next-line: undefined-field
    RUtils.info("Opened diff for: " .. choice.path)
  end
end

local function default_select_file_branch()
  return function(selected, _)
    if not selected then
      return
    end

    local branch = selected[1]
    local files = get_files_from_branch(branch)

    fzf_lua.fzf_exec(
      files,
      RUtils.fzflua.open_dock_bottom {
        prompt = RUtils.fzflua.padding_prompt(),
        winopts = { title = RUtils.fzflua.format_title "Files Branch - " },
        actions = {
          ["default"] = function(selected_file, _)
            if not selected then
              return
            end
            local filepath = selected_file[1]
            vim.cmd("Gedit " .. branch .. ":" .. filepath)
          end,
          ["ctrl-v"] = function(selected_file, _)
            if not selected then
              return
            end
            local filepath = selected_file[1]
            vim.cmd "vsplit"
            vim.cmd("Gedit " .. branch .. ":" .. filepath)
          end,
          ["ctrl-s"] = function(selected_file, _)
            if not selected then
              return
            end
            local filepath = selected_file[1]
            vim.cmd "split"
            vim.cmd("Gedit " .. branch .. ":" .. filepath)
          end,
          ["ctrl-t"] = function(selected_file, _)
            if not selected then
              return
            end
            local filepath = selected_file[1]
            vim.cmd "tabnew"
            vim.cmd("Gedit " .. branch .. ":" .. filepath)
          end,
        },
      }
    )
  end
end

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃ FUNC                                                    ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

function M.trace_file_event()
  local function get_deleted_files()
    -- local handle = io.popen("git log --diff-filter=R --summary")
    local handle = io.popen "git log --diff-filter=D --summary"
    if not handle then
      return {}
    end
    local output = handle:read "*a"
    handle:close()

    -- for commit, from, to in output:gmatch("commit ([%x]+).-rename from ([^\n]+).-rename to ([^\n]+)") do
    -- for commit, from, to in output:gmatch("commit ([%x]+).-rename ([^\n]+)") do
    -- for line in output:gmatch("[^\r\n]+") do

    -- for commit, path in output:gmatch "commit ([%x]+).-delete mode %d+ ([^\n]+)" do
    local current_commit = ""

    for line in output:gmatch "[^\r\n]+" do
      local commit = line:match "^commit ([%x]+)"
      if commit then
        current_commit = commit
      else
        -- local delete_line = line:match "^%s*delete mode %d+ .+"

        local path, _ = line:match "^%s*delete mode %d+ ([^\n]+)"
        -- RUtils.info(path)
        if path and current_commit ~= "" then
          -- table.insert(result, "commit " .. current_commit .. " " .. delete_line)

          local colored = string.format(
            "\27[33m%s\27[0m — \27[31m%s\27[0m",
            current_commit:sub(1, 8), -- Kuning
            path -- Merah
          )

          -- local display = string.format(
          --   "\27[34m%s\27[0m  \27[31m%s\27[0m  →  \27[32m%s\27[0m",
          --   commit:sub(1, 8), -- Blue commit
          --   from,             -- Red old path
          --   to                -- Green new path
          -- )
          table.insert(outputs, {
            -- display = current_commit:sub(1, 8) .. " | " .. path,
            display = colored,
            -- display = display,
            commit = current_commit,
            path = path,

            -- from = from,
            -- to = to,
          })
        end
      end
    end

    return outputs
  end

  local deleted_files = get_deleted_files()
  if #deleted_files == 0 then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn "No deleted files found"
    return
  end

  local fzf_contents = {}
  for _, x in pairs(outputs) do
    fzf_contents[#fzf_contents + 1] = x.display
  end

  require("fzf-lua").fzf_exec(
    fzf_contents,
    RUtils.fzflua.open_dock_bottom {
      winopts = { title = RUtils.fzflua.format_title("Track Commit for Renamed or Deleted File", "") },
      actions = {
        ["default"] = default_select_deleted(deleted_files),
        ["ctrl-s"] = default_select_deleted(deleted_files),
        ["ctrl-v"] = default_select_deleted(deleted_files),
        ["ctrl-t"] = default_select_deleted(deleted_files),
      },
    }
  )
end

function M.select_file_different_branch()
  local branches = vim.fn.systemlist "git branch --all --format='%(refname:short)'"
  fzf_lua.fzf_exec(
    branches,
    RUtils.fzflua.open_dock_bottom {
      prompt = RUtils.fzflua.padding_prompt(),
      winopts = {
        title = RUtils.fzflua.format_title "Select Branch",
      },
      actions = {
        ["default"] = default_select_file_branch(),
      },
    }
  )
end

return M
