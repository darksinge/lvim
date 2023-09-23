-- lvim.transparent_window = true
if vim.g.neovide then
  lvim.transparent_window = false
end

---@type { [1]: string, opts: table }
local themes = {
  lunar = "lunar",
  gruvbox = "gruvbox",
  gruvbox_material = "gruvbox-material",
  gruvbox_baby = "gruvbox-baby",
  rose_pine = "rose-pine",
  onedarker = "onedarker",
  onedark = "onedark",
  horizon = "horizon",
  tokyonight = "tokyonight",
  tokyonight_night = "tokyonight-night",
  tokyonight_day = "tokyonight-day",
  tokyonight_moon = "tokyonight-moon",
  desert = "desert",
  morning = "morning",
  sonokai = "sonokai",
  edge = "edge",
  ayu = "ayu",
}

local function set(scheme, opts)
  lvim.colorscheme = scheme
  opts = opts or {}
  if opts.global then
    for k, v in pairs(opts.global) do
      vim.g[k] = v
    end
  end

  if opts.lualine_theme then
    lvim.builtin.lualine.options.theme = opts.lualine_theme
  end
end

-- set(themes.lunar)
-- set(themes.onedarker)
-- set(themes.gruvbox)
-- set(themes.gruvbox_material)
-- set(themes.gruvbox_baby, {
--   global = {
--     use_original_palette = true,
--   },
--   lualine_theme = 'gruvbox-baby'
-- })
-- set(themes.tokyonight_day)
set(themes.tokyonight_moon)

-- set(themes.edge, {
--   lualine_theme = "edge",
--   global = {
--     airline_theme = "edge",
--     edge_style = "aura", -- or 'neon'
--   },
-- })

-- set(themes.sonokai, {
--   global = {
--     sonokai_style = "default", -- or 'espresso' or 'shusia'
--   }
-- })

-- set(themes.ayu, {
--   global = {
--     ayucolor = "mirage" -- or 'light' or 'dark'
--   }
-- })
