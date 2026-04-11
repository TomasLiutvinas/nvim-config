-- debug_theme.lua
-- Run this in Neovim with: :luafile debug_theme.lua

print("\n=== THEME DEBUG DIAGNOSTICS ===\n")

-- 1. Check if theme.lua is loaded
print("1. THEME MODULE CHECK")
local theme_loaded, theme_module = pcall(require, "theme")
print("   theme.lua loaded: " .. tostring(theme_loaded))
if not theme_loaded then
  print("   ERROR: " .. tostring(theme_module))
end

-- 2. Check highlight groups
print("\n2. HIGHLIGHT GROUPS CHECK")
local function check_hl(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if next(hl) == nil then
    print("   ❌ " .. name .. " - NOT DEFINED")
    return false
  else
    local fg = hl.fg and string.format("#%06x", hl.fg) or "none"
    local bg = hl.bg and string.format("#%06x", hl.bg) or "none"
    print("   ✓ " .. name .. " - fg: " .. fg .. ", bg: " .. bg)
    return true
  end
end

local critical_groups = {
  "Pmenu",
  "PmenuSel",
  "PmenuBorder",
  "NormalFloat",
  "FloatBorder",
}

for _, group in ipairs(critical_groups) do
  check_hl(group)
end

-- 3. Check expected values
print("\n3. EXPECTED VALUES (from theme.lua)")
print("   Pmenu:       fg=#d7d7d7, bg=#151517")
print("   PmenuSel:    fg=#d7d7d7, bg=#0f0f10 (bold)")
print("   PmenuBorder: fg=#9e1f1f, bg=#151517")
print("   FloatBorder: fg=#9e1f1f, bg=#151517")

-- 4. Check ColorScheme autocmd
print("\n4. COLORSCHEME AUTOCMD CHECK")
local autocmds = vim.api.nvim_get_autocmds({ event = "ColorScheme" })
if #autocmds > 0 then
  print("   ✓ Found " .. #autocmds .. " ColorScheme autocmd(s)")
  for i, cmd in ipairs(autocmds) do
    local pattern = cmd.pattern or "*"
    local group = cmd.group_name or "none"
    print("   [" .. i .. "] pattern: " .. pattern .. ", group: " .. group)
  end
else
  print("   ❌ No ColorScheme autocmds found!")
end

-- 5. Check current colorscheme
print("\n5. COLORSCHEME INFO")
local colorscheme = vim.g.colors_name or "none"
print("   Current colorscheme: " .. colorscheme)

-- 6. Check load order from scriptnames
print("\n6. LOAD ORDER CHECK")
local scripts = vim.api.nvim_exec2("scriptnames", { output = true }).output
local theme_line = nil
local lsp_config_line = nil
local tomsen_init_line = nil

for line in scripts:gmatch("[^\r\n]+") do
  local num, path = line:match("^%s*(%d+):%s*(.+)$")
  if num and path then
    if path:match("theme%.lua$") then
      theme_line = tonumber(num)
      print("   theme.lua at line " .. num)
    end
    if path:match("lsp_config%.lua$") then
      lsp_config_line = tonumber(num)
      print("   lsp_config.lua at line " .. num)
    end
    if path:match("tomsen_init%.lua$") then
      tomsen_init_line = tonumber(num)
      print("   tomsen_init.lua at line " .. num)
    end
  end
end

if theme_line and tomsen_init_line then
  if theme_line < tomsen_init_line then
    print("   ✓ Load order CORRECT: theme before plugins")
  else
    print("   ❌ Load order WRONG: theme after plugins")
  end
end

-- 7. Check cmp status
print("\n7. NVIM-CMP CHECK")
local cmp_loaded, cmp = pcall(require, "cmp")
if cmp_loaded then
  print("   ✓ nvim-cmp loaded")
  local config = cmp.get_config()
  if config and config.window then
    print("   ✓ cmp has window config")
    if config.window.completion then
      print("   ✓ cmp has completion window config")
    else
      print("   ❌ cmp missing completion window config")
    end
  else
    print("   ❌ cmp has no window config")
  end
else
  print("   ❌ nvim-cmp NOT loaded: " .. tostring(cmp))
end

-- 8. Manual fix test
print("\n8. MANUAL FIX TEST")
print("   Run these commands to test if manual apply works:")
print("   :lua require('theme')")
print("   :colorscheme tender")
print("   :lua print(vim.inspect(vim.api.nvim_get_hl(0, {name='PmenuBorder'})))")

-- 9. Recommendations
print("\n9. RECOMMENDATIONS")
local issues = {}

if not theme_loaded then
  table.insert(issues, "Theme module not loading")
end

local pmenu_hl = vim.api.nvim_get_hl(0, { name = "Pmenu" })
if next(pmenu_hl) == nil or not pmenu_hl.bg then
  table.insert(issues, "Pmenu highlights not applied")
end

if #autocmds == 0 then
  table.insert(issues, "ColorScheme autocmd missing")
end

if theme_line and tomsen_init_line and theme_line > tomsen_init_line then
  table.insert(issues, "Wrong load order")
end

if #issues == 0 then
  print("   ✅ No issues detected - theme should be working")
  print("   If completion still looks wrong, try: :colorscheme tender")
else
  print("   ❌ Issues found:")
  for _, issue in ipairs(issues) do
    print("      - " .. issue)
  end
end

print("\n=== END DEBUG ===\n")
