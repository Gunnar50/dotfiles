vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', 'mm', '<cmd>colorscheme darcula-solid-custom<CR>', { desc = 'Apply custom colorscheme' })
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- [[ Common Basic Keymaps ]] --
vim.keymap.set('v', 'p', 'P') -- in visual mode dont hold paste in clipboard
vim.keymap.set('n', 'x', '"_x') -- Send x command to void intead of clipboard
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('v', '<C-r>', '"hy:%s/h//gc<Left><Left><Left>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<C-D-S-n>', '<cmd>cnext<CR>', { desc = 'Alt+N - Next in quickfix list' })
vim.keymap.set('n', '<C-D-S-p>', '<cmd>cprev<CR>', { desc = 'Alt+P - Prev in quickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move lines or selections
vim.keymap.set('n', '<C-S-j>', ':m .+1<CR>==') -- move line up (normal mode)
vim.keymap.set('n', '<C-S-k>', ':m .-2<CR>==') -- move line down (normal mode)
vim.keymap.set('v', '<C-S-j>', ":m '>+1<CR>gv=gv") -- move line up (visual mode)
vim.keymap.set('v', '<C-S-k>', ":m '<-2<cr>gv=gv") -- move line down (visual mode)

vim.keymap.set('n', '<C-b>', '<cmd>Neotree toggle<CR>') -- toggle tree file
vim.keymap.set('n', '<leader>x', '<cmd>source %<CR>', { desc = 'Source current file' })
vim.keymap.set('n', '<leader>c', '<cmd>.lua<CR>', { desc = 'Source current line' })

-- Invert curlys
vim.keymap.set('n', '{', '}')
vim.keymap.set('n', '}', '{')

-- Move faster across file
vim.keymap.set('n', '(', '10j')
vim.keymap.set('n', ')', '10k')
vim.keymap.set('v', '(', '10j')
vim.keymap.set('v', ')', '10k')
vim.keymap.set('n', '<Up>', '5k')
vim.keymap.set('n', '<Down>', '5j')
vim.keymap.set('v', '<Up>', '5k')
vim.keymap.set('v', '<Down>', '5j')

vim.keymap.set('n', '<leader>o', '<cmd>Lazy<CR>', { desc = 'Open Lazy window' })

-- Make it so everytime a space is typed is saves to the undo tree
vim.keymap.set('i', '<space>', '<C-g>u<space>')

---- [[ Remap command ]] ----
vim.keymap.set({ 'n', 'i' }, '<M-s>', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<D-a>', 'ggVG', { desc = 'Select all' })
vim.keymap.set('n', '<D-w>', 'ZZ', { desc = 'Save and Quit current buffer' })

-- Copy to system clipboard
vim.keymap.set('v', '<D-c>', '"+y')
vim.keymap.set('n', '<D-c>', 'V"+y')
vim.keymap.set('n', '<D-v>', '"+p')

vim.keymap.set('n', '<C-D-S-h>', '<C-w>5>', { desc = 'Ctrl+CMD+Shift+H Move window size left' })
vim.keymap.set('n', '<C-D-S-l>', '<C-w>5<', { desc = 'Ctrl+CMD+Shift+L Move window size left' })
vim.keymap.set('n', '<C-D-S-j>', '<C-w>+', { desc = 'Ctrl+CMD+Shift+J Move window size left' })
vim.keymap.set('n', '<C-D-S-k>', '<C-w>-', { desc = 'Ctrl+CMD+Shift+K Move window size left' })

-- Buffer tabs
vim.keymap.set('n', '<S-l>', '<cmd>bn<CR>', { desc = 'Switch to left tab' })
vim.keymap.set('n', '<S-h>', '<cmd>bp<CR>', { desc = 'Switch to right tab' })
vim.keymap.set('n', '<S-q>', '<cmd>bd<CR>', { desc = 'Close tab' })
