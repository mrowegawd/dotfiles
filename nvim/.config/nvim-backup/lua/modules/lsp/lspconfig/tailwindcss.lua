local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- { "blade", "edge", "eelixir", "ejs", "elixir", "elm", "erb"
-- "eruby", "haml", "handlebars", "htmldjango", "HTML (EEx)", "HTML (Eex)",
-- "html.twig", "jade", "leaf", "markdown", "njk", "nunjucks",
-- "php", "razor", "slim", "svelte", "twig", "vue" }

local root_pattern = util.root_pattern("package.json")

configs.tailwindcss = {
  default_config = {
    cmd = {"node", "/home/mr00x/.cache/repos/lsp/tailwindcss/extension/dist/server/index.js", "--stdio"};
    filetypes = {"html", "svelte", "htmldjango"};
    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end;

    -- settings = {};
  };
}

-- vim:et ts=2 sw=2
