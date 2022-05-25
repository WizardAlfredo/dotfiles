local present, null_ls = pcall(require, "null-ls")
if not present then
    return
end

local formatting = null_ls.builtins.formatting

local options = {
    debug = false,
    sources = {
        formatting.prettier.with({ extra_args = { "--no-semi" } }),
        formatting.yapf,
        formatting.clang_format
    },
}


null_ls.setup(options)
