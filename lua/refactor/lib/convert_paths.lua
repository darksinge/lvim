local convert_schemas = reload('refactor.lib.convert_schemas')
local q = reload('refactor.lib.queries')
local u = reload('refactor.lib.ts_utils')
local w = reload('refactor.lib.wrappers')


---@param parent TSNode `parent` should be the `parameters` array in the JSON schema
local function get_parameter_config_nodes(parent)
  ---@type { params: {name: string, required: boolean, schema: TSNode, description: TSNode}[], queries: {name: string, required: boolean, schema: TSNode, description: TSNode}[] }
  local nodes = {
    params = {},
    queries = {},
  }

  if not parent then
    return nodes
  end

  for _, child in ipairs(parent:named_children()) do
    assert(child:type() == 'object', 'expected child to be object, got ' .. child:type() .. ' instead')
    local conf = {
      name = nil,
      required = false,
      schema = nil,
      description = nil,
    }

    local in_node = w.o.dot(child, 'in', true)
    local param_type = w.s.to_string(in_node)

    local name = w.o.dot(child, 'name')
    conf.name = w.s.to_string(name)
    local required = w.o.dot(child, 'required')
    if required and required:type() == 'true' then
      conf.required = true
    end

    conf.description = w.o.dot(child, 'description', true)

    conf.schema = w.o.dot(child, 'schema', true)

    if param_type == 'path' then
      table.insert(nodes.params, conf)
    elseif param_type == 'query' then
      table.insert(nodes.queries, conf)
    else
      assert(false, 'this should not happen')
    end
  end

  return nodes
end

---@param request_body TSNode `parent` should be the `requestObject` object in the JSON schema
local function get_request_object_from_config(request_body)
  ---@type {description: string, type: string, schema: TSNode|nil, required: boolean}
  local result = {
    description = '',
    type = nil,
    schema = nil,
    required = false,
  }

  if not request_body then
    return result
  end

  local content = w.o.dot(request_body, 'content', true)
  local content_type_node = content:named_child(0)
  local type = w.p.key(content_type_node)
  t(type)
  result.type = w.s.to_string(type)
  local content_type_node_value = w.p.value(content_type_node)
  local schema = w.o.dot(content_type_node_value, 'schema', true)
  result.schema = schema

  local required = w.o.dot(request_body, 'required')
  if required and required:type() == 'true' then
    result.required = true
  end

  local description = w.o.dot(request_body, 'description', true)
  if description then
    result.description = u.gnt(description)
  end

  return result
end

local function get_response_objects_from_config(responses)
  ---@type { ok_responses: { status: string, description: string, type: string, schema: TSNode, required: boolean }[], error_responses: string[] }
  local result = {
    ok_responses = {},
    error_responses = {},
  }

  if not responses then
    return result
  end

  local keys = w.o.keys(responses)
  for _, key in ipairs(keys) do
    local status = string.gsub(key, "^'(.*)'$", "%1")
    if string.match(status, '[45]%d%d') then
      table.insert(result.error_responses, status)
    else
      local conf = {
        status = status,
        description = '',
        type = nil,
        schema = nil,
        required = false,
      }

      local response = w.o.dot(responses, key, true)

      local description = w.o.dot(response, 'description', true)
      if description then
        conf.description = u.gnt(description)
      end

      local content = w.o.dot(response, 'content')
      if content then
        local content_type_node = content:named_child(0)
        local type = w.p.key(content_type_node)
        conf.type = w.s.to_string(type)
        local content_type_node_value = w.p.value(content_type_node)
        local schema = w.o.dot(content_type_node_value, 'schema')
        conf.schema = schema

        local required = w.o.dot(response, 'required')
        if required and required:type() == 'true' then
          conf.required = true
        end

      else
        assert(status == '204')
      end

      table.insert(result.ok_responses, conf)
    end
  end

  return result
end

local function convert_paths()
  local method_configs = q.query_method_configs()

  repeat
    local method_config = method_configs[1]
    local node = w.p.value(method_config)
    assert(node ~= nil)

    local parameters_config = w.o.dot(node, 'parameters')
    local parameter_nodes = get_parameter_config_nodes(parameters_config)

    local request_object_config = w.o.dot(node, 'requestBody')
    local request_object = get_request_object_from_config(request_object_config)

    local response_object_config = w.o.dot(node, 'responses')
    local responses = get_response_objects_from_config(response_object_config)

    local operation_id_node = w.o.dot(node, 'operationId')

    local summary = w.o.dot(node, 'summary')
    if not summary then
      print('"summary" was not found on "responses" object; check if it has "description" instead and rename to "summary" if found.')
      print('problem is with config on line ' .. node:start())
      assert(false)
    end
    local tags = w.o.dot(node, 'tags', true)

    local lines = { '{' }

    if operation_id_node then
      table.insert(lines, 'operationId: ' .. u.gnt(operation_id_node) .. ',')
    end

    if tags then
      table.insert(lines, 'tags: ' .. u.gnt(tags) .. ',')
    end

    table.insert(lines, 'request: {')
    if #parameter_nodes.params > 0 then
      table.insert(lines, 'params: {')
      table.insert(lines, '  schema: z.object({')
      for _, param in ipairs(parameter_nodes.params) do
        local schema = u.gnt(param.schema)
        if param.description then
          schema = schema .. '.describe(' .. u.gnt(param.description) .. ')'
        end
        local line = '  ' .. param.name .. ': ' .. schema .. ','
        table.insert(lines, line)
      end
      table.insert(lines, '  }),')
      table.insert(lines, '},')
    end

    if #parameter_nodes.queries > 0 then
      table.insert(lines, 'query: {')
      table.insert(lines, '  schema: z.object({')
      for _, query in ipairs(parameter_nodes.queries) do
        local schema = u.gnt(query.schema)
        if query.description then
          schema = schema .. '.describe(' .. u.gnt(query.description) .. ')'
        end
        local line = '  ' .. query.name .. ': ' .. schema .. ','
        table.insert(lines, line)
      end
      table.insert(lines, '  }),')
      table.insert(lines, '},')
    end

    if request_object.schema then
      table.insert(lines, 'body: {')
      if request_object.type ~= "application/json" then
        table.insert(lines, "contentType: '" .. request_object.type .. "',")
      end

      local schema = u.gnt(request_object.schema)
      if request_object.description then
        schema = schema .. '.describe(' .. request_object.description .. ')'
      end
      table.insert(lines, '  schema: ' .. schema)
      table.insert(lines, '},')
    end
    table.insert(lines, '},') -- closing bracket for `request`

    -- add responses
    table.insert(lines, 'responses: {')
    for _, res in ipairs(responses.ok_responses) do
      table.insert(lines, res.status .. ': {')
      table.insert(lines, 'description: ' .. res.description .. ',')
      if res.schema then
        local schema = u.gnt(res.schema)
        table.insert(lines, 'schema: ' .. schema .. ',')
      end
      table.insert(lines, '},')
    end

    if #responses.error_responses > 0 then
      local line = '...makeErrors(' .. table.concat(responses.error_responses, ', ') .. '),'
      table.insert(lines, line)
    end

    table.insert(lines, '},') -- closing bracket for responses
    table.insert(lines, '}')


    u.replace_node_with_text(node, lines)

    local method_name = w.p.key(method_config)
    u.replace_node_with_text(method_name, { '_' .. u.gnt(method_name) .. '_' })
    method_configs = q.query_method_configs()
    -- break
  until #method_configs == 0

  -- change all method names back from "_get_", "_put_", etc. back to their
  -- original form (without the underscored).
  method_configs = q.query_method_configs_with_underscores()
  repeat
    local method_config = method_configs[1]
    local method_node = w.p.key(method_config)
    local method = string.gsub(u.gnt(method_node), '_', '')
    u.replace_node_with_text(method_node, { method })
    method_configs = q.query_method_configs_with_underscores()
  until #method_configs == 0
end

local function run()
  -- convert_schemas.run()
  convert_paths()
end

run()
