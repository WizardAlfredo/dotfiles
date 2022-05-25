local present, impatient = pcall(require, "impatient")

if present then
    impatient.enable_profile()
end
vim.api.nvim_set_keymap('n', ' ', '<NOP>', { noremap = true, silent = true })
vim.g.mapleader = ' '


require('core.settings')
require('core.plugins')
require('core.colorscheme')
require('core.keybindings')
require('custom.autocmds')
require('configs')
require('lsp')
