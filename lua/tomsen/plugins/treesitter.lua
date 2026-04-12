return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-treesitter").install({
      "bash", "c", "lua", "vim", "vimdoc", "query",
      "javascript", "typescript", "jsdoc", "tsx",
      "go", "html", "json", "markdown", "markdown_inline",
      "scss", "sql", "gdscript", "godot_resource", "gdshader",
    })

    -- Highlighting (built into nvim, nvim-treesitter just provides queries)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function() pcall(vim.treesitter.start) end,
    })
  end,
}
