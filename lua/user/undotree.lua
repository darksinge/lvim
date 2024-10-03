local wk = require('which-key')
local undotree_ok, undotree = pcall(require, 'undotree')

local wkopts = lvim.builtin.which_key.opts

if not undotree_ok then
  return {}
end


local M = {}

M.undotree = undotree

M.setup = function()
  undotree.setup()

  local mappings = {
    ["u"] = {
      u = { undotree.toggle, lvim.icons.git.Branch .. ' Toggle Undotree' },
    }
  }

  wk.register(mappings, wkopts)
end

return M
