local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt


local M = {}

M.snippets = {
  {
    s('argc', t('eval "$(argc --argc-eval "$0" "$@")"'))
  },
}

return M
