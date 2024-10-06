return {
  "preservim/nerdtree", -- file browser with NT
  config = function()
    vim.keymap.set('n', 'NT', ':NERDTree<CR>', { desc = 'Open side panel (NERDTree)' })
  end
}
