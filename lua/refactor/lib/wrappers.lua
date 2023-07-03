local u = reload('refactor.lib.ts_utils')

local function assert_type(node, type)
  assert(node:type() == type, 'expected node type to be "' .. type .. '", got "' .. node:type() .. '" instead')
end

local function assert_object(node)
  assert_type(node, 'object')
end

local function assert_pair(node)
  assert_type(node, 'pair')
end

local function assert_string(node)
  assert_type(node, 'string')
end

local M = {
  -- objects
  o = {},
  -- pairs
  p = {},
  -- arrays
  a = {},
  -- strings
  s = {},
}

---@param node TSNode
local function convert_node(node)
  local type = node:type()
  if type == 'object' then
    return ObjectNode.new(node)
  end
  if type == 'pair' then
    return PairNode.new(node)
  end
  if type == 'string' then
    return StringNode.new(node)
  end
  if type == 'array' then
    return ArrayNode.new(node)
  end
  return node
end

---@param node TSNode
---@param prop string
---@param panic_if_not_found boolean|nil
---@return TSNode
M.o.dot = function(node, prop, panic_if_not_found)
  assert_object(node)
  for _, child in ipairs(node:named_children()) do
    if child:type() == 'pair' then
      local ident_node = child:named_child(0)
      if u.gnt(ident_node) == prop then
        return M.p.value(child)
      end
    end
  end

  if panic_if_not_found then
    assert(false, 'expected child node named "' .. prop .. '" to be found')
  end
end

M.o.has = function(node, prop)
  assert_object(node)
  for _, child in ipairs(node:named_children()) do
    if child:type() == 'pair' then
      local ident_node = child:named_child(0)
      if u.gnt(ident_node) == prop then
        return true
      end
    end
  end
  return false
end

M.o.keys = function(node)
  local keys = {}
  for _, child in ipairs(node:named_children()) do
    if child:type() == 'pair' then
      local ident_node = child:named_child(0)
      table.insert(keys, u.gnt(ident_node))
    end
  end
  return keys
end

---@param node TSNode
M.p.key = function(node)
  assert_pair(node)
  return u.get_field(node, 'key')
end

---@param node TSNode
---@return TSNode
M.p.value = function(node)
  assert_pair(node)
  local value, _ = u.get_field(node, 'value')
  assert(value ~= nil)
  return value
end

M.s.to_string = function(node)
  assert_string(node)
  return u.gnt(node:named_child(0))
end

return M

-- TSNodeWrapper = {}
-- TSNodeWrapper.__index = TSNodeWrapper

-- ---@type TSNode
-- TSNodeWrapper._node = nil

-- ---@param node TSNode|nil
-- function TSNodeWrapper:new(node)
--   local o = {}
--   setmetatable(o, {
--     __index = function(_, prop)
--       if TSNodeWrapper[prop] then
--         return TSNodeWrapper[prop]
--       end

--       assert(node ~= nil)

--       if node[prop] and type(node[prop] == 'function') then
--         return function(_, ...)
--           return node[prop](node, ...)
--         end
--       end

--       return node[prop]
--     end,
--   })
--   self.__index = self
--   o._node = node
--   return o
-- end

-- function TSNodeWrapper:type()
--   return self._node:type()
-- end

-- function TSNodeWrapper:named_child(i)
--   return self._node:named_child(i)
-- end

-- function TSNodeWrapper:named_children()
--   return self._node:named_children()
-- end

-- PairNode = TSNodeWrapper:new()
-- PairNode.__index = PairNode

-- ---@param node TSNode
-- ---@return PairNode
-- function PairNode.new(node)
--   assert(node:type() == 'pair', '`PairNode.new` must be called with a node of type "pair"')
--   local o = {}
--   local self = TSNodeWrapper:new(node)
--   setmetatable(o, self)
--   self.__index = self
--   self._node = node
--   return o
-- end

-- ---@return string|nil
-- function PairNode:key()
--   local _, key = u.get_field(self._node, 'key')
--   return key
-- end

-- function PairNode:key_node()
--   local node, _ = u.get_field(self._node, 'key')
--   assert(node ~= nil)
--   return convert_node(node)
-- end

-- function PairNode:value()
--   local _, value = u.get_field(self._node, 'value')
--   return value
-- end

-- function PairNode:value_node()
--   local node = u.get_field(self._node, 'value')
--   assert(node ~= nil)
--   return convert_node(node)
-- end

-- ---@class StringNode
-- StringNode = {}

-- ---@param node TSNode
-- ---@return StringNode
-- function StringNode.new(node)
--   local self = { _node = node }

--   setmetatable(self, {
--     __index = function(_, prop)
--       if StringNode[prop] then
--         return StringNode[prop]
--       end

--       if node[prop] and type(node[prop] == 'function') then
--         return function(_, ...)
--           return node[prop](node, ...)
--         end
--       end

--       return node[prop]
--     end,
--   })

--   return self
-- end

-- function StringNode:to_string()
--   return u.gnt(self:named_child(0))
-- end

-- ---@class ArrayNode
-- ArrayNode = {}

-- ---@param node TSNode
-- ---@return ArrayNode
-- function ArrayNode.new(node)
--   local self = {}
--   setmetatable(self, {
--     __index = function(_, prop)
--       if ArrayNode[prop] then
--         return ArrayNode[prop]
--       end

--       if node[prop] and type(node[prop] == 'function') then
--         return function(_, ...)
--           return node[prop](node, ...)
--         end
--       end

--       return node[prop]
--     end,
--   })
--   return self
-- end

-- function ArrayNode:includes(value)
--   for _, child in ipairs(self._node:named_children()) do
--     if u.gnt(child) == value then
--       return true
--     end
--   end
--   return false
-- end

-- ---@param i number 0-indexed position in array
-- function ArrayNode:at(i)
--   local item = self._node:named_child(i)
--   return convert_node(item)
-- end

-- ---@class ObjectNode
-- ObjectNode = {}

-- ---@param node TSNode
-- ---@return ObjectNode
-- function ObjectNode.new(node)
--   assert(node:type() == 'object')
--   local self = { _node = node }
--   setmetatable(self, {
--     __index = function(_, prop)
--       if ObjectNode[prop] then
--         return ObjectNode[prop]
--       end

--       if node[prop] and type(node[prop] == 'function') then
--         return function(_, ...)
--           return node[prop](node, ...)
--         end
--       end

--       return node[prop]
--     end,
--   })
--   return self
-- end

-- ---@param name string
-- ---@return PairNode | nil
-- function ObjectNode:dot(name)
--   for _, child in ipairs(self._node:named_children()) do
--     if child:type() == 'pair' then
--       local ident_node = child:named_child(0)
--       if u.gnt(ident_node) == name then
--         return PairNode.new(child)
--       end
--     end
--   end
-- end

-- return {
--   TSNodeWrapper = TSNodeWrapper,
--   ObjectNode = ObjectNode,
--   PairNode = PairNode,
--   StringNode = StringNode,
--   ArrayNode = ArrayNode,
-- }
