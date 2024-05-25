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

function M.finder_linkableGlobal()
  return { "yes" }
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

local function collect_all_tags_async(data, cb)
  data = data or {}

  local rg_optsc = "--no-config --json --type=md --ignore-case"
  local cmd = "rg "
    .. rg_optsc
    .. ' -e "tags: .*[a-z]+[a-z0-9_/-]*[a-z0-9]+"'
    .. ' -e "^\\s\\s*- [a-z]+[a-z0-9_/-]*[a-z0-9]+$"'
    .. ' -e "^#\\s[A-Za-z]+[A-Za-z0-9_/-]*[a-z0-9].*"'
    .. " "
    .. RUtils.config.path.wiki_path

  -- print(cmd)

  coroutine.wrap(function()
    local co = coroutine.running()

    RUtils.async.run_jobstart(cmd, function(_, dataout, event)
      if event == "stdout" then
        if dataout then
          for _, line in ipairs(dataout) do
            if line ~= "" then
              local json_data = vim.json.decode(line)

              local match_data = json_data.data
              if match_data["path"] then
                if match_data["lines"] then
                  local line_text = match_data.lines.text

                  -- Kita hanya butuh tag yang berada pada line frontmatter
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
  local msg = ""
  if #insert_tags > 0 then
    msg = "[" .. table.concat(insert_tags, ",") .. "]"
    msg = string.format("[Obsidian] Search by tag %s > ", msg)
  else
    msg = "[Obsidian] Search by tag > "
  end
  return msg
end

local function picker(contents)
  function tags_previewer:new(o, opts, fzf_win)
    tags_previewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, tags_previewer)
    return self
  end

  function tags_previewer:parse_entry(entry_str)
    local text = vim.split(entry_str, "|")

    for _, x in pairs(data_tags_table) do
      if x.title == text[2] then
        return {
          path = x.path,
          line = x.line_number,
          col = 1,
        }
      end
    end
    return {}
  end

  return require("fzf-lua").fzf_exec(contents, {
    previewer = tags_previewer,
    prompt = format_prompt_strings(),

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

  local cmd = "rg " .. rg_optsc .. line_e .. RUtils.config.path.wiki_path
  -- print(cmd)

  local contents = function(cb)
    coroutine.wrap(function()
      local co = coroutine.running()

      RUtils.async.run_jobstart(cmd, function(_, dataout, event)
        if event == "stdout" then
          if dataout and #dataout > 0 then
            for _, line in ipairs(dataout) do
              if #line > 0 then
                local json_data = vim.json.decode(line)
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
      vim.schedule(function()
        list_tags_async(all_tags)
      end)
    end)
  end
end

return M
