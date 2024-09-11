local builtin = require('telescope.builtin')

vim.keymap.set('n', 'NT', ':NERDTree<CR>', { desc = 'Open side panel (NERDTree)' })
vim.keymap.set('n', 'FN', builtin.find_files, { desc = 'Find filenames' })
vim.keymap.set('n', 'FT', builtin.live_grep, { desc = 'Find in files via grep' })


vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- navigating windows <C-hjkl>
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- moving lines up and down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==',{ desc = 'Move line down' }) -- normal mode
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==',{ desc = 'Move line up' }) -- normal mode
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi',{}) -- insert mode line down
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi',{}) -- insert mode line up
vim.keymap.set('x', '<A-j>', ":m '>+1<CR>gv=gv",{}) -- moving lines up down in visual mode
vim.keymap.set('x', '<A-k>', ":m '<-2<CR>gv=gv",{}) -- moving lines up up in visual mode

-- Telescope search Keys:
-- <C-n> Next
-- <C-p> Previous
-- <C-x> Open selection in split
-- <C-v> Open selection in vsplit
-- <C-t> Open selection in new tab
-- <C-c> Close telescope window
-- Preview Tab
-- <C-k> scroll right
-- <C-f> scroll left
-- <C-u> scroll up
-- <C-d> scroll down

-- TABS
-- xgt goes to tab where x is the index (starts from 1)

-- OTHER
-- gc toggle inline commenting
-- gb toggle block commenting
-- gcO create commented line above
-- gco create commented line below
-- gcA create comment end of line


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
