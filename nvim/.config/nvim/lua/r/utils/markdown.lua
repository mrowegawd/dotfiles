---@class r.utils.markdown
local M = {}

local data_tags_table = {}
local data_tags_out = {}
local data_title_out = {}
local insert_tags = {}

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

local regex_title = [[^#{1,}\s[\w<`].*$]] -- [[^#{1,}\s\w.*$]]
local regex_title_org = [[^\*{1,}\s[\w<`].*$]] -- [[^#{1,}\s\w.*$]]

local builtin = require "fzf-lua.previewer.builtin"
local Tagpreviewer = builtin.buffer_or_file:extend()

-- local TagCharsOptional = "[A-Za-z0-9_/-]*"
local TagCharsRequired = "[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+" -- assumes tag is at least 2 chars
local rg_opts =
  "--column --hidden --no-heading --ignore-case --smart-case --color=always --colors match:fg:178 --max-columns=4096 "

rg_opts = rg_opts .. " ~/Dropbox/neorg -e status"

local function format_data_tags(data_tag)
  local line = string.gsub(data_tag.lines.text, '"(%d+)"', "%1")
  line = string.gsub(line, "-%s", "")
  return {
    tag = RUtils.cmd.strip_whitespace(line),
    line_number = data_tag.line_number,
    path = data_tag.path.text,
    title = data_tag.title or "",
  }
end

local function format_tag_text(data_tag)
  local line = string.gsub(data_tag.lines.text, '\\"', "")
  line = string.gsub(line, "-%s", "") -- remove strip '- tags'
  return RUtils.cmd.strip_whitespace(line)
end

local function format_title_tag(data_tag)
  local line = string.gsub(data_tag.lines.text, '\\"', "")
  line = string.gsub(line, "#%s", "")
  return {
    title = RUtils.cmd.strip_whitespace(line),
    line_number = data_tag.line_number,
    path = data_tag.path.text,
  }
end

local function is_valid_json(str)
  local ok, _ = pcall(vim.json.decode, str)
  return ok
end

local function check_duplicate_element_data_tags(tbl, element)
  for _, x in pairs(tbl) do
    if x["text"] == element then
      return true
    end
  end
  return false
end

local function get_height_width_row_col_window()
  local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
  local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

  local win_height = math.ceil(lines * 0.5)
  local win_width = math.ceil(columns * 1)
  local col = math.ceil((columns - win_width) * 1)
  local row = math.ceil((lines - win_height) * 1 - 3)

  return win_height, win_width, row, col
end

local function extracted_str_tags(entry, data_tbl)
  local data = {}

  local text = vim.split(entry, "|")
  if not text then
    return data
  end

  for _, x in pairs(data_tbl) do
    local x_title_str = RUtils.fzflua.__strip_str(x.title)
    if not x_title_str then
      return data
    end

    if x_title_str == text[2] then
      data = {
        path = x.path,
        line = x.line_number,
        col = 1,
        text = x_title_str,
      }
    end
  end

  return data
end

local function open_with(mode, entry, data_tbl, is_open_folded)
  is_open_folded = is_open_folded or false

  local data = extracted_str_tags(entry, data_tbl)

  vim.cmd(mode .. " " .. data.path)
  vim.api.nvim_win_set_cursor(0, { tonumber(data.line), 1 })
  if is_open_folded then
    vim.cmd "normal! zv"
  end
end

---@param selected string[]
local function extracted_selected_tags(selected, data_tbl)
  local items = {}
  if #selected > 1 then
    for _, sel in pairs(selected) do
      local data = extracted_str_tags(sel, data_tbl)

      if not check_duplicate_element_data_tags(items, data.text) then
        items[#items + 1] = {
          filename = data.path,
          lnum = data.line,
          col = data.col,
          text = data.text,
        }
      end
    end
  else
    local data = extracted_str_tags(selected[1], data_tbl)
    if not check_duplicate_element_data_tags(items, data.text) then
      items[#items + 1] = {
        filename = data.path,
        lnum = data.line,
        col = data.col,
        text = data.text,
      }
    end
  end

  return items
end

local function json_output_wrapper(json_str)
  local output
  local ok, decoded = pcall(vim.json.decode, json_str)
  if decoded == vim.NIL or decoded == "" then
    output = nil
  end

  if ok then
    output = decoded
    return output
  end
end

local function collect_all_tags_async(data, cb, is_for_tags)
  is_for_tags = is_for_tags or false
  data = data or {}

  local rg_optsc = "--no-config --json --type=md --ignore-case"
  local msg_cmds = "rg "
    .. rg_optsc
    .. ' -e "tags: .*[a-z]+[a-z0-9_/-]*[a-z0-9]+"'
    .. ' -e "^\\s\\s*- [a-z]+[a-z0-9_/-]*[a-z0-9]+$"'
    .. ' -e "^#\\s[A-Za-z]+[A-Za-z0-9_/-]*[a-z0-9].*"'
    .. " "
    .. RUtils.config.path.wiki_path

  coroutine.wrap(function()
    local co = coroutine.running()

    RUtils.cmd.run_jobstart(msg_cmds, function(_, dataout, event)
      if event == "stdout" then
        if dataout and #dataout > 0 then
          for _, line in ipairs(dataout) do
            if #line == 0 then
              goto continue
            end

            if string.match(line, "binary_offset") ~= nil then
              goto continue
            end

            if not is_valid_json(line) then
              goto continue
            end

            local json_data = json_output_wrapper(line)
            if not json_data then
              goto continue
            end

            local match_data = json_data.data
            if not match_data.path or not match_data.lines then
              goto continue
            end

            local line_text = match_data.lines.text

            -- hanya butuh tag yang berada pada line frontmatter
            if string.match(line_text, "%s*- ") then
              if match_data.line_number < 23 then
                data_tags_out[#data_tags_out + 1] = format_tag_text(match_data)
                coroutine.resume(co, 0)
              end
            end

            if string.match(line_text, "^# ") then
              if match_data.line_number < 28 then
                data_title_out[#data_title_out + 1] = format_title_tag(match_data)
                coroutine.resume(co, 0)
              end
            end

            ::continue::
          end
        end
      elseif event == "stderr" then
        vim.cmd "echohl Error"
        vim.cmd('echomsg "' .. table.concat(dataout, " ") .. '"')
        vim.cmd "echohl None"
        coroutine.resume(co, 2)
      elseif event == "exit" then
        coroutine.resume(co, 1)
      end
    end)

    repeat
      -- Waiting for a call to 'resume'
      local ret = coroutine.yield()
    until ret ~= 0

    if #data_tags_out > 0 then
      local data_tags = RUtils.cmd.remove_duplicates_tbl(data_tags_out)

      if is_for_tags then
        for _, x in pairs(data_tags) do
          vim.api.nvim_put({ x }, "l", false, true)
        end
        return
      end
      cb(data_tags)
    end
  end)()
end

local function format_prompt_strings(msg)
  msg = msg or ""

  local title_fzf = "Obsidian"
  if #msg > 0 then
    title_fzf = title_fzf .. " > " .. msg
  end

  if #insert_tags > 0 then
    local tags = "[" .. table.concat(insert_tags, ", ") .. "]"
    title_fzf = string.format("%s > %s", title_fzf, tags)
  end
  return RUtils.fzflua.format_title(title_fzf, RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.tag))
end

local function processed_dataout(dataout)
  local entries_data = {}
  for _, line in ipairs(dataout) do
    if #line == 0 then
      goto continue
    end

    if string.match(line, "binary_offset") ~= nil then
      goto continue
    end

    if not is_valid_json(line) then
      goto continue
    end

    local json_data = json_output_wrapper(line)
    if not json_data then
      goto continue
    end

    local match_data = json_data.data
    if not match_data.path or not match_data.lines then
      goto continue
    end

    local line_text = match_data.lines.text
    if not string.match(line_text, "%s%s*- ") then
      goto continue
    end

    local formated_data_tags = format_data_tags(match_data)

    for _, x in pairs(data_title_out) do
      if x.path == formated_data_tags.path then
        formated_data_tags.title = x.title
      end
    end

    if #formated_data_tags.title > 0 then
      entries_data[#entries_data + 1] = formated_data_tags
      data_tags_table[#data_tags_table + 1] = formated_data_tags
    end

    ::continue::
  end

  return entries_data
end

local function picker(contents, actions, opts)
  opts = opts or {}

  actions = actions
    or {
      ["enter"] = function(selected, _)
        if not selected then
          return
        end
        open_with("edit", selected[1], data_tags_table, true)
      end,

      ["ctrl-v"] = function(selected, _)
        if not selected then
          return
        end
        open_with("vsplit", selected[1], data_tags_table, true)
      end,

      ["ctrl-s"] = function(selected, _)
        if not selected then
          return
        end
        open_with("split", selected[1], data_tags_table, true)
      end,

      ["ctrl-t"] = function(selected, _)
        open_with("tabnew", selected[1], data_tags_table, true)
      end,

      ["alt-q"] = function(selected, _)
        if not selected then
          return
        end
        local items = extracted_selected_tags(selected, data_tags_table)
        RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note")
      end,

      -- https://github.com/ibhagwan/fzf-lua/discussions/1211
      ["alt-Q"] = {
        prefix = "toggle-all",
        fn = function(selected, _)
          if not selected then
            return
          end

          local items = extracted_selected_tags(selected, data_tags_table)
          RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note All")
        end,
      },

      ["alt-l"] = function(selected, _)
        if not selected then
          return
        end

        local items = extracted_selected_tags(selected, data_tags_table)
        RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note", true)
      end,

      ["alt-L"] = {
        prefix = "toggle-all",
        fn = function(selected, _)
          if not selected then
            return
          end

          local items = extracted_selected_tags(selected, data_tags_table)
          RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note All", true)
        end,
      },

      ["ctrl-f"] = function(selected, _)
        if not selected then
          return
        end

        local items = extracted_selected_tags(selected, data_tags_table)

        local path_items = {}
        for _, x in pairs(items) do
          path_items[#path_items + 1] = x.filename
        end

        M.find_local_titles(path_items)
      end,

      ["alt-i"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, " ")

        table.insert(insert_tags, sel[1])
        insert_tags = RUtils.cmd.remove_duplicates_tbl(insert_tags)

        ---@diagnostic disable-next-line: undefined-field
        RUtils.info("Add tag: " .. vim.inspect(insert_tags), { title = "Markdown" })
        require("fzf-lua").actions.resume()
      end,

      ["alt-h"] = function()
        if #insert_tags == 0 then
          ---@diagnostic disable-next-line: undefined-field
          RUtils.warn("you need add your spesific tag first!", { title = "Markdown Tag Filter" })
          require("fzf-lua").actions.resume()
          return
        end
        M.find_note_by_tag { fargs = insert_tags }
        insert_tags = {}
      end,

      ["ctrl-r"] = function()
        insert_tags = {}
        M.find_note_by_tag()
      end,

      ["ctrl-g"] = function(selected, _)
        if not selected then
          return
        end

        local items = extracted_selected_tags(selected, data_tags_table)

        local path_items = {}
        for _, x in pairs(items) do
          path_items[#path_items + 1] = x.filename
        end

        M.live_grep_note(path_items)
      end,
    }

  function Tagpreviewer:new(o, optsc, fzf_win)
    Tagpreviewer.super.new(self, o, optsc, fzf_win)
    setmetatable(self, Tagpreviewer)
    return self
  end

  function Tagpreviewer:parse_entry(entry_str)
    local data = extracted_str_tags(entry_str, data_tags_table)
    if not data then
      return {}
    end

    return data
  end

  return fzf_lua.fzf_exec(
    contents,
    RUtils.fzflua.open_center_big {
      previewer = Tagpreviewer,
      prompt = RUtils.fzflua.padding_prompt(),
      winopts = { title = format_prompt_strings "Search By Tag" },
      fzf_opts = { ["--header"] = [[^r:reload  ^g:grep  ^f:greptitle  a-i:filtertag  a-h:addtag]] },
      actions = actions,
    }
  )
end

local function list_tags_async(all_tags, is_set)
  is_set = is_set or false

  local function concatting_tags()
    local search_terms = {}
    for _, t in pairs(all_tags) do
      if string.len(t) > 0 then
        -- tag in the wild
        -- search_terms[#search_terms + 1] = "#" .. TagCharsOptional .. t .. TagCharsOptional
        -- frontmatter tag in multiline list
        -- search_terms[#search_terms + 1] = "\\s*- " .. TagCharsOptional .. t .. TagCharsOptional .. "$"
        search_terms[#search_terms + 1] = "^\\s\\s*- " .. t .. "$"
        -- frontmatter tag in inline list
        -- search_terms[#search_terms + 1] = "tags: .*" .. TagCharsOptional .. t .. TagCharsOptional
        -- else
        --   -- tag in the wild
        --   -- search_terms[#search_terms + 1] = "#" .. TagCharsRequired
        --   -- frontmatter tag in multiline list
        --   search_terms[#search_terms + 1] = "\\s*- " .. TagCharsRequired .. "$"
        --   -- frontmatter tag in inline list
        --   search_terms[#search_terms + 1] = "tags: .*" .. TagCharsRequired
      end
    end
    return search_terms
  end

  local rg_optsc = "--no-config --json --type=md --ignore-case"

  local line_e = ""
  if #all_tags > 1 then
    for _, x in pairs(concatting_tags()) do
      line_e = line_e .. string.format(' -e "%s" ', x)
    end
  else
    line_e = string.format(' -e "%s" ', "^\\s\\s*- " .. all_tags[1] .. "$")
  end

  local msg_cmd = "rg " .. rg_optsc .. line_e .. RUtils.config.path.wiki_path

  local contents = function(cb)
    coroutine.wrap(function()
      local co = coroutine.running()

      RUtils.cmd.run_jobstart(msg_cmd, function(_, dataout, event)
        local entries_data = {}

        if event == "stdout" then
          if dataout and #dataout > 0 then
            entries_data = processed_dataout(dataout)
            if vim.tbl_isempty(entries_data) then
              return
            end

            -- data_tags_table = entries_data

            -- local get_width = function()
            --   local width_tag = 1
            --   for _, entry in pairs(entries_data) do
            --     if width_tag < #entry.tag + 1 then
            --       width_tag = #entry.tag + 1
            --     end
            --   end
            --   return width_tag
            -- end
            -- local width_tag = get_width()
            -- RUtils.info(width_tag)

            for _, entry in pairs(entries_data) do
              local fzf_str = string.format("%-57s %-4s |%s", entry.tag, "[" .. entry.line_number .. "]", entry.title)

              cb(require("fzf-lua").make_entry.file(fzf_str, {}), function()
                coroutine.resume(co, 0)
              end)
            end
          end
        elseif event == "stderr" then
          vim.cmd "echohl Error"
          vim.cmd('echomsg "' .. table.concat(dataout, " ") .. '"')
          vim.cmd "echohl None"
          coroutine.resume(co, 2)
        elseif event == "exit" then
          coroutine.resume(co, 1)
        end
      end)

      repeat
        -- Waiting for a call to 'resume'
        local ret = coroutine.yield()
      -- print("yielded ", ret)
      until ret ~= 0
      cb(nil)
    end)()
  end

  return picker(contents)
end

local function get_sel_text()
  local title = vim.fn.expand "<cWORD>"
  local stitle = title

  if string.find(title, "%[") or string.find(title, "%]") then
    vim.cmd "normal yi]"
    title = vim.fn.getreg '"0'
    stitle = string.gsub(stitle, "%[", "")
    stitle = string.gsub(stitle, "%]", "")
    return true, stitle
  end

  return false, stitle
end

local function is_markdown_file(path)
  vim.validate { path = { path, "string" } }
  if path:match "%.md$" or path:match "%.markdown$" then
    return true
  end
  return false
end

function M.find_note_by_tag(data, is_set, is_for_tags)
  is_set = is_set or false
  is_for_tags = is_for_tags or false
  data = data or {}
  local tags = data.fargs or {}

  if vim.tbl_isempty(tags) then
    -- Check for visual selection.
    local viz = RUtils.cmd.get_visual_selection { strict = true }
    if viz and #viz.lines == 1 and string.match(viz.selection, "^#?" .. TagCharsRequired .. "$") then
      local tag = viz.selection

      if vim.startswith(tag, "#") then
        tag = string.sub(tag, 2)
      end

      tags = { tag }
      -- else
      --   -- Otherwise check for a tag under the cursor.
      --   local tag = cursor_tag()
      --   if tag then
      --     tags = { tag }
      --   end
    end
  end

  if not vim.tbl_isempty(tags) then
    list_tags_async(tags, true)
  else
    collect_all_tags_async(tags, function(all_tags)
      -- print(vim.inspect(all_tags))
      -- vim.schedule(function()
      list_tags_async(all_tags, is_set)
    end, is_for_tags)
  end
end

function M.find_global_titles()
  local filename

  if not filename then
    local starting_bufname = vim.api.nvim_buf_get_name(0)
    filename = vim.fn.fnamemodify(starting_bufname, ":p")
  end

  fzf_lua.grep {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    search = is_markdown_file(filename) and regex_title or regex_title_org,
    rg_glob = false,
    no_esc = true,
    -- file_ignore_patterns = { "%.norg$", "%.json$", vim.bo.filetype == "markdown" and "%.org$" or "%.md$" },
    -- rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]],
    file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
    winopts = {
      title = format_prompt_strings "Jump Global Title",
      fullscreen = false,
      height = 0.90,
      width = 0.90,
      row = 0.50,
      col = 0.50,
    },
  }
end

function M.find_local_titles(item_paths)
  local _is_single = true
  local is_markdown_file_regex
  local filename = ""

  local is_many = item_paths and #item_paths > 1

  if item_paths == nil then
    local starting_bufname = vim.api.nvim_buf_get_name(0)
    filename = vim.fn.fnamemodify(starting_bufname, ":p")
    is_markdown_file_regex = filename
  else
    if type(item_paths) == "string" then
      filename = item_paths
      is_markdown_file_regex = filename
    end

    if type(item_paths) == "table" then
      filename = table.concat(item_paths, " ")
      is_markdown_file_regex = item_paths[1]
    end
  end

  function Tagpreviewer:new(o, opts, fzf_win)
    Tagpreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, Tagpreviewer)
    return self
  end

  function Tagpreviewer:parse_entry(entry_str)
    local idx = entry_str and tonumber(entry_str:match "(%d+).") or nil
    if not idx then
      return {}
    end

    if item_paths and type(item_paths) == "table" then
      if not is_many then
        filename = item_paths[1]
      else
        local entry_str_strip = RUtils.fzflua.__strip_str(entry_str)
        -- Debug output:
        -- tmuxconfig/.config/tmuxconfig/scripts/fzf_panes.tmux:10:1:# invoked by pane-focus-in event
        if not entry_str_strip then
          return {}
        end

        -- Split entry_str_strip to extract the filename
        local entry_filename = vim.split(entry_str_strip, ":")[1]
        if not entry_filename then
          return {}
        end

        local is_found = false
        local entry_full_filename = vim.fn.fnamemodify(entry_filename, ":p")

        for _, item_path in pairs(item_paths) do
          if item_path == entry_full_filename then
            is_found = true
            filename = item_path
          end
        end

        if not is_found then
          ---@diagnostic disable-next-line: undefined-field
          RUtils.warn "An error occurred in the find_local_titles previewer"
          return {}
        end
      end
    end

    return {
      path = filename,
      line = idx,
      col = 1,
    }
  end

  return fzf_lua.grep(RUtils.fzflua.open_center_big {
    prompt = RUtils.fzflua.padding_prompt(),
    previewer = Tagpreviewer,
    no_esc = true,
    rg_glob = false,
    search = is_markdown_file(is_markdown_file_regex) and regex_title or regex_title_org,
    rg_opts = [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
      .. filename
      .. " -e ",
    fzf_opts = {
      ["--delimiter"] = "[:\t]",
      -- Separated by tab and ':', 1: file icon+name, 2: file path 3: line number, it is dependes on rg_opts whether column or line number is enabled or not.
      ["--with-nth"] = "3..",
      -- ["--with-nth"] = "2..",
      -- Search fileds
      ["--nth"] = "1..",
    },
    winopts = {
      title = format_prompt_strings "Jump Local Title",
    },
    actions = {
      ["enter"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if not sel then
          return
        end

        vim.cmd("e " .. filename)
        sel = vim.split(sel, ":")
        local row = _is_single and tonumber(sel[1]) or tonumber(sel[2])
        vim.api.nvim_win_set_cursor(0, { row, 1 })
        vim.cmd "normal! zv"
      end,
      ["alt-l"] = function(selected, _)
        local items = {}
        local _text, lnum
        if #selected > 1 then
          for _, sel in pairs(selected) do
            local sel_strip = RUtils.fzflua.__strip_str(sel)
            if not sel_strip then
              return
            end

            local split_sel = vim.split(sel_strip, ":")

            if type(item_paths) == "string" then
              _text = split_sel[3]
              lnum = split_sel[1]
            end

            if type(item_paths) == "table" then
              _text = split_sel[4]
              lnum = split_sel[2]
              filename = vim.fn.fnamemodify(split_sel[1], ":p")
            end

            items[#items + 1] = {
              filename = filename,
              lnum = lnum,
              col = 1,
              text = _text,
            }
          end
        else
          local sel_strip = RUtils.fzflua.__strip_str(selected[1])
          if not sel_strip then
            return
          end

          local split_sel = vim.split(sel_strip, ":")

          if type(item_paths) == "string" then
            _text = split_sel[3]
            lnum = split_sel[1]
          end

          if type(item_paths) == "table" then
            _text = split_sel[4]
            lnum = split_sel[2]
            filename = vim.fn.fnamemodify(split_sel[1], ":p")
          end

          items[#items + 1] = {
            filename = filename,
            lnum = lnum,
            col = 1,
            text = _text,
          }
        end

        RUtils.qf.save_to_qf_and_auto_open_qf(items, "Title local", true)
      end,
      ["alt-q"] = function(selected, _)
        local items = {}
        local _text, lnum
        if #selected > 1 then
          for _, sel in pairs(selected) do
            local sel_strip = RUtils.fzflua.__strip_str(sel)
            if not sel_strip then
              return
            end

            local split_sel = vim.split(sel_strip, ":")

            if type(item_paths) == "string" then
              _text = split_sel[3]
              lnum = split_sel[1]
            end

            if type(item_paths) == "table" then
              _text = split_sel[4]
              lnum = split_sel[2]
              filename = vim.fn.fnamemodify(split_sel[1], ":p")
            end

            items[#items + 1] = {
              filename = filename,
              lnum = lnum,
              col = 1,
              text = _text,
            }
          end
        else
          local sel_strip = RUtils.fzflua.__strip_str(selected[1])
          if not sel_strip then
            return
          end

          local split_sel = vim.split(sel_strip, ":")

          if type(item_paths) == "string" then
            _text = split_sel[3]
            lnum = split_sel[1]
          end

          if type(item_paths) == "table" then
            _text = split_sel[4]
            lnum = split_sel[2]
            filename = vim.fn.fnamemodify(split_sel[1], ":p")
          end

          items[#items + 1] = {
            filename = filename,
            lnum = lnum,
            col = 1,
            text = _text,
          }
        end

        RUtils.qf.save_to_qf_and_auto_open_qf(items, "Title local")
      end,

      ["ctrl-v"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          local row = _is_single and tonumber(sel[1]) or tonumber(sel[2])
          vim.cmd("vsplit " .. filename)
          vim.api.nvim_win_set_cursor(0, { row, 1 })
          vim.cmd "normal! zv"
        end
      end,

      ["ctrl-s"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          local row = _is_single and tonumber(sel[1]) or tonumber(sel[2])
          vim.cmd("split " .. filename)
          vim.api.nvim_win_set_cursor(0, { row, 1 })
          vim.cmd "normal! zv"
        end
      end,
      ["ctrl-t"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          local row = _is_single and tonumber(sel[1]) or tonumber(sel[2])
          vim.cmd("tabe " .. filename)
          vim.api.nvim_win_set_cursor(0, { row, 1 })
          vim.cmd "normal! zv"
        end
      end,
    },
  })
end

function M.find_local_sitelink()
  fzf_lua.lgrep_curbuf {
    prompt = RUtils.fzflua.padding_prompt(),
    winopts = {
      title = RUtils.fzflua.format_title("Note: title curbuf", ""),
    },
    no_esc = true,
    search = [[http.*$]],
    formatter = false,
    actions = {
      ["enter"] = function(selected, _)
        local sel = selected[1]
        local sel_str = RUtils.fzflua.__strip_str(sel)

        if sel_str then
          local line_number = tonumber(sel_str:match "[%d]+")
          local line_count = vim.api.nvim_buf_line_count(0) + 1

          if line_count > line_number then
            vim.api.nvim_win_set_cursor(0, { line_number, 1 })
          end
        end
      end,
    },
  }
end

function M.find_backlinks()
  local is_str, curr_line_func = get_sel_text()
  local stitle = curr_line_func

  if not is_str then
    local char_under_cursor = vim.fn.expand "<cWORD>"
    ---@diagnostic disable-next-line: undefined-field
    RUtils.warn("'" .. char_under_cursor .. "' is not the link, this is the link --> [[ ... ]]", { title = "Markdown" })
    return
  end

  fzf_lua.grep {
    cwd = RUtils.config.path.wiki_path,
    search = "[[" .. stitle .. "]]",
    no_header = true,
    no_header_i = true,
    file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
    fzf_opts = { ["--header"] = false }, -- do not display our custom header
    winopts = {
      title = format_prompt_strings("Find Backlinks > [[" .. stitle .. "]]"),
      fullscreen = false,
      height = 0.90,
      width = 0.90,
      row = 0.50,
      col = 0.50,
    },
  }
end

function M.live_grep_note(path_items)
  local is_many = true
  if #path_items == 1 then
    is_many = false
  end

  function Tagpreviewer:new(o, opts, fzf_win)
    Tagpreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, Tagpreviewer)
    return self
  end

  function Tagpreviewer:parse_entry(entry_str)
    local str_e = RUtils.fzflua.__strip_str(entry_str)
    -- Debug output:
    -- tmuxconfig/.config/tmuxconfig/scripts/fzf_panes.tmux:10:1:# invoked by pane-focus-in event
    if not str_e then
      return {}
    end

    local split_entry = vim.split(str_e, ":")
    if not split_entry then
      return {}
    end

    local filename, line, col
    if not is_many then
      -- RUtils.info(vim.inspect(split_entry))
      filename = path_items[1]
      line = split_entry[1]
      col = split_entry[2]
    else
      filename = vim.fn.fnamemodify(split_entry[1], ":p")
      line = split_entry[2]
      col = split_entry[3]
    end

    return {
      path = filename,
      line = line,
      col = col,
    }
  end

  local rg_opts_format = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
    .. table.concat(path_items, " ")
    .. " -e "

  fzf_lua.live_grep(RUtils.fzflua.open_center_big {
    previewer = Tagpreviewer,
    rg_opts = rg_opts_format,
    no_esc = true,
    rg_glob = false,
    fzf_opts = {
      ["--delimiter"] = "[:\t]",
    },
    winopts = {
      title = RUtils.fzflua.format_title("Grep filter note", " "),
    },
  })
end

function M.insert_by_categories()
  local win_height, win_width, row, col = get_height_width_row_col_window()
  collect_all_tags_async({}, function(all_tags)
    vim.schedule(function()
      picker(all_tags, {
        ["enter"] = function(selected, _)
          local selection = selected[1]
          vim.api.nvim_put({ selection }, "c", false, true)
        end,
      }, {
        winopts = {
          width = win_width,
          height = win_height,
          row = row,
          col = col,
          title = format_prompt_strings "Insert By Tag",
          fullscreen = false,
          preview = { hidden = true },
        },
      })
    end)
  end)
end

function M.insert_local_titles()
  local filename

  if not filename then
    local starting_bufname = vim.api.nvim_buf_get_name(0)
    filename = vim.fn.fnamemodify(starting_bufname, ":p")
  end

  fzf_lua.lgrep_curbuf {
    prompt = RUtils.fzflua.padding_prompt(),
    winopts = {
      title = format_prompt_strings "Insert By Local Title",
      width = 0.90,
      height = 0.90,
      row = 0.50,
      col = 0.50,
      fullscreen = true,
      preview = {
        layout = "horizontal",
        vertical = "down:50%",
        horizontal = "up:45%",
      },
    },
    rg_glob = false,
    no_esc = true,
    search = is_markdown_file(filename) and regex_title or regex_title_org,
    formatter = false,
    actions = {
      ["enter"] = function(selected, _)
        local sel = selected[1]
        local sel_str = RUtils.fzflua.__strip_str(sel)

        if sel_str then
          local title_cur_note = string.match(sel_str, "(#[%w-_=:.,(){}`%s]+)")
          title_cur_note = string.gsub(title_cur_note, "^#%s", "")

          vim.api.nvim_put({
            "[[#" .. title_cur_note .. "]]",
          }, "c", false, true)
        end
      end,
    },
  }
end

function M.insert_global_titles()
  local filename

  if not filename then
    local starting_bufname = vim.api.nvim_buf_get_name(0)
    filename = vim.fn.fnamemodify(starting_bufname, ":p")
  end

  fzf_lua.grep {
    prompt = RUtils.fzflua.padding_prompt(),
    winopts = { title = format_prompt_strings "Insert By Global Title" },
    rg_glob = false,
    no_esc = true,
    search = is_markdown_file(filename) and regex_title or regex_title_org,
    cwd = RUtils.config.path.wiki_path,
    file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
    actions = {
      ["enter"] = function(selected, _)
        local selection = selected[1]

        local parts = vim.split(selection, ".md")
        local path_name = vim.split(parts[1], "/")
        local path_file = path_name[#path_name]

        local path_heading = vim.split(parts[2], "#")
        -- remove space
        local path_linkheading = string.gsub(path_heading[#path_heading], "^%s", "")

        local path_str = RUtils.fzflua.__strip_str(path_file)
        if path_str == nil then
          return
        end
        vim.api.nvim_put({
          "[[" .. path_str .. "#" .. path_linkheading .. "]]",
        }, "c", false, true)
      end,
    },
  }
end

function M.cursor_in_code_block(cursor_row, reverse)
  if reverse == nil or reverse == false then
    reverse = false
  else
    reverse = true
  end
  local lines = reverse and vim.api.nvim_buf_get_lines(0, cursor_row - 1, -1, false)
    or vim.api.nvim_buf_get_lines(0, 0, cursor_row, false)
  local fences = 0
  for _, line_text in ipairs(lines) do
    local _, count = string.gsub(line_text, "^```", "```")
    fences = fences + count
  end
  if fences % 2 == 0 then
    return false
  end
  return true
end

local links = {
  style = "markdown",
  name_is_source = false,
  transform_implicit = false,
  transform_explicit = function(text)
    text = text:gsub("[ /]", "-")
    text = text:lower()
    text = os.date "%Y-%m-%d_" .. text
    return text
  end,
}

local transformPath = function(text)
  if type(links.transform_explicit) ~= "function" or not links.transform_explicit then
    return text
  else
    return (links.transform_explicit(text))
  end
end

local formatLink = function(text, source, part)
  local replacement, path_text
  -- If the text starts with a hash, format the link as an anchor link
  if string.sub(text, 0, 1) == "#" and not source then
    path_text = string.gsub(text, "[^%a%s%d%-_]", "")
    text = string.gsub(text, "^#* *", "")
    path_text = string.gsub(path_text, "^ ", "")
    path_text = string.gsub(path_text, " ", "-")
    path_text = string.gsub(path_text, "%-%-", "-")
    path_text = "#" .. string.lower(path_text)
  elseif not source then
    path_text = transformPath(text)
    -- If no path_text, end here
    if not path_text then
      return
    end
    if not links.implicit_extension then
      path_text = path_text .. ".md"
    end
  else
    path_text = source
  end
  -- Format the replacement depending on the user's link style preference
  if links.style == "wiki" then
    replacement = (links.name_is_source and { "[[" .. text .. "]]" }) or { "[[" .. path_text .. "|" .. text .. "]]" }
  else
    replacement = { "[" .. text .. "]" .. "(" .. path_text .. ")" }
  end
  -- Return the requested part
  if part == nil then
    return replacement
  elseif part == 1 then
    return text
  elseif part == 2 then
    return path_text
  end
end

local cursorInCodeBlock = function(cursor_row, reverse)
  if reverse == nil or reverse == false then
    reverse = false
  else
    reverse = true
  end
  local lines = reverse and vim.api.nvim_buf_get_lines(0, cursor_row - 1, -1, false)
    or vim.api.nvim_buf_get_lines(0, 0, cursor_row, false)
  local fences = 0
  for _, line_text in ipairs(lines) do
    local _, count = string.gsub(line_text, "^```", "```")
    fences = fences + count
  end
  if fences % 2 == 0 then
    return false
  end
  return true
end

function M.go_to_heading(anchor_text, reverse)
  local silent = true
  local wrap = false

  -- Taken from and credit: https://github.com/jakewvincent/mkdnflow.nvim/blob/0fa1e682e35d46cd1a0102cedd05b0283e41d18d/lua/mkdnflow/cursor.lua#L138

  -- Record which line we're on; chances are the link goes to something later,
  -- so we'll start looking from here onwards and then circle back to the beginning
  local position = vim.api.nvim_win_get_cursor(0)
  local starting_row, continue = position[1], true
  local in_fenced_code_block = cursorInCodeBlock(starting_row, reverse)
  local row = (reverse and starting_row - 1) or starting_row + 1
  while continue do
    local line = (reverse and vim.api.nvim_buf_get_lines(0, row - 1, row, false))
      or vim.api.nvim_buf_get_lines(0, row - 1, row, false)
    -- If the line has contents, do the thing
    if line[1] then
      -- Are we in a code block?
      if string.find(line[1], "^```") then
        -- Flip the truth value
        in_fenced_code_block = not in_fenced_code_block
      end
      -- Does the line start with a hash?
      local has_heading = string.find(line[1], "^#")
      if has_heading and not in_fenced_code_block then
        if anchor_text == nil then
          -- Send the cursor to the heading
          vim.api.nvim_win_set_cursor(0, { row, 0 })
          continue = false
        else
          -- Format current heading to see if it matches our search term
          local heading_as_anchor = formatLink(line[1], nil, 2)
          if anchor_text == heading_as_anchor then
            -- Set a mark
            vim.api.nvim_buf_set_mark(0, "`", position[1], position[2], {})
            -- Send the cursor to the row w/ the matching heading
            vim.api.nvim_win_set_cursor(0, { row, 0 })
            continue = false
          end
        end
      end
      row = (reverse and row - 1) or row + 1
      if row == starting_row + 1 then
        continue = false
        if anchor_text == nil then
          local message = "⬇️  Couldn't find a heading to go to!"
          if not silent then
            vim.api.nvim_echo({ { message, "WarningMsg" } }, true, {})
          end
        else
          local message = "⬇️  Couldn't find a heading matching " .. anchor_text .. "!"
          if not silent then
            vim.api.nvim_echo({ { message, "WarningMsg" } }, true, {})
          end
        end
      end
    else
      -- If the line does not have contents, start searching from the beginning
      if anchor_text ~= nil or wrap == true then
        row = (reverse and vim.api.nvim_buf_line_count(0)) or 1
        in_fenced_code_block = false
      else
        continue = false
        local place = (reverse and "beginning") or "end"
        local preposition = (reverse and "after") or "before"
        local message = "⬇️  There are no more headings " .. preposition .. " the " .. place .. " of the document!"
        if not silent then
          vim.api.nvim_echo({ { message, "WarningMsg" } }, true, {})
        end
      end
    end
  end
end

return M
