local telescope = require "telescope"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local action_set = require "telescope.actions.set"
local conf = require("telescope.config").values

local listwikis = function(opts)
  local dir = RUtils.config.path.wiki_path or opts.path
  local list = {}

  local nvim_conf = io.popen(
    "rg --follow --hidden --color=never --no-heading --with-filename --line-number --column --smart-case -g '*.norg' -g '*.org' -g '!config/' -g '!.obsidian/' "
      .. dir
  )
  if nvim_conf ~= nil then
    for file in nvim_conf:lines() do
      table.insert(list, file)
    end
  end

  return list
end

local wikis = function(opts)
  opts = opts or {}
  local results = listwikis(opts)

  pickers
    .new(opts, {
      prompt_title = "My wikis",
      results_title = "~~~~~+++~~~~~",
      finder = finders.new_table {
        results = results,
        entry_maker = make_entry.gen_from_file(opts),
      },
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(_)
        action_set.select:enhance {
          post = function()
            vim.cmd ":normal! :e"
            vim.cmd ":normal! zx"
          end,
        }
        return true
      end,
    })
    :find()
end

return telescope.register_extension { exports = { wikis = wikis } }
