local harpoon = require('harpoon')

local M = {}

harpoon.setup({})

-- basic telescope configuration
local conf = require("telescope.config").values

local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

M.harpoon = harpoon

M.wk_mappings = {
  name = ' ' .. lvim.icons.ui.BookMark .. " Harpoon",
  t = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, lvim.icons.ui.List .. " List" },
  T = { function() toggle_telescope(harpoon:list()) end, lvim.icons.ui.Telescope .. " Telescope List" },
  m = { function() harpoon:list():add() end, lvim.icons.ui.BookMark .. " Mark buffer" },
  a = { function() harpoon:list():select(1) end, lvim.icons.ui.BoxChecked .. " Select 1" },
  s = { function() harpoon:list():select(2) end, lvim.icons.ui.BoxChecked .. " Select 2" },
  d = { function() harpoon:list():select(3) end, lvim.icons.ui.BoxChecked .. " Select 3" },
  f = { function() harpoon:list():select(4) end, lvim.icons.ui.BoxChecked .. " Select 4" },
  g = { function() harpoon:list():select(5) end, lvim.icons.ui.BoxChecked .. " Select 5" },
  q = { function() harpoon:list():select(6) end, lvim.icons.ui.BoxChecked .. " Select 6" },
  w = { function() harpoon:list():select(7) end, lvim.icons.ui.BoxChecked .. " Select 7" },
  e = { function() harpoon:list():select(8) end, lvim.icons.ui.BoxChecked .. " Select 8" },
  r = { function() harpoon:list():select(9) end, lvim.icons.ui.BoxChecked .. " Select 9" },
  n = { function() harpoon:list():next() end, lvim.icons.ui.BoldArrowRight .. " Next file" },
  p = { function() harpoon:list():prev() end, lvim.icons.ui.BoldArrowLeft .. " Prev file" },
}

return M
