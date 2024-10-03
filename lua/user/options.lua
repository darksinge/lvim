local M = {}

local neovide_default_opts = {
  ['opt.guifont'] = "MonoLisa:h24",
  ['g.neovide_transparency'] = 1,
  ['g.transparency'] = 0.8,
  ['g.neovide_scroll_animation_length'] = 0.3,
  ['g.neovide_refresh_rate'] = 60,
  ['g.neovide_confirm_quit'] = true,
  ['g.neovide_input_macos_alt_is_meta'] = false,
}

local default_lvim_opts = {
  format_on_save = true,
  reload_config_on_save = true,
  leader = "space",
  ['lsp.automatic_servers_installation'] = false,
  ['log.level'] = "warn",
  ['builtin.treesitter.ensure_installed'] = { "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx",
    "css", "rust", "java", "yaml", "haskell", },
  ['builtin.terminal.active'] = true,
  ['builtin.nvimtree.setup.view.side'] = "left",
  ['builtin.nvimtree.setup.renderer.icons.show.git'] = true,
  ['builtin.nvimtree.setup.filters.custom'] = {},
  ['builtin.treesitter.ignore_install'] = {},
  ['builtin.treesitter.highlight.enabled'] = true,
  ['builtin.project.detection_methods'] = { "pattern" },
  ['builtin.project.patterns'] = { "pnpm-lock.yaml", "package-lock.json", "yarn.lock", "requirements.txt", ".git", "lua",
    "bun.lockb", },
  ['builtin.telescope.defaults.path_display'] = { shorten = 4, },
}

local default_vim_opts = {
  ['g.maplocalleader'] = ',',
  ['opt.shell'] = "/bin/zsh",
  ['o.linebreak'] = true,
  ['o.wrap'] = false,
  ['o.sessionoptions'] = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
}

table.tail = function(tbl)
  local copy = {}
  local tail = tbl[#tbl]
  for i = 1, #tbl - 1 do
    table.insert(copy, tbl[i])
  end
  return tail, copy
end

---@param keys string[]
---@param value any
local function unpack_opt_keys(keys, value)
  local key = table.remove(keys, 1)
  if key == nil then
    return value
  end

  return { [key] = unpack_opt_keys(keys, value) }
end

local unpack_opts = function(opts)
  local unpacked = {}
  for key, value in pairs(opts) do
    local property_names = vim.split(key, '.', { plain = true })
    vim.tbl_deep_extend('error', unpack_opt_keys(property_names, value), unpacked)
  end
  return unpacked
end

---@param opts { colorscheme: string | nil; lvim: table<string, unknown> | nil; vim: table<string, unknown> | nil } | nil
M.setup = function(opts)
  opts = opts or {}

  require('user.colorscheme').setup({ scheme = opts.colorscheme })
  ---NOTE: This is a WIP. Basically, this commented-out stuff is what you were
  ---working on when you left off.

  -- ---@type { [1]: string[]; [2]: unknown }[]
  -- local default_opts = {}
  -- vim.list_extend(default_opts, unpack_opts(default_lvim_opts))
  -- vim.list_extend(default_opts, unpack_opts(default_vim_opts))

  -- vim.tbl_deep_extend('keep', opts, { lvim = unpack_opts(default_lvim_opts) })
  -- vim.tbl_deep_extend('keep', opts, { vim = unpack_opts(default_vim_opts) })
  -- if vim.g.neovide then
  --   vim.tbl_deep_extend('force', opts, { vim = unpack_opts(neovide_default_opts) })
  -- end

  lvim.reload_config_on_save = true
  lvim.leader = "space"
  vim.g.maplocalleader = ','
  lvim.lsp.automatic_servers_installation = false

  lvim.transparent_window = false

  if vim.g.neovide then
    vim.opt.guifont = "MonoLisa:h24"

    vim.g.neovide_transparency = 1
    vim.g.transparency = 0.8
    vim.g.neovide_scroll_animation_length = 0.3
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_confirm_quit = true
    vim.g.neovide_input_macos_alt_is_meta = false
  end

  lvim.log.level = "warn"
  lvim.format_on_save = true

  lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "css",
    "rust",
    "java",
    "yaml",
    "haskell",
  }

  lvim.builtin.terminal.active = true
  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
  lvim.builtin.nvimtree.setup.filters.custom = {}

  lvim.builtin.treesitter.ignore_install = {}
  lvim.builtin.treesitter.highlight.enabled = true

  lvim.builtin.project.detection_methods = { "pattern" }
  lvim.builtin.project.patterns = {
    "pnpm-lock.yaml",
    "package-lock.json",
    "yarn.lock",
    "requirements.txt",
    ".git",
    "lua",
    "bun.lockb",
  }

  vim.opt.shell = "/bin/zsh"
  lvim.format_on_save = true

  vim.o.linebreak = true
  vim.o.wrap = false
  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

  lvim.builtin.telescope.defaults.path_display = {
    shorten = 4,
  }

  -- lvim.builtin.telescope.pickers.git_files.hidden = true
  lvim.builtin.telescope.pickers.git_files.find_command = { 'git', 'ls-files', '--cached', '--others',
    '--exclude-standard', '--include=.env*' }
  lvim.builtin.telescope.pickers.find_files.hidden = false

  -- lvim.builtin.telescope.theme
  -- lvim.builtin.cmp.sources.H
end

return M
