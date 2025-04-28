local ls = require('luasnip')
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")
-- local conds_expand = require("luasnip.extras.conditions.expand")


local M = {}

---@param lang string
---@param snip table<unknown> | { name: string, snip: unknown, compat: string[] | nil}
---@param opts table<unknown> | nil
local add = function(lang, snip, opts)
  if type(snip.snip) == 'table' and type(snip.name) == 'string' then
    ls.add_snippets(lang, snip.snip, opts)
    if snip.compat then
      for _, compat_lang in ipairs(snip.compat) do
        ls.add_snippets(compat_lang, snip.snip, opts)
      end
    end
  else
    ls.add_snippets(lang, snip, opts)
  end
end

---@param lang string
---@param config { snippets: unknown[] | nil; auto_snippets: unknown[] | nil }
local setup_lang = function(lang, config)
  if config.snippets then
    for _, snip in ipairs(config.snippets) do
      add(lang, snip)
    end
  end

  if config.auto_snippets then
    for _, snip in ipairs(config.auto_snippets) do
      add(lang, snip, { type = 'autosnippets' })
    end
  end
end

M.setup = function()
  ls.cleanup()

  ls.config.setup({
    enable_autosnippets = true,
  })

  setup_lang('all', require('user.snippets.all'))
  setup_lang('lua', require('user.snippets.lua'))
  setup_lang('typescript', require('user.snippets.typescript'))
  setup_lang('javascript', require('user.snippets.javascript'))
  setup_lang('bash', require('user.snippets.bash'))
  -- setup_lang('typescriptreact', require('user.snippets.typescript-react'))

  vim.keymap.set({ "i", "s" }, "<M-s>j", function()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<M-s>k", function()
    if ls.jumpable(-1) then
      return ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set({ "i", "n" }, "<M-s>n", function()
    if ls.choice_active() then
      return ls.change_choice(-1)
    end
  end, { silent = true })

  vim.keymap.set({ "i", "n" }, "<M-s>p", function()
    if ls.choice_active() then
      return ls.change_choice(1)
    end
  end, { silent = true })
end

M.setup()

return M
