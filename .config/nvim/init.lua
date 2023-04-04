vim.opt.expandtab = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.cmd [[
  noremap <silent> <C-S> :update<CR>:w<CR>
  vnoremap <silent> <C-S> <C-C>:update<CR><C-C>:w<CR>
  inoremap <silent> <C-S> <C-O>:update<CR><C-O>:w<CR>
]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]]

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use {
    'sainnhe/gruvbox-material',
    config = function()
      pcall(vim.cmd, "colorscheme gruvbox-material")
    end,
  }

  use { "catppuccin/nvim", as = "catppuccin" }

  -- Pandoc
  use {
    'vim-pandoc/vim-pandoc',
    config = function()
      vim.cmd [[
        let g:pandoc#syntax#conceal#use = 0
        let g:pandoc#syntax#codeblocks#embeds#langs = ['python', 'julia', 'yaml', 'mermaid', 'tex', 'bash', 'javascript', 'typescript']
      ]]
    end
  }
  use 'vim-pandoc/vim-pandoc-syntax'

  use 'mracos/mermaid.vim'

  use 'posva/vim-vue'

  use 'lervag/vimtex'

  use {
    'urbainvaes/vim-ripple',
    requires = {
      { 'machakann/vim-highlightedyank' }
    }
  }

  -- Julia
  use {
    'JuliaEditorSupport/julia-vim',
    config = function()
      vim.cmd [[ let g:latex_to_unicode_file_types = ".*" ]]
    end
  }

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    config = function ()
      local lsp = require('lsp-zero')
      lsp.preset('recommended')
      lsp.nvim_workspace()
      lsp.setup()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  use {
    'nvim-telescope/telescope.nvim',
    config = function ()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<localleader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<localleader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<localleader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<localleader>fh', builtin.help_tags, {})
    end,
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'tpope/vim-fugitive',
    config = function ()
      vim.keymap.set('n', '<localleader>g', ':Git<CR>', {})
    end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
