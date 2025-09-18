---@class r.utils.treesitter
local M = {}

M._installed = nil ---@type table<string,string>?

---@param update boolean?
function M.get_installed(update)
  if update then
    M._installed = {}
    for _, lang in ipairs(require("nvim-treesitter").get_installed "parsers") do
      M._installed[lang] = lang
    end
  end
  return M._installed or {}
end

---@param ft string
function M.have(ft)
  local lang = vim.treesitter.language.get_lang(ft)
  return lang and M.get_installed()[lang]
end

function M.foldexpr()
  -- local buf = vim.api.nvim_get_current_buf()
  -- if vim.b[buf].ts_folds == nil then
  --   -- as long as we don't have a filetype, don't bother
  --   -- checking if treesitter is available (it won't)
  --   if vim.bo[buf].filetype == "" then
  --     return "0"
  --   end
  --   if vim.bo[buf].filetype:find "dashboard" then
  --     vim.b[buf].ts_folds = false
  --   else
  --     vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
  --   end
  -- end
  -- return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"

  local buf = vim.api.nvim_get_current_buf()
  return M.have(vim.bo[buf].filetype) and vim.treesitter.foldexpr() or "0"
end

function M.indentexpr()
  local buf = vim.api.nvim_get_current_buf()
  return M.have(vim.bo[buf].filetype) and require("nvim-treesitter").indentexpr() or 0
end

local middot = "·"
local raquo = "»"
local small_l = "ℓ"

-- Override default `foldtext()`, which produces something like:
--
--   +---  2 lines: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
--
-- Instead returning:
--
--   »··[2ℓ]··: source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
--

function M.foldtext()
  --   -- local line = vim.fn.getline(vim.v.foldstart)
  --   -- local line_count = vim.v.foldend - vim.v.foldstart + 1
  --   -- return " ⚡ " .. line .. ": " .. line_count .. " lines"
  --   return vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1]

  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local lines = "[" .. line_count .. small_l .. "]"
  local first = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]
  local tabs = first:match("^%s*"):gsub(" +", ""):len()
  local spaces = first:match("^%s*"):gsub("\t", ""):len()
  local indent = spaces + tabs * vim.bo.tabstop
  local stripped = first:match "^%s*(.-)$"
  local prefix = raquo .. middot .. middot .. lines
  local suffix = ": "

  -- Can't usefully use string.len() on UTF-8.
  local prefix_len = tostring(line_count):len() + 6

  local dash_count = math.max(indent - prefix_len - string.len(suffix), 0)
  local dashes = string.rep(middot, dash_count)
  return prefix .. dashes .. suffix .. stripped
end

return M
