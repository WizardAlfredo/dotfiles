local present, nvimtree = pcall(require, "nvim-tree")

if not present then
    return
end

local tree_cb = require('nvim-tree.config').nvim_tree_callback

local options = {
    filters = {
        dotfiles = false,
        custom = { "node_modules", "__pycache__", ".git" },
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
    renderer = {
        indent_markers = {
            enable = false,
        },
        highlight_git = true,
        root_folder_modifier = ":t",
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
}


nvimtree.setup(options)

