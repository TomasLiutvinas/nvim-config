vim.opt.tabstop = 4 -- number of spaces tab represents
vim.opt.softtabstop = 4 -- controls the number of spaces TAB counts when editing
vim.opt.shiftwidth = 4 -- auto indentation with << >> ==
vim.opt.expandtab = true  -- converts tabs into spaces

vim.g.mapleader= " " -- leader key for keybinds
vim.wo.number = true -- enables line numbers
vim.opt.wrap = false -- disables line wraping
vim.opt.backup = false -- disables creating backup files
vim.opt.encoding = "utf-8" -- sets default encoding
vim.opt.fileencoding = "utf-8" -- sets encoding for created and edited files

vim.opt.signcolumn = "yes" -- enables column on the left side to show git/error/warning indicators

vim.opt.relativenumber = true -- sets relative line numbers

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- if upper case letters used in search it becomes case-sensitive

vim.opt.updatetime = 250 -- timing for hotkeys
vim.opt.timeoutlen = 300 -- timeout for hotkeyus

vim.opt.list = true -- display whitespace chars
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- setting chars/symbols for whitespace chars

vim.opt.inccommand = 'split' -- should show something related to replacing in real time in a split window

vim.opt.scrolloff = 10 -- distance for edging of the screen for the cursor

vim.opt.hlsearch = true -- highlights searching

vim.opt.mouse = 'a' -- enables mouse for all modes, not quite sure why I want this
vim.g.OmniSharp_server_use_net6 = 1 -- specific to omnisharp: congfigures omnisharp to use net6, not sure why I want this
