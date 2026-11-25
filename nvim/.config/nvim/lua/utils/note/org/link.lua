local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local Fzflua = lazy "fzf-lua"
local Config = lazy "config"
local ConfigPath = Config.path

local NoteUtils = lazy "utils.note.note_utils"

local function realpath(path)
  if not path or path == "" then
    return nil
  end
  return vim.loop.fs_realpath(vim.fn.fnamemodify(path, ":p")) or path
end

local function relative_path(from_dir, to_path)
  from_dir = vim.fs.normalize(from_dir):gsub("/$", "")
  to_path = vim.fs.normalize(to_path)

  local to_dir = vim.fs.dirname(to_path)
  local to_file = vim.fn.fnamemodify(to_path, ":t")

  local function split(path)
    local parts = {}
    for p in path:gmatch "[^/]+" do
      if p ~= "" then
        parts[#parts + 1] = p
      end
    end
    return parts
  end

  local from_parts = split(from_dir)
  local to_parts = split(to_dir)

  local common = 0
  local limit = math.min(#from_parts, #to_parts)
  for i = 1, limit do
    if from_parts[i] == to_parts[i] then
      common = i
    else
      break
    end
  end

  local parts = {}

  local up = #from_parts - common
  if up == 0 then
    parts[#parts + 1] = "."
  else
    for _ = 1, up do
      parts[#parts + 1] = ".."
    end
  end

  for i = common + 1, #to_parts do
    parts[#parts + 1] = to_parts[i]
  end

  parts[#parts + 1] = to_file

  return table.concat(parts, "/")
end

local Mapping = {}

function Mapping.insert_backlinks()
  return {
    ["default"] = function(selected, _)
      local e = Fzflua.path.entry_to_file(selected[1])
      local target_path = e and e.path
      if not target_path then
        Log.warn "Invalid target path."
        return
      end

      local function norm(path)
        if not path or path == "" then
          return nil
        end
        return vim.fs.normalize(vim.fn.fnamemodify(path, ":p")):gsub("/$", "")
      end

      local wiki_sym = norm(ConfigPath.wiki_path)
      local current_file = norm(vim.api.nvim_buf_get_name(0))
      target_path = norm(target_path)

      if not current_file or not target_path or not wiki_sym then
        Log.warn "Could not resolve paths."
        return
      end

      if not vim.startswith(current_file, wiki_sym) then
        Log.warn "The current file is not part of the wiki."
        return
      end

      local function find_wiki_equivalent(real_target, wiki_root)
        local fname = vim.fn.fnamemodify(real_target, ":t")
        local matches = vim.fn.glob(wiki_root .. "/**/" .. fname, false, true)

        if #matches == 1 then
          return norm(matches[1])
        elseif #matches > 1 then
          local target_parts = vim.split(real_target, "/")
          local best, best_score = nil, 0
          for _, candidate in ipairs(matches) do
            local cparts = vim.split(candidate, "/")
            local score = 0
            local ti, ci = #target_parts, #cparts
            while ti > 0 and ci > 0 and target_parts[ti] == cparts[ci] do
              score = score + 1
              ti = ti - 1
              ci = ci - 1
            end
            if score > best_score then
              best = candidate
              best_score = score
            end
          end
          return best and norm(best) or nil
        end

        return nil
      end

      if not vim.startswith(target_path, wiki_sym) then
        local found = find_wiki_equivalent(target_path, wiki_sym)
        if found then
          target_path = found
        else
          Log.warn "Target file is not part of the wiki."
          return
        end
      end

      local current_dir = vim.fs.dirname(current_file)
      local relative = relative_path(current_dir, target_path)
      local label = vim.fn.fnamemodify(target_path, ":t:r")

      local link
      -- if M.note_mode == "org" then
      link = string.format("[[%s][ %s]]", relative, label)
      -- elseif M.note_mode == "markdown" then
      --   local fname = vim.fn.fnamemodify(target_path, ":t")
      --   link = string.format("[%s](%s)", label, fname)
      -- end
      vim.api.nvim_put({ link }, "c", false, true)
    end,
  }
end

---@param filename string
---@param is_global boolean?
function Mapping.insert_title(filename, is_global)
  is_global = is_global or false

  local icon_prefix = is_global and "🔗" or " "

  return {
    ["default"] = function(selected, _)
      local file_opts = NoteUtils.extract_str_title(selected, filename, is_global)
      if not file_opts then
        Log.warn "not found"
        return
      end

      local fmt_str

      -- if M.note_mode == "org" then
      local title = file_opts.title_str
      -- elseif M.note_mode == "markdown" then
      --   title = file_opts.title_str:gsub("^#+%s*", "")
      -- end

      if not is_global then
        -- if M.note_mode == "org" then
        fmt_str = "[[*" .. title .. "][" .. icon_prefix .. title .. "]]"
        -- elseif M.note_mode == "markdown" then
        --   fmt_str = "[[#" .. title .. "]]"
        -- end
      else
        local e = Fzflua.path.entry_to_file(selected[1])
        local target_path = e and e.path or nil
        local root = ConfigPath.wiki_path or ""

        if target_path and root then
          target_path = realpath(target_path) or ""
          root = realpath(root) or ""

          local current_file = realpath(vim.api.nvim_buf_get_name(0)) or ""

          if (#current_file > 1) and target_path then
            if vim.startswith(current_file, root) and vim.startswith(target_path, root) then
              local current_dir = vim.fs.dirname(current_file)
              local relative = relative_path(current_dir, target_path)
              if relative then
                -- if M.note_mode == "org" then
                fmt_str = "[[./" .. relative .. "::*" .. title .. "][" .. icon_prefix .. title .. "]]"
                -- elseif M.note_mode == "markdown" then
                --   fmt_str = "[[" .. relative .. "#" .. title .. "]]"
                -- end
              end
            end
          end
        end
      end

      if fmt_str then
        vim.api.nvim_put({ fmt_str }, "c", false, true)
      end
    end,
  }
end

---@param ignores string
---@param title string
function M.insert_backlinks_files(ignores, title)
  Fzflua.files {
    cwd = ConfigPath.wiki_path,
    file_ignore_patterns = ignores,
    winopts = { title = title },
    actions = Mapping.insert_backlinks(),
  }
end

---@param is_global boolean
function M.insert_heading_title(rg_opts, regex_title, title, is_global)
  local target_file = NoteUtils.get_target_file(ConfigPath.wiki_path, is_global)

  local copy_rgopts = vim.deepcopy(rg_opts)
  copy_rgopts[#copy_rgopts + 1] = target_file
  copy_rgopts[#copy_rgopts + 1] = "-e"

  Log.info(target_file)

  NoteUtils.grep(is_global, target_file, {
    winopts = { title = title },
    search = regex_title,
    rg_opts = table.concat(copy_rgopts, " "),
    actions = Mapping.insert_title(target_file, is_global),
  })
end

return M
