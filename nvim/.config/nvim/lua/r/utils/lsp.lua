---@class r.utils.lsp
local M = {}

---@param opts? LazyFormatter| {filter?: (string|vim.lsp.get_clients.Filter)}
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter vim.lsp.get_clients.Filter
  ---@type LazyFormatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(RUtils.merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients(RUtils.merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client:supports_method "textDocument/formatting" or client:supports_method "textDocument/rangeFormatting"
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return RUtils.merge(ret, opts) --[[@as LazyFormatter]]
end

---@alias lsp.Client.format {timeout_ms?: number, format_options?: table} | vim.lsp.get_clients.Filter

---@param opts? lsp.Client.format
function M.format(opts)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    RUtils.opts("nvim-lspconfig").format or {},
    RUtils.opts("conform.nvim").format or {}
  )
  local ok, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    opts.formatters = {}
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      }
    end
  end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open {
      mode = "lsp_command",
      params = params,
    }
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

-- local md_docs_ns = vim.api.nvim_create_namespace "markdown_docs_highlights"
-- function M.highlight_doc_patterns(bufnr)
--   vim.api.nvim_buf_clear_namespace(bufnr, md_docs_ns, 0, -1)
--   local patterns = {
--     ["─"] = "RenderMarkdownDash",
--     ["---"] = "RenderMarkdownDash",
--     -- Lua/vimdoc
--     ["@%S+"] = "@variable.parameter",
--     -- Python
--     ["^%s*(Parameters)$"] = "@markup.heading.vimdoc",
--     ["^%s*(Returns)$"] = "@markup.heading.vimdoc",
--     ["^%s*(Examples)$"] = "@markup.heading.vimdoc",
--     ["^%s*(Notes)$"] = "@markup.heading.vimdoc",
--     ["^%s*(See Also)$"] = "@markup.heading.vimdoc",
--   }
--
--   for l, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
--     if vim.startswith(line, "``` man") then
--       vim.bo[bufnr].filetype = "man"
--       return
--     end
--
--     for pattern, hl_group in pairs(patterns) do
--       local from = 1
--       while true do
--         local s, e = line:find(pattern, from)
--         if not s then
--           break
--         end
--         vim.api.nvim_buf_set_extmark(bufnr, md_docs_ns, l - 1, s - 1, {
--           end_col = e,
--           hl_group = hl_group,
--         })
--         from = e + 1
--       end
--     end
--   end
-- end

return M
