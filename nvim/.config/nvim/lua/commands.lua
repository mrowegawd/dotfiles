local lazy = require("utils.plugin").require_lazy

local IconsStatus = lazy("icons").status
local IconsMisc = lazy("icons").misc
local CreateCmd = lazy("utils.cmd").create_command

local Log = lazy "utils.log"

local function complete_packages(arg_lead)
  arg_lead = arg_lead or ""

  return vim
    .iter(vim.pack.get())
    :map(function(pack)
      return pack.spec.name
    end)
    :filter(function(name)
      return vim.startswith(name, arg_lead)
    end)
    :totable()
end

CreateCmd("PackUpdate", function(info)
  if #info.fargs > 0 then
    vim.pack.update(info.fargs, { force = info.bang })
    return
  end

  local ok, choice = pcall(vim.fn.confirm, "Do you want to update ALL packages?", "&Yes\n&No", 2)
  if not ok or choice ~= 1 then
    return
  end

  Log.info "Updating everything."
  vim.pack.update(nil, { force = info.bang })
end, {
  desc = "Update packages",
  nargs = "*",
  bang = true,
  complete = complete_packages,
})

--stylua: ignore
CreateCmd("ChangeMasterTheme", lazy("utils.themechange").change_colorscheme_global, { desc = "Misc: change colorscheme global" })
--stylua: ignore
CreateCmd("ImgInsert", lazy("utils.maim").insert, { desc = "Misc: insert image" })
--stylua: ignore
CreateCmd("E", function() vim.cmd [[ vnew ]] end, { desc = "Misc: start enew" })
--stylua: ignore
CreateCmd("PackDelete", function(info) vim.pack.del(info.fargs, { force = info.bang }) end, { desc = "Delete packages", nargs = "+", bang = true, complete = complete_packages, })
--stylua: ignore
CreateCmd("Snippets", lazy("utils.cmd").edit_snippet, { desc = "Misc: edit snippet file" })
--stylua: ignore
CreateCmd("InfoOption", function() vim.cmd "options" end, { desc = "Misc: echo options" })

--stylua: ignore
CreateCmd("ProfilerStart", function() lazy("utils.event_profiler").start() end, {})
--stylua: ignore
CreateCmd("ProfilerStop", function() lazy("utils.event_profiler").start() end, {})

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                LSP COMMANDS                                 ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local function lsp_call()
  return lazy "utils.lsp"
end

--stylua: ignore
CreateCmd("LspLog", function() vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename())) end, { desc = "Show LSP client log" })
--stylua: ignore
CreateCmd("LspInfo", ":checkhealth vim.lsp", { desc = "Show LSP info" })
--stylua: ignore
CreateCmd("LspInfoNew", function() lsp_call().print_status() end, { desc = "Show enhanced LSP information", })

CreateCmd("LspStatusNew", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  print(IconsStatus.list .. " LSP Status for Buffer " .. bufnr .. " (" .. vim.bo.filetype .. "):")

  if #clients == 0 then
    print("  " .. IconsStatus.error .. " No LSP clients connected")
  else
    for _, client in ipairs(clients) do
      print("  " .. IconsStatus.success .. " LSP Client: " .. client.name .. " (ID: " .. client.id .. ")")
      if client.config and client.config.root_dir then
        print("    " .. IconsMisc.folder .. " Root: " .. client.config.root_dir)
      end
    end
  end

  print("\n" .. IconsStatus.gear .. " Enabled LSP configurations:")
  for _, name in ipairs {
    "lua_ls",
    "pyright",
    "texlab",
    "htmlls",
    "cssls",
    "ts_ls",
    "jsonls",
    "rust_analyzer",
  } do
    local enabled = lsp_call().is_server_configured(name)
    local status = enabled and IconsStatus.success .. " enabled" or IconsStatus.error .. " disabled"
    print("  " .. name .. ": " .. status)
  end
end, { desc = "Show LSP client status" })

CreateCmd("LspRestart", function()
  -- Get all active clients
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    Log.warn(IconsStatus.warning .. " No active LSP clients found")
    return
  end

  -- Stop all clients
  for _, client in ipairs(clients) do
    client:stop()
  end

  vim.defer_fn(function()
    -- Restart LSP for all open buffers
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
        vim.cmd.edit()
        break
      end
    end
    Log.info(IconsStatus.sync .. " LSP restarted")
  end, 1000)
end, { desc = "Restart LSP clients" })

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                               PLUGIN VIM-PACK                               ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local function get_all_plugins()
  local all_plugins = vim.deepcopy(lazy("vim-pack").specs)
  -- local config = M.load_optional_config()
  --
  -- if config.selected then
  --   for _, feature_name in ipairs(config.selected) do
  --     local package = M.optional_packages[feature_name]
  --     if package and package.plugins then
  --       for name, url in pairs(package.plugins) do
  --         all_plugins[name] = url
  --       end
  --     end
  --   end
  -- end

  return all_plugins
end

CreateCmd("PluginStatus", function()
  local all_plugins = get_all_plugins()

  print(IconsStatus.search .. " Plugin Status:")
  local dir_vim_pack = vim.fn.stdpath "data" .. "/site/pack/core/opt/"
  print(IconsStatus.info .. " Dir:" .. dir_vim_pack)
  for name, _ in pairs(all_plugins) do
    local pack_path = dir_vim_pack .. name
    local status = vim.fn.isdirectory(pack_path) == 1 and IconsStatus.success .. " Installed"
      or IconsStatus.error .. " Missing"
    print("  " .. name .. ": " .. status)
  end
end, {
  desc = "Show plugin installation status",
})

-- ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- ╏                                     ORG                                     ╏
-- ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

CreateCmd("OrgChangeDirAgenda", function(args)
  if #args.fargs == 0 then
    lazy("utils.note").toggle_agenda_dir(true)
    return
  end
end, { desc = "Change agenda dir", nargs = "*" })

CreateCmd("OrgChangeDirAgendaMinimal", function(args)
  if #args.fargs == 0 then
    lazy("utils.note").toggle_agenda_dir(true, true)
    return
  end
end, { desc = "Change agenda dir", nargs = "*" })
