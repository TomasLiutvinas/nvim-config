-- lua/lsp_config.lua
-- LSP UI configuration: handlers, borders, float guards
-- Keybinds are handled in plugins/lsp.lua

local border = "rounded"

-- Kill "black band" differences inside hover by neutralizing CursorLine in floats
local winhl = table.concat({
  "Normal:NormalFloat",
  "FloatBorder:FloatBorder",
  "FloatTitle:FloatTitle",
  "CursorLine:NormalFloat",
  "CursorColumn:NormalFloat",
}, ",")

-- Guard: some servers (Godot in particular) can return empty hover -> width=0 crash
do
  local orig = vim.lsp.util.open_floating_preview

  local function has_text(contents)
    if type(contents) == "string" then
      return contents:match("%S") ~= nil
    end
    if type(contents) == "table" then
      for _, l in ipairs(contents) do
        if type(l) == "string" and l:match("%S") then
          return true
        end
      end
    end
    return false
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    if not has_text(contents) then
      return nil, nil
    end

    opts = opts or {}
    opts.border = opts.border or border
    opts.winhighlight = opts.winhighlight or winhl

    if type(opts.width) == "number" and opts.width < 1 then opts.width = nil end
    if type(opts.height) == "number" and opts.height < 1 then opts.height = nil end

    return orig(contents, syntax, opts, ...)
  end
end

-- Consistent borders/sizing for built-in LSP floats
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
  winhighlight = winhl,
  max_width = 120,
  max_height = 28,
  focusable = true,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
  winhighlight = winhl,
  max_width = 120,
  max_height = 18,
  focusable = true,
})

vim.diagnostic.config({
  float = {
    border = border,
    winhighlight = winhl,
    focusable = false,
    style = "minimal",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Make hover/signature floats comfortable to read/scroll once focused
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(ev)
    local win = vim.api.nvim_get_current_win()
    local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
    if not ok or not cfg or cfg.relative == "" then
      return
    end

    local buf = ev.buf
    if vim.b[buf].lsp_floating_preview ~= 1 then
      return
    end

    -- window-local options (0.11-safe)
    vim.api.nvim_set_option_value("wrap", true, { win = win })
    vim.api.nvim_set_option_value("linebreak", true, { win = win })
    vim.api.nvim_set_option_value("cursorline", false, { win = win })
    vim.api.nvim_set_option_value("cursorcolumn", false, { win = win })
    vim.api.nvim_set_option_value("conceallevel", 0, { win = win })

    -- nicer wrapped movement inside the float
    vim.keymap.set("n", "j", "gj", { buffer = buf, silent = true })
    vim.keymap.set("n", "k", "gk", { buffer = buf, silent = true })

    -- close helpers
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
    vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
  end,
})
