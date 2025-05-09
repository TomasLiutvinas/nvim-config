vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- navigating windows <C-hjkl>
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle undotree'})

-- moving lines up and down
-- vim.keymap.set('n', '<A-j>', ':m .+1<CR>==',{ desc = 'Move line down' }) -- normal mode
-- vim.keymap.set('n', '<A-k>', ':m .-2<CR>==',{ desc = 'Move line up' }) -- normal mode
-- -- need to use this instead of == >>>>> vim.lsp.buf.format
vim.keymap.set('n', '<A-j>', function()
  vim.cmd('m .+1')                 -- move line down
  vim.lsp.buf.format({ async = true })  -- format after move
end, { desc = 'Move line down with LSP format' })

vim.keymap.set('n', '<A-k>', function()
  vim.cmd('m .-2')                 -- move line up
  vim.lsp.buf.format({ async = true })  -- format after move
end, { desc = 'Move line up with LSP format' })

vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi',{}) -- insert mode line down
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi',{}) -- insert mode line up
vim.keymap.set('x', '<A-j>', ":m '>+1<CR>gv=gv",{}) -- moving lines up down in visual mode
vim.keymap.set('x', '<A-k>', ":m '<-2<CR>gv=gv",{}) -- moving lines up up in visual mode

vim.keymap.set('n', '=', '+', { desc = 'Move down screen line' })
vim.keymap.set('n', '+', '$', { desc = 'Move down screen line' })

-- Format JSON
vim.keymap.set("n", "<leader>jq", ":%!jq .<CR>", { desc = "Format JSON with jq" })

-- better indents
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

-- some more rarely used
vim.keymap.set("n", "J", "mzJ`z") -- joins line with space added, and returns cursor to the position
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- scroll down half a page and do zz
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- scroll up half a page and do zz
vim.keymap.set("n", "n", "nzzzv") -- not entirely sure, but normal n, center screen and enters visual mode?
vim.keymap.set("n", "N", "Nzzzv") -- not entirely sure, but normal N, center screen and enters visual mode?

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<Nop>") -- disables Q
vim.keymap.set("v", "K", "<Nop>", { desc = "Disable K in visual mode" })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) -- format all

-- for Go err handling
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- loads current file into nvim config
vim.keymap.set("n", "<leader>x", function()
    vim.cmd("so")
end)

-- buffer
vim.keymap.set("n", "<M-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<M-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#<cr>")

-- avoid vim register for some operations
vim.keymap.set("n", "x", [["_x]]) -- deleting without copying text into default buffer
vim.keymap.set("x", "p", [["_dP]]) -- pasting without copying into default buffer
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- copy current line to system clipboard
vim.keymap.set("n", "<leader>vp", "`[v`]") -- reselect pasted text
vim.keymap.set("n", "<leader>y", [["+y]]) -- copy to system clipboard
vim.keymap.set("n", "<leader>p", [["+p]]) -- paste from system clipboard
vim.keymap.set("x", "<leader>y", [["+y]]) -- copy to system clipboard
vim.keymap.set("x", "<leader>p", [["+p]]) -- paste from system clipboard

-- Quickfix open/close prev/next
vim.keymap.set('n', '<leader>q', ':copen<CR>', { desc = 'Quickfix: Open list' })
vim.keymap.set('n', '<leader>c', ':cclose<CR>', { desc = 'Quickfix: Close list' })
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Quickfix: Next item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Quickfix: Prev item' })

-- search and replace
vim.keymap.set("n", "<leader>rn", ":%s/<C-r><C-w><C-r><C-w>//gI<Left><Left><Left>")

-- TABS
-- xgt goes to tab where x is the index (starts from 1)

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


-- Prompting help

local append_register = "+" -- system clipboard

function AppendVisualSelection()
  -- Reselect visual range
  vim.cmd('normal! "vy') -- yank visually selected text into register v

  -- Get lines from register
  local selection = vim.fn.getreg("v")

  -- Wrap in ```
  local wrapped = "```\n" .. selection .. "\n```"

  -- Append to system clipboard
  local current = vim.fn.getreg(append_register)
  vim.fn.setreg(append_register, current .. wrapped .. "\n")

  print("Appended selection to clipboard.")
end

function ClearClipboard()
  vim.fn.setreg(append_register, "")
  print("Clipboard cleared.")
end

-- Use <leader>c in visual mode to append wrapped selection
vim.keymap.set("v", "<leader>c", function()
  AppendVisualSelection()
end, { desc = "Append selection to clipboard" })

-- Use <leader>cl in normal mode to clear clipboard
vim.keymap.set("n", "<leader>cl", function()
  ClearClipboard()
end, { desc = "Clear clipboard" })
