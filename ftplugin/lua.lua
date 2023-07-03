local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  local vopts = lvim.builtin.which_key.vopts
  local opts = lvim.builtin.which_key.opts

  local mappings = {
    ["z"] = {
      name = " Print",
      l = { '"ayiwoprint(\'<C-R>a:\' .. vim.inspect(<C-R>a))<Esc>', " Print" },
    }
  }

  local vmappings = {
    ['z'] = {
      name = 'Print',
      l = { 'yoprint(\'<esc>pa\' .. vim.inspect(<esc>pa))<Esc>', " Print" },
    },
  }

  wk.register(mappings, opts)
  wk.register(vmappings, vopts)
end


local parsers = require('nvim-treesitter.parsers')
local _ = require('neodash')

---@param node TSNode | nil
---@param node_type string
---@return TSNode | nil
local function find_containing_block(node, node_type)
  if not node then
    return nil
  end

  if node:type() == node_type then
    return node
  end

  return find_containing_block(node:parent(), node_type)
end

local function get_range_in_node(node_type)
  local lang = parsers.get_buf_lang(0)
  if lang ~= 'lua' then
    return
  end

  local node = vim.treesitter.get_node()
  local block = find_containing_block(node, node_type)
  if block then
    return _.table_pack(block:range())
  end
end

local function select_inner_node(node_type, mode)
  local range = get_range_in_node(node_type)
  if not range then
    return
  end

  local sr = range[1] + 1
  local sc = range[2]
  local er = range[3] + 1
  -- local ec = range[4]

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_cursor(win, { sr, sc })

  local line_diff = er - sr
  local keys = mode .. line_diff .. 'j'

  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    'n',
    true
  )
end

vim.keymap.set('o', 'ib', function()
  select_inner_node('block', 'd')
end, { silent = true, noremap = true, buffer = true })
