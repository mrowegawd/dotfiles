local validate = vim.validate
local fzf_lua = require "fzf-lua"

---@class r.utils.fzf_diffview
local M = {}

local last_query = ""

local set_last_query = function(query)
  last_query = query
end

local get_last_query = function()
  return last_query
end

local search_ancestors = function(startpath, func)
  validate { func = { func, "f" } }
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in RUtils.file.iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

local find_first_ancestor_dir_or_file = function(startpath, pattern)
  return search_ancestors(startpath, function(path)
    if
      RUtils.file.is_file(RUtils.file.path_join(path, pattern))
      or RUtils.file.is_dir(RUtils.file.path_join(path, pattern))
    then
      return path
    end
  end)
end

local escape_chars = function(x)
  x = x or ""
  return (
    x:gsub("%%", "%%%%")
      :gsub("^%^", "%%^")
      :gsub("%$$", "%%$")
      :gsub("%(", "%%(")
      :gsub("%)", "%%)")
      :gsub("%.", "%%.")
      :gsub("%[", "%%[")
      :gsub("%]", "%%]")
      :gsub("%*", "%%*")
      :gsub("%+", "%%+")
      :gsub("%-", "%%-")
      :gsub("%?", "%%?")
  )
end

local escape_term = function(x)
  x = x or ""
  return (
    x:gsub("%%", "\\%%")
      :gsub("^%^", "\\%^")
      :gsub("%$$", "\\%$")
      :gsub("%(", "\\%(")
      :gsub("%)", "\\%)")
      :gsub("%.", "\\%.")
      :gsub("%[", "\\%[")
      :gsub("%]", "\\%]")
      :gsub("%*", "\\%*")
      :gsub("%+", "\\%+")
      :gsub("%-", "\\%-")
      :gsub("%?", "\\%?")
  )
end

function M.git_relative_path(bufnr)
  local abs_filename = RUtils.file.absolute_path(bufnr)
  local git_dir = find_first_ancestor_dir_or_file(abs_filename, ".git")

  if git_dir and git_dir ~= "" then
    git_dir = escape_chars(git_dir .. "/")
    return string.gsub(abs_filename, git_dir, "")
  else
    -- try with current cwd (normally a git repo)
    git_dir = escape_chars(vim.fn.getcwd() .. "/")
    return string.gsub(abs_filename, git_dir, "")
  end
end

M.split_string = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

---@param prompt string|nil
---@param author string|nil
---@param bufnr number|nil
---@return table
M.git_log_content = function(prompt, author, bufnr)
  local command = {
    "git",
    "log",
    "--format='%h %as %an _ %s'",
  }

  if author and author ~= "" and author ~= '""' then
    table.insert(command, "--author=" .. author)
  end

  if prompt and prompt ~= "" and prompt ~= '""' then
    table.insert(command, "-G")
    table.insert(command, prompt)
    table.insert(command, "--pickaxe-all")
  end

  if bufnr then
    table.insert(command, "--follow")
    local filename = RUtils.file.absolute_path(bufnr)
    table.insert(command, filename)
  end

  return vim.iter(command):flatten():totable()
end

local split_query_from_author = function(query)
  local author = nil
  local prompt = nil
  if query ~= nil and query ~= "" then
    -- starts with @
    if query:sub(1, 1) == "@" then
      author = query:sub(2)
      return prompt, author
    end

    local split = M.split_string(query, "@")
    prompt = split[1]

    -- remove last space from prompt
    if prompt:sub(-1) == " " then
      prompt = prompt:sub(1, -2)
    end

    author = split[2]
  end

  prompt = prompt or ""
  author = author or ""
  return prompt, author
end

M.git_log_content_finder = function(query, bufnr)
  set_last_query(query)

  local prompt, author = split_query_from_author(query)

  author = author or ""
  local command = table.concat(
    M.git_log_content(string.format('"%s"', escape_term(prompt)), string.format('"%s"', author), bufnr),
    " "
  )

  return command
end

local previous_commit_hash = function(commit_hash)
  local command = "git rev-parse " .. commit_hash .. "~"

  local output = RUtils.cmd.execute_io_open(command)
  return string.gsub(output, "\n", "")
end

M.git_dir = function()
  return find_first_ancestor_dir_or_file(RUtils.file.sanitize(vim.fn.getcwd()), ".git")
end

local file_exists_on_commit = function(commit_hash, git_relative_file_path)
  local command = "cd "
    .. M.git_dir()
    .. " && git ls-tree --name-only "
    .. commit_hash
    .. " -- "
    .. git_relative_file_path

  local output = RUtils.cmd.execute_io_open(command)

  output = string.gsub(output, "\n", "")
  return output ~= ""
end

local all_commit_hashes = function()
  local command = "git rev-list HEAD"
  local output = RUtils.cmd.execute_io_open(command)

  return M.split_string(output, "\n")
end

local all_commit_hashes_touching_file = function(git_relative_file_path)
  local command = "cd " .. M.git_dir() .. " && git log --follow --pretty=format:'%H' -- " .. git_relative_file_path

  local output = RUtils.cmd.execute_io_open(command)
  return M.split_string(output, "\n")
end

--- Returns the file name of a file on a specific commit
--- @param commit_hash string
--- @param git_relative_file_path string
--- @return string|nil file name on commit
local file_name_on_commit = function(commit_hash, git_relative_file_path)
  if file_exists_on_commit(commit_hash, git_relative_file_path) then
    return git_relative_file_path
  end

  -- FIXME: this is a very naive implementation, but it always returns the
  -- correct filename for each commit (even if the commit didn't touch the file)

  -- first find index of the passed commit_hash in all_commit_hashes
  local all_hashes = all_commit_hashes()
  if all_hashes == nil then
    return nil
  end

  local index = 0
  for i, hash in ipairs(all_hashes) do
    -- compare on first 7 chars
    if string.sub(hash, 1, 7) == string.sub(commit_hash, 1, 7) then
      index = i
      break
    end
  end

  -- then find the first commit that has a different file name
  local touched_hashes = all_commit_hashes_touching_file(git_relative_file_path)
  if touched_hashes == nil then
    return nil
  end

  local last_touched_hash = nil
  for i = index, #all_hashes do
    local hash = all_hashes[i]
    -- search the hash in touched_hashes
    for _, touched_hash in ipairs(touched_hashes) do
      if touched_hash ~= nil and hash ~= nil and string.sub(touched_hash, 1, 7) == string.sub(hash, 1, 7) then
        last_touched_hash = touched_hash
        break
      end
    end

    if last_touched_hash ~= nil then
      break
    end
  end

  if last_touched_hash == nil then
    return nil
  end

  local command = "cd "
    .. M.git_dir()
    .. " && "
    .. "git --no-pager log --follow --pretty=format:'%H' --name-only "
    .. last_touched_hash
    .. "~.. -- "
    .. git_relative_file_path
    .. " | tail -1"

  local output = RUtils.cmd.execute_io_open(command)
  output = string.gsub(output, "\n", "")

  if file_exists_on_commit(commit_hash, output) then
    return output
  else
    return nil
  end
end

local empty_tree_commit = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"

---@param bufnr number|nil
---@param first_commit string
---@param second_commit string
---@return string|nil prev_name, string|nil curr_name
local function filename_commit(bufnr, first_commit, second_commit)
  if bufnr == nil then
    return nil, nil
  end

  local filename_on_head = M.git_relative_path(bufnr)

  local curr_name = file_name_on_commit(second_commit, filename_on_head)

  local prev_name = file_name_on_commit(first_commit, filename_on_head)

  return prev_name, curr_name
end

local git_relative_path_to_relative_path = function(git_relative_path)
  local git_dir = find_first_ancestor_dir_or_file(RUtils.file.sanitize(vim.fn.getcwd()), ".git")
  local project_dir = RUtils.file.sanitize(vim.fn.getcwd())

  local absolute_path = git_dir .. "/" .. git_relative_path
  project_dir = escape_chars(project_dir .. "/")
  local subbed, _ = string.gsub(absolute_path, project_dir, "")
  return subbed
end

local config = {}

M.git_flags = function()
  local git_flags = config["git_flags"] or {}

  if type(git_flags) ~= "table" then
    vim.notify("git_flags must be a table", vim.log.levels.ERROR, { title = "Advanced Git Search" })
    return nil
  end

  return git_flags
end

M.git_diff_flags = function()
  local git_diff_flags = config["git_diff_flags"] or {}

  if type(git_diff_flags) ~= "table" then
    vim.notify("git_diff_flags must be a table", vim.log.levels.ERROR, { title = "Advanced Git Search" })
    return nil
  end

  return git_diff_flags
end

--- @param command table
--- @param git_flags_ix number|nil
--- @param git_diff_flags_ix number|nil
--- @return table Command with configured git diff flags
M.format_git_diff_command = function(command, git_flags_ix, git_diff_flags_ix)
  git_flags_ix = git_flags_ix or 2
  git_diff_flags_ix = git_diff_flags_ix or 3

  local git_diff_flags = M.git_diff_flags()
  local git_flags = M.git_flags()

  if git_flags_ix > git_diff_flags_ix then
    vim.notify("git_flags must be inserted before git_diff_flags", vim.log.levels.ERROR)
  end

  if git_diff_flags ~= nil and #git_diff_flags > 0 then
    for i, flag in ipairs(git_diff_flags) do
      table.insert(command, git_diff_flags_ix + i - 1, flag)
    end
  end

  if git_flags ~= nil and #git_flags > 0 then
    for i, flag in ipairs(git_flags) do
      table.insert(command, git_flags_ix + i - 1, flag)
    end
  end

  return command
end

--- Returns true if hash is a commit
--- @param commit_hash string
--- @return boolean is_commit true if hash is commit
local is_commit = function(commit_hash)
  local git_dir = function()
    return find_first_ancestor_dir_or_file(RUtils.file.sanitize(vim.fn.getcwd()), ".git")
  end
  local command = "cd " .. git_dir() .. " && git cat-file -t " .. commit_hash

  local output = RUtils.cmd.execute_io_open(command)

  output = string.gsub(output, "\n", "")
  return output == "commit"
end

--- Shows a diff of 2 commit hashes and greps on prompt string
--- @param first_commit string
--- @param second_commit string
--- @param prompt string
--- @param opts table|nil
M.git_diff_content = function(first_commit, second_commit, prompt, opts)
  opts = opts or {}

  local prev_name, curr_name = filename_commit(opts.bufnr, first_commit, second_commit)

  if not is_commit(first_commit) then
    first_commit = empty_tree_commit
  end

  local base_cmd = {
    "git",
    "diff",
    "--color=always",
  }

  if prev_name == nil and curr_name == nil then
    table.insert(base_cmd, first_commit)
    table.insert(base_cmd, second_commit)
  elseif prev_name ~= nil and curr_name ~= nil then
    table.insert(base_cmd, first_commit .. ":" .. prev_name)
    table.insert(base_cmd, second_commit .. ":" .. curr_name)
  elseif prev_name == nil and curr_name ~= nil then
    table.insert(base_cmd, first_commit)
    table.insert(base_cmd, second_commit)
    table.insert(base_cmd, "--")
    table.insert(base_cmd, git_relative_path_to_relative_path(curr_name))
  end

  local command = M.format_git_diff_command(base_cmd)

  if prompt and prompt ~= "" and prompt ~= '""' then
    table.insert(command, "-G")
    table.insert(command, prompt)
  end

  return command
end

M.git_diff_content_previewer = function(opts)
  opts = opts or { bufnr = nil }

  return fzf_lua.shell.raw_preview_action_cmd(function(items)
    local selection = items[1]
    local hash = string.sub(selection, 1, 7)

    local prev_commit = previous_commit_hash(hash)
    local prompt, _ = split_query_from_author(get_last_query())

    local preview_command = table.concat(
      M.git_diff_content(prev_commit, hash, string.format('"%s"', escape_term(prompt)), { bufnr = opts.bufnr }),
      " "
    )

    if prompt and prompt ~= "" and prompt ~= '""' then
      preview_command = preview_command
        .. string.format(" | GREP_COLOR='3;30;105' grep -A 999999 -B 999999 --color=always '%s'", prompt)
    end

    return preview_command
  end)
end

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃ MAPPING ACTIONS                                         ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local diff_plugin = "diffview"

M.open_diff_view = function(commit, file_name)
  local cmds

  if file_name ~= nil and file_name ~= "" then
    if diff_plugin == "diffview" then
      cmds = "DiffviewOpen -uno " .. commit .. " -- " .. file_name
    elseif diff_plugin == "fugitive" then
      cmds = "Gvdiffsplit " .. commit .. ":" .. file_name
    end
  else
    if diff_plugin == "diffview" then
      cmds = "DiffviewOpen -uno " .. commit
    elseif diff_plugin == "fugitive" then
      cmds = "Gvdiffsplit " .. commit
    end
  end

  RUtils.info(cmds)
  vim.cmd(cmds)
end

M.open_commit = function(commit_hash)
  local cmds
  if diff_plugin == "diffview" then
    cmds = "DiffviewOpen -uno " .. commit_hash .. "~.." .. commit_hash
  elseif diff_plugin == "fugitive" then
    cmds = "Gedit " .. commit_hash
  end

  RUtils.info(cmds)
  vim.cmd(cmds)
end

---General action: Copy commit hash to system clipboard
---@param commit_hash string
M.copy_to_clipboard = function(commit_hash)
  RUtils.info("Copied commit hash " .. commit_hash .. " to clipboard", { title = "FZFGit" })

  vim.fn.setreg("+", commit_hash)
  vim.fn.setreg("*", commit_hash)
end

local get_browse_command = function(commit_hash)
  local cmd = "GBrowse {commit_hash}"
  local commit_pattern = "%{commit_hash%}"

  if string.find(cmd, commit_pattern) == nil then
    return cmd .. " " .. commit_hash
  end

  return string.gsub(cmd, commit_pattern, commit_hash)
end

M.opts_diffview_log = function(is_repo, title, bufnr)
  vim.validate {
    is_repo = { is_repo, "string" },
  }

  title = title or "Search > "
  bufnr = bufnr or vim.fn.bufnr()

  local preview_command
  if is_repo == "curbuf" then
    preview_command = function()
      return M.git_diff_content_previewer { bufnr = vim.fn.bufnr() }
    end
  else
    preview_command = function()
      return M.git_diff_content_previewer()
    end
  end

  -- TODO: cara load manual untuk fugitive ini gagal
  -- solusi sementara: kita load dari sisi load plugin dengan event,
  -- check config fugitive di plugins/git.lua
  -- local _ = package.loaded["vim-fugitive"]
  -- vim.cmd "packadd vim-fugitive"

  return {
    prompt = RUtils.fzflua.default_title_prompt(),
    exec_empty_query = true,
    func_async_callback = false,
    fzf_opts = {
      ["--preview"] = preview_command(),
      ["--header"] = [[^o:browser  ^y:copyhash  ^x:diffview  ^s/v/t:fugitive]],
    },
    winopts = { title = RUtils.fzflua.format_title(title, "󰈙") },
    actions = {
      -- TODO: open hash items qf -> open dengan gedit?
      ["ctrl-q"] = function(selected, _)
        local items = {}
        for _, item in pairs(selected) do
          local commit_hash = M.split_string(item, " ")[1]
          local commit_msg = vim.split(item, "_ ")[2]

          local function convert_path_hash_commit(short_hash)
            local handle = io.popen("git rev-parse " .. short_hash)
            if not handle then
              return ""
            end

            local full_hash = handle:read("*a"):gsub("%s+", "")
            handle:close()

            if full_hash == "" then
              return ""
            end

            -- Fugitive
            local path_commmit = "fugitive://" .. vim.fn.FugitiveGitDir() .. "//" .. full_hash

            -- Neogit
            -- local path_commmit = ??

            return path_commmit
          end

          local fugitive_commit_filename = convert_path_hash_commit(commit_hash)

          items[#items + 1] = {
            lnum = 1,
            col = 1,
            text = commit_msg,
            module = commit_hash,
            filename = fugitive_commit_filename,
          }
        end

        local what = {
          idx = "$",
          items = items,
          title = "Fzf_diffview",
        }

        vim.fn.setqflist({}, "r", what)
        vim.cmd "copen"
      end,
      ["ctrl-s"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        vim.cmd([[split | Gedit ]] .. commit_hash)
      end,
      ["ctrl-v"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        vim.cmd([[vsplit | Gedit ]] .. commit_hash)
      end,
      ["ctrl-t"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        vim.cmd([[tabe | Gedit ]] .. commit_hash)
      end,
      ["default"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        M.open_diff_view(commit_hash, M.git_relative_path(bufnr))
      end,
      ["ctrl-o"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        vim.api.nvim_command(":" .. get_browse_command(commit_hash))
      end,
      ["ctrl-x"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        M.open_commit(commit_hash)
      end,
      ["ctrl-y"] = function(selected, _)
        local selection = selected[1]
        local commit_hash = M.split_string(selection, " ")[1]

        M.copy_to_clipboard(commit_hash)
      end,
    },
  }
end

return M
