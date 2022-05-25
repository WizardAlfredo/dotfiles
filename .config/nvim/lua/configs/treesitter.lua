local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
    return
end

local options = {
    ensure_installed = require('global_configs').parsers,
    matchup = {
        enable = false,
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
            -- Languages that have a single comment style
            typescript = "// %s",
            css = "/* %s */",
            scss = "/* %s */",
            html = "<!-- %s -->",
            svelte = "<!-- %s -->",
            vue = "<!-- %s -->",
            json = "",
        },
    },
    indent = { enable = true, disable = { "yaml", "python" } },
    autotag = { enable = false },
    textobjects = {
        swap = {
            enable = false,
            -- swap_next = textobj_swap_keymaps,
        },
        -- move = textobj_move_keymaps,
        select = {
            enable = false,
            -- keymaps = textobj_sel_keymaps,
        },
    },
    textsubjects = {
        enable = false,
        keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    rainbow = {
        enable = false,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
}


treesitter.setup(options)
