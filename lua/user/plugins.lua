lvim.plugins = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestions = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },

  {
    'jose-elias-alvarez/typescript.nvim',
  },

  { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },
  { "luisiacc/gruvbox-baby" },

  { "sainnhe/sonokai" },
  { "sainnhe/edge" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        -- dir = vim.fn.expand(vim.fn.stdpath "state" .. "/sessions/"),
        -- options = { "buffers", "curdir", "tabpages", "winsize" }
      })
    end
  },

  { "christoomey/vim-tmux-navigator" },
  -- { "tpope/vim-surround" },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  { "felipec/vim-sanegx",            event = "BufRead" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  { "lunarvim/horizon.nvim" },
  { "tomasr/molokai" },
  { "ayu-theme/ayu-vim" },
  { "tpope/vim-repeat" },

  -- TODO: Learn what this plugin does
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },

  { "ThePrimeagen/harpoon" },

  -- {
  --   'phaazon/hop.nvim',
  --   branch = 'v2',
  --   config = function()
  --     -- see :h hop-config
  --     require('hop').setup()
  --   end
  -- },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function()
      require('user.flash')
    end
  },

  {
    "nvim-lua/lsp-status.nvim"
  },

  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua' },
    config = function()
      require('user.telescope').config()
    end
  },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require("rose-pine").setup({
        dark_variant = 'moon',
        disable_italics = true,
      })
      if vim.g.colors_name == 'rose-pine' then
        vim.cmd('colorscheme rose-pine')
      end
    end
  },

  -- {
  --   'AckslD/nvim-trevJ.lua',
  --   config = 'require("trevj").setup()',
  --   init = function()
  --     vim.keymap.set('n', '<leader>j', function()
  --       require('trevj').format_at_cursor()
  --     end)
  --   end,
  -- },

  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<leader>j', ':TSJToggle<cr>')
    end,
  },

  'lunarvim/lunar.nvim',

  -- { "tzachar/cmp-tabnine", event = "InsertEnter", build = "./install.sh", },
  {
    'LukasPietzschmann/telescope-tabs',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require 'telescope-tabs'.setup {}
    end
  },

  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require('user.inlay-hints')
    end
  },

  {
    "nvim-treesitter/playground",
    event = "BufRead",
  },

  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end
  },

  -- {
  --   'rmagatti/goto-preview',
  --   config = function()
  --     require('goto-preview').setup({})
  --   end
  -- },

  { 'kevinhwang91/nvim-bqf' },

  { 'nathom/filetype.nvim' },

  {
    -- upstream
    'MunifTanjim/nui.nvim',

    -- -- local
    -- dir = vim.env.HOME .. '/projects/personal/nui.nvim'

    -- -- downstream
    -- 'darksinge/nui.nvim',
    -- branch = 'develop',
  },

  {
    dir = vim.env.HOME .. '/projects/personal/nui-popup'
  },

  { 'darksinge/neodash.nvim' },

  -- {
  --   dir = vim.env.HOME .. '/projects/personal/plink.nvim',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'darksinge/neodash.nvim',
  --   }
  -- },

  {
    'darksinge/plink.nvim',
    commit = 'f8148f9',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'darksinge/neodash.nvim',
      'MunifTanjim/nui.nvim',
    },
  },

  -- {
  --   -- 'darksinge/noice.nvim',
  --   'folke/noice.nvim',
  --   -- dir = vim.env.HOME .. '/projects/git/noice.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     -- 'darksinge/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   config = function()
  --     require('noice').setup({
  --       messages = {
  --         enabled = false, -- enables the Noice messages UI
  --         -- view = "notify",           -- default view for messages
  --         -- view = 'mini',
  --         view = 'cmdline',
  --         -- view_error = "mini",       -- view for errors
  --         -- view_warn = "mini",        -- view for warnings
  --         -- view_history = "messages", -- view for :messages
  --         -- view_search = false,       -- view for search count messages. Set to `false` to disable
  --       },
  --       views = {
  --         cmdline_popup = {
  --           position = {
  --             row = 25,
  --             col = "50%",
  --           },
  --           size = {
  --             width = 60,
  --             height = "auto",
  --           },
  --         },
  --         popupmenu = {
  --           relative = "editor",
  --           position = {
  --             row = 28,
  --             col = "50%",
  --           },
  --           size = {
  --             width = 60,
  --             height = 10,
  --           },
  --           border = {
  --             style = "rounded",
  --             padding = { 0, 1 },
  --           },
  --           win_options = {
  --             winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
  --           },
  --         },
  --       },
  --     })

  --     require('telescope').load_extension('noice')
  --   end,
  -- },

  -- {
  --   'folke/neodev.nvim',
  --   opts = {
  --     library = {
  --       enabled = true,
  --       plugins = { 'nui' },
  --     },
  --   },
  -- },

  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
      require('nvim-treesitter.configs').setup({
        autotag = {
          enable = true,
        }
      })
    end
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      'marilari88/neotest-vitest',
    },
    config = function()
      require('user.neotest')
    end
  },
}

lvim.builtin.lualine.on_config_done = function(lualine)
  local noice_ok, noice = pcall(require, "noice")
  if noice_ok then
    local config = lualine.get_config()
    table.insert(config.sections.lualine_c, {
      noice.api.statusline.mode.get,
      cond = noice.api.statusline.mode.has,
      color = { fg = "#ff9e64" },
    })
    lualine.setup(config)
  end
end

lvim.lazy.opts.dev = {
  path = '~/projects/personal',
  fallback = false,
}

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    local ok, cmp = pcall(require, "copilot_cmp")
    if ok then cmp.setup({}) end
  end,
})

table.insert(lvim.plugins, 1, {
  'folke/neoconf.nvim',
  -- priority = 9999,
  -- init = function()
  --   require('neoconf').setup()
  -- end
})

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
end
