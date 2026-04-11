# Neovim Configuration Architecture

## 📊 Visual Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         init.lua (Entry)                        │
│                     Defines Load Order                          │
└────────────────┬────────────────────────────────────────────────┘
                 │
                 ├──► 1. general.lua
                 │    ┌────────────────────────────────────────┐
                 │    │  Core Neovim Settings                  │
                 │    │  • Tab/indent configuration            │
                 │    │  • Line numbers, wrapping              │
                 │    │  • Search, scrolloff, mouse            │
                 │    │  • Encoding, signcolumn                │
                 │    │  • Godot project detection             │
                 │    └────────────────────────────────────────┘
                 │
                 ├──► 2. lsp_config.lua
                 │    ┌────────────────────────────────────────┐
                 │    │  LSP UI Configuration                  │
                 │    │  • Float window guards                 │
                 │    │  • Handler overrides (hover, sig help) │
                 │    │  • Diagnostic float config             │
                 │    │  • Border styles (rounded)             │
                 │    │  • Float window behavior (wrap, keys)  │
                 │    └────────────────────────────────────────┘
                 │
                 ├──► 3. keybinds.lua
                 │    ┌────────────────────────────────────────┐
                 │    │  Generic Keybinds ONLY                 │
                 │    │  • Window navigation (<C-hjkl>)        │
                 │    │  • Text manipulation (move lines)      │
                 │    │  • Search (<Esc> to clear)             │
                 │    │  • Buffer operations                   │
                 │    │  • Quickfix navigation                 │
                 │    │  • Clipboard operations                │
                 │    │  • Yank highlighting                   │
                 │    └────────────────────────────────────────┘
                 │
                 ├──► 4. commands.lua
                 │    ┌────────────────────────────────────────┐
                 │    │  User Commands                         │
                 │    │  • :TruncateEOF                        │
                 │    │  • :W (alias for :w)                   │
                 │    └────────────────────────────────────────┘
                 │
                 ├──► 5. theme.lua
                 │    ┌────────────────────────────────────────┐
                 │    │  Visual Theme (BEFORE plugins)         │
                 │    │  • Color definitions (red, bg, fg)     │
                 │    │  • Highlight groups setup              │
                 │    │  • ColorScheme autocmd registration    │
                 │    │  • Initial apply() call                │
                 │    └────────────────────────────────────────┘
                 │
                 ├──► 6. tomsen_init.lua
                 │    ┌────────────────────────────────────────┐
                 │    │  Plugin Manager Bootstrap              │
                 │    │  • Lazy.nvim installation check        │
                 │    │  • require("lazy").setup()             │
                 │    │  • Imports from tomsen.plugins.*       │
                 │    └────────┬───────────────────────────────┘
                 │             │
                 │             ├──► plugins/lsp.lua
                 │             │    ┌─────────────────────────────────┐
                 │             │    │  • Mason + LSP servers          │
                 │             │    │  • nvim-cmp completion          │
                 │             │    │  • LspAttach keybinds:          │
                 │             │    │    - gd, <leader>vca, etc.      │
                 │             │    │    - ]d, [d (diagnostics)       │
                 │             │    │    - <C-k> (signature help)     │
                 │             │    └─────────────────────────────────┘
                 │             │
                 │             ├──► plugins/nvim-dap.lua
                 │             │    ┌─────────────────────────────────┐
                 │             │    │  • Python/Bash debugger adapters│
                 │             │    │  • DAP keybinds: F5, F9, F10... │
                 │             │    │  • K (smart hover: DAP or LSP)  │
                 │             │    │  • Breakpoint signs             │
                 │             │    └─────────────────────────────────┘
                 │             │
                 │             ├──► plugins/telescope.lua
                 │             │    ┌─────────────────────────────────┐
                 │             │    │  • Fuzzy finder setup           │
                 │             │    │  • <leader>sf, sg, sh...        │
                 │             │    └─────────────────────────────────┘
                 │             │
                 │             ├──► plugins/harpoon.lua
                 │             │    ┌─────────────────────────────────┐
                 │             │    │  • File marks                   │
                 │             │    │  • <leader>a, <leader>o, 1-5    │
                 │             │    └─────────────────────────────────┘
                 │             │
                 │             │
                 │             ├──► plugins/tender.lua
                 │             │    ┌─────────────────────────────────┐
                 │             │    │  • Runs: vim.cmd("colorscheme") │
                 │             │    │  • Triggers ColorScheme autocmd │
                 │             │    │  • theme.lua applies highlights │
                 │             │    └─────────────────────────────────┘
                 │             │
                 │             └──► plugins/[others].lua
                 │                  (treesitter, oil, fugitive, etc.)
```

## 🔄 Data Flow

### LSP Hover Request Example
```
User presses "K" on symbol
         │
         ├─► plugins/nvim-dap.lua (smart_hover function)
         │   ├─ Is debugging? → Yes → DAP hover
         │   └─ Is debugging? → No ─┐
         │                           ▼
         └─────────────────► vim.lsp.buf.hover()
                                     │
                                     ▼
                         lsp_config.lua (handler override)
                         ├─ Check for empty content (guard)
                         ├─ Apply border style (rounded)
                         ├─ Apply winhighlight (theme colors)
                         └─ Set max_width/height
                                     │
                                     ▼
                              Show float window
                                     │
                                     ▼
                         BufWinEnter autocmd (lsp_config.lua)
                         ├─ Enable wrap/linebreak
                         ├─ Disable cursorline
                         └─ Set j/k/q keybinds for float
                                     │
                                     ▼
                              theme.lua (applies colors)
                              ├─ NormalFloat → bg1
                              ├─ FloatBorder → red
                              └─ Markdown highlights
```

## 🎯 Responsibility Matrix

| Concern | File | Why |
|---------|------|-----|
| Tab width = 2 | `general.lua` | Core editor setting |
| Line numbers on | `general.lua` | Core editor setting |
| Hover border = rounded | `lsp_config.lua` | LSP UI concern |
| Hover color = red | `theme.lua` | Visual theme concern |
| Window nav `<C-w>h` | `keybinds.lua` / native | `<C-h>` overridden by treewalker in n/v |
| LSP goto def `gd` | `plugins/lsp.lua` | LSP-specific keybind |
| Debug step `<F5>` | `plugins/nvim-dap.lua` | DAP-specific keybind |
| Find files `<leader>sf` | `plugins/telescope.lua` | Telescope-specific keybind |
| Which LSP servers | `plugins/lsp.lua` | LSP business logic |
| Empty hover guard | `lsp_config.lua` | LSP UI robustness |
| Completion menu color | `theme.lua` | Visual theme |

## 🏗️ Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Layer 6: PLUGINS (tomsen/plugins/*)                    │
│  Business logic, features, plugin-specific keybinds     │
│  (tender.vim triggers ColorScheme event here)           │
├─────────────────────────────────────────────────────────┤
│  Layer 5: PLUGIN MANAGER (tomsen_init.lua)              │
│  Lazy.nvim bootstrap, plugin loading orchestration      │
├─────────────────────────────────────────────────────────┤
│  Layer 4: VISUAL THEME (theme.lua)                      │
│  ColorScheme autocmd setup, highlight definitions       │
│  (Autocmd ready BEFORE colorscheme command runs)        │
├─────────────────────────────────────────────────────────┤
│  Layer 3: COMMANDS (commands.lua)                       │
│  Custom user commands, reusable functions               │
├─────────────────────────────────────────────────────────┤
│  Layer 2: KEYBINDS (keybinds.lua)                       │
│  Generic keybinds (no plugin dependencies)              │
├─────────────────────────────────────────────────────────┤
│  Layer 1b: LSP UI CONFIG (lsp_config.lua)               │
│  LSP handler configuration, float UI behavior           │
├─────────────────────────────────────────────────────────┤
│  Layer 1a: CORE SETTINGS (general.lua)                  │
│  Fundamental Neovim options, editor behavior            │
└─────────────────────────────────────────────────────────┘
```

## 🔀 Dependency Graph

```
general.lua ─────────────┐
                         │
lsp_config.lua ──────────┤
                         │
keybinds.lua ────────────┤
                         │
commands.lua ────────────┤
                         ├──► theme.lua ──► tomsen_init.lua ──► lazy.nvim
                         │       │                                   │
                         │       │                                   ▼
                         │       │                             Plugin Specs
                         │       │                                   │
                         │       │      ┌────────────────────────────┼────────────────┐
                         │       │      ▼                            ▼                ▼
                         │       │  lsp.lua                   nvim-dap.lua     telescope.lua
                         │       │      │                            │                │
                         │       │      └────────────────────────────┴────────────────┘
                         │       │                                   │
                         │       │                                   ▼
                         │       │                              tender.lua
                         │       │                                   │
                         │       │                      vim.cmd("colorscheme tender")
                         │       │                                   │
                         │       └───────────────────────────────────┘
                         │                      │
                         │              ColorScheme event fires
                         │                      │
                         └──────────────────────┘
                                                │
                                    theme.lua autocmd applies highlights
```

## 🎨 Design Patterns

### 1. **Configuration Separation**
- Settings (general.lua) separate from behavior (plugins)
- UI config (lsp_config.lua) separate from business logic (plugins/lsp.lua)
- Theme (theme.lua) separate from structure

### 2. **Lazy Loading**
- Plugins load only when needed
- Keybinds can trigger plugin loading
- Uses `keys = { ... }` in plugin specs

### 3. **Progressive Enhancement**
```
Core editor → LSP UI → Generic keybinds → Commands → Theme setup → Plugins
   (Must)      (Early)     (Basic)        (Utils)    (Autocmd)    (ColorScheme)
```

### 4. **Single Responsibility**
- Each file has ONE job
- Each plugin file is self-contained
- No cross-file keybind definitions

### 5. **Override Chain**
```
Neovim defaults
    ↓
general.lua (core settings)
    ↓
lsp_config.lua (LSP handlers)
    ↓
theme.lua (register ColorScheme autocmd)
    ↓
Plugins load (tender.vim runs colorscheme command)
    ↓
ColorScheme event fires → theme.lua autocmd applies ← WINS
```

## 🧩 Plugin Pattern

Every plugin follows this structure:
```lua
return {
  "author/plugin-name",
  dependencies = { "required/plugins" },
  lazy = true,  -- Optional: lazy load
  keys = { ... },  -- Optional: lazy load on these keys
  config = function()
    -- 1. Setup plugin
    require('plugin').setup({ ... })
    
    -- 2. Plugin-specific keybinds
    vim.keymap.set('n', '<leader>x', function() ... end)
    
    -- 3. Plugin-specific autocmds (if needed)
    vim.api.nvim_create_autocmd(...)
  end,
}
```

## 🔍 Decision Tree: Where Does This Go?

```
New configuration to add?
         │
         ├─ Is it a vim option (number, tabstop, etc.)?
         │  └─► general.lua
         │
         ├─ Is it a keybind?
         │  ├─ Requires a plugin? ──► plugins/{plugin}.lua
         │  └─ Generic (no plugin)? ──► keybinds.lua
         │
         ├─ Is it a color/highlight?
         │  └─► theme.lua
         │
         ├─ Is it an LSP handler override?
         │  └─► lsp_config.lua
         │
         ├─ Is it an LSP server/completion config?
         │  └─► plugins/lsp.lua
         │
         ├─ Is it a custom command?
         │  └─► commands.lua
         │
         └─ Is it a new plugin?
            └─► Create plugins/{plugin-name}.lua
```

## 📚 Examples

### Example 1: Adding Line Number Color
**Wrong:** Put in `lsp_config.lua` (not LSP-related)
**Wrong:** Put in `plugins/lsp.lua` (not LSP business logic)
**Correct:** Put in `theme.lua` (it's a highlight group)

```lua
-- theme.lua
hl("LineNr", { fg = "#808080" })
```

### Example 2: Adding a Telescope Keybind
**Wrong:** Put in `keybinds.lua` (requires Telescope plugin)
**Wrong:** Put in `theme.lua` (not visual)
**Correct:** Put in `plugins/telescope.lua` (Telescope-specific)

```lua
-- plugins/telescope.lua
vim.keymap.set('n', '<leader>fb', builtin.buffers)
```

### Example 3: Changing Scroll Offset
**Wrong:** Put in `lsp_config.lua` (not LSP-related)
**Wrong:** Put in `keybinds.lua` (not a keybind)
**Correct:** Put in `general.lua` (core vim setting)

```lua
-- general.lua
vim.opt.scrolloff = 8
```

## 🎓 Key Insights

1. **Load order matters:** `lsp_config` before plugins, `theme` after plugins
2. **Keybind location = responsibility:** Plugin keybinds stay with plugin
3. **LSP split:** UI config (lsp_config) vs business logic (plugins/lsp)
4. **Theme is king:** Loads last to override everything
5. **General is foundation:** Pure vim options, no plugins
6. **One concern per file:** Easy to find, easy to modify

## 🚀 Benefits

✅ **Predictable** - Always know where to look  
✅ **Maintainable** - Change one thing without breaking others  
✅ **Modular** - Easy to add/remove plugins  
✅ **Clear** - Each file has obvious purpose  
✅ **Debuggable** - Load order makes sense  
✅ **Scalable** - Pattern repeats for new plugins  
✅ **Robust** - Theme autocmd exists before colorscheme runs  
✅ **Styled** - Completion menu and floats have custom colors  
