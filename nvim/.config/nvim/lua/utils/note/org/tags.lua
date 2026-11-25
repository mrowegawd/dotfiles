local M = {}

local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local Fzflua = lazy "fzf-lua"

-- Stores the last state for each custom picker
local last_state = {}

local selected_tag = {}

local state_name = {
  ["search tags"] = true,
  ["insert tags"] = true,
}

local contents_tags = { val = {}, tags = {} }

local function resume_picker(name)
  local s = last_state[name]
  if not s then
    Log.warn("No cache for picker: `" .. name .. "`")
    return
  end
  s.opts.resume = true
  Fzflua.fzf_exec(s.contents, s.opts)
end

local Mapping = {}

function Mapping.open_tags(fn)
  return {
    ["default"] = {
      fn = function(selection)
        if selection == nil then
          return
        end
        if selected_tag and #selected_tag > 0 then
          require("org.agenda").open_tags(table.concat(selected_tag, "+"))
          selected_tag = {}
          fn()
          return
        end

        -- local sel = {}
        --
        -- if #selection > 1 then
        --   for _, x in pairs(selection) do
        --     table.insert(sel, x)
        --   end
        --
        --   match_tags = table.concat(sel, "+")
        -- else
        --   sel = { selection[1] }
        --   match_tags = table.concat(sel, "")
        -- end
        --
        -- if not sel then
        --   return
        -- end

        -- Temporarily swap ke full wiki path
        -- if M.note_mode == "org" then
        local function item_of(items, entry)
          local idx = tonumber(tostring(entry or ""):match "^%s*(%d+)\t")
          return idx and items[idx] or nil
        end

        local chosen = {}
        for _, e in ipairs(selection or {}) do
          local it = item_of(contents_tags.val, e)
          if it then
            chosen[#chosen + 1] = it
          end
        end

        local match = chosen[1].value

        local pred, err = lazy("org.agenda.search").try_compile(match)
        if not pred then
          Log.error("Invalid match: " .. tostring(err))
          fn()
          return
        end
        require("org.agenda").open_tags(match)
        selected_tag = {}
        fn()
        -- org.set_agenda_dir(org.path_local_wiki)

        -- elseif M.note_mode == "markdown" then
        --   local function gather_tag_picker_list(tag_locations, tags)
        --     local entries = {}
        --     for _, tag_loc in ipairs(tag_locations) do
        --       for _, tag in ipairs(tags) do
        --         if tag_loc.tag:lower() == tag:lower() or vim.startswith(tag_loc.tag:lower(), tag:lower() .. "/") then
        --           local display = string.format("%s [%s] %s", tag_loc.note:display_name(), tag_loc.line, tag_loc.text)
        --           entries[#entries + 1] = {
        --             value = { path = tag_loc.path, line = tag_loc.line, col = tag_loc.tag_start },
        --             display = display,
        --             ordinal = display,
        --             filename = tostring(tag_loc.path),
        --             lnum = tag_loc.line,
        --             col = tag_loc.tag_start,
        --           }
        --           break
        --         end
        --       end
        --     end
        --     if vim.tbl_isempty(entries) then
        --       return
        --     end
        --
        --     vim.schedule(function()
        --       local obsidian = lazy "obsidian"
        --       obsidian.picker.pick(entries, {
        --         prompt_title = "#" .. table.concat(tags, ", #"),
        --         actions = {
        --           ["default"] = function(selected, fzf_opts)
        --             local entry_to_file = lazy("fzf-lua.path").entry_to_file
        --             local path = entry_to_file(selected[1], fzf_opts).path
        --             if not path then
        --               return
        --             end
        --
        --             Log.info(path)
        --
        --             -- if path_only then
        --             --   opts.callback(path)
        --             -- else
        --             --   opts.callback { filename = path }
        --             -- end
        --             -- elseif not opts.no_default_mappings then
        --             --   lazy("fzf-lua.actions").file_edit_or_qf(selected, fzf_opts)
        --             -- end
        --           end,
        --         },
        --       })
        --     end)
        --   end
        --
        --   gather_tag_picker_list(contents_tags.val, sel)
        -- end
      end,
      desc = "select+search tag",
      header = "search+search tag",
    },

    ["alt-s"] = {
      fn = function(selection, opts)
        if selection == nil then
          return
        end

        -- local sel = {}
        --
        -- if #selection > 1 then
        --   for _, x in pairs(selection) do
        --     table.insert(sel, x)
        --   end
        --
        --   match_tags = table.concat(sel, "+")
        -- else
        --   sel = { selection[1] }
        --   match_tags = table.concat(sel, "")
        -- end
        --
        -- if not sel then
        --   return
        -- end

        -- Temporarily swap ke full wiki path
        -- if M.note_mode == "org" then
        local function item_of(items, entry)
          local idx = tonumber(tostring(entry or ""):match "^%s*(%d+)\t")
          return idx and items[idx] or nil
        end

        local chosen = {}
        for _, e in ipairs(selection or {}) do
          local it = item_of(contents_tags.val, e)
          if it then
            chosen[#chosen + 1] = it
          end
        end

        local match = chosen[1].value

        local pred, err = lazy("org.agenda.search").try_compile(match)
        if not pred then
          Log.error("Invalid match: " .. tostring(err))
          fn()
          return
        end
        if match then
          selected_tag[#selected_tag + 1] = match
        end

        Log.info("selected tag: " .. table.concat(selected_tag, " "))

        require("fzf-lua").resume(opts)
        -- fn()

        -- org.set_agenda_dir(org.path_local_wiki)

        -- elseif M.note_mode == "markdown" then
        --   local function gather_tag_picker_list(tag_locations, tags)
        --     local entries = {}
        --     for _, tag_loc in ipairs(tag_locations) do
        --       for _, tag in ipairs(tags) do
        --         if tag_loc.tag:lower() == tag:lower() or vim.startswith(tag_loc.tag:lower(), tag:lower() .. "/") then
        --           local display = string.format("%s [%s] %s", tag_loc.note:display_name(), tag_loc.line, tag_loc.text)
        --           entries[#entries + 1] = {
        --             value = { path = tag_loc.path, line = tag_loc.line, col = tag_loc.tag_start },
        --             display = display,
        --             ordinal = display,
        --             filename = tostring(tag_loc.path),
        --             lnum = tag_loc.line,
        --             col = tag_loc.tag_start,
        --           }
        --           break
        --         end
        --       end
        --     end
        --     if vim.tbl_isempty(entries) then
        --       return
        --     end
        --
        --     vim.schedule(function()
        --       local obsidian = lazy "obsidian"
        --       obsidian.picker.pick(entries, {
        --         prompt_title = "#" .. table.concat(tags, ", #"),
        --         actions = {
        --           ["default"] = function(selected, fzf_opts)
        --             local entry_to_file = lazy("fzf-lua.path").entry_to_file
        --             local path = entry_to_file(selected[1], fzf_opts).path
        --             if not path then
        --               return
        --             end
        --
        --             Log.info(path)
        --
        --             -- if path_only then
        --             --   opts.callback(path)
        --             -- else
        --             --   opts.callback { filename = path }
        --             -- end
        --             -- elseif not opts.no_default_mappings then
        --             --   lazy("fzf-lua.actions").file_edit_or_qf(selected, fzf_opts)
        --             -- end
        --           end,
        --         },
        --       })
        --     end)
        --   end
        --
        --   gather_tag_picker_list(contents_tags.val, sel)
        -- end
      end,
      desc = "select tag",
      header = "select tag",
    },
  }
end

local function opts_fzf(opts)
  return {
    winopts = opts.winopts,
    actions = opts.actions,
    fzf_opts = opts.fzf_opts,
  }
end

---@param name string -- id picker with name
---@param contents table
---@param opts table
local function picker(name, contents, opts)
  opts = opts or {}
  if not state_name[name] then
    Log.warn("There is no state name for `" .. name .. "`")
    return
  end

  last_state[name] = { contents = contents.tags, opts = vim.deepcopy(opts) }

  if name == "search tags" then
    Fzflua.fzf_exec(contents.tags, opts_fzf(opts))
  else
    Fzflua.fzf_exec(contents.tags, opts_fzf(opts))
  end
end

-- ---@param opts? {last: boolean }
-- function M.insert_tag(opts)
---@param stat_name "search tags" | "insert tags"
---@param fn function
---@param opts? {last: boolean, title: string, use_plugin: boolean?}
function M.insert_tag(stat_name, fn, opts)
  opts = opts or {}

  if opts.last then
    resume_picker(stat_name)
    return
  end

  if opts.use_plugin then
    vim.cmd "Org pick_set_tags"
  else
    local optsfzf = {
      winopts = { title = opts.title },
      actions = {
        ["default"] = function(selection)
          if selection == nil then
            return
          end

          local sel = selection[1]
          if not sel then
            return
          end

          vim.api.nvim_put({ sel }, "c", false, true)
          fn()
        end,
      },
    }
    local tags = lazy "org.tags"
    local counts, defined = {}, {}

    local function define(defs)
      for _, d in ipairs(defs or {}) do
        if type(d) == "table" and d.name and not d.name:match "^[{}]" then
          defined[d.name] = true
        end
      end
    end

    pcall(function()
      define(tags.option_definitions())
    end)

    for _, f in ipairs(lazy("org.files").agenda_files()) do
      pcall(function()
        define(f:tag_definitions())
      end)

      for _, t in ipairs(f.settings.filetags or {}) do
        counts[t] = (counts[t] or 0) + 1
      end

      for _, hl in ipairs(f.headlines) do
        for _, t in ipairs(hl.tags) do
          counts[t] = (counts[t] or 0) + 1
        end
      end
    end

    local names = {}
    for k in pairs(counts) do
      names[#names + 1] = k
    end
    for k in pairs(defined) do
      if not counts[k] then
        names[#names + 1] = k
      end
    end

    table.sort(names)
    contents_tags.tags = names

    if not contents_tags.tags or #contents_tags.tags == 0 then
      return
    end
    picker("insert tags", contents_tags, optsfzf)
  end
  fn()
  -- elseif M.note_mode == "markdown" then
  --   local search = lazy "obsidian.search"
  --   search.find_tags_async("", function(tag_locations)
  --     contents_tags.tags = list_tags(tag_locations)
  --     contents_tags.val = tag_locations
  --     if not contents_tags.tags or #contents_tags.tags == 0 then
  --       return
  --     end
  --     picker("insert tags", contents_tags, optsfzf)
  --   end)
  --   return
end

---@param stat_name "search tags" | "insert tags"
---@param fn function
---@param opts? {last: boolean, title: string}
function M.get_tags(stat_name, fn, opts)
  opts = opts or {}

  if opts.last then
    resume_picker(stat_name)
    return
  end

  -- if not set_global_agenda_files then
  --   org.set_agenda_dir(org.path_global_wiki)
  -- end

  -- vim.cmd "Org pick_tag"

  local files = require "org.files"
  local sources = require "org.pickers.sources"
  local file_list = files.agenda_files_with_current()

  local ok_u, fzfluaUtils = pcall(require, "fzf-lua.utils")
  local ansi
  if ok_u and type(fzfluaUtils) == "table" and type(fzfluaUtils.ansi_from_hl) == "function" then
    ansi = function(hl, s)
      return (fzfluaUtils.ansi_from_hl(hl, s))
    end
  end

  local tag_items = sources.tag_items(sources.tag_list(file_list))

  local function line(item)
    if item.text then
      return item.text
    end
    local parts = {}
    for i, c in ipairs(item.display or {}) do
      parts[i] = c[1]
    end
    return table.concat(parts)
  end

  local function colored(item)
    local parts = {}
    for i, c in ipairs(item.display or { { line(item) } }) do
      local text = c[1]:gsub("[\t\n]", " ")
      parts[i] = ansi and c[2] and ansi(c[2], text) or text
    end
    return table.concat(parts)
  end

  local entries = {}
  for i, it in ipairs(tag_items) do
    entries[i] = i .. "\t" .. colored(it)
  end

  contents_tags.tags = entries
  contents_tags.val = tag_items

  local fzfopts = {
    winopts = { title = opts.title },
    fzf_opts = {
      ["--ansi"] = true,
      ["--delimiter"] = "\t",
      ["--with-nth"] = "2..",
      -- ["--multi"] = spec.multi and true or false,
      -- ["--no-multi"] = not spec.multi and true or nil,
    },
    -- previewer = spec.preview and previewer(spec.items) or nil,
    actions = Mapping.open_tags(fn),
  }
  picker("search tags", contents_tags, fzfopts)
end

return M
