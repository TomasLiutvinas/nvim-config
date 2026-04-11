-- test_completion.lua
-- Quick test to verify completion menu styling is working
-- Run with: nvim -u NONE -c "source test_completion.lua"

print("=== Completion Styling Test ===\n")

-- 1. Check if Pmenu highlights are defined
local function check_highlight(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if next(hl) == nil then
    print("❌ " .. name .. " - NOT DEFINED")
    return false
  else
    local fg = hl.fg and string.format("#%06x", hl.fg) or "none"
    local bg = hl.bg and string.format("#%06x", hl.bg) or "none"
    print("✓ " .. name)
    print("   fg: " .. fg .. ", bg: " .. bg)
    return true
  end
end

print("Checking highlight groups:\n")
local highlights = {
  "Pmenu",
  "PmenuSel",
  "PmenuBorder",
  "NormalFloat",
  "FloatBorder",
}

local all_ok = true
for _, hl_name in ipairs(highlights) do
  if not check_highlight(hl_name) then
    all_ok = false
  end
end

print("\n--- Expected Values (from theme.lua) ---")
print("Pmenu:       fg=#d7d7d7, bg=#151517")
print("PmenuSel:    fg=#d7d7d7, bg=#0f0f10 (bold)")
print("PmenuBorder: fg=#9e1f1f, bg=#151517")
print("FloatBorder: fg=#9e1f1f, bg=#151517")

print("\n--- Load Order Check ---")
local scripts = vim.api.nvim_exec2("scriptnames", { output = true }).output
local theme_line = nil
local lazy_line = nil

for line_num, line in ipairs(vim.split(scripts, "\n")) do
  if line:match("theme%.lua") then
    theme_line = line_num
    print("✓ theme.lua loaded at line " .. line_num)
  end
  if line:match("tomsen_init%.lua") or line:match("lazy%.nvim") then
    lazy_line = line_num
    print("✓ plugin manager loaded at line " .. line_num)
  end
end

if theme_line and lazy_line then
  if theme_line < lazy_line then
    print("✓ Load order correct: theme.lua loads BEFORE plugins")
  else
    print("❌ Load order wrong: theme.lua loads AFTER plugins")
    all_ok = false
  end
end

print("\n--- ColorScheme Event Check ---")
local autocmds = vim.api.nvim_get_autocmds({ event = "ColorScheme" })
local has_theme_autocmd = false
for _, autocmd in ipairs(autocmds) do
  if autocmd.callback then
    has_theme_autocmd = true
    print("✓ ColorScheme autocmd registered")
    break
  end
end
if not has_theme_autocmd then
  print("❌ No ColorScheme autocmd found")
  all_ok = false
end

print("\n=== Result ===")
if all_ok then
  print("✅ All checks passed! Completion styling should work.")
else
  print("❌ Issues found. Check output above.")
end

print("\n=== Manual Test ===")
print("1. Open a file with LSP support")
print("2. Start typing to trigger completion")
print("3. Verify completion menu has red borders and custom colors")
print("\nOr run: :lua vim.cmd('colorscheme tender')")
print("Then check: :hi Pmenu")
