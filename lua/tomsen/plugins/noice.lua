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
        local notify = require("notify")
        notify.setup({
          background_colour = "#000000", -- fix for NotifyBackground issue
          stages = "slide",
          timeout = 3000,
          top_down = false,
        })
        vim.notify = notify

        -- Keybind to clear all notifications
        vim.keymap.set("n", "<leader>n", function()
          notify.dismiss({ silent = true, pending = true })
        end, { desc = "Clear notifications" })
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
      views = {
        notify = {
          position = {
            row = -2,
            col = "100%",
          },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end,
}
