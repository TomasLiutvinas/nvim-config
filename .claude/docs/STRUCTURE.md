# Neovim Configuration Structure

## 📁 File Organization

```
~/.config/nvim/
├── init.lua                    # Entry point (load order defined here)
├── lua/
│   ├── general.lua            # Core Neovim settings
│   ├── lsp_config.lua         # LSP UI handlers & borders
│   ├── keybinds.lua           # Generic keybinds only
│   ├── commands.lua           # User commands
│   ├── tomsen_init.lua        # Lazy.nvim plugin manager
│   ├── theme.lua              # Visual theme & highlights
│   └── tomsen/
│       └── plugins/           # Individual plugin configurations
│           ├── lsp.lua        # LSP servers + completion + LSP keybinds
│           ├── nvim-dap.lua   # Debugger + DAP keybinds
│           ├── telescope.lua  # Telescope + search keybinds
│           └── ...            # Other plugins
└── lazy-lock.json             # Plugin version lockfile
```

## 🔄 Load Order (init.lua)

```lua
1. require("general")      -- Core vim options first
2. require("lsp_config")   -- LSP handlers before servers start
3. require("keybinds")     -- Generic keybinds
4. require("commands")     -- User commands
5. require("theme")        -- Theme autocmd setup (before colorscheme)
6. require("tomsen_init")  -- Plugin manager (loads all plugins)
```

## 📋 File Responsibilities

### `general.lua`
**Purpose:** Core Neovim settings  
**Contains:**
- Tab/indentation settings (`tabstop`, `shiftwidth`, `expandtab`)
- UI settings (`number`, `relativenumber`, `signcolumn`)
- Search settings (`ignorecase`, `smartcase`, `hlsearch`)
- Editor behavior (`updatetime`, `scrolloff`, `mouse`)
- File encoding (`encoding`, `fileencoding`)
- Godot project auto-detection

**Does NOT contain:**
- Keybinds (goes in `keybinds.lua` or plugin files)
- Plugin-specific settings
- Theme/colors

---

### `lsp_config.lua`
**Purpose:** LSP UI configuration (handlers, borders, float behavior)  
**Contains:**
- Float window guards (prevents empty hover crashes)
- LSP handler overrides (`textDocument/hover`, `signatureHelp`)
- Diagnostic float configuration
- Float window autocmd (wrap, linebreak, close keybinds)
- Border style definitions

**Does NOT contain:**
- LSP server configurations (goes in `plugins/lsp.lua`)
- LSP keybinds (goes in `plugins/lsp.lua`)
- Completion setup (goes in `plugins/lsp.lua`)

**Why separate?**
- Needs to load BEFORE plugin manager so handlers are ready when servers start
- Pure UI/UX configuration, not business logic

---

### `keybinds.lua`
**Purpose:** Generic, non-plugin-specific keybinds  
**Contains:**
- Window navigation (`<C-hjkl>`)
- Text manipulation (moving lines, indenting)
- Search highlighting (`<Esc>` to clear)
- Buffer operations
- Quickfix/location list navigation
- Clipboard operations
- Terminal mode escape
- Yank highlighting autocmd

**Does NOT contain:**
- LSP keybinds (goes in `plugins/lsp.lua`)
- DAP keybinds (goes in `plugins/nvim-dap.lua`)
- Telescope keybinds (goes in `plugins/telescope.lua`)
- Any plugin-specific keybinds

**Rule:** If it requires a plugin to work, it belongs in that plugin's config file.

---

### `commands.lua`
**Purpose:** Custom user commands  
**Contains:**
- `:TruncateEOF` - Remove trailing newline
- `:W` - Alias for `:w`
- Any other custom commands

---

### `tomsen_init.lua`
**Purpose:** Plugin manager bootstrap  
**Contains:**
- Lazy.nvim installation check
- Lazy.nvim setup
- Plugin spec import from `tomsen.plugins`

**Does NOT contain:**
- Individual plugin configurations (those go in `plugins/` directory)

---

### `theme.lua`
**Purpose:** Visual theming and highlight groups  
**Contains:**
- Color definitions (`red`, `bg0`, `bg1`, `fg0`)
- Highlight group definitions (`NormalFloat`, `FloatBorder`, etc.)
- LSP hover markdown styling
- Completion menu styling
- Treesitter markdown highlights
- `ColorScheme` autocmd to reapply on theme change

**Why load before plugins?**
- Sets up ColorScheme autocmd before plugins run
- When tender.vim runs `colorscheme tender`, autocmd already exists
- Allows theme to apply highlights immediately after colorscheme loads

---

### `plugins/lsp.lua`
**Purpose:** Language Server Protocol configuration  
**Contains:**
- LSP server list and settings
- Mason & mason-lspconfig setup
- Completion (nvim-cmp) configuration
- **LSP keybinds** (`gd`, `<leader>vca`, `<leader>vrr`, etc.)
- **Signature help keybind** (`<C-k>`)
- **Diagnostic navigation** (`]d`, `[d`)
- LspAttach autocmd

**Why keybinds here?**
- LSP-specific functionality
- Only relevant when LSP is attached
- Keeps all LSP concerns in one place

---

### `plugins/nvim-dap.lua`
**Purpose:** Debug Adapter Protocol configuration  
**Contains:**
- DAP adapter configurations (Python, Bash)
- Debugger keybinds (`<F5>`, `<F9>`, etc.)
- **`K` keybind** (smart hover: DAP hover if debugging, LSP hover otherwise)
- Breakpoint signs

**Why `K` here?**
- DAP takes precedence over LSP for hover
- Smart fallback logic needs access to DAP session state

---

### Other Plugin Files
Each plugin file in `tomsen/plugins/` follows the same pattern:
```lua
return {
  "author/plugin-name",
  dependencies = { ... },
  config = function()
    -- Plugin setup
    require('plugin').setup({ ... })
    
    -- Plugin-specific keybinds
    vim.keymap.set(...)
  end
}
```

## 🎯 Design Principles

### 1. **Separation of Concerns**
- Each file has ONE clear responsibility
- No overlap between files
- Easy to locate any setting

### 2. **Keybind Placement Rule**
```
Generic keybind → keybinds.lua
Plugin keybind  → plugins/{plugin}.lua
```

Examples:
- `<C-h>` (window nav) → `keybinds.lua` ✓
- `gd` (LSP go to definition) → `plugins/lsp.lua` ✓
- `<leader>sf` (Telescope find files) → `plugins/telescope.lua` ✓

### 3. **Load Order Matters**
```
Settings → LSP Config → Keybinds → Theme → Plugins
```

- **lsp_config** loads before plugins so handlers are ready
- **theme** loads before plugins so autocmd exists when colorscheme runs
- **keybinds** loads before plugins so generic binds are available

### 4. **Plugin Isolation**
- Each plugin is self-contained in its own file
- Plugin keybinds stay with plugin config
- Lazy loading works correctly
- Easy to disable/remove plugins

## 🔍 Finding Things

| I need to change... | Look in... |
|---------------------|------------|
| Tab width | `general.lua` |
| Line numbers | `general.lua` |
| LSP hover border style | `lsp_config.lua` |
| Window navigation keys | `keybinds.lua` |
| Text manipulation keys | `keybinds.lua` |
| LSP keybinds (`gd`, etc.) | `plugins/lsp.lua` |
| Which LSP servers to install | `plugins/lsp.lua` |
| Completion behavior | `plugins/lsp.lua` |
| Debugger keybinds | `plugins/nvim-dap.lua` |
| Telescope keybinds | `plugins/telescope.lua` |
| Float window colors | `theme.lua` |
| Any highlight group | `theme.lua` |

## ⚠️ Common Mistakes to Avoid

### ❌ DON'T:
- Put LSP keybinds in `keybinds.lua`
- Put theme colors in `lsp_config.lua`
- Load theme after plugins (autocmd won't exist for colorscheme)
- Mix plugin setup and keybinds in separate files
- Put plugin settings in `general.lua`

### ✅ DO:
- Keep LSP keybinds in `plugins/lsp.lua`
- Keep theme colors in `theme.lua`
- Load theme BEFORE plugins (so autocmd exists)
- Keep plugin config and keybinds together
- Keep only vim options in `general.lua`

## 🔧 Maintenance

### Adding a New Plugin
1. Create `lua/tomsen/plugins/plugin-name.lua`
2. Add plugin spec and setup
3. Add plugin-specific keybinds in the same file
4. Update this document if needed

### Adding a New Keybind
**Ask:** Does this require a plugin?
- **Yes** → Add to `plugins/{plugin}.lua`
- **No** → Add to `keybinds.lua`

### Changing Theme
- Edit `theme.lua` only
- Use `:so` to reload
- Changes persist across sessions

### Debugging Load Issues
Check load order:
```vim
:messages
:lua print(vim.inspect(require("lazy").plugins()))
```
