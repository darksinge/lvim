local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

M.snippets = {
  {
    s(
      ':us',
      fmt('const [{1}, {2}] = useState({3})', {
      })
    )
  }
}

M.auto_snippets = {
  {
    s(':fns', fmt('{1} {2} = ({3}){4} => {{{5}}}', {
      c(1, { t('const'), t('export const') }),
      i(2, 'fn'),
      c(3, {
        fmt('{}: {}', {
          i(1, '...args'),
          i(2, 'unknown[]'),
        }),
        t(''),
      }),
      c(4, {
        fmt(': {}', {
          i(1, 'ReturnType'),
        }),
        t('')
      }),
      i(5),
    })
    )
  },
}

return M
