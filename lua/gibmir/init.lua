require('gibmir/base/search')
require('gibmir/base/editor')
require('gibmir/base/tabs')
require('gibmir/config/lazy')

-- nvim-tree open
vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

-- theme setup
vim.o.background = "dark" -- or "light" for light mode
vim.cmd.colorscheme "catppuccin-macchiato"
