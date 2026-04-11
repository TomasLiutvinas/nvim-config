-- lua/tomsen/plugins/nvim-dap.lua  (DAP ONLY; owns K)
return {
  "mfussenegger/nvim-dap",
  version = false,

  keys = {
    { "<F5>" },
    { "<F9>" },
    { "<F10>" },
    { "<F11>" },
    { "<F12>" },
    { "<S-F5>" },
    { "<F6>" },
    { "K" },
    { "<leader>de" },
    { "<leader>ds" },
    { "<leader>dr" },
    { "<leader>dl" },
    { "<leader>dq" },
  },

  config = function()
    local dap = require("dap")
    local widgets = require("dap.ui.widgets")

    dap.adapters.python = {
      type = "executable",
      command = "python3",
      args = { "-m", "debugpy.adapter" },
    }

    local function python_path()
      local cwd = vim.fn.getcwd()
      local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/venv/bin/python",
        cwd .. "/.env/bin/python",
      }
      for _, p in ipairs(candidates) do
        if vim.fn.executable(p) == 1 then return p end
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
        if not input or input == "" then return {} end
        if input:sub(1, 1) == "[" then
          local ok, decoded = pcall(vim.json.decode, input)
          if ok and type(decoded) == "table" then return decoded end
        end
        return vim.fn.split(input, "%s+")
      end

      if vim.fn.executable(adapter) == 1 then
        dap.adapters.bashdb = { type = "executable", command = adapter, name = "bashdb" }

        local common = {
          type = "bashdb",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          env = { PATH = vim.env.PATH },
          showDebugOutput = true,

          pathBash = xp("bash"),
          pathCat = xp("cat"),
          pathMkfifo = xp("mkfifo"),
          pathPkill = xp("pkill"),
          pathSed = xp("sed"),
          pathEnv = xp("env"),

          pathBashdb = pkg .. "/extension/bashdb_dir/bashdb",
          pathBashdbLib = pkg .. "/extension/bashdb_dir",
        }

        dap.configurations.sh = {
          vim.tbl_extend("force", {}, common, { name = "Bash: current file", args = {} }),
          vim.tbl_extend("force", {}, common, { name = "Bash: current file (prompt args)", args = prompt_args }),
        }
        dap.configurations.bash = dap.configurations.sh
        dap.configurations.zsh = dap.configurations.sh
      end
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
    end

    map("<F9>", function() dap.toggle_breakpoint() end, "dap toggle breakpoint")
    map("<F5>", function() dap.continue() end, "dap start/continue")
    map("<F10>", function() dap.step_over() end, "dap step over")
    map("<F11>", function() dap.step_into() end, "dap step into")
    map("<F12>", function() dap.step_out() end, "dap step out")
    map("<S-F5>", function() dap.terminate() end, "dap terminate")
    map("<F6>", function()
      dap.terminate()
      dap.disconnect({ terminateDebuggee = true })
      dap.close()
    end, "dap stop")
    map("<leader>dq", function()
      dap.terminate()
      dap.disconnect({ terminateDebuggee = true })
      dap.close()
    end, "dap stop")

    map("<leader>dr", function() dap.repl.open() end, "dap repl")
    map("<leader>dl", function() dap.run_last() end, "dap run last")
    vim.keymap.set({ "n", "v" }, "<leader>de", function() widgets.eval() end, { silent = true, desc = "dap eval" })
    map("<leader>ds", function() widgets.centered_float(widgets.scopes) end, "dap scopes")

    local function is_float_win(win)
      if type(win) ~= "number" or not vim.api.nvim_win_is_valid(win) then return false end
      local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
      return ok and cfg and cfg.relative ~= ""
    end

    local function find_lsp_preview_float_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if is_float_win(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].lsp_floating_preview == 1 then
            return win
          end
        end
      end
      return nil
    end

    local function close_all_floats()
      local cur = vim.api.nvim_get_current_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if is_float_win(win) then pcall(vim.api.nvim_win_close, win, true) end
      end
      if vim.api.nvim_win_is_valid(cur) then pcall(vim.api.nvim_set_current_win, cur) end
    end

    local lsp_hover_opts = {
      border = "rounded",
      max_width = 120,
      max_height = 28,
      focusable = true,
    }

    local function smart_hover()
      local w = find_lsp_preview_float_win()
      if w then
        pcall(vim.api.nvim_set_current_win, w)
        return
      end

      if dap.session() then
        close_all_floats()
        pcall(widgets.hover)
        return
      end

      vim.lsp.buf.hover(lsp_hover_opts)

      -- creation can be async; focus after it appears
      vim.defer_fn(function()
        local w2 = find_lsp_preview_float_win()
        if w2 then pcall(vim.api.nvim_set_current_win, w2) end
      end, 20)
    end

    vim.keymap.set("n", "K", smart_hover, { silent = true, desc = "hover (focus existing / open+focus)" })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        vim.keymap.set("n", "K", smart_hover, {
          buffer = args.buf,
          silent = true,
          desc = "hover (focus existing / open+focus)",
        })
      end,
    })

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })
  end,
}
