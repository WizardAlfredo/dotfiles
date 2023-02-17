-- Basically a file to keep some global settigns I change often.

local M = {}

M.parsers = {
    "bash",
    "c",
    "cpp",
    "javascript",
    "json",
    "lua",
    "python",
    "css",
    "dockerfile",
    "markdown",
    "solidity"
}

M.language_servers = {
    "clangd",
    "pyright",
    "bashls",
    "sumneko_lua",
    "solidity_ls"
}


M.active_plugins = {
    "treesitter",
    "autopairs",
    "better-escape",
    "bufferline",
    "cmp",
    "comments",
    "gitsigns",
    "indent_blankline",
    "nvimtree",
    "project",
    "telescope",
    "toggleterm",
    "whichkey",
    "colorizer"
}

M.colorscheme = "htb"
return M
