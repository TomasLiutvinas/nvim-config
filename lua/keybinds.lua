vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- navigating windows <C-hjkl>
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle undotree' })

-- moving lines up and down
-- vim.keymap.set('n', '<A-j>', ':m .+1<CR>==',{ desc = 'Move line down' }) -- normal mode
-- vim.keymap.set('n', '<A-k>', ':m .-2<CR>==',{ desc = 'Move line up' }) -- normal mode
-- -- need to use this instead of == >>>>> vim.lsp.buf.format
vim.keymap.set('n', '<A-j>', function()
  vim.cmd('m .+1')                     -- move line down
  vim.lsp.buf.format({ async = true }) -- format after move
end, { desc = 'Move line down with LSP format' })

vim.keymap.set('n', '<A-k>', function()
  vim.cmd('m .-2')                     -- move line up
  vim.lsp.buf.format({ async = true }) -- format after move
end, { desc = 'Move line up with LSP format' })

vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' }) -- insert mode line down
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })   -- insert mode line up
vim.keymap.set('x', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' }) -- moving lines up down in visual mode
vim.keymap.set('x', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })   -- moving lines up up in visual mode

vim.keymap.set('n', '=', '+', { desc = 'Move down screen line' })
vim.keymap.set('n', '+', '$', { desc = 'Move to end of line' })

-- Format JSON
vim.keymap.set("n", "<leader>jq", ":%!jq .<CR>", { desc = "Format JSON with jq" })

-- better indents
vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })

-- some more rarely used
vim.keymap.set("n", "J", "mzgJ`z", { desc = "Join lines keep cursor" }) -- joins line with space added, and returns cursor to the position
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" }) -- scroll down half a page and do zz
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })   -- scroll up half a page and do zz
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })   -- normal n, center screen and open folds
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result and center" })   -- normal N, center screen and open folds

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "Q", "<Nop>", { desc = "Disable Ex mode" }) -- disables Q
vim.keymap.set("v", "K", "<Nop>", { desc = "Disable K in visual mode" })

vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" }) -- format all

-- for Go err handling
vim.keymap.set(
  "n",
  "<leader>ee",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>",
  { desc = "Insert Go error check" }
)

-- loads current file into nvim config
vim.keymap.set("n", "<leader>x", function()
  vim.cmd("so")
end, { desc = "Source current file" })

-- buffer
-- vim.keymap.set("n", "<M-h>", "<cmd>bprev<CR>")
-- vim.keymap.set("n", "<M-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#<cr>", { desc = "Close all buffers but current" })

-- avoid vim register for some operations
vim.keymap.set("n", "x", [["_x]], { desc = "Delete char without yanking" })               -- deleting without copying text into default buffer
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking selection" })         -- pasting without copying into default buffer
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })           -- copy current line to system clipboard
vim.keymap.set("n", "<leader>vp", "`[v`]", { desc = "Reselect last paste" })             -- reselect pasted text
vim.keymap.set("n", "<leader>y", [["+y]], { desc = "Yank to clipboard" })                -- copy to system clipboard
vim.keymap.set("n", "<leader>p", [["+p]], { desc = "Paste from clipboard" })             -- paste from system clipboard
vim.keymap.set("x", "<leader>y", [["+y]], { desc = "Yank selection to clipboard" })      -- copy to system clipboard
vim.keymap.set("x", "<leader>p", [["+p]], { desc = "Paste from clipboard" })             -- paste from system clipboard

-- Quickfix open/close prev/next
vim.keymap.set('n', '<leader>q', ':copen<CR>', { desc = 'Quickfix: Open list' })
vim.keymap.set('n', '<leader>c', ':cclose<CR>', { desc = 'Quickfix: Close list' })
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Quickfix: Next item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Quickfix: Prev item' })

-- search and replace
vim.keymap.set("n", "<leader>rn", ":%s/<C-r><C-w><C-r><C-w>//gI<Left><Left><Left>", { desc = "Rename word (substitute)" })

-- TABS
-- xgt goes to tab where x is the index (starts from 1)

vim.api.nvim_create_user_command("W", "w", {})

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

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = e.buf, desc = "Go to Definition" })
    -- K is owned by nvim-dap plugin config (DAP hover / LSP hover fallback)
    -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts, { desc = "Show Hover Information" })

    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { buffer = e.buf, desc = "Search Workspace Symbols" })
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { buffer = e.buf, desc = "Show Diagnostics (float)" })
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = e.buf, desc = "Show Code Actions" })
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { buffer = e.buf, desc = "Show References" })
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { buffer = e.buf, desc = "Rename Symbol" })
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = e.buf, desc = "Show Signature Help" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { buffer = e.buf, desc = "Next Diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { buffer = e.buf, desc = "Prev Diagnostic" })

    -- keep <leader>q for quickfix; use loclist on <leader>l
    vim.keymap.set('n', '<leader>l', function() vim.diagnostic.setloclist() end,
      { buffer = e.buf, desc = 'Diagnostics to location list' })
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

-- Use <leader>cn in normal mode to start new clip
vim.keymap.set("v", "<leader>cn", function()
  ClearClipboard()
  AppendVisualSelection()
end, { desc = "Create new clipboard" })

-- Resize windows with Ctrl + Arrow keys:
vim.keymap.set('n', '<C-Left>', '<C-w><', { desc = 'Resize window left' })
vim.keymap.set('n', '<C-Right>', '<C-w>>', { desc = 'Resize window right' })
vim.keymap.set('n', '<C-Up>', '<C-w>+', { desc = 'Resize window up' })
vim.keymap.set('n', '<C-Down>', '<C-w>-', { desc = 'Resize window down' })
