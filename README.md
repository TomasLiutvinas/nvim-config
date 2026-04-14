# nvim-config

Personal Neovim configuration. Requires **Neovim 0.12+**.

---

# Requirements and installation guide (Arch Linux)

## Requirements
```bash
sudo pacman -S neovim git ripgrep tree-sitter make gcc nodejs
```

Install a Nerd Font — e.g.:
```bash
yay -S ttf-jetbrains-mono-nerd
```

## Installation

### 1. Backup Existing Config
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Clone the Configuration
```bash
git clone git@github.com:TomasLiutvinas/nvim-config.git ~/.config/nvim
```

### 3. Launch Neovim
```bash
nvim
```
On first launch, lazy.nvim will install all plugins automatically.

### 4. Install parsers
```vim
:TSUpdate
```
Restart Neovim afterwards.

### 5. Verify
```vim
:checkhealth
```

---

# Requirements and installation guide (MacOs)

## Requirements
- Homebrew (idk what for probably to satisfy other requirements)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Neovim
```bash
brew install neovim
```
- C compiler
```bash
xcode-select --install
```
- Node
```bash
brew install node
```
- Ripgrep
```bash
brew install ripgrep
```
- tree-sitter CLI *(required as of the 0.12 update — needed to compile treesitter parsers)*
```bash
brew install tree-sitter
```
- fd (optional, for faster file finding in telescope)
```bash
brew install fd
```

## Installation
### 1. Backup Existing Config (if care about this at all)
```bash
# If you have an existing nvim config, back it up first
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Clone the Configuration
```bash
git clone git@github.com:TomasLiutvinas/nvim-config.git ~/.config/nvim
```

### 3. Launch Neovim
```bash
nvim
```
On first launch, lazy.nvim will do everything (idk what exactly)

### 4. Install parsers *(new step as of the 0.12 update)*
After plugins finish installing, run inside Neovim:
```vim
:TSUpdate
```
Restart Neovim afterwards.

### 5. Install LSP Servers
After plugins are installed, run inside Neovim:
```vim
:Mason
```
Then install the language servers you need (e.g., lua_ls, tsserver, pyright).
(this paragraph is ai generated, no clue what it means)

### 6. Verify Installation
```vim
:checkhealth
```

---

# Requirements and installation guide (Windows)

Ensure the following are available on your `PATH`:
- [Git](https://git-scm.com/)
- [Neovim](https://neovim.io/) >= 0.12
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- `make` and `gcc` — via [MSYS2](https://www.msys2.org/) (`pacman -S mingw-w64-x86_64-gcc make`)
- [Node.js](https://nodejs.org/)
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) (`cargo install tree-sitter-cli` or via `winget install tree-sitter.tree-sitter`)
- A [Nerd Font](https://www.nerdfonts.com/) set in your terminal

```powershell
git clone git@github.com:TomasLiutvinas/nvim-config.git $env:LOCALAPPDATA\nvim
nvim
```

Then run `:TSUpdate` inside Neovim and restart.

---

# Keybindings

> Generated 2026-04-11. This may get out of date — when in doubt, check the source files or press `<leader>sk` to search keymaps live inside Neovim.

`<leader>` is `Space`.

## Search / Telescope

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sf` | n | Find files |
| `<leader>sg` | n | Live grep |
| `<leader>se` | n | Live grep filtered by extension |
| `<leader>sw` | n | Grep word under cursor |
| `<leader>s/` | n | Live grep in open files only |
| `<leader>sd` | n | Search diagnostics |
| `<leader>sh` | n | Search help tags |
| `<leader>sk` | n | Search keymaps |
| `<leader>sc` | n | Search commands |
| `<leader>ss` | n | Search Telescope pickers |
| `<leader>sr` | n | Resume last search |
| `<leader>s.` | n | Recent files |
| `<leader>sn` | n | Search Neovim config files |
| `<leader><leader>` | n | Open buffers |
| `<leader>/` | n | Fuzzy search current buffer |

### Inside a Telescope window

| Key | Action |
|-----|--------|
| `<C-n>` / `<C-p>` | Next / prev result |
| `<CR>` | Open |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-u>` / `<C-d>` | Scroll preview up / down |
| `<C-f>` / `<C-k>` | Scroll preview left / right |
| `<C-c>` | Close |

## LSP

*These are buffer-local and only active when an LSP server is attached.*

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition |
| `K` | n | Hover (focus existing float, or open and focus) |
| `<C-k>` | i | Signature help |
| `<leader>vca` | n | Code actions |
| `<leader>vrn` | n | Rename symbol |
| `<leader>vrr` | n | References |
| `<leader>vws` | n | Search workspace symbols |
| `<leader>vd` | n | Show diagnostics float |
| `<leader>vp` | n | Reselect last paste |
| `]d` | n | Next diagnostic |
| `[d` | n | Prev diagnostic |
| `<leader>l` | n | Send diagnostics to location list |
| `<leader>f` | n | Format buffer |

## Completion (nvim-cmp)

*Active in insert / snippet mode.*

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | i, s | Next item / trigger completion |
| `<S-Tab>` | i, s | Prev item |
| `<C-CR>` | i, s | Confirm selection |

## Debug (DAP)

| Key | Mode | Action |
|-----|------|--------|
| `<F5>` | n | Start / continue |
| `<F9>` | n | Toggle breakpoint |
| `<F10>` | n | Step over |
| `<F11>` | n | Step into |
| `<F12>` | n | Step out |
| `<S-F5>` | n | Terminate |
| `<F6>` | n | Stop and close |
| `<leader>dq` | n | Stop and close |
| `<leader>de` | n, v | Eval expression under cursor |
| `<leader>ds` | n | Scopes float |
| `<leader>dr` | n | Open REPL |
| `<leader>dl` | n | Run last configuration |
| `<leader>du` | n | Toggle DAP UI |

## File Explorer (Oil)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>t` | n | Open Oil (float) |

### Inside an Oil buffer

| Key | Action |
|-----|--------|
| `<CR>` | Open |
| `-` | Go to parent directory |
| `_` | Open cwd |
| `<C-s>` | Open in vertical split |
| `<C-h>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview |
| `<C-l>` | Refresh |
| `g.` | Toggle hidden files |
| `gs` | Change sort |
| `gx` | Open with system default |
| `g?` | Show help |
| `<ESC>` / `q` | Close |

## Harpoon

| Key | Mode | Action |
|-----|------|--------|
| `<leader>a` | n | Mark current file |
| `<leader>o` | n | Open quick menu |
| `<leader>1`–`5` | n | Jump to file 1–5 |

## Treewalker (AST navigation)

*Overrides `<C-h/j/k/l>` in normal and visual mode. Use `<C-w>h/j/k/l` for window navigation instead.*

| Key | Mode | Action |
|-----|------|--------|
| `<C-k>` | n, v | Move to previous AST node |
| `<C-j>` | n, v | Move to next AST node |
| `<C-h>` | n, v | Move to parent AST node |
| `<C-l>` | n, v | Move to child AST node |
| `<C-A-K>` | n | Swap node up |
| `<C-A-J>` | n | Swap node down |
| `<A-h>` | n | Swap node left |
| `<A-l>` | n | Swap node right |

## Treesitter Context

| Key | Mode | Action |
|-----|------|--------|
| `[c` | n | Jump to context (e.g. current function/class) |

## Git

| Key / Command | Action |
|---------------|--------|
| `:G` | Fugitive status |

## Windows & Buffers

| Key | Mode | Action |
|-----|------|--------|
| `<C-w>h/j/k/l` | n | Move between windows (see Treewalker note above) |
| `<C-Left/Right/Up/Down>` | n | Resize window |
| `<leader>ba` | n | Close all buffers except current |

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `<A-j>` | n | Move line down (+ LSP format) |
| `<A-k>` | n | Move line up (+ LSP format) |
| `<A-j>` | i | Move line down |
| `<A-k>` | i | Move line up |
| `<A-j>` | x | Move selection down |
| `<A-k>` | x | Move selection up |
| `<` | x | Indent left and reselect |
| `>` | x | Indent right and reselect |
| `J` | n | Join lines (cursor stays in place) |
| `gc` | n, v | Toggle line comment (built-in) |
| `gb` | v | Toggle block comment (built-in) |
| `x` | n | Delete char without yanking |
| `p` | x | Paste without yanking the replaced text |
| `<C-c>` | i | Exit insert mode |
| `Q` | n | Disabled (was Ex mode) |

## Clipboard

| Key | Mode | Action |
|-----|------|--------|
| `<leader>y` | n, x | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |
| `<leader>p` | n, x | Paste from system clipboard |
| `<leader>ca` | v | Append selection (wrapped in ``` ``` ```) to clipboard |
| `<leader>cn` | v | Clear clipboard and start new selection |

## Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-d>` | n | Half-page down (centred) |
| `<C-u>` | n | Half-page up (centred) |
| `n` | n | Next search result (centred, folds open) |
| `N` | n | Prev search result (centred, folds open) |
| `=` | n | Move down one screen line |
| `+` | n | Move to end of line |
| `<Esc>` | n | Clear search highlight |
| `<Esc><Esc>` | t | Exit terminal mode |

## Quickfix

| Key | Mode | Action |
|-----|------|--------|
| `<leader>q` | n | Open quickfix list |
| `<leader>c` | n | Close quickfix list |
| `]q` | n | Next quickfix item |
| `[q` | n | Prev quickfix item |

## Misc

| Key / Command | Mode | Action |
|---------------|------|--------|
| `<leader>u` | n | Toggle undotree |
| `<leader>=` | n | Toggle: Markdown read/edit mode (.md) or cloak secrets (.env) |
| `<leader>jq` | n | Format JSON with `jq` |
| `<leader>rn` | n | Rename word under cursor (substitute) |
| `<leader>ee` | n | Insert Go `if err != nil` block |
| `<leader>x` | n | Source current file |
| `:TruncateEOF` | | Remove trailing newline from current file |
| `:W` | | Alias for `:w` |
