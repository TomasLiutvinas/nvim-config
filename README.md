# nvim-config

Work in progress, need to document more.
Try :checkhealth
But hopefully can pull and run anywhere.

# Requirements and issues (For windows only)
- Chocolatey

```choco install mingw```
```choco install python311```
```pip3 install pynvim```
```choco install luarocks```
```npm install -g tree-sitter-cli```

# Issues
## No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable.
Missing mingw


## [coc.nvim] build/index.js not found, please install dependencies and compile coc.nvim by: npm ci
no clue

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

### 4. Install LSP Servers
After plugins are installed, run inside Neovim:
```vim
:Mason
```
Then install the language servers you need (e.g., lua_ls, tsserver, pyright).
(this paragraph is ai generated, no clue what it means)

### 5. Verify Installation
```vim
:checkhealth
```


