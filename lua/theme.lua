-- lua/theme.lua
vim.o.termguicolors = true

local red = "#9e1f1f"
local bg0 = "#0f0f10"
local bg1 = "#151517"
local fg0 = "#d7d7d7"

local function hl(group, spec)
  vim.api.nvim_set_hl(0, group, spec)
end

local function apply()
  -- floats / borders
  hl("NormalFloat", { fg = fg0, bg = bg1 })
  hl("FloatBorder", { fg = red, bg = bg1 })
  hl("FloatTitle",  { fg = fg0, bg = bg1, bold = true })

  -- Neovim 0.11 LSP float groups (link to your float theme)
  hl("LspFloatNormal", { link = "NormalFloat" })
  hl("LspFloatBorder", { link = "FloatBorder" })
  hl("LspFloatTitle",  { link = "FloatTitle" })

  -- completion menu
  hl("Pmenu",       { fg = fg0, bg = bg1 })
  hl("PmenuSel",    { fg = fg0, bg = bg0, bold = true })
  hl("PmenuBorder", { fg = red, bg = bg1 })

  -- cmp links
  hl("CmpPmenu",               { link = "Pmenu" })
  hl("CmpPmenuSel",            { link = "PmenuSel" })
  hl("CmpPmenuBorder",         { link = "PmenuBorder" })
  hl("CmpDocumentation",       { link = "NormalFloat" })
  hl("CmpDocumentationBorder", { link = "FloatBorder" })

  -- LSP emphasis
  hl("LspSignatureActiveParameter", { fg = fg0, bg = bg0, bold = true })

  -- LSP hover markdown: make things like `<Native>` pop without heavy bg blocks
  hl("LspMarkdownCode",          { fg = fg0, bold = true })        -- inline code
  hl("LspMarkdownCodeBlock",     { fg = fg0, bg = bg0 })           -- fenced blocks
  hl("LspMarkdownCodeDelimiter", { fg = red, bold = true })        -- ``` fences

  -- markdown HTML tags (covers `<Native>` in many LSP hovers)
  hl("htmlTag",      { fg = red, bold = true })
  hl("htmlEndTag",   { fg = red, bold = true })
  hl("htmlTagName",  { fg = fg0, bold = true })

  -- Treesitter fallbacks (if your markdown is TS-highlighted)
  hl("@markup.heading",       { fg = "#9a8cf2", bold = true })
  hl("@markup.heading.1",     { fg = "#9a8cf2", bold = true })
  hl("@markup.heading.2",     { fg = "#9a8cf2" })
  hl("@markup.heading.3",     { fg = "#9a8cf2" })
  hl("@markup.heading.4",     { fg = "#9a8cf2" })
  hl("@markup.heading.5",     { fg = "#9a8cf2" })
  hl("@markup.heading.6",     { fg = "#9a8cf2" })
  hl("@markup.heading.marker",{ fg = "#9a8cf2", bold = true })
  hl("markdownH1",            { fg = "#9a8cf2", bold = true })
  hl("markdownH2",            { fg = "#9a8cf2" })
  hl("markdownH3",            { fg = "#9a8cf2" })
  hl("markdownH4",            { fg = "#9a8cf2" })
  hl("markdownH5",            { fg = "#9a8cf2" })
  hl("markdownH6",            { fg = "#9a8cf2" })
  hl("markdownHeadingDelimiter", { fg = "#9a8cf2", bold = true })
  hl("@tag",             { fg = fg0, bold = true })
  hl("@tag.delimiter",   { fg = red, bold = true })
  hl("@tag.attribute",   { fg = fg0 })
  hl("@markup.raw",      { fg = fg0, bold = true })
  hl("@markup.raw.block",{ bg = bg0 })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
apply()

vim.opt.winblend = 0
vim.opt.pumblend = 0
