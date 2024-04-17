local telescope = require "telescope"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local action_set = require "telescope.actions.set"
local conf = require("telescope.config").values

local insert_table = function(tbl, data)
  for file in data:lines() do
    table.insert(tbl, file)
  end
end

local journal_files = function(opts)
  -- local dir = opts.path or ""
  local tbl = {}
  local grep_commands = "rg --files -g '*.org' " or opts.path

  local notes = io.popen(grep_commands .. RUtils.config.path.wiki_path .. "/journal")
  local org = io.popen(grep_commands .. RUtils.config.path.wiki_path .. "/gtd")

  insert_table(tbl, notes)
  insert_table(tbl, org)

  return tbl
end

local wikisjournal = function(opts)
  opts = opts or {}
  local results = journal_files(opts)

  pickers
    .new(opts, {
      prompt_title = "Journal Wiki",
      finder = finders.new_table {
        results = results,
        entry_maker = make_entry.gen_from_file(opts),
      },
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),

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
  exports = { wikisjournal = wikisjournal },
}
