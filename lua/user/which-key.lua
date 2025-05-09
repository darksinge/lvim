local icons = lvim.icons
local wk = lvim.builtin.which_key
local _, telescope = pcall(require, "telescope.builtin")

-- I never use this, except when fat fingering
-- wk.mappings["a"] = { ":Alpha<cr>", icons.ui.Dashboard .. " Dashboard" }

wk.mappings['f'] = { "<cmd>Telescope find_files<cr>", "Find File" }
wk.mappings['s']['f'] = { function() telescope.git_files() end, "Find File" }

wk.mappings["v"] = {
  name = ' ' .. icons.diagnostics.Trace .. ' Vitest',
  t = { ':Vitest run<cr>', 'Run Tests' },
  f = { ':Vitest run %<cr>', 'Run Tests in current file' },
}

-- folke/persistence.nvim
wk.mappings["S"] = {
  name = "Session",
  S = { "<cmd>lua require('persistence').load()<cr>", icons.ui.History .. " Reload last session for dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", icons.ui.History .. " Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", icons.ui.SignOut .. " Quit without saving session" },
}

wk.mappings["l"]["F"] = { ":LvimToggleFormatOnSave<cr>", icons.ui.File .. " Toggle format on save" }
wk.mappings["l"]["t"] = { ":LvimToggleFormatOnSave<cr>", icons.ui.Code .. " Toggle FoS" }
wk.mappings["l"]["R"] = { ":LspRestart<cr>", icons.ui.History .. " Restart" }
wk.mappings["l"]["h"] = { ":lua require('lsp-inlayhints').toggle()<cr>", "Toggle Hints" }

wk.mappings["T"]["p"] = { ":TSPlaygroundToggle<cr>", "TS Playground" }

wk.mappings["s"]["w"] = {
  "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<cr>",
  ' ' .. icons.kind.Keyword .. " Search Word Under Cursor"
}

wk.mappings["s"]["c"] = {
  ":lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = true, search_dirs = { '~/.config/lvim' } }))<cr>",
  ' ' .. icons.kind.Keyword .. " Search Config Files"
}


wk.mappings["s"]["c"] = {
  ":lua require'user.telescope'.grep_config()<cr>",
  ' ' .. icons.ui.Gear .. " Search Config Files"
}

--   c = { "", 'LunarVim Config' },

---Harpoon v1 mappings
-- wk.mappings["m"] = {
--   name = ' ' .. icons.ui.BookMark .. " Harpoon",
--   m = { ":lua require('harpoon.mark').add_file()<cr>", "Mark file" },
--   t = { ":lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle UI" },
--   a = { ":lua require('harpoon.ui').nav_file(1)<cr>", "Goto mark 1" },
--   s = { ":lua require('harpoon.ui').nav_file(2)<cr>", "Goto mark 2" },
--   d = { ":lua require('harpoon.ui').nav_file(3)<cr>", "Goto mark 3" },
--   f = { ":lua require('harpoon.ui').nav_file(4)<cr>", "Goto mark 4" },
--   g = { ":lua require('harpoon.ui').nav_file(5)<cr>", "Goto mark 5" },
--   q = { ":lua require('harpoon.ui').nav_file(6)<cr>", "Goto mark 6" },
--   w = { ":lua require('harpoon.ui').nav_file(7)<cr>", "Goto mark 7" },
--   e = { ":lua require('harpoon.ui').nav_file(8)<cr>", "Goto mark 8" },
--   r = { ":lua require('harpoon.ui').nav_file(9)<cr>", "Goto mark 9" },
--   n = { ":lua require('harpoon.ui').nav_next()<cr>", "Next file" },
--   p = { ":lua require('harpoon.ui').nav_prev()<cr>", "Prev file" },
-- }

local harpoon_config_ok, harpoon_config = pcall(require, 'user.harpoon')
if harpoon_config_ok then
  local mappings = harpoon_config.wk_mappings

  wk.mappings["m"] = {}
  for key, value in pairs(mappings) do
    wk.mappings["m"][key] = value
  end
end

wk.mappings["W"] = {
  name = ' ' .. icons.ui.Circle .. " Window Ctrl",
  h = { '<C-w>|', 'Maximize window horizontally (|)' },
  v = { '<C-w>_', 'Maximize window vertically (_)' },
  ['='] = { '<C-w>=', 'Resize windows equally' },
  s = { ":lua require('telescope-tabs').list_tabs()<cr>", 'Search Tabs' },
}

-- wk.mappings["G"] = {
--   name = ' ' .. icons.git.Octoface .. " Github Copilot",
--   a = { ":lua require('copilot.suggestion').accept()<cr>", "Accept" },
--   n = { ":lua require('copilot.suggestion').next()<cr>", "Next" },
--   N = { ":lua require('copilot.suggestion').prev()<cr>", "Prev" },
--   d = { ":lua require('copilot.suggestion').dismiss()<cr>", "Dismiss" },
--   t = { ":lua require('copilot.suggestion').toggle_auto_trigger()<cr>", "Toggle Auto Trigger" },
-- }

wk.mappings['Q'] = { ":qa<cr>", "Quit all", }
wk.mappings['x'] = { ":xa<cr>", "Save All and Quit", }

wk.mappings["t"] = {
  name = ' ' .. icons.ui.Telescope .. 'Test',
  --   r = { ':Telescope resume<cr>', 'Resume' },
  --   b = { ':Telescope buffers<cr>', 'Buffers' },
  --   p = { ':Telescope projects<cr>', 'Projects' }, -- requires telescope-project.nvim plugin
  --   t = { ':Telescope telescope-tabs list_tabs<cr>', 'Tabs' }, -- requires telescope-tabs plugin
  --   c = { ":lua require'user.telescope'.grep_config()<cr>", 'LunarVim Config' },
}


wk.mappings['p']['P'] = wk.mappings['p']['p']
wk.mappings['p']['p'] = { ":e ~/.config/lvim/lua/user/plugins.lua<cr>", "Edit plugins.lua" }

wk.mappings['s']['/'] = wk.mappings['s']['t']

wk.mappings['b']['y'] = { ":let @+ = expand('%:t')<cr>", " Yank file name" }
wk.mappings['b']['Y'] = { ":let @+ = expand('%')<cr>", " Yank file path" }

wk.mappings['g']['m'] = { ':GitConflictListQf<cr>', icons.git.FileUnmerged .. ' List Merge Conflicts' }

-- wk.vmappings['a'] = {
--   name = ' ' .. icons.misc.Robot .. ' AI Assistance',
--   ['e'] = { ":Gen Enhance_Wording<CR>", "Enhance Wording" },
--   ['f'] = { ":Gen Fix_Code<CR>", "Fix Code" },
-- }

local avante_config_ok, avante_config = pcall(require, 'user.avante')
if avante_config_ok then
  local mappings = avante_config.wk_mappings

  local function assign_nested_mappings(src, dest)
    for key, value in pairs(src) do
      -- print('mappings: ' .. 'key=' .. vim.inspect(key) .. ', value=' .. vim.inspect(value))
      if (type(value) == 'string') then
        dest[key] = value
      elseif type(value) == "table" then
        if type(dest[key]) ~= "table" then
          dest[key] = {}
        end
        assign_nested_mappings(value, dest[key])
      else
        dest[key] = value
      end
    end
  end

  wk.mappings["a"] = {}
  assign_nested_mappings(mappings, wk.mappings["a"])
end
