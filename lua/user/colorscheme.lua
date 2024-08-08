---@alias ColorScheme
--- |'lunar'
--- |'gruvbox'
--- |'gruvbox_material'
--- |'gruvbox_baby'
--- |'rose_pine'
--- |'onedarker'
--- |'onedark'
--- |'horizon'
--- |'tokyonight'
--- |'tokyonight_night'
--- |'tokyonight_day'
--- |'tokyonight_moon'
--- |'desert'
--- |'morning'
--- |'sonokai'
--- |'sonokai_espresso'
--- |'sonokai_shusia'
--- |'edge_aura'
--- |'edge_neon'
--- |'ayu'
--- |'ayu_light'
--- |'ayu_dark'

---@alias ColorSchemaOpts { global: table<string, any> | nil; lualine_theme: string | nil }

---@type table<ColorScheme, { [1]: string; [2]: ColorSchemaOpts } | nil> ;
local themes_defaults = {
  lunar = { "lunar" },
  gruvbox = { "gruvbox" },
  gruvbox_material = { "gruvbox-material", {
    global = {
      -- gruvbox_material_background = 'hard',
      -- gruvbox_material_background = 'soft',
      gruvbox_material_background = 'medium', -- default

      gruvbox_material_foreground = 'mix',
      -- gruvbox_material_foreground = 'original',
      -- gruvbox_material_foreground = 'material',
    }
  } },
  gruvbox_baby = { "gruvbox-baby", { global = { use_original_palette = true }, lualine_theme = 'gruvbox-baby' } },
  rose_pine = { "rose-pine" },
  onedarker = { "onedarker" },
  onedark = { "onedark" },
  horizon = { "horizon" },
  tokyonight = { "tokyonight" },
  tokyonight_night = { "tokyonight-night" },
  tokyonight_day = { "tokyonight-day" },
  tokyonight_moon = { "tokyonight-moon" },
  desert = { "desert" },
  morning = { "morning" },
  sonokai = { "sonokai", { global = { sonokai_style = "default" } } },
  sonokai_espresso = { "sonokai", { global = { sonokai_style = "espresso" } } },
  sonokai_shusia = { "sonokai", { global = { sonokai_style = "shusia" } } },
  edge_aura = { "edge", { lualine_theme = "edge", global = { airline_theme = "edge", edge_style = "aura" } } },
  edge_neon = { "edge", { lualine_theme = "edge", global = { airline_theme = "edge", edge_style = "neon" } } },
  ayu = { "ayu", { global = { ayucolor = "mirage" } } },
  ayu_light = { "ayu", { global = { ayucolor = "light" } } },
  ayu_dark = { "ayu", { global = { ayucolor = "dark" } } },
}

local M = {}

---@param scheme ColorScheme
---@param opts ColorSchemaOpts | nil
local function set_theme(scheme, opts)
  opts = opts or {}
  lvim.colorscheme = scheme
  if opts.global then
    for k, v in pairs(opts.global) do
      vim.g[k] = v
    end
  end

  if opts.lualine_theme then
    lvim.builtin.lualine.options.theme = opts.lualine_theme
  end
end

---@param opts { scheme: ColorScheme | nil, transparent_window: boolean | nil } | nil
M.setup = function(opts)
  opts = opts or { scheme = 'gruvbox', transparent_window = false }

  lvim.transparent_window = not vim.g.neovide or opts.transparent_window

  local scheme, scheme_opts = unpack(themes_defaults[opts.scheme])
  set_theme(scheme, scheme_opts)
end

return M
