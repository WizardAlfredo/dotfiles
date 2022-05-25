local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
    return
end

project.setup({
    active = true,
    detection_methods = { "pattern", "lsp" },
    patterns = { ".git", "Makefile", "package.json", "go.mod", "Cargo.toml" },
})
