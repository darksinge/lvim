local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local function get_uuid()
  local uuid = vim.fn.system("uuid")
  if type(uuid) ~= 'string' then
    return "00000000-0000-0000-0000-000000000000"
  end
  return string.gsub(uuid, "\n", "")
end

local M = {}

M.snippets = {
  {
    s(
      "uuid",
      fmt([['{}']], {
        f(get_uuid),
      })
    )
  }
}

M.auto_snippets = {
  {
    s(
      "uuid'",
      fmt([['{}']], {
        f(get_uuid),
      })
    )
  },
  {
    s(
      'uuid"',
      fmt([["{}]], {
        f(get_uuid),
      })
    )
  },
  {
    -- for when you need to shrug
    s(':shrug', t('¯\\_(ツ)_/¯'))
  },
  {
    s(':ty', t('taxonomy')),
  },
  {
    s(':ties', t('taxonomies')),
  },
  {
    s(':Ty', t('Taxonomy')),
  },
  {
    s(':Td', t('TaxonomyDocument')),
  },
  {
    s(':Tm', t('TaxonomyModel')),
  }
}


return M
