local telescope = require('telescope')

local find_myfiles = function(opts)
  opts = opts or {}
  require("telescope.builtin").find_files({
    file_ignore_patterns = { "%.png", "%.jpg", "%.webp" },
    hidden = true,
    follow = true,
  })
end

return telescope.register_extension { exports = {  find_myfiles = find_myfiles } }
