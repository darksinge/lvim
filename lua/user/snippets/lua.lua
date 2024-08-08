local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

M.autosnippets = {
  { s('lcl', t('local')) },
  {
    s('lfn', fmt([[local {} = function()
  {}
end]], { i(1), i(2) }))
  },
  {
    s('func', fmt([[function()
  {}
end]], { i(1) }))
  }
}

return M
