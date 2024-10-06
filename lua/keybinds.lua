vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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

vim.api.nvim_create_user_command('W', 'w', { desc = "I am stupid." })
vim.api.nvim_create_user_command('Q', 'q', { desc = "I am stupid." })

-- telescope
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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts, { desc = "Go to Definition" })
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts, { desc = "Show Hover Information" })
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts, { desc = "Search Workspace Symbols" })
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts, { desc = "Show Diagnostics in Floating Window" })
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts, { desc = "Show Code Actions" })
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts, { desc = "Show References to Symbol" })
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts, { desc = "Rename Symbol" })
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts, { desc = "Show Signature Help" })
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts, { desc = "Go to Next Diagnostic" })
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts, { desc = "Go to Previous Diagnostic" })
    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.setloclist() end, { desc = 'Open diagnostic [Q]uickfix list' })
  end
})
