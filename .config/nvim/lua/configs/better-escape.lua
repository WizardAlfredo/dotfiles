local present, better_escape = pcall(require, "better_escape")

if not present then
    return
end

require("better_escape").setup({
    mapping = { "jk", "jj", "kj","kk" },
    timeout = vim.o.timeoutlen,
    clear_empty_lines = false,
    keys = "<Esc>"
})
