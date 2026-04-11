# Neovim Config Quick Reference

## 📁 File Locations

| Need to change... | Edit this file |
|-------------------|----------------|
| Tab width, line numbers | `lua/general.lua` |
| Window nav keybinds | `lua/keybinds.lua` |
| LSP keybinds (gd, etc.) | `lua/tomsen/plugins/lsp.lua` |
| LSP servers to install | `lua/tomsen/plugins/lsp.lua` |
| LSP hover border style | `lua/lsp_config.lua` |
| Debugger keybinds | `lua/tomsen/plugins/nvim-dap.lua` |
| Telescope keybinds | `lua/tomsen/plugins/telescope.lua` |
| Colors & highlights | `lua/theme.lua` |
| Load order | `init.lua` |

## 🎯 Decision Tree

**Adding a keybind?**
- Requires plugin? → `lua/tomsen/plugins/{plugin}.lua`
- Generic (no plugin)? → `lua/keybinds.lua`

**Adding a setting?**
- Vim option (tabstop, etc.)? → `lua/general.lua`
- LSP handler? → `lua/lsp_config.lua`
- Color/highlight? → `lua/theme.lua`
- New plugin? → Create `lua/tomsen/plugins/{name}.lua`

## 📋 Load Order

```
init.lua loads in this order:
1. general      (vim settings)
2. lsp_config   (LSP UI handlers)
3. keybinds     (generic keybinds)
4. commands     (user commands)
5. theme        (colors, autocmd setup)
6. tomsen_init  (plugin manager → loads all plugins)
```

## 🔑 Key Keybinds

### Generic (keybinds.lua)
| Key | Action |
|-----|--------|
| `<C-hjkl>` | Navigate windows |
| `<A-jk>` | Move lines up/down |
| `<leader>u` | Toggle undotree |
| `<leader>f` | Format buffer |
| `<leader>q` | Open quickfix |
| `]q` / `[q` | Next/prev quickfix |

### LSP (plugins/lsp.lua)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `<leader>vca` | Code actions |
| `<leader>vrr` | Show references |
| `<leader>vrn` | Rename symbol |
| `]d` / `[d` | Next/prev diagnostic |
| `<C-k>` | Signature help |
| `<leader>l` | Diagnostics to loclist |

### DAP (plugins/nvim-dap.lua)
| Key | Action |
|-----|--------|
| `<F5>` | Start/continue |
| `<F9>` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `K` | Hover (DAP or LSP) |

### Telescope (plugins/telescope.lua)
| Key | Action |
|-----|--------|
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sh` | Search help |
| `<leader>sd` | Search diagnostics |

## 🛠️ Common Tasks

### Add New LSP Server
Edit `lua/tomsen/plugins/lsp.lua`:
```lua
ensure_installed = {
  "lua_ls",
  "rust_analyzer",
  "your_server_here",  -- Add this
}
```

### Change Hover Border Color
Edit `lua/theme.lua`:
```lua
hl("FloatBorder", { fg = red, bg = bg1 })
                       ^^^
                    Change this
```

### Add Plugin Keybind
Edit the plugin file in `lua/tomsen/plugins/{plugin}.lua`:
```lua
config = function()
  require('plugin').setup()
  
  vim.keymap.set('n', '<leader>x', function()
    -- your action
  end, { desc = "Description" })
end
```

### Debug Config Issues
```vim
:messages              " Check for errors
:scriptnames           " See load order
:LspInfo              " Check LSP status
:Lazy                 " Check plugins
:verbose map gd       " Check keybind
```

## 📖 Full Documentation

- **STRUCTURE.md** - Complete file organization
- **ARCHITECTURE.md** - Visual diagrams & patterns
- **MIGRATION.md** - Testing checklist
- **CHANGES_SUMMARY.md** - Recent changes

## ⚠️ Important Rules

1. **Plugin keybinds go in plugin files** - NOT in keybinds.lua
2. **LSP UI config ≠ LSP servers** - Different files
3. **Theme loads BEFORE plugins** - So autocmd exists when colorscheme runs
4. **lsp_config loads EARLY** - Before servers start
5. **One concern per file** - Easy to find & modify

## 🔧 Maintenance

### After Changing Files
```bash
# Restart Neovim or reload config
:source ~/.config/nvim/init.lua

# Check for errors
:messages
```

### Clean Plugin Cache
```bash
# If plugins act weird
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

### Update Plugins
```vim
:Lazy sync
```

## 🆘 Troubleshooting

| Problem | Solution |
|---------|----------|
| LSP keybinds not working | Open file with LSP, check `:LspInfo` |
| Hover has wrong colors | Check `theme.lua` loads after plugins |
| Empty hover crashes | Check `lsp_config.lua` loaded |
| Keybind doesn't work | Check `:verbose map {key}` |
| Plugin not loading | Check `:Lazy`, look for errors |

---

**Last Updated:** January 30, 2025
**Neovim Version:** 0.11+