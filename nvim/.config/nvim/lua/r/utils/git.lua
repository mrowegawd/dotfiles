---@class r.utils.git
local M = {}

local outputs = {}

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
    --for line in output:gmatch("[^\r\n]+") do

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
    RUtils.warn "No deleted files found."
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
        ["default"] = function(selected)
          local choice = nil
          RUtils.info(selected[1])
          for _, item in ipairs(deleted_files) do
            if item.display == selected[1] then
              choice = item
              break
            end
          end

          if choice then
            -- Bisa memakaig Gclog -- path
            -- Open diffview of the commit that deleted the file
            vim.cmd("DiffviewOpen " .. choice.commit .. "^.." .. choice.commit)
            RUtils.info("Opened diff for: " .. choice.path)
          end
        end,
      },
    }
  )
end

return M
