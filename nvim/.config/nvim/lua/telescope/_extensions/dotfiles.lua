local telescope = require "telescope"
local finders = require "telescope.finders"
local action_set = require "telescope.actions.set"
local pickers = require "telescope.pickers"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local dotfiles_list = function()
  local list = {}
  local nvim_conf = io.popen(
    "rg --files --hidden --color=never --no-heading --with-filename --line-number --column --smart-case "
      .. os.getenv "HOME"
      .. "/moxconf/development/dotfiles"
  )
  if nvim_conf ~= nil then
    for file in nvim_conf:lines() do
      table.insert(list, file)
    end
  end
  return list
end

local dotfiles = function(opts)
  opts = opts or {}
  local results = dotfiles_list()

  pickers
    .new(opts, {
      prompt_title = "My dotfiles",
      results_title = "File & Folders",
      finder = finders.new_table {
        results = results,
        entry_maker = make_entry.gen_from_file(opts),
      },
      previewer = false,

      attach_mappings = function(_)
        action_set.select:enhance {
          post = function()
            vim.cmd ":normal! zx"
          end,
        }
        return true
      end,
      sorter = conf.file_sorter(opts),
    })
    :find()
end

return telescope.register_extension { exports = { dotfiles = dotfiles } }
