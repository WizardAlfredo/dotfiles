local present, indent_blankline = pcall(require, "indent_blankline")

if not present then
    return
end

indent_blankline.setup {
    show_first_indent_level = false,
    filetype_exclude = { "lspinfo", "packer", "checkhealth", "help", "man", "dashboard", "terminal" },
}
