-- lazy.nvim
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    { "MunifTanjim/nui.nvim", module = "nui" },
    {
      "rcarriga/nvim-notify",
      module = "notify",
      config = function()
        require("notify").setup({
          background_colour = "#000000", -- fix for NotifyBackground issue
        })
        vim.notify = require("notify") -- use notify globally
      end,
    },
  },
  config = function()
    require("noice").setup({
      cmdline = {
        view = "cmdline",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end,
}
