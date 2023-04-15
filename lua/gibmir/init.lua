require('gibmir/base/search')
require('gibmir/base/editor')
require('gibmir/base/tabs')
require('gibmir/plugins/plugins')
require('gibmir/keys/main')

-- theme setup
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
