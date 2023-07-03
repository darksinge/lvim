lvim.reload_config_on_save = true

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
    "nvim-lua/lsp-status.nvim"
  },

  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'kkharji/sqlite.lua' },
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

  { 'MunifTanjim/nui.nvim' },

  {
    dir = vim.env.HOME .. '/projects/personal/plink.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'darksinge/neodash.nvim',
    }
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('noice').setup()
    end,
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}

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

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
end