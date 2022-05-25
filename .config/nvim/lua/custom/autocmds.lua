local autocmd = vim.api.nvim_create_autocmd

-- Don't autocommend
autocmd("FileType", {
    pattern = "*",
    command = "set formatoptions-=cro"
})

-- Format on save
autocmd("BufWritePre", {
    pattern = "*",
    command = "lua vim.lsp.buf.formatting()"
})
