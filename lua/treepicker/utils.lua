local ts = vim.treesitter

local M = {}

---@param node TSNode
---@param strip_quotes boolean | nil
M.stringify = function(node, strip_quotes)
  if strip_quotes and node:type() == 'string' then
    node = node:named_child(0)
  end
  return ts.get_node_text(node, 0)
end

---@param node TSNode
---@param type string
M.get_children_by_type = function(node, type)
  return coroutine.wrap(function()
    for _, child in ipairs(node:children()) do
      if child:type() == type then
        coroutine.yield(child)
      end
    end
  end)
end

---@param node TSNode
---@param type string
---@return TSNode, string
M.get_field = function(node, key)
  local field = node:field(key)[1]
  return field, M.stringify(field)
end

return M
