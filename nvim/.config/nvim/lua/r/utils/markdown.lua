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
    title = "",
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

local function get_height_width_row_col_window()
  local lines = vim.api.nvim_get_option_value("lines", { scope = "local" })
  local columns = vim.api.nvim_get_option_value("columns", { scope = "local" })

  local win_height = math.ceil(lines * 0.5)
  local win_width = math.ceil(columns * 1)
  local col = math.ceil((columns - win_width) * 1)
  local row = math.ceil((lines - win_height) * 1 - 3)

  return win_height, win_width, row, col
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
        if dataout then
          -- __AUTO_GENERATED_PRINT_VAR_START__
          -- print([==[collect_all_tags_async#function#function#if#if dataout:]==], vim.inspect(dataout)) -- __AUTO_GENERATED_PRINT_VAR_END__
          for _, line in ipairs(dataout) do
            if line ~= "" then
              if string.match(line, "binary_offset") == nil then
                local json_data = json_output_wrapper(line)
                if json_data then
                  local match_data = json_data.data
                  if match_data["path"] then
                    if match_data["lines"] then
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
                    end
                  end
                end
              end
            end
          end
        end
      elseif event == "stderr" then
        vim.cmd "echohl Error"
        vim.cmd('echomsg "' .. table.concat(dataout, "") .. '"')
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

local function check_duplicate_element(tbl, element)
  for _, x in pairs(tbl) do
    if x == element then
      return true
    end
  end
  return false
end

local function check_duplicate_element_data_tags(tbl, element)
  for _, x in pairs(tbl) do
    if x["text"] == element then
      return true
    end
  end
  return false
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

local function picker(contents, actions, opts)
  opts = opts or {}

  actions = actions
    or {
      ["enter"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, "|")
        for _, x in pairs(data_tags_table) do
          if x.title == sel[2] then
            vim.cmd("e " .. x.path)
            vim.api.nvim_win_set_cursor(0, { tonumber(x.line_number), 1 })
            vim.cmd "normal! zv"
          end
        end
      end,

      ["ctrl-v"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, "|")
        for _, x in pairs(data_tags_table) do
          if x.title == sel[2] then
            vim.cmd("vsplit " .. x.path)
            vim.api.nvim_win_set_cursor(0, { tonumber(x.line_number), 1 })
            vim.cmd "normal! zv"
            break
          end
        end
      end,

      ["ctrl-s"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, "|")
        for _, x in pairs(data_tags_table) do
          if x.title == sel[2] then
            vim.cmd("split " .. x.path)
            vim.api.nvim_win_set_cursor(0, { tonumber(x.line_number), 1 })
            vim.cmd "normal! zv"
            break
          end
        end
      end,

      ["ctrl-t"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, "|")
        for _, x in pairs(data_tags_table) do
          if x.title == sel[2] then
            vim.cmd("tabe " .. x.path)
            vim.api.nvim_win_set_cursor(0, { tonumber(x.line_number), 1 })
            vim.cmd "normal! zv"
            break
          end
        end
      end,

      ["ctrl-f"] = function(selected, _)
        local path_item
        local path_items_tbl = {}
        if #selected > 1 then
          for _, sel in pairs(selected) do
            local sel_strip = vim.split(sel, "|")
            for _, x in pairs(data_tags_table) do
              if x.title == sel_strip[2] then
                if x.path and not check_duplicate_element(path_items_tbl, x.path) then
                  path_items_tbl[#path_items_tbl + 1] = x.path
                end
              end
            end
          end
        else
          local sel = selected[1]
          sel = vim.split(sel, "|")
          for _, x in pairs(data_tags_table) do
            if x.title == sel[2] then
              path_item = x.path
            end
          end
        end

        if #path_items_tbl > 0 then
          path_item = path_items_tbl
        end
        M.find_local_titles(path_item)
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

      -- https://github.com/ibhagwan/fzf-lua/discussions/1211
      ["ctrl-g"] = {
        fn = function(selected, _)
          local item_data_tbl = {}
          if #selected > 1 then
            for _, sel in pairs(selected) do
              local sel_strip = vim.split(sel, "|")
              for _, x in pairs(data_tags_table) do
                if x.title == sel_strip[2] then
                  if not check_duplicate_element(item_data_tbl, x.path) then
                    item_data_tbl[#item_data_tbl + 1] = x.path
                  end
                end
              end
            end
          else
            local sel_strip = vim.split(selected[1], "|")
            for _, x in pairs(data_tags_table) do
              if x.title == sel_strip[2] then
                if not check_duplicate_element(item_data_tbl, x.path) then
                  item_data_tbl[#item_data_tbl + 1] = x.path
                end
              end
            end
          end

          local rg_opts_format = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
            .. table.concat(item_data_tbl, " ")
            .. " -e "

          local opts_c = {
            -- debug = true,
            rg_opts = rg_opts_format,
            no_esc = true,
            rg_glob = false,
            winopts = {
              title = RUtils.fzflua.format_title("Grep filter note", " "),
              preview = {
                horizontal = "up:60%",
              },
            },
          }

          fzf_lua.live_grep(opts_c)
        end,
      },

      ["alt-q"] = function(selected, _)
        local items = {}
        if #selected > 1 then
          for _, sel in pairs(selected) do
            local sel_str = vim.split(sel, "|")[2]

            for _, tbl_tags in pairs(data_tags_table) do
              if tbl_tags.title == sel_str then
                if not check_duplicate_element_data_tags(items, tbl_tags.title) then
                  items[#items + 1] = {
                    filename = tbl_tags.path,
                    lnum = tbl_tags.line_number,
                    col = 1,
                    text = tbl_tags.title,
                  }
                end
              end
            end
          end
        else
          local sel_str = vim.split(selected[1], "|")[2]
          for _, tbl_tags in pairs(data_tags_table) do
            if tbl_tags.title == sel_str then
              if not check_duplicate_element_data_tags(items, tbl_tags.title) then
                items[#items + 1] = {
                  filename = tbl_tags.path,
                  lnum = tbl_tags.line_number,
                  col = 1,
                  text = tbl_tags.title,
                }
                break
              end
            end
          end
        end

        RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note")
      end,

      ["alt-Q"] = {
        prefix = "select-all+accept",
        fn = function(selected, _)
          local items = {}
          for _, sel in pairs(selected) do
            local sel_str = vim.split(sel, "|")[2]

            for _, tbl_tags in pairs(data_tags_table) do
              if tbl_tags.title == sel_str then
                if not check_duplicate_element_data_tags(items, tbl_tags.title) then
                  items[#items + 1] = {
                    filename = tbl_tags.path,
                    lnum = tbl_tags.line_number,
                    col = 1,
                    text = tbl_tags.title,
                  }
                end
              end
            end
          end

          RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note All")
        end,
      },

      ["alt-l"] = function(selected, _)
        local items = {}
        if #selected > 1 then
          for _, sel in pairs(selected) do
            local sel_str = vim.split(sel, "|")[2]

            for _, tbl_tags in pairs(data_tags_table) do
              if tbl_tags.title == sel_str then
                if not check_duplicate_element_data_tags(items, tbl_tags.title) then
                  items[#items + 1] = {
                    filename = tbl_tags.path,
                    lnum = tbl_tags.line_number,
                    col = 1,
                    text = tbl_tags.title,
                  }
                end
              end
            end
          end
        else
          local sel_str = vim.split(selected[1], "|")[2]
          for _, tbl_tags in pairs(data_tags_table) do
            if tbl_tags.title == sel_str then
              if not check_duplicate_element_data_tags(items, tbl_tags.title) then
                items[#items + 1] = {
                  filename = tbl_tags.path,
                  lnum = tbl_tags.line_number,
                  col = 1,
                  text = tbl_tags.title,
                }
                break
              end
            end
          end
        end

        RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note", true)
      end,

      ["alt-L"] = {
        prefix = "select-all+accept",
        fn = function(selected, _)
          local items = {}
          for _, sel in pairs(selected) do
            local sel_str = vim.split(sel, "|")[2]

            for _, tbl_tags in pairs(data_tags_table) do
              if tbl_tags.title == sel_str then
                if not check_duplicate_element_data_tags(items, tbl_tags.title) then
                  items[#items + 1] = {
                    filename = tbl_tags.path,
                    lnum = tbl_tags.line_number,
                    col = 1,
                    text = tbl_tags.title,
                  }
                end
              end
            end
          end

          RUtils.qf.save_to_qf_and_auto_open_qf(items, "Tags Note All", true)
        end,
      },
    }

  function Tagpreviewer:new(o, optsc, fzf_win)
    Tagpreviewer.super.new(self, o, optsc, fzf_win)
    setmetatable(self, Tagpreviewer)
    return self
  end

  function Tagpreviewer:parse_entry(entry_str)
    local text = vim.split(entry_str, "|")

    local data
    if text then
      for _, x in pairs(data_tags_table) do
        if x.title == text[2] then
          data = {
            path = x.path,
            line = x.line_number,
            col = 1,
          }
        end
      end
    end

    if data then
      return data
    end
    return {}
  end

  local win_height, win_width, row, col = get_height_width_row_col_window()
  return fzf_lua.fzf_exec(
    contents,
    vim.tbl_deep_extend("force", {}, {
      previewer = Tagpreviewer,
      prompt = RUtils.fzflua.padding_prompt(),
      winopts = {
        title = format_prompt_strings "Search By Tag",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        backdrop = 100,
        fullscreen = false,
        -- border = { "", "-", "", "", "", "", "", "" },
        preview = {
          -- border = { "", "-", "", "", "", "", "", "" },
          lazyout = "horizontal",
          vertical = "up:50%", -- up|down:size
          horizontal = "right:50%", -- right|left:size
        },
      },
      fzf_opts = { ["--header"] = [[^r:reload  ^g:grep  ^f:greptitle  m-i:filtertag  m-i:addtag]] },
      actions = actions,
    }, opts)
  )
end

local function is_valid_json(str)
  local ok, _ = pcall(vim.json.decode, str)
  return ok
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
        if event == "stdout" then
          if dataout and #dataout > 0 then
            for _, line in ipairs(dataout) do
              if #line > 0 then
                if string.match(line, "binary_offset") == nil then
                  if is_valid_json(line) then
                    local json_data = json_output_wrapper(line)
                    if json_data then
                      local match_data = json_data.data

                      if match_data["path"] then
                        if match_data["lines"] then
                          local line_text = match_data.lines.text
                          if string.match(line_text, "%s%s*- ") then
                            local data_tags = format_data_tags(match_data)

                            local title_s
                            for _, x in pairs(data_title_out) do
                              if x.path == data_tags.path then
                                title_s = x.title
                              end
                            end

                            if title_s then
                              data_tags.title = title_s
                              data_tags_table[#data_tags_table + 1] = data_tags
                              -- data_tags_table_is_set[#data_tags_table_is_set + 1] = data_tags

                              -- local fzf_str =
                              --   string.format("%s| [%s] %s", data_tags.title, data_tags.line_number, data_tags.tag)

                              local fzf_str = string.format(
                                "%-30s %-4s |%s",
                                data_tags.tag,
                                "[" .. data_tags.line_number .. "]",
                                data_tags.title
                              )

                              cb(require("fzf-lua").make_entry.file(fzf_str, {}), function()
                                coroutine.resume(co, 0)
                              end)
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        elseif event == "stderr" then
          vim.cmd "echohl Error"
          vim.cmd('echomsg "' .. table.concat(dataout, "") .. '"')
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
  fzf_lua.grep {
    prompt = RUtils.fzflua.padding_prompt(),
    cwd = RUtils.config.path.wiki_path,
    search = is_markdown_file() and regex_title or regex_title_org,
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
        RUtils.warn "An error occurred in the find_local_titles previewer"
        return {}
      end
    end

    return {
      path = filename,
      line = idx,
      col = 1,
    }
  end

  return fzf_lua.grep {
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
      fullscreen = false,
      height = 0.90,
      width = 0.90,
      row = 0.50,
      col = 0.50,
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
  }
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

function M.insert_by_categories()
  local win_height, win_width, row, col = get_height_width_row_col_window()
  collect_all_tags_async(tags, function(all_tags)
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
  fzf_lua.grep {
    prompt = RUtils.fzflua.padding_prompt(),
    winopts = { title = format_prompt_strings "Insert By Global Title" },
    rg_glob = false,
    no_esc = true,
    search = is_markdown_file() and regex_title or regex_title_org,
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

function M.go_to_heading(anchor_text, reverse)
  -- Taken from and credit: https://github.com/jakewvincent/mkdnflow.nvim/blob/0fa1e682e35d46cd1a0102cedd05b0283e41d18d/lua/mkdnflow/cursor.lua#L138

  -- Record which line we're on; chances are the link goes to something later,
  -- so we'll start looking from here onwards and then circle back to the beginning
  local position = vim.api.nvim_win_get_cursor(0)
  local starting_row, continue = position[1], true
  local in_fenced_code_block = M.cursor_in_code_block(starting_row, reverse)
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
          local heading_as_anchor = links.formatLink(line[1], nil, 2)
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
        ---@diagnostic disable-next-line: cast-local-type
        continue = nil
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
        ---@diagnostic disable-next-line: cast-local-type
        continue = nil
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
