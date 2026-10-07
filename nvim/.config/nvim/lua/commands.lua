local Log = require "utils.log"
local CreateCmd = require("utils.cmd").create_command

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
  if #info.fargs ~= 0 then
    vim.pack.update(info.fargs, { force = info.bang })
  else
    local prompt = "Do you want to update ALL packages?"
    local choice = vim.fn.confirm(prompt, "&Yes\n&No", 2)

    if choice == 1 then
      Log.info "Updating everything."
      vim.pack.update(nil, { force = info.bang })
    else
      Log.warn "Update aborted."
    end
  end
end, {
  desc = "Update packages",
  nargs = "*",
  bang = true,
  complete = complete_packages,
})

--stylua: ignore
CreateCmd( "ChangeMasterTheme", require("utils.themechange").change_colorscheme_global, { desc = "Misc: change colorscheme global" })
--stylua: ignore
CreateCmd("ImgInsert", require("utils.maim").insert, { desc = "Misc: insert image" })
--stylua: ignore
CreateCmd("E", function() vim.cmd [[ vnew ]] end, { desc = "Misc: start enew" })
--stylua: ignore
CreateCmd("PackDelete", function(info) vim.pack.del(info.fargs, { force = info.bang }) end, { desc = "Delete packages", nargs = "+", bang = true, complete = complete_packages, })
--stylua: ignore
CreateCmd("Snippets", require("utils.cmd").edit_snippet, { desc = "Misc: edit snippet file" })
--stylua: ignore
CreateCmd("LspLog", function() vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename())) end, { desc = "Show LSP client log" })
--stylua: ignore
CreateCmd("LspInfo", ":checkhealth vim.lsp", { desc = "Show LSP info" })
