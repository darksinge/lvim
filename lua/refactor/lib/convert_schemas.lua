local q = reload('refactor.lib.queries')
local u = reload('refactor.lib.ts_utils')

local M = {}

---`node` should be an `object` node with properties that can be extracted into
--the `openapi()` method provided by `zod-to-openapi`
---@param node TSNode
---@return table<integer, TSNode>
local _get_openapi_data = function(node)
  local openapi_props = {
    title = true,
    example = true,
    examples = true,
    -- default = true,
  }
  local result = {}
  for pair, pair_text in u.get_children_by_type(node, 'pair') do
    local _, key = u.get_field(pair, 'key')
    if openapi_props[key] then
      table.insert(result, pair_text)
    end
  end
  return result
end

---@param node TSNode
---@param zod_list string[]
local _add_zod_common = function(node, zod_list)
  local _, format = u.get_child_value_by_key(node, 'format')
  if format then
    if string.match(format, "date.time") then
      table.insert(zod_list, 'datetime()')
    end

    if string.match(format, "email") then
      table.insert(zod_list, 'email()')
    end

    if string.match(format, "uri") then
      table.insert(zod_list, 'url()')
    end

    if string.match(format, "uuid") then
      table.insert(zod_list, 'uuid()')
    end
  end

  local _, minimum = u.get_child_value_by_key(node, 'minimum')
  if minimum then
    table.insert(zod_list, 'min(' .. minimum .. ')')
  end

  local _, min_length = u.get_child_value_by_key(node, 'minLength')
  if min_length then
    table.insert(zod_list, 'min(' .. min_length .. ')')
  end

  local _, maximum = u.get_child_value_by_key(node, 'maximum')
  if maximum then
    table.insert(zod_list, 'max(' .. maximum .. ')')
  end

  local _, max_length = u.get_child_value_by_key(node, 'maxLength')
  if max_length then
    table.insert(zod_list, 'max(' .. max_length .. ')')
  end

  local pattern = u.get_child_value_by_key(node, 'pattern')
  if pattern and pattern:type() == 'string' then
    local re = u.gnt(pattern:named_child(0))
    table.insert(zod_list, 'regex(/' .. re .. '/)')
  end

  local _, nullable = u.get_child_value_by_key(node, 'nullable')
  if nullable then
    if nullable == 'true' then
      table.insert(zod_list, 'nullable()')
    end
  end

  local _, default_value = u.get_child_value_by_key(node, 'default')
  if default_value then
    table.insert(zod_list, 'default(' .. default_value .. ')')
  end

  local _, description = u.get_child_value_by_key(node, 'description')
  if description then
    table.insert(zod_list, 'describe(' .. description .. ')')
  end

  return zod_list
end

M.convert_boolean = function()
  local query_results = q.query_schemas_by_type('boolean')
  if not query_results then
    return
  end

  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  for _, schema in ipairs(query_results) do
    local zod_schema = { 'z.boolean()' }
    _add_zod_common(schema, zod_schema)
    local zod_text = table.concat(zod_schema, '.')

    local openapi = _get_openapi_data(schema)
    if #openapi > 0 then
      zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
    end

    local replacement = { zod_text }
    table.insert(replacements, { node = schema, replacement = replacement })
  end

  u.bulk_replace_lines(replacements)
end

M.convert_string = function()
  local query_results = q.query_schemas_by_type('string')
  if not query_results then
    return
  end

  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  for _, schema in ipairs(query_results) do
    local enum = u.get_child_pair_by_ident(schema, 'enum')
    local zod_text = ""
    if enum then
      local array, array_text = u.get_field(enum, 'value')
      assert(array and array:type() == 'array', 'enum is not an array')
      local zod_schema = { 'z.enum(' .. array_text .. ')' }
      _add_zod_common(schema, zod_schema)
      zod_text = table.concat(zod_schema, '.')
    else
      local zod_schema = { 'z.string()' }
      _add_zod_common(schema, zod_schema)
      zod_text = table.concat(zod_schema, '.')
    end

    local openapi = _get_openapi_data(schema)
    if #openapi > 0 then
      zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
    end

    local replacement = { zod_text }
    table.insert(replacements, { node = schema, replacement = replacement })
  end

  u.bulk_replace_lines(replacements)
end

M.convert_integer = function()
  local query_results = q.query_schemas_by_type('integer')
  if not query_results then
    return
  end

  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  for _, schema in ipairs(query_results) do
    local zod_schema = { 'z.number().int()' }
    _add_zod_common(schema, zod_schema)
    local zod_text = table.concat(zod_schema, '.')

    local openapi = _get_openapi_data(schema)
    if #openapi > 0 then
      zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
    end

    local replacement = { zod_text }
    table.insert(replacements, { node = schema, replacement = replacement })
  end

  u.bulk_replace_lines(replacements)
end

M.convert_number = function()
  local query_results = q.query_schemas_by_type('number')
  if not query_results then
    return
  end

  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  for _, schema in ipairs(query_results) do
    local zod_schema = { 'z.number()' }
    _add_zod_common(schema, zod_schema)
    local zod_text = table.concat(zod_schema, '.')

    local openapi = _get_openapi_data(schema)
    if #openapi > 0 then
      zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
    end

    local replacement = { zod_text }
    table.insert(replacements, { node = schema, replacement = replacement })
  end

  u.bulk_replace_lines(replacements)
end

---Converts schemas with `$ref` property
M.convert_refs = function()
  local query_results = q.query_ref_schemas()

  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  for _, schema in ipairs(query_results) do
    local ref_child = u.get_child_value_by_key(schema, '$ref')
    if not ref_child then
      goto continue
    end

    local ref_field = u.gnt(ref_child:named_child(0))
    if not ref_field then
      goto continue
    end


    local schema_name = string.match(ref_field, "#/components/schemas/(%w+)")
    local zod_schema = { 'schemas.' .. schema_name }
    _add_zod_common(schema, zod_schema)
    local zod_text = table.concat(zod_schema, '.')

    local openapi = _get_openapi_data(schema)
    if #openapi > 0 then
      zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
    end

    local replacement = { zod_text }
    table.insert(replacements, { node = schema, replacement = replacement })

    ::continue::
  end

  u.bulk_replace_lines(replacements)
end


---@param node TSNode
local function _convert_object_nodes(node)
  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  local type = u.get_child_value_by_key(node, 'type')
  table.insert(replacements, { node = type, replacement = { "'zod_schema'" } })
  local prop, props_text = u.get_child_value_by_key(node, 'properties')
  if not props_text then
    return
  end

  local zod_schema = { 'z.object(' .. props_text .. ')' }
  _add_zod_common(node, zod_schema)
  local zod_text = table.concat(zod_schema, '.')

  local openapi = _get_openapi_data(node)
  if #openapi > 0 then
    zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
  end

  local replacement = { zod_text }
  -- p(replacement)
  table.insert(replacements, { node = prop, replacement = replacement })
  u.bulk_replace_lines(replacements)
end

---@param node TSNode A node that looks like `{ type: 'zod_schema', properties: z.object({ ... }), ... }`
local function make_optional(node)
  local prop, _ = u.get_child_value_by_key(node, 'properties')
  local required = u.get_child_value_by_key(node, 'required')
  if not required then
    return
  end

  -- vim.api.nvim_buf_set_lines(0, required:start(), required:end_(), false, { '' })
  -- p(prop:type())
  local required_props = required and u.parse_string_array(required) or {}
  for args in u.get_children_by_type(prop, 'arguments') do
    local object = u.get_first_child_by_type(args, 'object')
    for arg in u.get_children_by_type(object, 'pair') do
      if arg:type() == 'pair' then
        local _, field = u.get_field(arg, 'key')
        local value = u.get_field(arg, 'value')
        if value:type() == 'call_expression' then
          if not u.array_includes(required_props, field) then
            local line = u.gnt(arg) .. '.optional()'
            u.replace_node_with_text(arg, { line })
          end
        end
      end
    end
  end

  for _, child in ipairs(node:named_children()) do
    if child:type() == 'pair' then
      local node, key = u.get_field(child, 'key')
      if key == 'required' then
        u.replace_node_with_text(node, { '__required__' })
      end
    end
  end

end

---@param node TSNode A node that looks like `{ type: 'zod_schema', properties: z.object({ ... }), ... }`
local function _refactor_converted_object_nodes(node)
  local prop, _ = u.get_child_value_by_key(node, 'properties')
  u.replace_node(node, prop)
end

---@param root TSNode | nil
M.convert_object = function(root)
  -- the first half of this function basically just wraps the `properties`
  -- object with `properties: z.object({ <contents of "properties"> })`
  local get_object_query = function()
    return q.query_schemas_by_type('object', root) or {}
  end

  local get_zod_query = function()
    return q.query_schemas_by_type('zod_schema', root) or {}
  end

  local visited = {}

  local object_queries = get_object_query()
  if not object_queries then
    return
  end

  local node = get_object_query()[1]
  while node do
    _convert_object_nodes(node)
    node = nil
    for _, match in ipairs(get_object_query()) do
      local node_text = u.gnt(match)
      if not visited[node_text] then
        node = match
        visited[node_text] = true
        goto continue
      end
    end
    ::continue::
  end

  -- for props_node in q.query_required_object_props_co() do
  --   make_optional(props_node)
  -- end

  local zod_queries = get_zod_query()
  if not zod_queries then
    return
  end

  -- node = get_zod_query()[1]
  -- while node do
  --   _refactor_converted_object_nodes(node)
  --   node = get_zod_query()[1] or nil
  -- end
end

local _convert_array_nodes = function(node)
  ---@type { node: TSNode, replacement: string[] }[]
  local replacements = {}
  local type = u.get_child_value_by_key(node, 'type')
  table.insert(replacements, { node = type, replacement = { "'zod_array'" } })
  local items, items_text = u.get_child_value_by_key(node, 'items')
  local zod_schema = {}
  if items:type() == 'object' then
    zod_schema[1] = 'z.array(z.object(' .. items_text .. '))'
  else
    zod_schema[1] = 'z.array(' .. items_text .. ')'
  end
  _add_zod_common(node, zod_schema)
  local zod_text = table.concat(zod_schema, '.')

  local openapi = _get_openapi_data(node)
  if #openapi > 0 then
    zod_text = zod_text .. '.openapi({' .. table.concat(openapi, ', ') .. '})'
  end

  local replacement = { zod_text }
  table.insert(replacements, { node = items, replacement = replacement })
  u.bulk_replace_lines(replacements)
end

local _refactor_converted_array_nodes = function(node)
  local items, _ = u.get_child_value_by_key(node, 'items')
  u.replace_node(node, items)
end

M.convert_array = function(root)
  local get_array_query = function()
    return q.query_schemas_by_type('array', root)
  end

  local get_zod_query = function()
    return q.query_schemas_by_type('zod_array', root)
  end

  local array_queries = get_array_query()
  if not array_queries then
    return
  end

  local node = nil
  repeat
    node = get_array_query()[1]
    if node then
      _convert_array_nodes(node)
    end
  until not node

  local zod_queries = get_zod_query()
  if not zod_queries then
    return
  end

  repeat
    node = get_zod_query()[1]
    if node then
      _refactor_converted_array_nodes(node)
    end
  until not node
end

---Call this function last. Extracts all the schemas out of an object named `variable_name`.
---@param variable string
local extract_schemas_from_object = function(variable)
  local schemas = q.query_schemas_nested_in_object(variable)
  local lines = {}

  if not schemas or #schemas == 0 then
    return
  end

  for _, node in ipairs(schemas) do
    local key = u.get_field(node, 'key')
    local value = u.get_field(node, 'value')
    local line = 'export const ' .. u.gnt(key) .. ' = ' .. u.gnt(value)
    table.insert(lines, line)
    table.insert(lines, ' ')
  end

  local parent = schemas[1]:parent()
  repeat
    parent = parent:parent()
  until not parent:parent()

  u.bulk_replace_lines({
    { node = parent, replacement = lines }
  })
end

M.run = function()
  M.convert_string()
  M.convert_number()
  M.convert_integer()
  M.convert_boolean()
  M.convert_refs()
  M.convert_object()
  M.convert_array()
  extract_schemas_from_object('schemas')
  -- extract_schemas_from_object('paths')
end

-- TODO: Get rid of this after you're done testing
M.run()

return M
