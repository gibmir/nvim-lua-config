return {
    "nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
    build = ":TSUpdate",
    dependencies = {
        {"nvim-treesitter/nvim-treesitter-textobjects"}, -- Syntax aware text-objects
        {
            "nvim-treesitter/nvim-treesitter-context", -- Show code context
            opts = {enable = true, mode = "topline", line_numbers = true}
        }
    },
		config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            ensure_installed = {
                "dockerfile", "gitignore", "go", "gomod", "gosum",
                "gowork", "json", "lua", "proto",
                "python", "sql", "yaml", 
            },
            indent = {enable = true},
            auto_install = true,
            sync_install = false,
            highlight = {enable = true},
            textobjects = {select = {enable = true, lookahead = true}}
        })
		end

}
