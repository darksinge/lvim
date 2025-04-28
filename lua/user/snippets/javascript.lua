local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

M.add_snippets = {
  {
    -- javascript: create async arrow function
    s('=fa', fmt('const {} = async ({}) => {{{}}}', { i(1, 'fn'), i(2, '...args'), i(3) }))
  },
  {
    -- javascript: create normal arrow function
    s('=fs', fmt('const {} = ({}) => {{{}}}', { i(1, 'fn'), i(2, '...args'), i(3) }))
  },
  {
    s(':p.e', fmt('process.exit({}0);', { i(0) }))
  },
}

return M
