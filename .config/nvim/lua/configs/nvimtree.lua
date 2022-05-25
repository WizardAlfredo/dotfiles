local present, nvimtree = pcall(require, "nvim-tree")

if not present then
    return
end

-- globals must be set prior to requiring nvim-tree to function
local g = vim.g
local tree_cb = require('nvim-tree.config').nvim_tree_callback
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_root_folder_modifier = ":t"

g.nvim_tree_show_icons = {
    folders = 1,
    files = 1,
    git = 1,
    folder_arrows = 1,
}

g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        deleted = "",
        ignored = "◌",
        renamed = "➜",
        staged = "✓",
        unmerged = "",
        unstaged = "✗",
        untracked = "★",
    },
    folder = {
        default = "",
        empty = "",
        empty_open = "",
        open = "",
        symlink = "",
        symlink_open = "",
        arrow_open = "",
        arrow_closed = "",
    },
}

local options = {
    filters = {
        dotfiles = false,
        custom = { "node_modules", "__pycache__", ".git", "custom" },
        exclude = {},
    },
    disable_netrw = true,
    hijack_netrw = true,
    ignore_ft_on_setup = { "dashboard" },
    open_on_tab = false,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    --root_folder_modifier = ":t",
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    diagnostics = {
        enable = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    view = {
        side = "left",
        width = 25,
        hide_root_folder = false,
        mappings = {
            custom_only = false,
            list = {
                { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
                { key = "h", cb = tree_cb "close_node" },
                { key = "v", cb = tree_cb "vsplit" },
            },
        },
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    git = {
        enable = false,
        ignore = true,
    },
    actions = {
        open_file = {
            quit_on_open = false,
            resize_window = true,
        },
    },
    renderer = {
        indent_markers = {
            enable = false,
        },
    },
}


nvimtree.setup(options)
