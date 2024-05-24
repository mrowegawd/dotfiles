local uv = vim.uv
local lsp = require "vim.lsp"

---@class r.utils.lsp
local M = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

function M.setup()
  local register_capability = vim.lsp.handlers["client/registerCapability"]
  vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    ---@diagnostic disable-next-line: no-unknown
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in ipairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspDynamicCapability",
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  M.on_attach(M._check_methods)
  M.on_dynamic_capability(M._check_methods)
end

---@param client vim.lsp.Client
function M._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(M._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function M.on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspDynamicCapability",
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client then
        return fn(client, buffer)
      end
    end,
  })
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function M.on_supports_method(method, fn)
  M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

---@param from string
---@param to string
function M.on_rename(from, to)
  local clients = M.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method "workspace/willRenameFiles" then
      ---@diagnostic disable-next-line: invisible
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

---@diagnostic disable-next-line: undefined-doc-name
---@return _.lspconfig.options
function M.get_config(server)
  local configs = require "lspconfig.configs"
  return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.disable(server, cond)
  local util = require "lspconfig.util"
  local def = M.get_config(server)
  ---@diagnostic disable-next-line: undefined-field
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter lsp.Client.filter
  ---@type LazyFormatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(RUtils.merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = M.get_clients(RUtils.merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return RUtils.merge(ret, opts) --[[@as LazyFormatter]]
end

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

---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}, current?:boolean} 1-0 indexed
M.words = {}
M.words.ns = vim.api.nvim_create_namespace "vim_lsp_references"

---@param opts? {enabled?: boolean}
function M.words.setup(opts)
  opts = opts or {}
  if not opts.enabled then
    return
  end
  local handler = vim.lsp.handlers["textDocument/documentHighlight"]
  vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
    if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
      return
    end
    return handler(err, result, ctx, config)
  end

  M.on_supports_method("textDocument/documentHighlight", function(_, buf)
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
      group = vim.api.nvim_create_augroup("lsp_word_" .. buf, { clear = true }),
      buffer = buf,
      callback = function(ev)
        if not M.words.at() then
          if ev.event:find "CursorMoved" then
            vim.lsp.buf.clear_references()
          else
            vim.lsp.buf.document_highlight()
          end
        end
      end,
    })
  end)
end

---@return LspWord[]
function M.words.get()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return vim.tbl_map(function(extmark)
    local ret = {
      from = { extmark[2] + 1, extmark[3] },
      to = { extmark[4].end_row + 1, extmark[4].end_col },
    }
    if cursor[1] >= ret.from[1] and cursor[1] <= ret.to[1] and cursor[2] >= ret.from[2] and cursor[2] <= ret.to[2] then
      ret.current = true
    end
    return ret
  end, vim.api.nvim_buf_get_extmarks(0, M.words.ns, 0, -1, { details = true }))
end

---@param words? LspWord[]
---@return LspWord?, number?
function M.words.at(words)
  for idx, word in ipairs(words or M.words.get()) do
    if word.current then
      return word, idx
    end
  end
end

function M.words.jump(count)
  local words = M.words.get()
  local _, idx = M.words.at(words)
  if not idx then
    return
  end
  local target = words[idx + count]
  if target then
    vim.api.nvim_win_set_cursor(0, target.from)
  end
end

-- ──────────────────────────────────────────────────────────────────────
-- LSP KEYMAPS SUPPORT
-- ──────────────────────────────────────────────────────────────────────

-- local severity = {
--   [1] = "ERROR",
--   [2] = "WARN",
--   [3] = "INFO",
--   [4] = "HINT",
-- }

function M.process_item(item, bufnr)
  bufnr = bufnr or item.bufnr
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local range = item.range or item.targetSelectionRange

  local start = {
    line = range and vim.tbl_get(range, "start", "line") or item.lnum,
    character = range and vim.tbl_get(range, "start", "character") or item.col,
  }
  local finish = {
    line = range and vim.tbl_get(range, "end", "line") or item.end_lnum,
    character = range and vim.tbl_get(range, "end", "character") or item.end_col,
  }

  if start.character == nil or start.line == nil then
    ---@diagnostic disable-next-line: undefined-field
    M.error("Found an item for Trouble without start range " .. vim.inspect(start))
  end
  if finish.character == nil or finish.line == nil then
    ---@diagnostic disable-next-line: undefined-field
    RUtils.error("Found an item for Trouble without finish range " .. vim.inspect(finish))
  end
  local row = start.line ---@type number
  local col = start.character ---@type number

  if not item.message and filename then
    -- check if the filename is a uri
    if string.match(filename, "^%w+://") ~= nil then
      if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
      end
      local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
      item.message = lines[1] or ""
    else
      local fd = assert(uv.fs_open(filename, "r", 438))
      local stat = assert(uv.fs_fstat(fd))
      local data = assert(uv.fs_read(fd, stat.size, 0))
      assert(uv.fs_close(fd))

      ---@diagnostic disable-next-line: param-type-mismatch
      item.message = vim.split(data, "\n", { plain = true })[row + 1] or ""
    end
  end

  ---@class Item
  ---@field is_file boolean
  ---@field fixed boolean
  local ret = {
    bufnr = bufnr,
    filename = filename,
    lnum = row + 1,
    col = col + 1,
    start = start,
    finish = finish,
    sign = item.sign, ---@type string?
    sign_hl = item.sign_hl, ---@type string?
    -- remove line break to avoid display issues
    text = vim.trim(item.message:gsub("[\n]+", "")):sub(0, vim.o.columns),
    full_text = vim.trim(item.message),
    -- type = M.severity[item.severity] or M.severity[0],
    code = item.code or (item.user_data and item.user_data.lsp and item.user_data.lsp.code), ---@type string?
    code_href = (item.codeDescription and item.codeDescription.href)
      or (
        item.user_data
        and item.user_data.lsp
        and item.user_data.lsp.codeDescription
        and item.user_data.lsp.codeDescription.href
      ), ---@type string?
    source = item.source, ---@type string?
    severity = item.severity or 0,
  }
  return ret
end

local function lsp_buf_request(buf, method, params, handler)
  lsp.buf_request(buf, method, params, function(err, m, result)
    handler(err, method == m and result or m)
  end)
end

local function locations_to_items(results, default_severity)
  default_severity = default_severity or 0
  local ret = {}
  for bufnr, locs in pairs(results or {}) do
    for _, loc in pairs(locs.result or locs) do
      if not vim.tbl_isempty(loc) then
        local uri = loc.uri or loc.targetUri
        local buf = uri and vim.uri_to_bufnr(uri) or bufnr
        loc.severity = loc.severity or default_severity
        table.insert(ret, M.process_item(loc, buf))
      end
    end
  end
  return ret
end

local include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" } -- for the given modes, include the declaration of the current symbol in the results

-- @private
local function make_position_param(win, buf)
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
  if not line then
    return { line = 0, character = 0 }
  end
  col = vim.str_utfindex(line, col)
  return { line = row, character = col }
end

function M.make_text_document_params(buf)
  return { uri = vim.uri_from_bufnr(buf) }
end

--- Creates a `TextDocumentPositionParams` object for the current buffer and cursor position.
---
-- @returns `TextDocumentPositionParams` object
-- @see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocumentPositionParams
local function make_position_params(win, buf)
  return {
    textDocument = M.make_text_document_params(buf),
    position = make_position_param(win, buf),
  }
end
function M.references(win, buf, cb, mode)
  local method = "textDocument/references"
  local params = make_position_params(win, buf)

  params.context = { includeDeclaration = vim.tbl_contains(include_declaration, mode) }

  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.error("an error happened getting references: " .. err.message)
      return cb {}
    end
    if result == nil or #result == 0 then
      return cb {}
    end
    local ret = locations_to_items({ result }, 0)
    cb(ret)
  end)
end

function M.definitions(win, buf, cb, mode)
  local method = "textDocument/definition"
  local params = make_position_params(win, buf)
  params.context = { includeDeclaration = vim.tbl_contains(include_declaration, mode) }
  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.error("an error happened getting definitions: " .. err.message)
      return cb {}
    end
    if result == nil or #result == 0 then
      return cb {}
    end
    for _, value in ipairs(result) do
      value.uri = value.targetUri or value.uri
      value.range = value.targetSelectionRange or value.range
    end
    local ret = locations_to_items({ result }, 0)
    cb(ret)
  end)
end

function M.type_definitions(win, buf, cb)
  local method = "textDocument/typeDefinition"
  local params = make_position_params(win, buf)
  lsp_buf_request(buf, method, params, function(err, result)
    if err then
      ---@diagnostic disable-next-line: undefined-field
      RUtils.error("an error happened getting type definitions: " .. err.message)
      return cb {}
    end
    if result == nil or #result == 0 then
      return cb {}
    end
    for _, value in ipairs(result) do
      value.uri = value.targetUri or value.uri
      value.range = value.targetSelectionRange or value.range
    end
    local ret = locations_to_items({ result }, 0)
    cb(ret)
  end)
end

return M
