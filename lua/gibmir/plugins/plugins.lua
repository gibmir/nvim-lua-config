-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- packer config
return require('packer').startup(function(use)
  -- packer
  use 'wbthomason/packer.nvim'

	-- treesitter
  use {
  	'nvim-treesitter/nvim-treesitter',
  	run = ':TSUpdate'
  }

	-- devicons
	use 'nvim-tree/nvim-web-devicons'

	-- telescope
	use {
  	'nvim-telescope/telescope.nvim', tag = '0.1.1',
  	requires = { {'nvim-lua/plenary.nvim'} }
  }

	-- airline
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'

	-- gruvbox theme
	use { "ellisonleao/gruvbox.nvim" }

	-- file explorer
  use {
    'nvim-tree/nvim-tree.lua',
		--plugin setup function
		config = function()
	    local k =	require("gibmir/keys/nvim-tree")
			require("nvim-tree").setup({
				on_attach = k.on_attach,
				--
			})
		end,
    requires = {
			-- hack nerd font
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }

  -- Autocomplete
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

	-- LSP
	use {
		'neovim/nvim-lspconfig',
		config = function()
			vim.api.nvim_create_autocmd('BufWritePre', {
  			pattern = '*.go',
 				callback = function()
    			vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  			end
			})
			local lspconfig = require'lspconfig'
			lspconfig.gopls.setup{}
			lspconfig.pyright.setup{
				capabilities = require'cmp_nvim_lsp'.default_capabilities()
			}
		end,
	}

	-- nvim-dap
	use {
		'mfussenegger/nvim-dap'
	}

	-- git
	use {
  	'lewis6991/gitsigns.nvim',
  	config = function()
    	require('gitsigns').setup()
  	end
	}

end)
