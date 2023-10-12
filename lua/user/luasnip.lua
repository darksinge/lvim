local ls = require('luasnip')

local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")
-- local conds_expand = require("luasnip.extras.conditions.expand")

local function get_uuid()
  return "'" .. string.gsub(vim.fn.system("uuid"), "\n", "") .. "'"
end

local uuid_snippet = {
  s(
    "uuid",
    fmt([[{}]], {
      f(get_uuid),
    })
  )
}

ls.config.setup({
  enable_autosnippets = true,
})

local ts = vim.treesitter

-- ls.cleanup()
ls.add_snippets("javascript", uuid_snippet)
ls.add_snippets("typescript", uuid_snippet)
ls.add_snippets("lua", uuid_snippet)

local p = function(...)
  local n = select('#', ...)
  for i = 1, n do
    local v = select(i, ...)
    print(vim.inspect(v))
  end
end

local gnt = function(node)
  return ts.get_node_text(node, vim.api.nvim_get_current_buf())
end

local pn = function(node)
  if node then
    p(gnt(node))
  else
    p(node)
  end
end

---@param root TSNode | nil
---@return table<integer, TSNode>
local get_fns_with_comments = function()
  local parsers = require('nvim-treesitter.parsers')
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = parsers.get_buf_lang(bufnr)
  local parser = parsers.get_parser(bufnr, lang)
  ---@type TSTree
  local tree = parser:parse()[1]
  local root = tree:root()
  local fns = {}
  local query = ts.query.parse(lang, [[(function_declaration) @fn]])
  for _, matches, _ in query:iter_matches(root, bufnr, root:start(), root:end_()) do
    table.insert(fns, matches[1])
  end
  return fns
end

-- local snip = {
--   s('foo', fmt([[{}]], {
--     f(function()
--       docnode(0)
--       return ''
--     end),
--     i(0)
--   })),
-- }

---@param row integer
---@param col integer
---@param node TSNode
local node_is_in_range = function(row, col, node)
  local sr, sc, er, ec = node:range()
  if row >= sr and row <= er then
    if col >= sc and col <= ec then
      return true
    end
  end
end

---@param fn TSNode
---@return table<integer, TSNode>
local get_fn_args = function(fn)
  local meta = {}
  p(fn:type())
  local name = fn:field('name')[1]
  meta.name = gnt(name)
  meta.params = {}
  local params = fn:field('parameters')[1]
  for _, param in ipairs(params:named_children()) do
    if param:type() == 'identifier' then
      table.insert(meta.params, { name = gnt(param) })
    end
  end
  return meta
end

-- local snip = {
--   s('//', f(function()
--     local node = ts.get_node()
--     if node then
--       local fns = get_fns_with_comments()
--       local pos = vim.api.nvim_win_get_cursor(0)
--       local row = pos[1]
--       local col = pos[2]
--       for _, fn in ipairs(fns) do
--         if node_is_in_range(row, col, fn) then
--           local meta = get_fn_args(fn)
--           local line = '/** ' .. meta.name .. ' '
--           for _, param in ipairs(meta.params) do
--             line = line .. '; @param {*} ' .. param.name
--           end
--           return line .. ' */'
--         end
--       end
--     end
--     return '//'
--   end)),
-- }

-- ls.add_snippets("all", snip, { type = 'autosnippets' })

local multline_comment_snip = {
  s('/***', fmt([[/**
 * {}
 */]], { i(0) }))
}
ls.add_snippets("typescript", multline_comment_snip, { type = 'autosnippets' })
ls.add_snippets("javascript", multline_comment_snip, { type = 'autosnippets' })




local objectid_snip = {
  s('objectid', fmt([[ObjectId{}]], { i(0) }))
}
ls.add_snippets("typescript", objectid_snip, { type = 'autosnippets' })
ls.add_snippets("javascript", objectid_snip, { type = 'autosnippets' })




local newObjectid_snip = {
  s('noid', fmt([[new ObjectId(){}]], { i(0) }))
}
ls.add_snippets("typescript", newObjectid_snip, { type = 'autosnippets' })
ls.add_snippets("javascript", newObjectid_snip, { type = 'autosnippets' })




-- javascript: create async arrow function
ls.add_snippets("javascript", {
  s('=fa', fmt('const {} = async ({}) => {{{}}}', { i(1, 'fn'), i(2, '...args'), i(3) }))
}, { type = 'autosnippets' })



-- javascript: create normal arrow function
ls.add_snippets("javascript", {
  s('=fs', fmt('const {} = ({}) => {{{}}}', { i(1, 'fn'), i(2, '...args'), i(3) }))
}, { type = 'autosnippets' })



-- typescript: create async arrow function
ls.add_snippets(
  "typescript",
  {
    s('fna=', fmt('const {1} = async ({2}: {3}): Promise<{4}> => {{{5}}}', {
      i(1, 'fn'),
      i(2, '...args'),
      i(3, 'unknown[]'),
      i(4, 'ReturnType'),
      i(5),
    })
    )
  },
  { type = 'autosnippets' }
)


-- typescript: create normal arrow function with types
ls.add_snippets(
  "typescript",
  {
    s('fns=', fmt('const {1} = ({2}: {3}): {4} => {{{5}}}', {
      i(1, 'fn'),
      i(2, '...args'),
      i(3, 'unknown[]'),
      i(4, 'ReturnType'),
      i(5),
    })
    )
  },
  { type = 'autosnippets' }
)



vim.keymap.set({ "i", "s" }, "<M-]>", function()
  if ls.expand_or_jumpable() then
    return ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<M-[>", function()
  if ls.jumpable(-1) then
    return ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i" }, "<M-,>", function()
  if ls.choice_active() then
    return ls.change_choice(-1)
  end
end, { silent = true })

vim.keymap.set({ "i" }, "<M-.>", function()
  if ls.choice_active() then
    return ls.change_choice(1)
  end
end, { silent = true })
