local t_ok, t = pcall(require, 'telescope.builtin')
if not t_ok then
  return
end

local M = {}

function M.grep_config()
  local opts = {}
  opts.prompt_prefix = lvim.icons.ui.Search .. ' '
  opts.search_dirs = { '~/.config/lvim/', }
  opts.prompt_title = 'LunarVim Config'
  opts.shorten_path = true
  t.find_files(opts)
end

return M
