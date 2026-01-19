return {
  "mfussenegger/nvim-dap",
  version = false,

  -- ensure the plugin is loaded when these are pressed (lazy.nvim)
  keys = {
    { "<F5>" },
    { "<F9>" },
    { "<F10>" },
    { "<F11>" },
    { "<F12>" },
    { "<S-F5>" },
    { "K" },
    { "<leader>de" },
    { "<leader>ds" },
    { "<leader>dr" },
    { "<leader>dl" },
  },

  config = function()
    local dap = require("dap")
    local widgets = require("dap.ui.widgets")

    -- debugpy adapter (uses whatever "python3" resolves to)
    dap.adapters.python = {
      type = "executable",
      command = "python3",
      args = { "-m", "debugpy.adapter" },
    }

    -- prefer project venv if present, else python3
    local function python_path()
      local cwd = vim.fn.getcwd()
      local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/venv/bin/python",
        cwd .. "/.env/bin/python",
      }
      for _, p in ipairs(candidates) do
        if vim.fn.executable(p) == 1 then
          return p
        end
      end
      return "python3"
    end

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Python: current file",
        program = "${file}",
        pythonPath = python_path(),
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        justMyCode = true,
      },
      {
        type = "python",
        request = "launch",
        name = "Python: current file (justMyCode:false)",
        program = "${file}",
        pythonPath = python_path(),
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        justMyCode = false,
      },
      {
        type = "python",
        request = "launch",
        name = "Pytest: current file",
        module = "pytest",
        args = { "${file}" },
        pythonPath = python_path(),
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        justMyCode = true,
      },
      {
        type = "python",
        request = "attach",
        name = "Python: attach (127.0.0.1:5678)",
        connect = { host = "127.0.0.1", port = 5678 },
        justMyCode = true,
      },
    }

    -- Bash / sh debugging (bashdb via bash-debug-adapter)
    do
      local pkg = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter"
      local adapter = pkg .. "/bash-debug-adapter"

      local function xp(cmd)
        local p = vim.fn.exepath(cmd)
        return (p ~= "" and p) or cmd
      end

      local function prompt_args()
        local input = vim.fn.input("Args (space-separated or JSON array): ")
        if not input or input == "" then
          return {}
        end
        if input:sub(1, 1) == "[" then
          local ok, decoded = pcall(vim.json.decode, input)
          if ok and type(decoded) == "table" then
            return decoded
          end
        end
        return vim.fn.split(input, "%s+")
      end

      if vim.fn.executable(adapter) == 1 then
        dap.adapters.bashdb = {
          type = "executable",
          command = adapter,
          name = "bashdb",
        }

        local common = {
          type = "bashdb",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          env = { PATH = vim.env.PATH }, -- ensure /usr/bin is visible
          showDebugOutput = true,

          -- hard-pin required tools (prevents "pathCat: undefined")
          pathBash = xp("bash"),
          pathCat = xp("cat"),
          pathMkfifo = xp("mkfifo"),
          pathPkill = xp("pkill"),
          pathSed = xp("sed"),
          pathEnv = xp("env"),

          -- mason layout
          pathBashdb = pkg .. "/extension/bashdb_dir/bashdb",
          pathBashdbLib = pkg .. "/extension/bashdb_dir",
        }

        dap.configurations.sh = {
          vim.tbl_extend("force", {}, common, {
            name = "Bash: current file",
            args = {},
          }),
          vim.tbl_extend("force", {}, common, {
            name = "Bash: current file (prompt args)",
            args = prompt_args,
          }),
        }

        dap.configurations.bash = dap.configurations.sh
        dap.configurations.zsh = dap.configurations.sh
      end
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
    end

    -- core debug controls
    map("<F9>", function() dap.toggle_breakpoint() end, "dap toggle breakpoint")
    map("<F5>", function() dap.continue() end, "dap start/continue")
    map("<F10>", function() dap.step_over() end, "dap step over")
    map("<F11>", function() dap.step_into() end, "dap step into")
    map("<F12>", function() dap.step_out() end, "dap step out")
    map("<S-F5>", function() dap.terminate() end, "dap terminate")

    map("<leader>dr", function() dap.repl.open() end, "dap repl")
    map("<leader>dl", function() dap.run_last() end, "dap run last")

    vim.keymap.set({ "n", "v" }, "<leader>de", function()
      widgets.eval()
    end, { silent = true, desc = "dap eval" })

    map("<leader>ds", function()
      widgets.centered_float(widgets.scopes)
    end, "dap scopes")

    -- close the current hover float if it's open, otherwise open hover
    local function close_float_if_any()
      local cur = vim.api.nvim_get_current_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg and cfg.relative ~= "" then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
      pcall(vim.api.nvim_set_current_win, cur)
    end

    local function smart_hover_toggle()
      close_float_if_any()
      if dap.session() then
        widgets.hover()
        return
      end
      if vim.lsp then
        vim.lsp.buf.hover()
      end
    end

    -- global fallback
    vim.keymap.set("n", "K", smart_hover_toggle, { silent = true, desc = "hover toggle (dap value / lsp info)" })

    -- buffer-local override when LSP attaches (prevents LSP-only K from clobbering DAP hover)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        vim.keymap.set("n", "K", smart_hover_toggle, {
          buffer = args.buf,
          silent = true,
          desc = "hover toggle (dap value / lsp info)",
        })
      end,
    })

    -- allow closing floats with q (only when you're in the float)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lsp-hover", "dap-float" },
      callback = function(ev)
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true, desc = "close float" })
        vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = ev.buf, silent = true, desc = "close float" })
      end,
    })

    -- signs
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })

    -- stop session (works for launch + attach)
    map("<F6>", function()
      dap.terminate()
      dap.disconnect({ terminateDebuggee = true })
      dap.close()
    end, "dap stop")

    -- optional: also on leader
    map("<leader>dq", function()
      dap.terminate()
      dap.disconnect({ terminateDebuggee = true })
      dap.close()
    end, "dap stop")
  end,
}
