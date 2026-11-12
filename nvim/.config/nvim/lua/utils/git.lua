local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local Fzflua = lazy "fzf-lua"

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                 GIT HELPERS                                 ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local ANSI_PATTERN = "\27%[[%d;]*m"

--- Run git directly without a shell
--- (avoids quoting issues and injection, no need for 2>/dev/null).
---@param args string[]
---@param cwd string?
---@return string? output  nil if the command fails or returns nothing
local function git(args, cwd)
  local ok, res = pcall(function()
    return vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
  end)
  if not ok or res.code ~= 0 then
    return nil
  end
  local out = vim.trim(res.stdout or "")
  return out ~= "" and out or nil
end

function M.git_root()
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  if vim.fn.isdirectory(dir) == 0 then
    ---@diagnostic disable-next-line: cast-local-type
    dir = vim.uv.cwd()
  end
  return git({ "rev-parse", "--show-toplevel" }, dir)
end

--- Get the branch name, or fall back to the commit hash if HEAD is detached.
local function git_ref(root)
  local branch = git({ "rev-parse", "--abbrev-ref", "HEAD" }, root)
  if branch and branch ~= "HEAD" then
    return branch
  end
  return git({ "rev-parse", "HEAD" }, root)
end

--- Parse remote URL (scp-like, ssh://, git://, http(s)://) -> host, path
---@return string? host, string? path
local function parse_remote(raw)
  raw = raw:gsub("/+$", ""):gsub("%.git$", "")

  local host, path
  if not raw:find("://", 1, true) then
    -- git@github.com:owner/repo
    host, path = raw:match "^[^@/]+@([^:/]+):(.+)$"
  else
    local scheme, authority, rest = raw:match "^(%a[%w+.-]*)://([^/]+)/(.+)$"
    if scheme then
      host = authority:gsub("^.*@", "") -- buang user:token@
      if scheme ~= "http" and scheme ~= "https" then
        host = host:gsub(":%d+$", "") -- buang port ssh
      end
      path = rest
    end
  end

  if not host or not path then
    return nil
  end
  path = path:gsub("^/+", "")
  return host, path
end

---@class RemoteInfo
---@field host string
---@field path string  "owner/repo" (atau group/subgroup/repo)
---@field url string   https url

---@param root string
---@param remote_name string?
---@return RemoteInfo?
local function remote_info(root, remote_name)
  remote_name = remote_name or "origin"
  local raw = git({ "config", "--get", "remote." .. remote_name .. ".url" }, root)
  if not raw then
    Log.error(string.format("Remote '%s' tidak ditemukan. Jalankan 'git remote -v' untuk cek", remote_name))
    return nil
  end

  local host, path = parse_remote(raw)
  if not host then
    Log.error("Tidak bisa parse owner/repo dari remote URL: " .. raw)
    return nil
  end

  return { host = host, path = path, url = "https://" .. host .. "/" .. path }
end

--- Resolve the repo root and remote info in one go, logging an error if it fails.
---@return string? root, RemoteInfo? remote
local function resolve_repo()
  local root = M.git_root()
  if not root then
    Log.error "Not a git repository"
    return nil
  end
  local remote = remote_info(root)
  if not remote then
    return nil
  end
  return root, remote
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               GENERAL HELPERS                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local function copy_to_clipboard(text)
  vim.fn.setreg("+", text)
  Log.info("Git `" .. text .. "` copied to clipboard")
end

local function open_url(url)
  local _, err = vim.ui.open(url)
  if err then
    Log.error("Gagal membuka: " .. tostring(err))
    return
  end
  Log.info("Opening: " .. url)
end

local function url_encode(s)
  return (s:gsub("[^%w%-%._~/]", function(c)
    return string.format("%%%02X", c:byte())
  end))
end

local function normalize_slashes(p)
  return (p:gsub("\\", "/"))
end

--- Get the file path relative to the repo root (handles symlinks and Windows paths).
local function relative_path(root, bufname)
  local abs = vim.uv.fs_realpath(bufname) or vim.fn.fnamemodify(bufname, ":p")
  abs, root = normalize_slashes(abs), normalize_slashes(root)
  if abs:sub(1, #root + 1) ~= root .. "/" then
    return nil
  end
  return abs:sub(#root + 2)
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                             FZF ACTION BUILDERS                             ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local WINDOW_KEYS = {
  ["ctrl-s"] = "split",
  ["ctrl-v"] = "vsplit",
  ["ctrl-t"] = "tabnew",
}

--- Build the default, ctrl-s, ctrl-v, and ctrl-t actions in one go.
---@param handler fun(sel: string, mode: string?)
---@param default_mode string?
local function window_actions(handler, default_mode)
  local function wrap(mode)
    return function(selected)
      local sel = selected and selected[1]
      if sel then
        handler(sel, mode)
      end
    end
  end

  local actions = { ["default"] = wrap(default_mode) }
  for key, mode in pairs(WINDOW_KEYS) do
    actions[key] = wrap(mode)
  end
  return actions
end

--- Entry format dari trace_file_event: "<hash> — <path>" (dengan/ tanpa ANSI).
---@return { commit: string, path: string }?
local function parse_entry(sel)
  if not sel then
    return nil
  end
  local plain = sel:gsub(ANSI_PATTERN, "")
  local commit, path = plain:match "^(%x+) — (.+)$"
  if commit then
    return { commit = commit, path = path }
  end
end

local function entry_action(fn)
  return function(selected)
    local entry = parse_entry(selected and selected[1])
    if entry then
      fn(entry)
    end
  end
end

local function run_with_mode(mode, cmd)
  if mode then
    vim.cmd(mode)
  end
  vim.cmd(cmd)
end

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                    FUNC                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

--- Stream previously deleted files into fzf asynchronously (keeps the UI responsive).
function M.trace_file_event()
  local root = M.git_root()
  if not root then
    Log.error "Bukan repository git"
    return
  end

  local actions = window_actions(function(sel, mode)
    local entry = parse_entry(sel)
    if entry then
      run_with_mode(mode, "Gclog " .. entry.commit)
    end
  end, "edit")

  actions["alt-c"] = entry_action(function(e)
    copy_to_clipboard(e.commit)
  end)

  actions["ctrl-o"] = entry_action(function(e)
    require("vim-pack").load_now "diffview.nvim"
    vim.cmd("DiffviewOpen " .. e.commit .. "^.." .. e.commit)
    Log.info("Open diff (with `diffview`) : " .. e.path)
  end)

  actions["ctrl-z"] = entry_action(function(e)
    vim.cmd "vsplit"
    lazy("vim-pack").load_now "vim-fugitive"
    vim.cmd("Gedit " .. e.commit)
    Log.info("Open diff (with `fugitive`) : " .. e.path)
  end)

  Fzflua.fzf_exec(function(fzf_cb)
    local commit, count, tail = nil, 0, ""

    local function feed(line)
      line = line:gsub("\r$", "")
      if line == "" then
        return
      end
      local hash = line:match "^commit (%x+)$"
      if hash then
        commit = hash
      elseif commit then
        count = count + 1
        -- Yellow: commit hash, red: file path
        fzf_cb(string.format("\27[33m%s\27[0m — \27[31m%s\27[0m", commit:sub(1, 8), line))
      end
    end

    local ok = pcall(vim.system, {
      "git",
      "-c",
      "core.quotepath=false",
      "log",
      "--diff-filter=D",
      "--name-only",
      "--format=commit %H",
    }, {
      cwd = root,
      text = true,
      stdout = function(_, data)
        if not data then
          return
        end
        local lines = vim.split(tail .. data, "\n", { plain = true })
        tail = table.remove(lines) -- The last line might be incomplete
        for _, line in ipairs(lines) do
          feed(line)
        end
      end,
    }, function()
      feed(tail)
      fzf_cb() -- Close the stream
      if count == 0 then
        vim.schedule(function()
          Log.warn "No deleted files found"
        end)
      end
    end)

    if not ok then
      fzf_cb()
    end
  end, {
    fzf_opts = { ["--header"] = [[a-c:copyhash  ^o:diffviewopen  ^z:fugitive]] },
    actions = actions,
  })
end

--- Pick a branch, then a file from that branch, and open it with fugitive.
function M.select_file_different_branch()
  local root = M.git_root()
  local branches = vim.fn.systemlist {
    "git",
    "-C",
    root or ".",
    "branch",
    "--all",
    "--format=%(refname:short)",
  }

  Fzflua.fzf_exec(branches, {
    actions = {
      ["default"] = function(selected)
        local branch = selected and selected[1]
        if not branch then
          return
        end

        -- Pass a command string so fzf-lua runs it asynchronously without blocking.
        -- --full-tree keeps paths relative to the repo root, which works with Gedit.
        local cmd = "git ls-tree -r --name-only --full-tree " .. vim.fn.shellescape(branch)

        Fzflua.fzf_exec(cmd, {
          cwd = root,
          actions = window_actions(function(filepath, mode)
            lazy("vim-pack").load_now "vim-fugitive"
            run_with_mode(mode, "Gedit " .. vim.fn.fnameescape(branch .. ":" .. filepath))
          end),
        })
      end,

      ["alt-c"] = function(selected)
        if selected and selected[1] then
          copy_to_clipboard(selected[1])
        end
      end,

      ["ctrl-o"] = function(selected)
        local branch = selected and selected[1]
        if branch then
          lazy("vim-pack").load_now "vim-fugitive"
          vim.cmd "vsplit"
          vim.cmd("Gedit " .. branch .. ":%")
        end
      end,
    },
  })
end

function M.copy_repo_name()
  local _, remote = resolve_repo()
  if remote then
    copy_to_clipboard(remote.path)
  end
end

function M.open_repo()
  local _, remote = resolve_repo()
  if remote then
    open_url(remote.url)
  end
end

--- Format URL "blob" per forge: { host-pattern, format(url, ref, path, line) }
local FORGES = {
  { "gitlab", "%s/-/blob/%s/%s#L%d" },
  { "bitbucket", "%s/src/%s/%s#lines-%d" },
}
local DEFAULT_BLOB_FMT = "%s/blob/%s/%s#L%d" -- GitHub & fallback

function M.open_file()
  local root, remote = resolve_repo()
  if not root or not remote then
    return
  end

  local ref = git_ref(root)
  if not ref then
    Log.error "Tidak bisa resolve branch (detached HEAD?)"
    return
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    Log.error "Buffer ini bukan file"
    return
  end

  local rel_path = relative_path(root, bufname)
  if not rel_path then
    Log.error "File berada di luar repository"
    return
  end

  local fmt = DEFAULT_BLOB_FMT
  for _, forge in ipairs(FORGES) do
    if remote.host:find(forge[1], 1, true) then
      fmt = forge[2]
      break
    end
  end

  local line = vim.api.nvim_win_get_cursor(0)[1]
  open_url(string.format(fmt, remote.url, url_encode(ref), url_encode(rel_path), line))
end

return M
