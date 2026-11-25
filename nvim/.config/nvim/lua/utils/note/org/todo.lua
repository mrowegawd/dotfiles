local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"

local M = {}

--- Extract date info from an AgendaItem for a given field.
--- `tags`/`todo`/`search` don't populate `it.date`, so we also check `it.headline`.
--- @param it table
--- @param field string "date" | "scheduled" | "deadline"
--- @return string|nil date_string  "YYYY-MM-DD"
--- @return table|nil date_obj     full Date object (has .timestamp, .time, .repeater)
local function item_date(it, field)
  local function norm(v)
    if type(v) == "table" and v.date then
      return v.date, v
    elseif type(v) == "string" then
      return v, nil
    end
    return nil, nil
  end

  -- field directly on the item (populated for "agenda" type)
  if it[field] then
    local s, o = norm(it[field])
    if s then
      return s, o
    end
  end

  -- field on the headline (scheduled/deadline always live here)
  if it.headline and it.headline[field] then
    local s, o = norm(it.headline[field])
    if s then
      return s, o
    end
  end

  -- fallback: if "date" is requested but empty, try scheduled then deadline
  if field == "date" and it.headline then
    local s, o = norm(it.headline.scheduled)
    if s then
      return s, o
    end
    s, o = norm(it.headline.deadline)
    if s then
      return s, o
    end
  end

  return nil, nil
end

--- Mark overdue entries as DONE, with a configurable query.
--- @param opts? table
---   opts.match        string|nil  Tag/property match string (default "+homework")
---   opts.mode         string|nil  "tags" | "todo" | "search" (default "tags")
---   opts.date_field   string|nil  "date" | "scheduled" | "deadline" (default "date")
---   opts.today        string|nil  Override today's date (YYYY-MM-DD), for testing
---   opts.state        string|nil  Target state (default "DONE")
---   opts.save         boolean|nil true = always save, false = don't save, nil = org.nvim default
---   opts.dry_run      boolean|nil true = report only, no changes
---   opts.notify       boolean|nil false = fully silent
---   opts.by_time      boolean|nil true = compare by timestamp (time of day), false = by date
--- @return integer done, integer failed, string[]? errors
M.remove_repeater_todo = function(opts)
  opts = opts or {}
  local match = opts.match or "+homework"
  local mode = opts.mode or "tags"
  local date_field = opts.date_field or "date"
  local state = opts.state or "DONE"
  local today = opts.today or os.date "%Y-%m-%d"
  local notify = opts.notify ~= false
  local by_time = opts.by_time == true
  local now_ts = os.time()

  local agenda = lazy "org.api.agenda"

  -- Fetch items according to mode
  local items, err
  if mode == "tags" then
    items, err = agenda.tags(match, { todo_only = true })
  elseif mode == "todo" then
    items, err = agenda.todo { keywords = match ~= "" and match or nil }
  elseif mode == "search" then
    items, err = agenda.search(match, { todo_only = true })
  else
    return 0, 0, { "unknown mode: " .. tostring(mode) }
  end

  if not items then
    if notify then
      Log.error("Query failed: " .. (err or "unknown"))
    end
    return 0, 0, { err or "query failed" }
  end

  -- Filter overdue entries based on the chosen date_field
  local overdue = {}
  for _, it in ipairs(items) do
    if not it.done and it.headline then
      local ds, dobj = item_date(it, date_field)
      local is_overdue = false
      if ds then
        if by_time and dobj and dobj.timestamp then
          -- compare by seconds (local timestamp). Items without a time default to 00:00.
          is_overdue = dobj.timestamp < now_ts
        else
          -- compare YYYY-MM-DD strings (lexicographic order = chronological order)
          is_overdue = ds < today
        end
      end
      if is_overdue then
        -- stash date info for messages / dry-run
        ---@diagnostic disable-next-line: inject-field
        it._auto_done_ds = ds
        ---@diagnostic disable-next-line: inject-field
        it._auto_done_dobj = dobj
        table.insert(overdue, it)
      end
    end
  end

  if #overdue == 0 then
    if notify then
      Log.info("No overdue entries for match: " .. match)
    end
    return 0, 0, nil
  end

  -- Dry run: report only
  if opts.dry_run then
    if notify then
      local list = {}
      for _, it in ipairs(overdue) do
        table.insert(list, string.format("  %s (%s, %s)", it.title, tostring(it._auto_done_ds or "?"), it.file or "?"))
      end
      Log.info(string.format("[dry-run] %d overdue entries:\n%s", #overdue, table.concat(list, "\n")))
    end
    return #overdue, 0, nil
  end

  -- Mark each one as DONE
  local done, failed = 0, 0
  local errors = {}
  for _, it in ipairs(overdue) do
    local ok, res, serr = pcall(function()
      return it.headline:set_todo(state, { save = opts.save })
    end)
    if ok and res then
      done = done + 1
    else
      failed = failed + 1
      local msg = string.format("%s (%s)", it.title, tostring(serr or res))
      table.insert(errors, msg)
      if notify then
        Log.warn("Failed to set " .. state .. ": " .. msg)
      end
    end
  end

  if notify then
    if failed > 0 then
      Log.warn(string.format("Overdue: %d marked %s, %d failed", done, state, failed))
    else
      Log.info(string.format("Overdue: %d marked %s, %d failed", done, state, failed))
    end
  end

  return done, failed, #errors > 0 and errors or nil
end

return M
