local parsers = require('nvim-treesitter.parsers')
local u = reload('refactor.lib.ts_utils')

local ts = vim.treesitter

local M = {}

---@param querystring string
---@param match_index integer
---@param node TSNode | nil
---@limit limit integer | nil
---@return table<integer, TSNode>
local get_query_results = function(querystring, match_index, node, limit)
  local root, bufnr = u.get_root_node()
  node = node or root
  local lang = parsers.get_buf_lang(bufnr)
  local query = ts.query.parse(lang, querystring)
  local results = {}
  local count = 0
  for _, matches, _ in query:iter_matches(node, bufnr, node:start(), node:end_()) do
    local match = matches[match_index]

    if match then
      table.insert(results, match)
    end

    count = count + 1
    if limit and count >= limit then
      return results
    end
  end
  return results
end

---@param type string
---@param node TSNode | nil
---@return table<integer, TSNode> | nil
M.query_schemas_by_type = function(type, node)
  local query = string.format([[
      (object
        (pair
          key: (property_identifier) @prop (#eq? @prop "type")
          value: (string
                   (string_fragment) @type (#eq? @type "%s"))) ) @schema
    ]], type)

  local results = get_query_results(query, 3, node)
  return results
end

---@param type string
M.query_schemas_by_type_co = function(type)
  return coroutine.wrap(function()
    local query = string.format([[
      (object
        (pair
          key: (property_identifier) @prop (#eq? @prop "type")
          value: (string
                   (string_fragment) @type (#eq? @type "%s"))) ) @schema
    ]], type)
    local ok, results = pcall(get_query_results, query, 3, nil, 1)
    if ok then
      coroutine.yield(results[1])
    end
  end)
end

---Find schemas that have a `$ref` property
---@return table<integer, TSNode>
M.query_ref_schemas = function()
  local query = [[
    (object
      (pair
        key: (property_identifier) @prop (#eq? @prop "$ref"))) @schema
  ]]
  return get_query_results(query, 2)
end

---Find `parameters` array in openapi schema
M.query_route_params = function()
  local query = [[
    (pair
      key: (property_identifier) @key (#eq? @key "parameters")
      value: (array
               (object
                 (pair
                   (property_identifier) @schema-key (#eq? @schema-key "schema"))))) @params
  ]]
  return get_query_results(query, 3)
end

M.query_required_object_props_co = function()
  local parent_nodes = M.query_schemas_by_type('zod_schema')
  local count = #parent_nodes
  return coroutine.wrap(function()
    for _ = 0, count do
      local nodes = M.query_schemas_by_type('zod_schema')
      if nodes and nodes[1] then
        for _, child in ipairs(get_query_results([[
          (object
            (pair
              key: [
                (property_identifier) @required (#eq? @required "required")
                (property_identifier) @key (#eq? @key "properties")
              ])) @schema
        ]], 3, nodes[1])) do
          coroutine.yield(child)
        end
      end
    end
  end)
end

---@param variable_name string
---@return table<integer, TSNode>
M.query_schemas_nested_in_object = function(variable_name)
  local query = [[
    (variable_declarator
      (identifier) @id (#eq? @id "]] .. variable_name .. [[")
      value: (object
               (pair
                 key: (property_identifier)
                 value: (call_expression)) @schema))
  ]]
  return get_query_results(query, 2)
end

-- I created this to remember what the query should look like, but of right
-- now, I'm not planning on actually using it. It queries those annoying
-- schemas that use the "allOf: [schema1, schema2, ...]" thing.
M.query_all_of_schemas = function()
  local query = [[
    (pair
      (object
        (pair
          key: (property_identifier) @prop (#eq? @prop "allOf")
          value: (array)))) @schema
  ]]
  return get_query_results(query, 2)
end

-- M.query_route_configs = function()
--   local query = [[
--     (lexical_declaration
--       (variable_declarator
--         name: (identifier) @paths_var (#eq? @paths_var "paths")
--         value: (object
--                  (pair) @route_config)))
--   ]]
--   return get_query_results(query, 2)
-- end

M.query_parameters_object_on_route_config = function()
  local query = [[
    (pair
      (property_identifier) @method (#match? @method "(put|get|post|delete)")
      (object
        (pair
          key: (property_identifier) @params_ident (#eq? @params_ident "parameters")
          value: (array) @params)))
      ]]
  return get_query_results(query, 3)
end

M.query_method_configs = function()
  local qs = [[
    (object
      (pair
        (property_identifier) @prop (#match? @prop "^(put|get|post|delete)$")) @method_config)
  ]]
  return get_query_results(qs, 2)
end

M.query_method_configs_with_underscores = function()
  local qs = [[
    (object
      (pair
        (property_identifier) @prop (#match? @prop "^_(put|get|post|delete)_$")) @method_config)
  ]]
  return get_query_results(qs, 2)
end


return M
