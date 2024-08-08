local ts = vim.treesitter
local parsers = require('nvim-treesitter.parsers')
local utils = reload('refactor.lib.ts_utils')

local tostr = utils.gnt

local queries = {
  -- NOTE: probably won't need `exported_arrow_functions` because `const_fns` matches
  -- the same stuff, just doesn't include the parent `export_statement` node if
  -- the function is being exported, but we can just look if the parent of the
  -- `lexical_declaration` node is of type `export_statement` to determine if
  -- the function should be "public" or "private".
  exported_arrow_functions = [[
    (export_statement
      (lexical_declaration
        (variable_declarator
          name: (identifier) @ident
          value: (arrow_function
                   parameters: (formal_parameters) @params
                   return_type: (type_annotation)? @return_type
                   body: (statement_block) @body))))
  ]],

  -- NOTE: Use this to get all arrow functions
  arrow_functions = [[
    (lexical_declaration
      (variable_declarator
        name: (identifier) @ident
        value: (arrow_function
                 parameters: (formal_parameters) @params
                 return_type: (type_annotation)? @return_type
                 body: (statement_block) @body))) @declaration
  ]],

  normal_fns = [[
    (function_declaration
      name: (identifier) @ident
      parameters: (formal_parameters) @params
      return_type: (type_annotation)? @return_type
      body: (statement_block) @body) @declaration
  ]],

  -- NOTE: Will need to use this to get the names of functions that get called.
  -- Use this in conjunction with `arrow_functions` query to figure out the names of
  -- functions that need to be converted from `myFn()` to `this.myFn()`.
  fn_names = [[
    (call_expression
      function: (identifier) @fn_name)
  ]]
}

local p = function(v)
  print(vim.inspect(v))
end

local t = function(node)
  p(ts.get_node_text(node, 0))
end

local M = {}


---@class Fn
---@field identifier TSNode
---@field params TSNode | nil
---@field return_type TSNode | nil
---@field body TSNode
---@field exported boolean
---@field async boolean

---@param tbl table
---@param n number
local _fill = function(n)
  local tbl = {}
  for _ = 0, n do
    table.insert(tbl, nil)
  end
  return tbl
end

---@param qs string The query string
---@param root TSNode
---@param lang string
---@param root_capture_node_type string
---@return table<string, TSNode>[]
local function unpack_captured_nodes(qs, root, lang, root_capture_node_type)
  ---@type TSNode[][]
  local results = {}
  ---@type table<string, TSNode> | nil
  local curr = nil

  local query = ts.query.parse(lang, qs)
  for _, node, _ in query:iter_captures(root, 0) do
    local type = node:type()
    if type == root_capture_node_type then
      if curr ~= nil then
        table.insert(results, curr)
      end
      curr = {}
    end
    curr[type] = node
  end

  if curr then
    table.insert(results, curr)
  end

  return results
end

---@param root TSNode
---@param lang string
---@return Fn[]
local function get_fns(root, lang)
  ---@type Fn[]
  local fns = {}

  local normal_fns_nodes = unpack_captured_nodes(queries.normal_fns, root, lang, 'function_declaration')
  local arrow_fn_nodes = unpack_captured_nodes(queries.arrow_functions, root, lang, 'lexical_declaration')
  local all_fn_nodes = {}
  for _, group in ipairs(arrow_fn_nodes) do
    table.insert(all_fn_nodes, group)
  end
  for _, group in ipairs(normal_fns_nodes) do
    table.insert(all_fn_nodes, group)
  end

  for _, group in ipairs(all_fn_nodes) do
    local fn = {
      identifier = nil,
      params = nil,
      return_type = nil,
      body = nil,
      exported = false,
      async = false,
    }
    for type, node in pairs(group) do
      if type == 'identifier' then
        fn.identifier = node
      end

      if type == 'formal_parameters' then
        fn.params = node
      end

      if type == 'type_annotation' then
        fn.return_type = node
      end

      if type == 'statement_block' then
        fn.body = node
      end

      if type == 'lexical_declaration' or type == 'function_declaration' then
        local parent = node:parent()
        if parent and parent:type() == 'export_statement' then
          fn.exported = true
        end
        local txt = utils.gnt(node)
        if txt and txt:match('async') then
          fn.async = true
        end
      end
    end
    table.insert(fns, fn)
  end

  -- for _, value in ipairs(fns) do
  --   local d = {}
  --   for k, v in pairs(value) do
  --     if type(v) ~= 'boolean' then
  --       d[k] = ts.get_node_text(v, 0)
  --     else
  --       d[k] = v
  --     end
  --   end
  --   p(d)
  -- end

  return fns
end

local append = function(tbl, other)
  for _, v in ipairs(other) do
    table.insert(tbl, v)
  end
end

M.run = function()
  p('running the script...')
  local parser = parsers.get_parser()
  local tree = parser:parse()[1]
  local root = tree:root()
  local lang = parser:lang()
  local fns = get_fns(root, lang)

  local class_innards = {
    'export class BundleService {\n'
  }

  for _, fn in ipairs(fns) do
    local parts = {}
    if fn.exported == false then
      table.insert(parts, 'private ')
    end

    if fn.async then
      table.insert(parts, ' async ')
    end

    table.insert(parts, tostr(fn.identifier))
    table.insert(parts, tostr(fn.params))
    if fn.return_type then
      table.insert(parts, tostr(fn.return_type))
    end
    table.insert(parts, tostr(fn.body))
    table.insert(parts, '\n \n')
    -- local s = table.concat(parts, ' ')
    append(class_innards, parts)
  end


  table.insert(class_innards, '}')
  local lines = { '' }
  local i = 1
  for _, s in ipairs(class_innards) do
    if s:match('\n') then
      for split in string.gmatch(s, '[^\n\r]+') do
        lines[i] = lines[i] .. split
        table.insert(lines, '')
        i = i + 1
      end
    else
      lines[i] = lines[i] .. s
    end
  end
  -- for _, v in ipairs(lines) do
  --   p(v)
  -- end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

vim.keymap.set('n', '<leader>,,',
  ':luafile $HOME/.config/lvim/lua/refactor/lib/convert_typescript_module_to_class.lua<cr>',
  { noremap = true })

M.run()

-- return M
