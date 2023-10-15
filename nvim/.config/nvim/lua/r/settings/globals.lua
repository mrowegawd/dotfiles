vim.g.autoformat = true

local namespace = {
  ui = {
    winbar = { enable = true },
    statuscolumn = { enable = true },
    foldtext = { enable = false },
  },

  -- some vim mappings require a mixture of commandline commands and function
  -- calls this table is place to store lua functions to be called in those
  -- mappings
  mappings = { enable = true },
}

-- This table is a globally accessible store to facilitating accessing
-- helper functions and variables throughout my config
_G.as = as or namespace

-- as.home = os.getenv "HOME"
-- as.dropbox_path = fmt("%s/Dropbox", as.home, "Dropbox")
-- as.wiki_path = fmt("%s/neorg", as.dropbox_path)
-- as.snippet_path = as.dropbox_path .. "/friendly-snippets"

-- as.colorscheme = "tokyonight"
-- as.term_count = 1
-- as.toggle_number = 1
-- as.colorcolumn_width = 80

-- as.use_search_telescope = false -- if false, use fzflua

-- as.vimgrep_arguments = {
--   "rg",
--   "--hidden",
--   "--follow",
--   "--no-ignore-vcs",
--   "-g",
--   "!{node_modules,.git,__pycache__,.pytest_cache}",
--   "--color=never",
--   "--no-heading",
--   "--with-filename",
--   "--line-number",
--   "--column",
--   "--smart-case",
-- }

-- local function fold(callback, list, accum)
--   accum = accum or {}
--   for k, v in pairs(list) do
--     accum = callback(accum, v, k)
--     assert(accum ~= nil, "The accumulator must be returned on each iteration")
--   end
--   return accum
-- end

-- local autocmd_keys = {
--   "event",
--   "buffer",
--   "pattern",
--   "desc",
--   "command",
--   "group",
--   "once",
--   "nested",
-- }
-- local function validate_autocmd(name, command)
--   local incorrect = fold(function(accum, _, key)
--     if not vim.tbl_contains(autocmd_keys, key) then
--       table.insert(accum, key)
--     end
--     return accum
--   end, command, {})

--   if #incorrect > 0 then
--     vim.schedule(function()
--       local msg = "Incorrect keys: " .. table.concat(incorrect, ", ")
--       ---@diagnostic disable-next-line: param-type-mismatch
--       vim.notify(msg, "error", { title = fmt("Autocmd: %s", name) })
--     end)
--   end
-- end

-- function as.augroup(name, ...)
--   local commands = { ... }
--   assert(name ~= "User", "The name of an augroup CANNOT be User")
--   assert(#commands > 0, fmt("You must specify at least one autocommand for %s", name))
--   local id = api.nvim_create_augroup(name, { clear = true })
--   for _, autocmd in ipairs(commands) do
--     validate_autocmd(name, autocmd)
--     local is_callback = type(autocmd.command) == "function"
--     api.nvim_create_autocmd(autocmd.event, {
--       group = name,
--       pattern = autocmd.pattern,
--       desc = autocmd.desc,
--       callback = is_callback and autocmd.command or nil,
--       command = not is_callback and autocmd.command or nil,
--       once = autocmd.once,
--       nested = autocmd.nested,
--       buffer = autocmd.buffer,
--     })
--   end
--   return id
-- end
