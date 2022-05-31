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
    "typescript",
    "css",
    "dockerfile",
    "markdown"
}

M.language_servers = {
    "clangd",
    "pyright",
    "bashls",
    "sumneko_lua"
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
