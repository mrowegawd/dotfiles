local M = {}

local title, kind
local search_mode = "files"
local filename_part = ""

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
  return is_tag_or_link_at(line, col, M.Cfg)
end

function M.followLink(Config)
  local saved_reg = vim.fn.getreg '"0'
  kind, _ = check_for_link_or_tag()

  if kind == "link" then
    vim.cmd "normal yi]"
    title = vim.fn.getreg '"0'
    title = title:gsub("^(%[)(.+)(%])$", "%2")
    title = remove_alias(title)
  end

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

    local fzflua = require "fzf-lua"
    fzflua.grep { cwd = Config.path.wiki_path, search = title }
  else
    if require("obsidian").util.cursor_on_markdown_link() then
      vim.cmd "ObsidianFollowLink"
    end
  end
end

function M.finder_linkableGlobal()
  return { "yes" }
end

return M
