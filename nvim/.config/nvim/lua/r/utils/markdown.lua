---@class r.utils.markdown
local M = {}

local title, kind

local fzf_lua = RUtils.cmd.reqcall "fzf-lua"

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
  return is_tag_or_link_at(line, col, {}) -- TODO: ini adalah yang salah
end

function M.open_with_mvp_or_sxiv(is_selection)
  is_selection = is_selection or false

  local url = vim.fn.expand "<cWORD>"

  -- check jika terdapat `https` pada `url`
  local uri = vim.fn.matchstr(url, [[https\?:\/\/[A-Za-z0-9-_\.#\/=\?%]\+]])

  -- if not string.match(url, "[a-z]*://[^ >,;]*") and string.match(url, "[%w%p\\-]*/[%w%p\\-]*") then
  --   url = string.format("https://github.com/%s", url)
  if uri ~= "" then
    url = uri
  else
    print "fasdfa"
    if not is_selection then
      url = string.format("https://google.com/search?q=%s", url)
    end

    vim.cmd "normal yy"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = RUtils.cmd.remove_alias(title)

    local parts = vim.split(title, "#")
    if #parts > 0 then
      url = string.format("https://google.com/search?q=%s", parts[1])
    end
    -- vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "xdg-open", url }, { detach = true })
    local browser = os.getenv "NUBROWSER"
    local notif_msg = "Open with browser: "
    local cmds = { browser, url }
    if vim.bo.filetype == "octo" then
      notif_msg = "Open with mpv: "
      cmds =
        { "tsp", "mpv", "--ontop", "--no-border", "--force-window", "--autofit=1000x500", "--geometry=-20-60", url }
    end

    vim.fn.jobstart(cmds, { detach = true })
    RUtils.info(notif_msg .. url, { title = "Open With" })
  end
end

function M.follow_link(is_selection)
  is_selection = is_selection or false

  local saved_reg = vim.fn.getreg '"0'
  kind, _ = check_for_link_or_tag()

  if kind == "link" then
    vim.cmd "normal yi]"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = RUtils.cmd.remove_alias(title)
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
        [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --colors match:fg:178 --max-columns=4096 -g "*.md" ]]

      fzf_lua.grep { cwd = RUtils.config.path.wiki_path, search = title, rg_opts = rg_opts }
    else
      if require("obsidian").util.cursor_on_markdown_link(nil, nil, true) then
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
        if require("obsidian").util.cursor_on_markdown_link(nil, nil, true) then
          return vim.cmd "ObsidianFollowLink"
        end
      end
      url = uri
    else
      if not is_selection then
        url = string.format("https://google.com/search?q=%s", url)
      end

      vim.cmd "normal yy"
      title = vim.fn.getreg '"0'
      title = title:gsub("^(%[)(.+)(%])$", "%2")
      title = RUtils.cmd.remove_alias(title)

      local parts = vim.split(title, "#")
      if #parts > 0 then
        url = string.format("https://google.com/search?q=%s", parts[1])
      end
    end

    -- vim.fn.jobstart({ vim.fn.has "macunix" ~= 0 and "open" or "xdg-open", url }, { detach = true })
    local browser = os.getenv "NUBROWSER"
    local notif_msg = "Open with browser: "
    local cmds = { browser, url }
    if vim.bo.filetype == "octo" then
      notif_msg = "Open with mpv: "
      cmds =
        { "tsp", "mpv", "--ontop", "--no-border", "--force-window", "--autofit=1000x500", "--geometry=-15-60", url }
    end

    vim.fn.jobstart(cmds, { detach = true })
    RUtils.info(notif_msg .. url, { title = "Open With" })
  end
end

-- local TagCharsOptional = "[A-Za-z0-9_/-]*"
local TagCharsRequired = "[A-Za-z]+[A-Za-z0-9_/-]*[A-Za-z0-9]+" -- assumes tag is at least 2 chars

local rg_opts =
  "--column --hidden --no-heading --ignore-case --smart-case --color=always --colors match:fg:178 --max-columns=4096 "
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
  return RUtils.fzflua.format_title(title_fzf, RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.tag))
end

local builtin = require "fzf-lua.previewer.builtin"
local Tagpreviewer = builtin.buffer_or_file:extend()

function Tagpreviewer:new(o, opts, fzf_win)
  Tagpreviewer.super.new(self, o, opts, fzf_win)
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

local function picker(contents, actions)
  actions = actions
    or {
      ["enter"] = function(selected, _)
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

      ["ctrl-t"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, "|")
        for _, x in pairs(data_tags_table) do
          if x.title == sel[2] then
            vim.cmd("tabe " .. x.path)
            vim.api.nvim_win_set_cursor(0, { tonumber(x.line_number), 1 })
            break
          end
        end
      end,

      ["ctrl-y"] = function(selected, _)
        local sel = selected[1]
        sel = vim.split(sel, " ")
        -- sel = vim.split(sel[1], " ")

        table.insert(insert_tags, sel[1])
        print("Add tag: " .. vim.inspect(insert_tags))

        require("fzf-lua").actions.resume()
      end,

      ["ctrl-x"] = function()
        if #insert_tags == 0 then
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
        prefix = "select-all",
        fn = function(selected, _)
          local check_tbl_element = function(tbl, path)
            for _, x in pairs(tbl) do
              if x.title == path then
                return true
              end
            end
            return false
          end

          local newtbl = {}
          for _, sel in pairs(selected) do
            local seltitle = vim.split(sel, "|")
            for _, x in pairs(data_tags_table) do
              if x.title == seltitle[2] then
                if not check_tbl_element(newtbl, x.title) then
                  newtbl[#newtbl + 1] = x
                end
              end
            end
          end

          local cmdscs = {}
          for _, y in pairs(newtbl) do
            cmdscs[#cmdscs + 1] = y.path
          end

          local rg_optssc = [[--column --hidden --line-number --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
            .. table.concat(cmdscs, " ")
            .. " -e "

          fzf_lua.live_grep {
            -- debug = true,
            rg_glob = false,
            no_esc = true,
            rg_opts = rg_optssc,
            winopts = { title = RUtils.fzflua.format_title("Grep filter note", " ") },
          }
        end,
      },

      ["ctrl-q"] = function(selected, _)
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
    }

  return fzf_lua.fzf_exec(contents, {
    previewer = {
      _ctor = function()
        return Tagpreviewer
      end,
    },
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = { title = format_prompt_strings() },
    fzf_opts = { ["--header"] = [[CTRL-Y:addtag  CTRL-X:filtertag  CTRL-R:reload  CTRL-G:grep]] },
    actions = actions,
  })
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

local regex_title = [[^#{1,}\s[\w<`].*$]] -- [[^#{1,}\s\w.*$]]
local regex_title_org = [[^\*{1,}\s[\w<`].*$]] -- [[^#{1,}\s\w.*$]]

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

function M.find_global_titles()
  fzf_lua.grep {
    prompt = RUtils.fzflua.default_title_prompt(),
    cwd = RUtils.config.path.wiki_path,
    -- search = vim.bo.filetype == "markdown" and regex_title or regex_title_org,
    search = regex_title,
    rg_glob = false,
    no_esc = true,
    -- file_ignore_patterns = { "%.norg$", "%.json$", vim.bo.filetype == "markdown" and "%.org$" or "%.md$" },
    file_ignore_patterns = { "%.norg$", "%.json$", "%.org$" },
    -- rg_opts = [[--column --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 -g "*.md" ]],
    winopts = {
      title = RUtils.fzflua.format_title("Global titles", RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.code)),
      preview = {
        vertical = "down:55%", -- up|down:size
        horizontal = "right:45%", -- right|left:size
      },
    },
  }
end

function M.find_local_titles()
  local starting_bufname = vim.api.nvim_buf_get_name(0)
  local fullname = vim.fn.fnamemodify(starting_bufname, ":p")

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
    local entry_str_strip = RUtils.fzflua.__strip_str(entry_str)
    if entry_str_strip then
      local x = vim.split(entry_str_strip, ":")
      return {
        path = fullname,
        line = idx,
        col = 1,
      }
    end
  end

  return fzf_lua.grep {
    prompt = RUtils.fzflua.default_title_prompt(),
    previewer = Tagpreviewer,
    no_esc = true,
    rg_glob = false,
    search = vim.bo.filetype == "markdown" and regex_title or regex_title_org,
    rg_opts = [[--column --line-number --hidden --no-heading --ignore-case --smart-case --color=always --max-columns=4096 ]]
      .. fullname
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
      -- fullscreen = true,
      title = RUtils.fzflua.format_title("Local titles", RUtils.cmd.strip_whitespace(RUtils.config.icons.misc.code)),
      width = 0.80,
      height = 0.90,
      preview = {
        vertical = "down:55%", -- up|down:size
        horizontal = "right:45%", -- right|left:size
      },
    },
    actions = {
      ["enter"] = function(selected, _)
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
      ["ctrl-t"] = function(selected, _)
        local sel = RUtils.fzflua.__strip_str(selected[1])
        if sel then
          sel = vim.split(sel, ":")
          vim.cmd("tabe " .. fullname)
          vim.api.nvim_win_set_cursor(0, { tonumber(sel[1]), 1 })
        end
      end,
    },
  }
end

function M.find_local_sitelink()
  fzf_lua.lgrep_curbuf {
    prompt = RUtils.fzflua.default_title_prompt(),
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

local function get_sel_text()
  title = vim.fn.expand "<cWORD>"
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

function M.find_backlinks()
  local is_str, curr_line_func = get_sel_text()
  local stitle = curr_line_func

  if not is_str then
    local char_under_cursor = vim.fn.expand "<cWORD>"
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
      title = RUtils.fzflua.format_title("Find Backlinks: [[" .. stitle .. "]]", ""),
    },
  }
end

function M.insert_by_categories()
  collect_all_tags_async(tags, function(all_tags)
    vim.schedule(function()
      picker(all_tags, {
        ["enter"] = function(selected, _)
          local selection = selected[1]
          vim.api.nvim_put({ selection }, "c", false, true)
        end,
      })
    end)
  end)
end

function M.insert_local_titles()
  fzf_lua.lgrep_curbuf {
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = {
      title = RUtils.fzflua.format_title("Note: title curbuf", ""),
    },
    rg_glob = false,
    no_esc = true,
    search = regex_title,
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
    prompt = RUtils.fzflua.default_title_prompt(),
    winopts = {
      title = RUtils.fzflua.format_title("Note: title global", ""),
    },
    rg_glob = false,
    no_esc = true,
    search = vim.bo.filetype == "markdown" and regex_title or regex_title_org,
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

M.cursor_in_code_block = function(cursor_row, reverse)
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
M.go_to_heading = function(anchor_text, reverse)
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
