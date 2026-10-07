local M = {}

local last_query = ""
local UtilCmd = require "utils.cmd"
local UtilFile = require "utils.file"
local UtilQf = require "utils.qf"

local Log = require "utils.log"

local Fzflua

local setup_fzflua = function()
  if not Fzflua then
    Fzflua = require "fzf-lua"
  end

  return Fzflua
end

local status_cmd_git = {
  ["open commit only"] = function(commit_hash)
    -- cmds = "DiffviewOpen -uno " .. "HEAD.." .. commit_hash .. "~1"
    -- return "DiffviewOpen -uno " .. commit_hash .. "~.." .. commit_hash
    return "DiffviewOpen " .. commit_hash .. "^!"
  end,
  ["open commit only with fugitive"] = function(commit_hash)
    return "Gedit " .. commit_hash
  end,
  ["open commit only with gitsigns"] = function(commit_hash)
    return "Gedit " .. commit_hash
  end,
  ["compare commit diff to head"] = function(commit_hash)
    ---@diagnostic disable-next-line: undefined-field
    Log.info("Checking all files from commit " .. commit_hash .. " to HEAD...")
    return "DiffviewOpen " .. commit_hash .. "~..HEAD"
  end,
}

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
  for path in UtilFile.iterate_parents(startpath) do
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
    if UtilFile.is_file(UtilFile.path_join(path, pattern)) or UtilFile.is_dir(UtilFile.path_join(path, pattern)) then
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
  local abs_filename = UtilFile.absolute_path(bufnr)
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
    local filename = UtilFile.absolute_path(bufnr)
    table.insert(command, filename)
  end

  ---@diagnostic disable-next-line: undefined-field
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

    if prompt:sub(-1) == " " then
      prompt = prompt:sub(1, -2)
    end

    author = split[2]
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

  local output = UtilCmd.execute_io_open(command)
  return string.gsub(output, "\n", "")
end

function M.git_dir()
  local cwd = vim.uv.cwd()
  if cwd then
    return find_first_ancestor_dir_or_file(UtilFile.sanitize(cwd), ".git")
  end
end

local file_exists_on_commit = function(commit_hash, git_relative_file_path)
  local command = "cd "
    .. M.git_dir()
    .. " && git ls-tree --name-only "
    .. commit_hash
    .. " -- "
    .. git_relative_file_path

  local output = UtilCmd.execute_io_open(command)

  output = string.gsub(output, "\n", "")
  return output ~= ""
end

local all_commit_hashes = function()
  local command = "git rev-list HEAD"
  local output = UtilCmd.execute_io_open(command)

  return M.split_string(output, "\n")
end

local all_commit_hashes_touching_file = function(git_relative_file_path)
  local command = "cd " .. M.git_dir() .. " && git log --follow --pretty=format:'%H' -- " .. git_relative_file_path

  local output = UtilCmd.execute_io_open(command)
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

  local output = UtilCmd.execute_io_open(command)
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
  local cwd = vim.uv.cwd()
  if not cwd then
    return
  end

  local git_dir = find_first_ancestor_dir_or_file(UtilFile.sanitize(cwd), ".git")
  local project_dir = UtilFile.sanitize(cwd)

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

---@param commit_hash string
---@return boolean
local is_commit = function(commit_hash)
  local cwd = vim.uv.cwd()
  if not cwd then
    return false
  end

  local git_dir = function()
    return find_first_ancestor_dir_or_file(UtilFile.sanitize(cwd), ".git")
  end

  local command = "cd " .. git_dir() .. " && git cat-file -t " .. commit_hash
  local output = UtilCmd.execute_io_open(command)
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

  local fzf_shell = require "fzf-lua.shell"

  return fzf_shell.stringify_cmd(function(items)
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

local function vsplit_layout()
  local total_wins = UtilCmd.get_total_wins()
  if #total_wins == 1 then
    vim.cmd "vsplit"
  end
end

---@param short_hash string
---@return string|nil, string
local function convert_path_hash_commit(short_hash)
  local handle = io.popen("git rev-parse " .. short_hash)
  if not handle then
    return nil, "failed command `git rev-parse " .. short_hash .. "`"
  end

  local full_hash = handle:read("*a"):gsub("%s+", "")
  handle:close()

  if full_hash == "" then
    return nil, "failed read gsub"
  end

  -- Fugitive
  local path_commmit = "fugitive://" .. vim.fn.FugitiveGitDir() .. "//" .. full_hash

  -- Neogit
  -- local path_commmit = ??

  return path_commmit, ""
end

---@return string|nil, string|nil
local function extract_git_hash_single(selected)
  local commit_hash = M.split_string(selected, " ")[1]
  if commit_hash then
    return commit_hash, nil
  end
  return nil, "split string `" .. selected .. "`"
end

local function extract_git_hash(sel)
  local commit_hash, commit_msg = sel:match "^(%S+)%s+(.+)$"
  return commit_hash, commit_msg
end

---@return boolean , table|nil, string
local function parse_selected_git_commits(selected)
  if not selected or #selected == 0 then
    return false, nil, ""
  end

  local items = {}

  for _, item in pairs(selected) do
    local commit_hash, commit_msg = extract_git_hash(item)
    local fugitive_commit_filename, err_msg = convert_path_hash_commit(commit_hash)
    if not fugitive_commit_filename then
      return false, nil, err_msg
    end

    items[#items + 1] = {
      lnum = 1,
      col = 1,
      text = commit_msg,
      module = commit_hash,
      filename = fugitive_commit_filename,
    }
  end
  return true, items, ""
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
      -- cmds = "DiffviewOpen -uno " .. commit .. " -- " .. file_name
      cmds = "DiffviewOpen " .. commit .. "^!"
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

  Log.info(cmds)
  vim.cmd(cmds)
end

function M.open_commit(commit_hash, state_cmd)
  local get_cmd = status_cmd_git[state_cmd]
  if not get_cmd then
    ---@diagnostic disable-next-line: undefined-field
    Log.warn("'" .. state_cmd .. "' its unknown command")
    return
  end

  local cmds = get_cmd(commit_hash)

  if cmds then
    ---@diagnostic disable-next-line: undefined-field
    Log.info(cmds)
    vsplit_layout()
    vim.cmd(cmds)
  end
end

function M.copy_to_clipboard(commit_or_branch_name)
  Log.info("Copied `" .. commit_or_branch_name .. "` to clipboard")

  vim.fn.setreg("+", commit_or_branch_name)
  vim.fn.setreg("*", commit_or_branch_name)
end

local get_browse_command = function(commit_hash)
  local cmd = "GBrowse {commit_hash}"
  local commit_pattern = "%{commit_hash%}"

  if string.find(cmd, commit_pattern) == nil then
    return cmd .. " " .. commit_hash
  end

  return string.gsub(cmd, commit_pattern, commit_hash)
end

---@param is_repo string
---@param title string
---@param bufnr? integer
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

  return {
    exec_empty_query = true,
    func_async_callback = false,
    fzf_opts = {
      ["--preview"] = preview_command(),
      ["--header"] = [[a-c:copyhash  ^b:browser  ^o:diffview]],
    },
    actions = {
      ["alt-l"] = M.git_open_to_loc "Fzf_diffview",
      ["alt-L"] = M.git_open_to_loc "Fzf_diffview All",
      ["alt-q"] = M.git_open_to_qf "Fzf_diffview",
      ["alt-Q"] = M.git_open_to_qf "Fzf_diffview All",

      ["alt-c"] = M.git_copy_to_clipboard_or_yank(),

      ["ctrl-s"] = M.git_open "split",
      ["ctrl-v"] = M.git_open "vsplit",
      ["ctrl-t"] = M.git_open "tabe",
      ["default"] = M.git_open "vsplit",

      ["ctrl-b"] = M.git_open_with_browser(),
      ["ctrl-o"] = M.git_open_with_diffview(),
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
    local list_items = { items = items, title = title }
    UtilQf.save_to_qf_and_auto_open_qf(list_items, true)
  end
end

function M.git_open_to_qf(title)
  vim.validate { title = { title, "string" } }

  return function(selected, _)
    local ok, items, err_msg = parse_selected_git_commits(selected)
    if not ok then
      Log.error(err_msg)
      return
    end

    local list_items = { items = items, title = "fzf_diffview" }
    UtilQf.save_to_qf_and_auto_open_qf(list_items)
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
    if not selected and #selected == 0 then
      return
    end

    for _, sel in pairs(selected) do
      local commit_hash, err_msg = extract_git_hash_single(sel)
      if not commit_hash then
        Log.warn(err_msg)
        return
      end
      M.open_commit(commit_hash, "open commit only")
    end
  end
end

function M.git_open_with_fugitive()
  return function(selected, _)
    if not selected and #selected == 0 then
      return
    end

    for _, sel in pairs(selected) do
      local commit_hash, err_msg = extract_git_hash_single(sel)
      if not commit_hash then
        Log.warn(err_msg)
        return
      end
      M.open_commit(commit_hash, "open commit only with fugitive")
    end
  end
end

function M.git_open_diff_to_head()
  return function(selected, _)
    if not selected and #selected == 0 then
      return
    end

    for _, sel in pairs(selected) do
      local commit_hash, err_msg = extract_git_hash_single(sel)
      if not commit_hash then
        Log.warn(err_msg)
        return
      end
      M.open_commit(commit_hash, "compare commit diff to head")
    end
  end
end

function M.git_open_with_compare_hash()
  return function(selected, _)
    if not selected and #selected == 0 then
      return
    end

    local is_done
    local commit_hash_msg = {}
    for _, sel in pairs(selected) do
      local commit_hash, err_msg = extract_git_hash_single(sel)
      if not commit_hash then
        Log.warn(err_msg)
        return
      end

      if not is_done then
        vim.cmd "tabnew %"
        is_done = true
      end

      -- With gitsigns
      local gitsigns = require "gitsigns"
      local ok, err = pcall(gitsigns.diffthis, commit_hash)
      if not ok then
        Log.info "kacau bro"
        Log.error(err)
        return
      end

      -- With vim-fugitive
      -- local cmdmsg = "Gvdiffsplit " .. commit_hash
      -- vim.cmd(cmdmsg)

      -- With diffview
      -- local cmdmsg = "DiffviewOpen -uno " .. commit_hash
      -- vim.cmd(cmdmsg)

      -- With codediff.nvim
      -- vim.cmd("VscodeDiff file " .. commit_hash)

      commit_hash_msg[#commit_hash_msg + 1] = commit_hash
    end

    Log.info("Compare diff:\nCurrent <--> " .. table.concat(commit_hash_msg, " "))
  end
end

function M.git_copy_to_clipboard_or_yank()
  return function(selected, _)
    local commit_hash = extract_git_hash_single(selected)
    if commit_hash then
      M.copy_to_clipboard(commit_hash)
      Fzflua = setup_fzflua()
      Fzflua.actions.resume()
    end
  end
end

function M.git_grep_log()
  return function()
    Fzflua = setup_fzflua()
    Fzflua.fzf_live(function(query)
      return M.git_log_content_finder(query, nil)
    end, M.opts_diffview_log("repo", "Grep log history"))
  end
end

return M
