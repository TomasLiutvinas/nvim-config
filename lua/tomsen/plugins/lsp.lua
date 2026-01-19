return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "omnisharp",
        "html",
        "cssls",
        "pyright",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        cssls = function()
          local lspconfig = require("lspconfig")
          lspconfig.cssls.setup({
            capabilities = capabilities,
            settings = {
              css = {
                lint = {
                  unknownAtRules = "ignore" -- Ignores Tailwind @rules
                }
              }
            }
          })
        end,

        pylsp = function()
          local lspconfig = require("lspconfig")
          lspconfig.pylsp.setup({
            capabilities = capabilities,
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = {
                    ignore = { "E501" },
                    maxLineLength = 120,
                  },
                },
              },
            },
          })
        end,

        omnisharp = function()
          local lspconfig = require("lspconfig")
          lspconfig.omnisharp.setup({
            capabilities = capabilities,
            enable_roslyn_analysers = true,
            enable_import_completion = true,
            organize_imports_on_format = true,
            enable_decompilation_support = true,
            filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' }
          })
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          local util = require("lspconfig.util")

          local nvim_config = vim.fn.stdpath("config")

          local lua_settings = {
            Lua = {
              runtime = { version = "LuaJIT" }, -- Neovim
              diagnostics = {
                globals = { "vim", "bit", "it", "describe", "before_each", "after_each" },
              },
              workspace = {
                library = {
                  [vim.env.VIMRUNTIME] = true,
                  [vim.fn.stdpath("config")] = true,
                },
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          }

          lspconfig.lua_ls.setup({
            capabilities = capabilities,

            root_dir = function(fname)
              -- ensure all ~/.config/nvim lua files share the same workspace (consistent settings)
              if fname:sub(1, #nvim_config) == nvim_config then
                return nvim_config
              end
              return util.root_pattern(".luarc.json", ".luarc.jsonc", ".git")(fname) or util.path.dirname(fname)
            end,

            on_new_config = function(new_config, _)
              new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, lua_settings)
            end,

            on_init = function(client)
              client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, lua_settings)
              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end,

            settings = lua_settings,
          })
        end,

      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and
          vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),

        ['<C-l>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),

        ['<C-y>'] = function() end,
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      })
    })

    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
