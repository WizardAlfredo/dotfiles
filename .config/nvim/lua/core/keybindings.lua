local options = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Here you I have the mappings that I use all the time

-- better tabbing
keymap('v', '>', '>gv', options)
keymap('v', '<', '<gv', options)

-- Buffer switch with tab
keymap('n', '<TAB>', ':bnext<CR>', options)
keymap('n', '<S-TAB>', ':bprevious<CR>', options)
-- error nui
-- keymap('n', '<C-c>', '<cmd>lua require("custom.functions").close_buf()<cr>', options)

keymap('n', '<leader>e', ":NvimTreeToggle<CR>", options)

-- Move selected line / block of text in visual mode
keymap('x', 'K', ':move \'<-2<CR>gv-gv', options)
keymap('x', 'J', ':move \'>+1<CR>gv-gv', options)
keymap("v", "p", '"_dP', options)

-- Move current line in normal and insert mode
keymap('n', '<A-Down>', 'v$:move \'>+1<CR>gv-gv<ESC>', options)
keymap('n', '<A-Up>', 'v$:move \'>-2<CR>gv-gv<ESC>', options)
keymap('i', '<A-Up>', '<ESC>v$:move \'>-2<CR>gv-gv<ESC>i', options)
keymap('i', '<A-Down>', '<ESC>v$:move \'>+1<CR>gv-gv<ESC>i', options)
keymap("v", "<A-Down>", ":m .+1<CR>==", options)
keymap("v", "<A-Up>", ":m .-2<CR>==", options)
keymap("x", "<A-Down>", ":move '>+1<CR>gv-gv", options)
keymap("x", "<A-Up>", ":move '<-2<CR>gv-gv", options)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", options)
keymap("n", "<C-j>", "<C-w>j", options)
keymap("n", "<C-k>", "<C-w>k", options)
keymap("n", "<C-l>", "<C-w>l", options)

keymap("n", "<C-Down>", ":resize +2<CR>", options)
keymap("n", "<C-Up>", ":resize -2<CR>", options)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", options)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", options)

keymap("n", "<C-n>", ":enew<CR>", options)

keymap("n", "<leader>f",
    "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>"
    , options)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", options)
keymap("n", "C-f", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", options)

-- Comments
keymap("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)<cr>", options)
keymap("n", "<leader>/", "<Plug>(comment_toggle_linewise_visual)<cr>", options)
