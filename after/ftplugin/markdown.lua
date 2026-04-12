-- Navigate by visual (screen) lines instead of real lines.
-- Makes j/k behave naturally on long wrapped lines in markdown.
vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.showbreak = "↪ "
