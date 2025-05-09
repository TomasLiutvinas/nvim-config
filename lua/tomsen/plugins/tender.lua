return {
  "jacoborus/tender.vim",
  config = function()
    vim.cmd("colorscheme tender")

    -- I wonder whats diff from these
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")

    -- Make sure line numbers are enabled and cursor line highlighting is on
    vim.o.number = true
    vim.o.cursorline = true
    vim.o.cursorlineopt = "number"

    -- Set different color for current line number
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6370" })
    -- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffcc66", bold = true }) -- kind of like this too
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ff0f0f", bold = true })
  end,
}
