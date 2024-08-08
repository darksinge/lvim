-- local ts = vim.treesitter

-- local p = function(...)
--   local n = select('#', ...)
--   for i = 1, n do
--     local v = select(i, ...)
--     print(vim.inspect(v))
--   end
-- end

-- local gnt = function(node)
--   return ts.get_node_text(node, vim.api.nvim_get_current_buf())
-- end

-- local pn = function(node)
--   if node then
--     p(gnt(node))
--   else
--     p(node)
--   end
-- end

-- ---@param root TSNode | nil
-- ---@return table<integer, TSNode>
-- local get_fns_with_comments = function()
--   local parsers = require('nvim-treesitter.parsers')
--   local bufnr = vim.api.nvim_get_current_buf()
--   local lang = parsers.get_buf_lang(bufnr)
--   local parser = parsers.get_parser(bufnr, lang)
--   ---@type TSTree
--   local tree = parser:parse()[1]
--   local root = tree:root()
--   local fns = {}
--   local query = ts.query.parse(lang, [[(function_declaration) @fn]])
--   for _, matches, _ in query:iter_matches(root, bufnr, root:start(), root:end_()) do
--     table.insert(fns, matches[1])
--   end
--   return fns
-- end

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
