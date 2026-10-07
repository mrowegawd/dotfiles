local add_on_event = require("vim-pack").add_on_event

-- Autoclosing braces.
add_on_event("InsertEnter", {
  {
    src = "windwp/nvim-autopairs",
    on_setup = function()
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local conds = require "nvim-autopairs.conds"

      -- Autoclosing angle-brackets.
      npairs.add_rule(Rule("<", ">", {
        -- Avoid conflicts with nvim-ts-autotag.
        "-html",
        "-javascriptreact",
        "-typescriptreact",
      }):with_pair(conds.before_regex("%a+:?:?$", 3)):with_move(function(opts)
        return opts.char == ">"
      end))

      npairs.add_rules {
        Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
          :use_regex(true)
          :set_end_pair_length(2),
      }

      local cond = require "nvim-autopairs.conds"
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_)
              return "<C-c>2xi<CR><C-c>O"
            end),
        }
      end

      -- Markdown
      npairs.add_rules {
        Rule("```", "```", "markdown"):with_pair(cond.none()):set_end_pair_length(3),
      }

      -- Orgmode
      npairs.add_rules {
        Rule("^%s*#%+BEGIN_SRC%s+[%w_-]+$", "", "org")
          :use_regex(true)
          :with_pair(cond.none())
          :replace_map_cr(function(opts)
            local line = opts.line

            -- Ambil indent + nama language dari BEGIN_SRC
            local prefix, lang = line:match "^(%s*#%+BEGIN_SRC%s+)([%w_-]+)$"

            if not lang then
              return "<CR>"
            end

            return "<CR>" .. prefix:gsub("%#%+BEGIN_SRC%s+", "#+END_SRC")
          end),
      }
    end,
  },
})
