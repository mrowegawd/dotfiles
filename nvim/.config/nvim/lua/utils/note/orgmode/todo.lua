local lazy = require("utils.plugin").require_lazy

local Log = lazy "utils.log"
local UtilCmd = lazy "utils.cmd"

local M = {}

---@param bufnr integer
local function set_repeater_todo(bufnr, repeater_dates, headline)
  local OrgMappings = Org.org_mappings

  vim.api.nvim_buf_call(bufnr, function()
    local range = headline:get_range()
    vim.api.nvim_win_set_cursor(0, { range.start_line, 0 })

    -- Step 1: advance repeater dates dulu (ini pakai range dari date object sendiri)
    for _, date in ipairs(repeater_dates) do
      OrgMappings:_replace_date(date:apply_repeater())
    end

    -- Step 2: setelah buffer berubah, reload file dan cari headline yang sama by line
    vim.cmd "silent! write"

    local file = Org.files:get(vim.api.nvim_buf_get_name(bufnr))
    if not file then
      return
    end

    -- Cari headline di range yang sama (start_line tidak bergeser karena _replace_date
    -- hanya replace konten di baris yang sama, tidak menambah/kurang baris)
    local target_line = range.start_line
    local fresh_headline = nil
    for _, h in ipairs(file:get_headlines()) do
      if h:get_range().start_line == target_line then
        fresh_headline = h
        break
      end
    end

    if not fresh_headline then
      Log.warn("Cannot find headline at line " .. target_line)
      return
    end

    local Date = lazy "orgmode.objects.date"

    -- Step 3: set LAST_REPEAT pada headline yang sudah fresh
    fresh_headline:set_property("LAST_REPEAT", Date.now():to_wrapped_string(false))

    -- Step 4: add state note
    local indent = fresh_headline:get_indent()
    local note = ("%s- State %-12s from %-12s [%s]"):format(indent, [["DONE"]], [["TODO"]], Date.now():to_string())
    fresh_headline:add_note { note }

    vim.cmd "silent! write"
  end)
end

---@param tags string[]
local function remove_todo_by_tag(tags)
  local files = Org.files

  local EventManager = lazy "orgmode.events"
  local events = EventManager.event

  if not files then
    return
  end

  local processed = {}

  for _, file in ipairs(files:all()) do
    for _, headline in ipairs(file:get_headlines()) do
      local todos = headline:get_todo()

      if not (todos and todos == "TODO") then
        goto continue_headline_loop
      end

      local has_matching_tag = false
      for _, tag in ipairs(tags) do
        if headline:has_tag(tag) then
          has_matching_tag = true
          break
        end
      end
      if not has_matching_tag then
        goto continue_headline_loop
      end

      local todo_schedule = headline:get_scheduled_date()
      if not todo_schedule or not todo_schedule.active then
        goto continue_headline_loop
      end

      local raw_date = todo_schedule:without_adjustments()
      local now = os.date "*t"

      local is_past = (raw_date.year < now.year)
        or (raw_date.year == now.year and raw_date.month < now.month)
        or (raw_date.year == now.year and raw_date.month == now.month and raw_date.day < now.day)

      local is_today = (raw_date.year == now.year) and (raw_date.month == now.month) and (raw_date.day == now.day)

      -- Ignore todo today if the scheduled time has not been reached yet
      local today_is_due = is_today
        and (
          not raw_date.hour -- tidak ada jam → anggap due
          or (raw_date.hour < now.hour)
          or (raw_date.hour == now.hour and (raw_date.min or 0) <= now.min)
        )

      local is_past_or_today = is_past or today_is_due

      if not is_past_or_today then
        goto continue_headline_loop
      end

      local repeater_dates = headline:get_repeater_dates()
      if #repeater_dates == 0 then
        goto continue_headline_loop
      end

      local filename = file.filename
      local bufnr = UtilCmd.get_or_create_bufnr(filename)
      if bufnr == nil then
        goto continue_headline_loop
      end

      local old_state = headline:get_todo()
      local was_done = headline:is_done()

      EventManager.dispatch(events.TodoChanged:new(headline, old_state, was_done))
      set_repeater_todo(bufnr, repeater_dates, headline)

      table.insert(processed, {
        title = headline:get_title(),
        file = vim.fn.fnamemodify(filename, ":t"), -- hanya nama file, tanpa path penuh
        old_date = todo_schedule:without_adjustments():to_string(),
        new_date = repeater_dates[1]:apply_repeater():to_string(),
      })

      ::continue_headline_loop::
    end
  end

  if #processed == 0 then
    Log.info "No expired repeater tasks found"
  else
    local lines = { ("Processed %d repeater task(s):"):format(#processed) }
    for _, item in ipairs(processed) do
      table.insert(lines, ("  • [%s] %s"):format(item.file, item.title))
      table.insert(lines, ("    %s → %s"):format(item.old_date, item.new_date))
    end
    Log.info(table.concat(lines, "\n"))
  end
end

M.remove_repeater_todo = function()
  -- NOTE: disarankan menggunakan tag yang di set di `#+filetags`,
  -- bukan pada heading TODO, jika menggunakan tag pada heading
  -- hasilnya kurang optimal, string bakal di apply pada incorrect line
  local tags = { "working", "workout" }
  remove_todo_by_tag(tags)
end

return M
