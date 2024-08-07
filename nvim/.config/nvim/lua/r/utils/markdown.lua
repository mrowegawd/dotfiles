---@class r.utils.markdown
local M = {}

-- local search_mode = "files"
-- local filename_part = ""

local title, kind
local function remove_alias(link)
  local split_index = string.find(link, "%s*|")
  if split_index ~= nil and type(split_index) == "number" then
    return string.sub(link, 0, split_index - 1)
  end
  return link
end

-- local JSON_DECODE_OPTS = { luanil = { object = true, array = true } }

local function is_tag_or_link_at(line, col, opts)
  opts = opts or {}
  local initial_col = col

  local char
  local is_tagline = opts.tag_notation == "yaml-bare" and line:sub(1, 4) == "tags"

  local seen_bracket = false
  local seen_parenthesis = false
  local seen_hashtag = false
  local cannot_be_tag = false

  -- Solves [[Link]]
  --     at ^
  -- In this case we try to move col forward to match the link.
  if "[" == line:sub(col, col) then
    col = math.max(col + 1, string.len(line))
  end

  while col >= 1 do
    char = line:sub(col, col)

    if seen_bracket then
      if char == "[" then
        return "link", col + 2
      end
    end

    if seen_parenthesis then
      -- Media link, currently identified by not link nor tag
      if char == "]" then
        return nil, nil
      end
    end

    if char == "[" then
      seen_bracket = true
    elseif char == "(" then
      seen_parenthesis = true
    end

    if is_tagline == true then
      if char == " " or char == "\t" or char == "," or char == ":" then
        if col ~= initial_col then
          return "tag", col + 1
        end
      end
    else
      if char == "#" then
        seen_hashtag = true
      end
      if char == "@" then
        seen_hashtag = true
      end
      -- Tags should have a space before #, if not we are likely in a link
      if char == " " and seen_hashtag and opts.tag_notation == "#tag" then
        if not cannot_be_tag then
          return "tag", col
        end
      end

      if char == ":" and opts.tag_notation == ":tag:" then
        if not cannot_be_tag then
          return "tag", col
        end
      end
    end

    if char == " " or char == "\t" then
      cannot_be_tag = true
    end
    col = col - 1
  end
  return nil, nil
end

local function check_for_link_or_tag()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col "."
  -- TODO: ini adalah yang salah
  return is_tag_or_link_at(line, col, {})
end

function M.follow_link(is_selection)
  is_selection = is_selection or false

  local saved_reg = vim.fn.getreg '"0'
  kind, _ = check_for_link_or_tag()

  if kind == "link" then
    vim.cmd "normal yi]"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = remove_alias(title)
  end

  if kind ~= nil then
    vim.fn.setreg('"0', saved_reg)

    local parts = vim.split(title, "#")

    -- if there is a #
    if #parts ~= 1 then
      title = parts[2]
      parts = vim.split(title, "%^")
      if #parts ~= 1 then
        title = parts[2]
      end
      -- local search = require "obsidian.search"
      -- search.find_notes_async(".", title .. ".md")
      local rg_opts =
        [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]]

      local fzflua = require "fzf-lua"
      fzflua.grep { cwd = RUtils.config.path.wiki_path, search = title, rg_opts = rg_opts }
    else
      if require("obsidian").util.cursor_on_markdown_link() then
        vim.cmd "ObsidianFollowLink"
      end
    end
  else
    local url = vim.fn.expand "<cWORD>"

    -- check jika terdapat `https` pada `url`
    local uri = vim.fn.matchstr(url, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])

    -- if not string.match(url, "[a-z]*://[^ >,;]*") and string.match(url, "[%w%p\\-]*/[%w%p\\-]*") then
    --   url = string.format("https://github.com/%s", url)
    if uri ~= "" then
      if vim.bo.filetype == "markdown" then
        if require("obsidian").util.cursor_on_markdown_link() then
          vim.cmd "ObsidianFollowLink"
          return
        end
      else
        url = url
      end
    else
      if is_selection then
        vim.cmd "normal yy"
        title = vim.fn.getreg '"0'
        title = title:gsub("^(%[)(.+)(%])$", "%2")
        title = remove_alias(title)

        local parts = vim.split(title, "#")
        if #parts > 0 then
          url = string.format("https://google.com/search?q=%s", parts[1])
        end
      else
        url = string.format("https://google.com/search?q=%s", url)
      end
    end

    vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "firefox", url }, { detach = true })
  end
end

-- local TagCharsOptional = "[A-Za-z0-9_/-]*"
local TagCharsRequired = "[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+" -- assumes tag is at least 2 chars

local rg_opts = "--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 "
rg_opts = rg_opts .. " ~/Dropbox/neorg -e status"

-- local function cursor_tag(line, col)
--   local current_line = line and line or vim.api.nvim_get_current_line()
--   local _, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
--   cur_col = col or cur_col + 1 -- nvim_win_get_cursor returns 0-indexed column
--
--   for match in iter(search.find_tags(current_line)) do
--     local open, close, _ = unpack(match)
--     if open <= cur_col and cur_col <= close then
--       return string.sub(current_line, open + 1, close)
--     end
--   end
--
--   return nil
-- end

local data_tags_table = {}
local data_tags_out = {}
local data_title_out = {}

local insert_tags = {}

local builtin = require "fzf-lua.previewer.builtin"
local tags_previewer = builtin.buffer_or_file:extend()

local function format_data_tags(match_data)
  local line = string.gsub(match_data.lines.text, '"(%d+)"', "%1")
  line = string.gsub(line, "-%s", "")
  return {
    tag = RUtils.cmd.strip_whitespace(line),
    line_number = match_data.line_number,
    path = match_data.path.text,
    title = "",
  }
end

local function format_tag_text(match_data)
  local line = string.gsub(match_data.lines.text, '\\"', "")
  -- local line = string.gsub(match_data.lines.text, '"(%d+)"', "%1")
  line = string.gsub(line, "-%s", "") -- remove strip '- tags'
  return RUtils.cmd.strip_whitespace(line)
end

local function format_title_tag(match_data)
  local line = string.gsub(match_data.lines.text, '\\"', "")
  line = string.gsub(line, "#%s", "")
  return {
    title = RUtils.cmd.strip_whitespace(line),
    line_number = match_data.line_number,
    path = match_data.path.text,
  }
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

local function collect_all_tags_async(data, cb)
  data = data or {}

  local rg_optsc = "--no-config --json --type=md --ignore-case"
  local msg_cmds = "rg "
    .. rg_optsc
    .. ' -e "tags: .*[a-z]+[a-z0-9_/-]*[a-z0-9]+"'
    .. ' -e "^\\s\\s*- [a-z]+[a-z0-9_/-]*[a-z0-9]+$"'
    .. ' -e "^#\\s[A-Za-z]+[A-Za-z0-9_/-]*[a-z0-9].*"'
    .. " "
    .. RUtils.config.path.wiki_path

  -- print(msg_cmds)

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
                        if match_data.line_number < 20 then
                          data_tags_out[#data_tags_out + 1] = format_tag_text(match_data)
                          coroutine.resume(co, 0)
                        end
                      end

                      if string.match(line_text, "^# ") then
                        if match_data.line_number < 25 then
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
      cb(data_tags)
    end
  end)()
end

local function format_prompt_strings()
  local title_fzf = "Obsidian > Search By Tag"
  if #insert_tags > 0 then
    local tags = "[" .. table.concat(insert_tags, ", ") .. "]"
    title_fzf = string.format("%s > %s", title_fzf, tags)
  end
  return RUtils.fzflua.format_title(
    title_fzf,
    RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.tag),
    "GitSignsChange"
  )
end

local function picker(contents)
  function tags_previewer:new(o, opts, fzf_win)
    tags_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, tags_previewer)
    return self
  end

  function tags_previewer:parse_entry(entry_str)
    local text = vim.split(entry_str, "|")

    if text then
      for _, x in pairs(data_tags_table) do
        if x.title == text[2] then
          return {
            path = x.path,
            line = x.line_number,
            col = 1,
          }
        end
      end
    end
    return {}
  end

  return require("fzf-lua").fzf_exec(contents, {
    previewer = tags_previewer,
    prompt = "   ",
    winopts = {
      title = format_prompt_strings(),
    },

    fzf_opts = { ["--header"] = [[Ctrl-t: filter by tag | Ctrl-a: add tag | Ctrl-r: reload | Ctrl-g: search by regex]] },

    actions = {
      ["default"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, "|")
        for _, x in pairs(data_tags_table) do
          if x.title == sel[2] then
            vim.cmd("e " .. x.path)
            vim.api.nvim_win_set_cursor(0, { tonumber(x.line_number), 1 })
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
            break
          end
        end
      end,

      ["ctrl-a"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, " ")
        -- sel = vim.split(sel[1], " ")

        table.insert(insert_tags, sel[1])
        print("Add tag: " .. vim.inspect(insert_tags))

        require("fzf-lua").actions.resume()
      end,

      ["ctrl-t"] = function()
        if #insert_tags == 0 then
          print "add tags first"
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

      ["alt-q"] = function(selected, _)
        local function check_tbl_element(tbl, element)
          for _, x in pairs(tbl) do
            if x["text"] == element then
              return true
            end
          end
          return false
        end

        local items = {}
        if #selected > 1 then
          for _, sel in pairs(selected) do
            local sel_str = vim.split(sel, "|")[2]

            for _, tbl_tags in pairs(data_tags_table) do
              if tbl_tags.title == sel_str then
                if not check_tbl_element(items, tbl_tags.title) then
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
              if not check_tbl_element(items, tbl_tags.title) then
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

        local what = {
          idx = "$",
          items = items,
          title = "Tags Note Random",
        }

        vim.fn.setqflist({}, "r", what)
        vim.cmd "copen"
      end,
    },
  })
end
-- Fungsi untuk memeriksa apakah string JSON valid
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

                            -- TODO: ensure id note exists #postpone #25/5/saturday
                            -- if is_set then
                            -- end

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

function M.find_note_by_tag(data, is_set)
  is_set = is_set or false
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
      list_tags_async(all_tags)
      -- end)
    end)
  end
end

function M.find_by_categories()
  collect_all_tags_async(tags, function(all_tags)
    vim.schedule(function()
      picker(all_tags)
    end)
  end)
end

function M.find_global_titles()
  return require("fzf-lua").grep {
    prompt = "   ",
    cwd = RUtils.config.path.wiki_path,
    search = "^#.*",
    rg_glob = false,
    no_esc = true,
    file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
    rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]],
    winopts = {
      fullscreen = true,
      title = RUtils.fzflua.format_title(
        "Obsidian > Search Global Note Titles",
        RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.code),
        "GitSignsChange"
      ),
    },
  }
end

function M.find_local_titles()
  local starting_bufname = vim.api.nvim_buf_get_name(0)
  local fullname = vim.fn.fnamemodify(starting_bufname, ":p")

  function tags_previewer:new(o, opts, fzf_win)
    tags_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, tags_previewer)
    return self
  end

  function tags_previewer:parse_entry(entry_str)
    local entry_str_strip = RUtils.fzflua.__strip_str(entry_str)
    if entry_str_strip then
      local x = vim.split(entry_str_strip, ":")
      return {
        path = fullname,
        line = x[1],
        col = 1,
      }
    end
  end

  return require("fzf-lua").grep {
    prompt = "   ",
    previewer = tags_previewer,
    no_esc = true,
    rg_glob = false,
    search = "^#.*",
    rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
      .. fullname
      .. " -e ",
    winopts = {
      fullscreen = true,
      title = RUtils.fzflua.format_title(
        "Obsidian > Search Local Note Titles",
        RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.code),
        "GitSignsChange"
      ),
    },
    actions = {
      ["default"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          vim.api.nvim_win_set_cursor(0, { tonumber(sel[1]), 1 })
        end
      end,

      ["ctrl-v"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          vim.cmd("vsplit " .. fullname)
          vim.api.nvim_win_set_cursor(0, { tonumber(sel[1]), 1 })
        end
      end,

      ["ctrl-s"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          vim.cmd("split " .. fullname)
          vim.api.nvim_win_set_cursor(0, { tonumber(sel[1]), 1 })
        end
      end,
    },
  }
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

-- Taken from and credit: https://github.com/jakewvincent/mkdnflow.nvim/blob/0fa1e682e35d46cd1a0102cedd05b0283e41d18d/lua/mkdnflow/cursor.lua#L138
function M.go_to_heading(anchor_text, reverse)
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
