local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

M.snippets = {}

M.auto_snippets = {
  {
    name = 'promise_then_catch',
    snip = {
      s('.thentry', fmt([[.then(() => {
  +1-
  process.exit(0);
})
.catch((error) => {
  console.error(error);
  process.exit(1);
});]], { i(0) }, { delimiters = '+-' }))
    },
    compat = { 'javascript', 'typescriptreact' }
  },
  {
    name = 'multiline_comment_snip',
    snip = {
      s('/***', fmt([[/**
 * {}
 */]], { i(0) }))
    },
    compat = { 'javascript', 'typescriptreact' }
  },
  {
    name = 'ObjectId',
    snip = {
      s(':oid', fmt([[ObjectId{}]], { i(0) }))
    },
    compat = { 'javascript', 'typescriptreact' }
  },
  {
    name = 'new ObjectId()',
    snip = {
      s(':noid', fmt([[new ObjectId(){}]], { i(0) }))
    },
    compat = { 'javascript', 'typescriptreact' }
  },
  {
    s('$fnas', fmt('{1} {2} = async ({3}){4} => {{{5}}}', {
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
        fmt(': Promise<{}>', {
          i(1, 'ReturnType'),
        }),
        t('')
      }),
      i(5),
    })
    )
  },
  {
    -- typescript: create normal arrow function with types
    s('$fns', fmt('{1} {2} = ({3}){4} => {{{5}}}', {
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
