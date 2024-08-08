local ts_indent = require('nvim-treesitter.indent')
local parsers = require('nvim-treesitter.parsers')

local ts = vim.treesitter

local ns_id = nil
local hl_group = 'MyHighlightGroup'
vim.cmd('highlight ' .. hl_group .. ' gui=bold guibg=yellow guifg=black')
ns_id = vim.api.nvim_create_namespace('my_highlight_namespace')

local get_bufnr = vim.api.nvim_get_current_buf

---@param node TSNode
---@return string | nil
local function gnt(node)
  local bufnr = get_bufnr()
  local ok, result = pcall(ts.get_node_text, node, bufnr)
  if ok then
    return result
  end
end

function p(value) print(vim.inspect(value)) end

---@param node TSNode
function t(node)
  p(gnt(node))
end

local M = {}

M.p = p

M.t = t

M.get_bufnr = function(bufnr)
  return bufnr or get_bufnr()
end

---@return TSNode, integer
M.get_root_node = function()
  local bufnr = M.get_bufnr()
  local lang = parsers.get_buf_lang(bufnr)
  local parser = parsers.get_parser(bufnr, lang)
  ---@type TSTree
  local tree = parser:parse()[1]
  return tree:root(), bufnr
end

M.gnt = gnt

---@param node TSNode
---@param key string
---@return TSNode | nil, string | nil
M.get_field = function(node, key)
  ---@type TSNode[] | nil
  local field_node = node:field(key)
  if not field_node then
    return nil, nil
  end

  local field = field_node[1]
  -- local field_text_node = field:type() == 'string' and field:named_child(0) or field
  return field, M.gnt(field)
end

---@param node TSNode
---@param key string
---@param strip_quotes_on_strings boolean
---@return string | nil
M.get_field_text = function(node, key, strip_quotes_on_strings)
  local text_node, text = M.get_field(node, key)
  if strip_quotes_on_strings and text_node:type() == 'string' then
    local value = text_node:named_children()[1]
    return gnt(value)
  end

  return text
end

---@param node TSNode
---@param type string
---@return fun():TSNode, string
M.get_children_by_type = function(node, type)
  return coroutine.wrap(function()
    for _, child in ipairs(node:named_children()) do
      if child:type() == type then
        coroutine.yield(child, gnt(child))
      end
    end
  end)
end

---@param node TSNode
---@param type string
---@return TSNode | nil, string | nil
M.get_first_child_by_type = function(node, type)
  for _, child in ipairs(node:named_children()) do
    if child:type() == type then
      return child, gnt(child)
    end
  end
end

---@param node TSNode
---@param identifier_name string
---@return TSNode | nil
M.get_child_pair_by_ident = function(node, identifier_name)
  for _, child in ipairs(node:named_children()) do
    local _, inner_key = M.get_field(child, 'key')
    if child:type() == 'pair' and identifier_name == inner_key then
      return child
    end
  end
end

---@param node TSNode
---@param key string
---@return TSNode | nil, string | nil
M.get_child_value_by_key = function(node, key)
  if node:type() == 'pair' then
    return M.get_field(node, 'value')
  end

  if node:type() == 'object' then
    for _, child in ipairs(node:named_children()) do
      local _, inner_key = M.get_field(child, 'key')
      if child:type() == 'pair' and key == inner_key then
        return M.get_field(child, 'value')
      end
    end
  end
end

---@param node TSNode
---@return string[] | nil
M.parse_string_array = function(node)
  assert(node:type() == 'array', 'node type not "array"')
  local result = {}
  for _, child in ipairs(node:named_children()) do
    local value = child:named_child(0)
    if value then
      table.insert(result, M.gnt(value))
    end
  end
  return result
end

---get the indentation level of `line`
---@param line integer
---@return string
M.get_indent_for_line = function(line)
  ---NOTE: I refactored this without testing it so I have no idea if it still
  ---works, but it wasn't referenced anywhere so ¯\_(ツ)_/¯
  local indent = vim.fn.indent(line)
  local whitespace = string.rep(' ', indent)
  return whitespace
end

---@param lines string[]
local sanitize_newlines = function(lines)
  local result = {}
  for _, line in ipairs(lines) do
    for split in string.gmatch(line, '[^\n|\r]+') do
      table.insert(result, split)
    end
  end
  return result
end

M.sanitize_newlines = sanitize_newlines

---@param node TSNode
---@return string[]
M.stringify_node = function(node)
  local s = gnt(node)
  if not s then
    return {}
  end
  return sanitize_newlines({ s })
end

---@param node TSNode
---@param replacement string[]
M.replace_node_with_text = function(node, replacement)
  local bufnr = get_bufnr()
  replacement = sanitize_newlines(replacement)
  local start_row, start_col, end_row, end_col = node:range()
  local ok = pcall(vim.api.nvim_buf_set_text, bufnr, start_row, start_col, end_row, end_col, replacement)
  if not ok then
    p('something went wrong!')
    p('range:' .. start_row .. ', ' .. start_col .. ', ' .. end_row .. ', ' .. end_col)
  end
end

---@param replacements { node: TSNode, replacement: string[] }[]
M.bulk_replace_lines = function(replacements)
  table.sort(replacements, function(a, b)
    local a_start_row, a_start_col = a.node:start()
    local b_start_row, b_start_col = b.node:start()
    if a_start_row == b_start_row then
      return a_start_col > b_start_col
    else
      return a_start_row > b_start_row
    end
  end)
  for _, item in ipairs(replacements) do
    M.replace_node_with_text(item.node, item.replacement)
  end
end


M.highlight_node = function(node, clear_existing)
  if clear_existing then
    M.clear_highlights()
  end

  local bufnr = get_bufnr()
  local a, b, c, d = node:range()
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, a, b, {
    end_line = c,
    end_col = d,
    hl_group = 'MyHighlightGroup',
  })
end

M.clear_highlights = function()
  local bufnr = M.get_bufnr()
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

M.replace_node = function(src_node, target_node)
  local bufnr = M.get_bufnr()
  local start_row, start_col, end_row, end_col = src_node:range()
  local target_text = ts.get_node_text(target_node, bufnr)

  -- Get the text representation of the target node as a list of lines
  local lines = {}
  for line in string.gmatch(target_text, "[^\r\n]+") do
    table.insert(lines, line)
  end

  -- Replace the source node with the target node's text
  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, lines)
end

---@param arr string[]
---@param string string
---@return boolean
M.array_includes = function(arr, string)
  for _, value in ipairs(arr) do
    if value == string then
      return true
    end
  end
  return false
end


return M
