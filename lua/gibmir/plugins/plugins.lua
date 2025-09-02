-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- packer config
return require('packer').startup(function(use)
  -- packer
  use 'wbthomason/packer.nvim'


	-- devicons
	use 'nvim-tree/nvim-web-devicons'

	-- telescope
	use {
  	'nvim-telescope/telescope.nvim', branch = '0.1.x',
  	requires = { {'nvim-lua/plenary.nvim'} }
  }

	-- airline
	use 'vim-airline/vim-airline'
	use 'vim-airline/vim-airline-themes'

	-- color theme
	use { 
    "catppuccin/nvim", as = "catppuccin",
		config = function()
			require("catppuccin").setup({
				color_overrides = {
					
				},
				integrations = {
				  cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
					native_lsp = {
						enabled = true,
					},
				},
			})
		end
	}

	-- treesitter
  use {
  	'nvim-treesitter/nvim-treesitter',
    config = function() 
			require('nvim-treesitter.configs').setup({
			  ensure_installed = {"lua", "vim", "go", "python", "proto"},
			  sync_install = false,
			  auto_install = true,
			  highlight = {
				  enable = true,
			  },
		  }) 
	  end,
  }
	-- file explorer
  use {
    'nvim-tree/nvim-tree.lua',
		--plugin setup function
		config = function()
	    local k =	require("gibmir/keys/nvim-tree")
			require("nvim-tree").setup({
				on_attach = k.on_attach,
				respect_buf_cwd = true,
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

	-- neotest
use({
  "nvim-neotest/neotest",
  requires = {
    "nvim-neotest/neotest-go",
    -- Your other test adapters here
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)
    require("neotest").setup({
      -- your neotest config here
      adapters = {
        require("neotest-go"),
      },
    })
  end,
})

-- coverage
use({
  "andythigpen/nvim-coverage",
  requires = "nvim-lua/plenary.nvim",
  -- Optional: needed for PHP when using the cobertura parser
  rocks = { 'lua-xmlreader' },
  config = function()
    require("coverage").setup()
  end,
})
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
		'mfussenegger/nvim-dap',
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
  			dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
  			dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
  			dapui.close()
			end
			dap.adapters.delve = {
				type = 'server',
				port = '${port}',
				executable = {
					command = 'dlv',
					args = {'dap','-l','127.0.0.1:${port}'}
				}
			}
			dap.configurations.go = {
				{
					type = "delve",
					name = "Debug",
					request = "launch",
					program = "${file}"
				},
				{
					type = "delve",
					name = "Debug test",
					request = "launch",
					mode = "test",
					program = "${file}"
				},
				{
					type = "delve",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}"
				}
			}
		end,
	}

	use 'leoluz/nvim-dap-go'
	-- nvim-dap-ui
	use {
		'rcarriga/nvim-dap-ui',
		requires = {'mfussenegger/nvim-dap','nvim-neotest/nvim-nio'},

		config = function()
			require("dapui").setup()
		end
	}


	-- neodev
	use {
		'folke/neodev.nvim',
		config = function()
			require("neodev").setup({
  			library = { plugins = { "nvim-dap-ui" }, types = true },
  		})
		end
	}

	-- git
	use {
  	'lewis6991/gitsigns.nvim',

  	config = function()

      require('gitsigns').setup {
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }
		end
	}

end)
