local query = require('vim.treesitter.query')
local u = require('treepicker.utils')

local ts = vim.treesitter

---@param node TSNode
local assert_type = function(node, type)
  assert(node:type() == type, 'expected node to be of type "' .. type .. '", got "' .. node:type() .. '" instead')
end

---@param node TSNode
local wrap = function(node)
  local type = node:type()
  if type == 'object' then
    return ObjectNode(node)
  end
  if type == 'pair' then
    return PairNode(node)
  end
  if type == 'array' then
    return ArrayNode(node)
  end
  return node
end

---@param node TSNode
function PairNode(node)
  assert_type(node, 'pair')

  return {
    node = node,
    key = function(self)
      return u.get_field(node, 'key')
    end,
    value = function(self)
      local value_node = u.get_field(node, 'value')
      return wrap(value_node)
    end,
  }
end

---@param node TSNode
function ObjectNode(node)
  assert_type(node, 'object')

  ---@type string[]
  local keys = {}

  ---@type table<string, TSNode>
  local map = {}

  for child in u.get_children_by_type(node, 'pair') do
    local key_node = u.get_field(child, 'key')
    local value = u.get_field(child, 'value')
    local key = u.stringify(key_node, true)
    table.insert(keys, key)
    map[key] = wrap(value)
  end

  return {
    node = node,
    ---@return string[]
    keys = function(self)
      return keys
    end,
    ---@param key string
    ---@return TSNode | nil
    get = function(self, key)
      return map[key]
    end,
    iter_values = function(self)
      return coroutine.wrap(function()
        for _, key in ipairs(keys) do
          coroutine.yield(self.get(key))
        end
      end)
    end
  }
end

---@param node TSNode
function ArrayNode(node)
  assert_type(node, 'array')

  return {
    node = node,
    iter = function(self)
      return coroutine.wrap(function()
        for child in node:iter_children() do
          coroutine.yield(wrap(child))
        end
      end)
    end,
  }
end

---@param node TSNode
local test = function(node)
  local o = ObjectNode(node)
  o:keys()
  local foo = o:get('foo')
end
