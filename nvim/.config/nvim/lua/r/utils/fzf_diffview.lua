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
    git_dir = escape_chars(vim.uv.cwd() .. "/")
    return string.gsub(abs_filename, git_dir, "")
  end
end

function M.split_string(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function M.split_string_2(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, sep) do
    table.insert(t, str)
  end
  return t
end

function M.git_log_content(prompt, author, bufnr)
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
  query = query[1]
  if query ~= nil and query ~= "" and #query ~= 0 then
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

    -- if #prompt == 0 then
    -- prompt = query
    -- RUtils.info(prompt)
    -- end
  end

  prompt = prompt or ""
  author = author or ""
  return prompt, author
end

function M.git_log_content_finder(query, bufnr)
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

function M.git_dir()
  return find_first_ancestor_dir_or_file(RUtils.file.sanitize(vim.uv.cwd()), ".git")
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

local filename_commit = function(bufnr, first_commit, second_commit)
  if bufnr == nil then
    return nil, nil
  end

  local filename_on_head = M.git_relative_path(bufnr)

  local curr_name = file_name_on_commit(second_commit, filename_on_head)

  local prev_name = file_name_on_commit(first_commit, filename_on_head)

  return prev_name, curr_name
end

local git_relative_path_to_relative_path = function(git_relative_path)
  local git_dir = find_first_ancestor_dir_or_file(RUtils.file.sanitize(vim.uv.cwd()), ".git")
  local project_dir = RUtils.file.sanitize(vim.uv.cwd())

  local absolute_path = git_dir .. "/" .. git_relative_path
  project_dir = escape_chars(project_dir .. "/")
  local subbed, _ = string.gsub(absolute_path, project_dir, "")
  return subbed
end

local config = {}

function M.git_flags()
  local git_flags = config["git_flags"] or {}

  if type(git_flags) ~= "table" then
    vim.notify("git_flags must be a table", vim.log.levels.ERROR, { title = "Advanced Git Search" })
    return nil
  end

  return git_flags
end

function M.git_diff_flags()
  local git_diff_flags = config["git_diff_flags"] or {}

  if type(git_diff_flags) ~= "table" then
    vim.notify("git_diff_flags must be a table", vim.log.levels.ERROR, { title = "Advanced Git Search" })
    return nil
  end

  return git_diff_flags
end

function M.format_git_diff_command(command, git_flags_ix, git_diff_flags_ix)
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

local is_commit = function(commit_hash)
  local git_dir = function()
    return find_first_ancestor_dir_or_file(RUtils.file.sanitize(vim.uv.cwd()), ".git")
  end
  local command = "cd " .. git_dir() .. " && git cat-file -t " .. commit_hash

  local output = RUtils.cmd.execute_io_open(command)

  output = string.gsub(output, "\n", "")
  return output == "commit"
end

function M.git_diff_content(first_commit, second_commit, prompt, opts)
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

function M.git_diff_content_previewer(opts)
  opts = opts or { bufnr = nil }

  return fzf_lua.shell.stringify_cmd(function(items)
    local selection = items[1]
    if selection then
      local hash = string.sub(selection, 1, 7)

      local prev_commit = previous_commit_hash(hash)
      local prompt, _ = split_query_from_author(get_last_query())

      local preview_command = table.concat(
        M.git_diff_content(prev_commit, hash, string.format('"%s"', escape_term(prompt)), { bufnr = opts.bufnr }),
        " "
      )

      if prompt and prompt ~= "" and prompt ~= '""' then
        preview_command = preview_command
          .. string.format(" | GREP_COLORS='mt=3;30;43' grep -A 999999 -B 999999 --color=always '%s'", prompt)
      end

      return preview_command
    end
    return ""
  end, {}, "{} {q}")
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                      MAPPING UTILS                      │
-- ╰─────────────────────────────────────────────────────────╯

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

local function extract_git_hash_single(selected)
  if not selected and #selected == 0 then
    return
  end

  local selection = selected[1]
  local commit_hash = M.split_string(selection, " ")[1]
  if commit_hash then
    return commit_hash
  end
  RUtils.warn "open single: someting went wrong"
end

local function extract_git_hash(sel)
  local commit_hash, commit_msg = sel:match "^(%S+)%s+(.+)$"
  return commit_hash, commit_msg
end

local function parse_selected_git_commits(selected)
  if not selected or #selected == 0 then
    return
  end

  local items = {}
  local sel

  if selected and #selected == 1 then
    sel = selected[1]
    local commit_hash, commit_msg = extract_git_hash(sel)
    local fugitive_commit_filename = convert_path_hash_commit(commit_hash)

    RUtils.info("commit message: " .. commit_msg)

    items[#items + 1] = {
      lnum = 1,
      col = 1,
      text = commit_msg,
      module = commit_hash,
      filename = fugitive_commit_filename,
    }
    return items
  end

  for _, item in pairs(selected) do
    local commit_hash, commit_msg = extract_git_hash(item)
    local fugitive_commit_filename = convert_path_hash_commit(commit_hash)

    items[#items + 1] = {
      lnum = 1,
      col = 1,
      text = commit_msg,
      module = commit_hash,
      filename = fugitive_commit_filename,
    }
  end
  return items
end

local open_single_with_cmd = function(selected, direction)
  local commit_hash = extract_git_hash_single(selected)
  if commit_hash then
    vim.cmd(direction .. [[ | Gedit ]] .. commit_hash)
  end
end

function M.open_diff_view(commit, file_name, diff_plugin)
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

function M.open_commit(commit_hash, diff_plugin)
  local cmds
  if diff_plugin == "diffview" then
    cmds = "DiffviewOpen -uno " .. commit_hash .. "~.." .. commit_hash
    -- cmds = "DiffviewOpen -uno " .. "HEAD.." .. commit_hash .. "~1"
  elseif diff_plugin == "fugitive" then
    cmds = "Gedit " .. commit_hash
  end

  RUtils.info(cmds)
  vim.cmd(cmds)
end

function M.copy_to_clipboard(commit_hash)
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

function M.opts_diffview_log(is_repo, title, bufnr)
  vim.validate { is_repo = { is_repo, "string" } }

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
  --

  return RUtils.fzflua.open_dock_bottom {
    exec_empty_query = true,
    func_async_callback = false,
    fzf_opts = {
      ["--preview"] = preview_command(),
      ["--header"] = [[^y:copyhash  m-i:diffview  m-o:browser]],
    },
    winopts = { title = RUtils.fzflua.format_title(title, "󰈙") },
    actions = {
      ["alt-l"] = M.git_open_to_loc "Fzf_diffview",
      ["alt-L"] = M.git_open_to_loc "Fzf_diffview All",
      ["alt-q"] = M.git_open_to_qf "Fzf_diffview",
      ["alt-Q"] = M.git_open_to_qf "Fzf_diffview All",
      ["ctrl-s"] = M.git_open "split",
      ["ctrl-v"] = M.git_open "vsplit",
      ["ctrl-t"] = M.git_open "tabe",
      ["default"] = M.git_open_default(bufnr),
      ["alt-o"] = M.git_open_with_browser(),
      ["alt-i"] = M.git_open_with_diffview(),
      ["ctrl-y"] = M.git_copy_to_clipboard_or_yank(),
    },
  }
end

-- ╭─────────────────────────────────────────────────────────╮
-- │                        MAPPINGS                         │
-- ╰─────────────────────────────────────────────────────────╯

function M.git_open_to_loc(title)
  vim.validate { title = { title, "string" } }

  return function(selected, _)
    local items = parse_selected_git_commits(selected)
    RUtils.qf.save_to_qf_and_auto_open_qf(items, title, true)
  end
end

function M.git_open_to_qf(title)
  vim.validate { title = { title, "string" } }

  return function(selected, _)
    local items = parse_selected_git_commits(selected)
    RUtils.qf.save_to_qf_and_auto_open_qf(items, "Fzf_diffview")
  end
end

function M.git_open(direction)
  return function(selected, _)
    open_single_with_cmd(selected, direction)
  end
end

function M.git_open_default(bufnr)
  bufnr = bufnr or vim.fn.bufnr()

  return function(selected, _)
    local commit_hash = extract_git_hash_single(selected)
    M.open_diff_view(commit_hash, M.git_relative_path(bufnr), "diffview")
  end
end

function M.git_open_with_browser()
  return function(selected, _)
    local commit_hash = extract_git_hash_single(selected)
    if commit_hash then
      vim.api.nvim_command(":" .. get_browse_command(commit_hash))
    end
  end
end

function M.git_open_with_diffview()
  return function(selected, _)
    local commit_hash = extract_git_hash_single(selected)
    if commit_hash then
      M.open_commit(commit_hash, "diffview")
    end
  end
end

function M.git_open_with_compare_hash()
  return function(selected, _)
    local commit_hash = extract_git_hash_single(selected)
    if commit_hash then
      local gitsigns = require "gitsigns"
      gitsigns.diffthis(commit_hash)

      -- With vim-fugitive
      -- local cmdmsg = "Gvdiffsplit " .. commit_hash
      -- vim.cmd(cmdmsg)

      -- With diffview
      -- local cmdmsg = "DiffviewOpen -uno " .. commit_hash
      -- local cmdmsg = "Gvdiffsplit " .. commit_hash
      -- vim.cmd(cmdmsg)

      ---@diagnostic disable-next-line: undefined-field
      RUtils.info("Compare diff: current commit --> " .. commit_hash, { title = "FZFGit" })
    end
  end
end

function M.git_copy_to_clipboard_or_yank()
  return function(selected, _)
    local commit_hash = extract_git_hash_single(selected)
    if commit_hash then
      M.copy_to_clipboard(commit_hash)
      require("fzf-lua").actions.resume()
    end
  end
end

function M.git_grep_log()
  return function()
    require("fzf-lua").fzf_live(function(query)
      return M.git_log_content_finder(query, nil)
    end, RUtils.fzf_diffview.opts_diffview_log("repo", "Grep log history"))
  end
end

return M
