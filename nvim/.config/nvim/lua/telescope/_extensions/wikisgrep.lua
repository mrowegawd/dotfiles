-- taken from https://github.com/nvim-telescope/telescope-rg.nvim
local telescope = require "telescope"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local conf = require("telescope.config").values
local previewers = require "telescope.previewers"
local make_entry = require "telescope.make_entry"
local action_set = require "telescope.actions.set"
local finders = require "telescope.finders"

local fmt = string.format
local utils = require "neorg.telescope_utils"

-- local neorg_loaded, _ = pcall(require, "neorg.modules")

-- assert(
--     neorg_loaded,
--     "Neorg is not loaded - please make sure to load Neorg first"
-- )
-- local states = utils.states

-- local function get_task_list(project)
--     local project_tasks = utils.get_project_tasks()
--     local raw_tasks = project_tasks[project.uuid]
--     local tasks = {}
--     local highlights = {}
--     if raw_tasks == {} or not raw_tasks then
--         return {}, {}
--     end
--     for _, task in ipairs(raw_tasks) do
--         table.insert(tasks, states[task.state][1] .. task.content)
--         table.insert(highlights, states[task.state][2])
--     end
--     return tasks, highlights
-- end

local function shift_until_delim(str, delim)
  local i = str["pos"]

  while i <= str["len"] do
    local current = string.sub(str["chars"], i, i)

    if current == delim then
      local result = string.sub(str["chars"], str["pos"], i - 1)
      str["pos"] = i + 1
      return result
    elseif current == "\\" then
      i = i + 1
    end

    i = i + 1

    if i > str["len"] then
      -- end reached without delimiter; return the rest of the string
      local result = string.sub(str["chars"], str["pos"], str["len"])
      str["pos"] = str["len"] + 1
      return result
    end
  end
end

--- If str begins with char, it shifts off the char of the beginning of str
local function shift_char(str, char)
  if str["pos"] > str["len"] then
    return false
  end

  local current = string.sub(str["chars"], str["pos"], str["pos"])

  if current == char then
    str["pos"] = str["pos"] + 1
    return true
  end

  return false
end

-- disabled ini, karena space akan ditandai sebagai skipped
-- local function skip_spaces(str)
--     local i = str["pos"]
--     local skipped = false

--     while i <= str["len"] do
--         local current = string.sub(str["chars"], i, i)

--         if current == " " then
--             skipped = true
--         else
--             str["pos"] = i
--             return skipped
--         end

--         i = i + 1
--     end

--     return skipped
-- end

--- Shifts any char off the begining of str
local function shift_any(str)
  if str["pos"] > str["len"] then
    return nil
  end

  local result = string.sub(str["chars"], str["pos"], str["pos"])
  str["pos"] = str["pos"] + 1
  return result
end

--- Parses prompt shell like and returns a table containing the arguments
local parse = function(prompt)
  local str = {
    chars = prompt,
    pos = 1,
    len = string.len(prompt),
  }

  local parts = {}
  local current_arg = nil

  while str["pos"] <= str["len"] do
    local safeguard = str["pos"]

    local delim
    local frag

    -- if skip_spaces(str) then
    --     if current_arg ~= nil then
    --         table.insert(parts, current_arg)
    --         current_arg = nil
    --     end
    -- else
    if shift_char(str, '"') then
      delim = '"'
    end

    if shift_char(str, "'") then
      delim = "'"
    end

    if delim then
      frag = shift_until_delim(str, delim)
      frag = string.gsub(frag, '\\"', '"')
      frag = string.gsub(frag, "\\'", "'")
    else
      frag = shift_any(str)
    end

    if current_arg == nil then
      current_arg = frag
    else
      current_arg = current_arg .. frag
    end
    -- end

    if safeguard == str["pos"] then
      -- this should not happen
      goto afterloop
    end
  end

  if current_arg ~= nil then
    table.insert(parts, current_arg)
  end

  ::afterloop::

  return parts
end

local tbl_clone = function(original)
  local copy = {}
  for key, value in pairs(original) do
    copy[key] = value
  end
  return copy
end

local wikisgrep = function(opts)
  opts = opts or {}

  opts.vimgrep_arguments = {
    -- "rg",
    -- "--follow",
    -- "--hidden",
    -- "--color=never",
    -- "--no-heading",
    -- "--with-filename",
    -- "--line-number",
    -- "--column",
    -- "--smart-case",
    -- "--trim", -- remove indentation
    -- "-g",
    -- "*.norg",
    -- "-g",
    -- "*.org",
    -- "-g",
    -- "!config/",
    -- "-g",
    -- "!.obsidian/",

    -- Vimgrep command yg dicommented diatas sama saja dengan yang bawah
    -- cuma mau menunjukkan kedua command tersebut bisa diguanakan

    "rg",
    "--follow",
    "--hidden",
    "--no-config",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "-g=*.norg",
    "-g=*.org",
    "-g=!config/",
    "-g=!.obsidian/",
  }
  opts.cwd = RUtils.config.path.wiki_path
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd)

  local cmd_generator = function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    local args = tbl_clone(opts.vimgrep_arguments)
    local prompt_parts = parse(prompt)

    -- vim.notify(fmt("%s", vim.inspect(prompt_parts)))

    local cmd = vim.tbl_flatten { args, prompt_parts }
    return cmd
  end

  pickers
    .new(opts, {
      prompt_title = "Live Grep Wikis",
      finder = finders.new_job(cmd_generator, opts.entry_maker, opts.max_results, opts.cwd),
      previewer = conf.grep_previewer(opts),

      -- previewer = previewers.new_buffer_previewer {
      --     define_preview = function(self, entry, status)
      --         local tasks, highlights = get_task_list(entry.value)
      --         vim.api.nvim_buf_set_lines(
      --             self.state.bufnr,
      --             0,
      --             -1,
      --             true,
      --             tasks
      --         )
      --         vim.bo[self.state.bufnr].filetype = "norg"
      --         -- for i, highlight in ipairs(highlights) do
      --         --     vim.api.nvim_buf_add_highlight(
      --         --         self.state.bufnr,
      --         --         ns,
      --         --         highlight,
      --         --         i - 1,
      --         --         0,
      --         --         5
      --         --     )
      --         -- end
      --     end,
      -- },
      sorter = sorters.highlighter_only(opts),

      attach_mappings = function(_)
        action_set.select:enhance {
          post = function()
            vim.cmd ":normal! zx"
          end,
        }
        return true
      end,
    })
    :find()
end

return telescope.register_extension {
  exports = { wikisgrep = wikisgrep },
}
