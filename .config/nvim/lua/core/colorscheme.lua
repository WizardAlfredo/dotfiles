local colorscheme = require('global_configs').colorscheme

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.cmd [[colorscheme default]]
    return
end
