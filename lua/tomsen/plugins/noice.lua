-- lua/tomsen/plugins/noice.lua
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    { "MunifTanjim/nui.nvim", module = "nui" },
    {
      "rcarriga/nvim-notify",
      module = "notify",
      config = function()
        local notify = require("notify")
        notify.setup({
          background_colour = "#000000",
          stages = "slide",
          timeout = 3000,
          top_down = false,
        })
        vim.notify = notify
        vim.keymap.set("n", "<leader>n", function()
          notify.dismiss({ silent = true, pending = true })
        end, { desc = "Clear notifications" })
      end,
    },
  },
  opts = {
    -- keep Noice away from LSP hover/signature (prevents Noice scrollbars + fullscreen hovers)
    lsp = {
      hover = { enabled = false },
      signature = { enabled = false },
    },
    views = {
      hover = { scrollbar = false },
      signature = { scrollbar = false },
    },
    presets = {
      lsp_doc_border = false,
    },
  },
}
