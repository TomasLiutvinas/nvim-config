-- lua/tomsen/plugins/lsp.lua  (servers + cmp ONLY)
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
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

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
    })

    local function root_dir_from(patterns)
      return function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if not fname or fname == "" then return end
        local start = vim.fs.dirname(fname)
        local hit = vim.fs.find(patterns, { path = start, upward = true })[1]
        on_dir(hit and vim.fs.dirname(hit) or start)
      end
    end

    local nvim_config = vim.fn.stdpath("config")

    local servers = {
      gopls = {},
      rust_analyzer = {},
      html = {},
      cssls = {
        settings = { css = { lint = { unknownAtRules = "ignore" } } },
      },
      pyright = {},
      omnisharp = {
        enable_roslyn_analysers = true,
        enable_import_completion = true,
        organize_imports_on_format = true,
        enable_decompilation_support = true,
        filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
      },
      lua_ls = {
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if fname and fname ~= "" and fname:sub(1, #nvim_config) == nvim_config then
            on_dir(nvim_config)
            return
          end
          root_dir_from({ ".luarc.json", ".luarc.jsonc", ".git" })(bufnr, on_dir)
        end,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "bit", "it", "describe", "before_each", "after_each" } },
            workspace = {
              library = {
                [vim.env.VIMRUNTIME] = true,
                [vim.fn.stdpath("config")] = true,
              },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },
      gdscript = {
        root_dir = root_dir_from({ "project.godot", ".git" }),
      },
    }

    for name, cfg in pairs(servers) do
      cfg.capabilities = capabilities
      vim.lsp.config(name, cfg)
    end
    vim.lsp.enable(vim.tbl_keys(servers))

    -- LSP Keybinds (on attach)
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(e)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = e.buf, desc = "Go to Definition" })
        -- K is owned by nvim-dap plugin config (DAP hover / LSP hover fallback)

        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol,
          { buffer = e.buf, desc = "Search Workspace Symbols" })
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float,
          { buffer = e.buf, desc = "Show Diagnostics (float)" })
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = e.buf, desc = "Show Code Actions" })
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { buffer = e.buf, desc = "Show References" })
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { buffer = e.buf, desc = "Rename Symbol" })

        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, { buffer = e.buf, desc = "Next Diagnostic" })

        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, { buffer = e.buf, desc = "Prev Diagnostic" })

        -- Diagnostics to location list
        vim.keymap.set('n', '<leader>l', function() vim.diagnostic.setloclist() end,
          { buffer = e.buf, desc = 'Diagnostics to location list' })

        -- Signature help
        vim.keymap.set({ "n", "i" }, "<C-k>", function()
          vim.lsp.buf.signature_help()
        end, { buffer = e.buf, silent = true, desc = "LSP signature help" })
      end
    })

    local function has_words_before()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),

        ["<C-y>"] = function() end,
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }),
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
        },
      },
      viewxperimental = {
        ghost_text = false,
      },
    })
  end,
}
