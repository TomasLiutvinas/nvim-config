return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
    config = function()
        require('render-markdown').setup({
            heading = {
                sign = false,
                position = 'overlay',
                width = 'block',
                border = false,
            },
            code = {
                sign = false,
                border = 'none',
                width = 'block',
            },
            pipe_table = {
                style = 'full',
            },
        })

        local function hl(group, spec)
            vim.api.nvim_set_hl(0, group, spec)
        end

        local function apply_highlights()
            local heading_fg = {
                "#9a8cf2", -- muted purple
                "#9a8cf2", -- muted purple
                "#9a8cf2", -- muted purple
                "#9a8cf2", -- muted purple
                "#9a8cf2", -- muted purple
                "#9a8cf2", -- muted purple
            }
            for i, fg in ipairs(heading_fg) do
                hl('RenderMarkdownH' .. i, { fg = fg, bold = i == 1 })
                hl('RenderMarkdownH' .. i .. 'Bg', {})
            end

            hl('RenderMarkdownCode',       {})
            hl('RenderMarkdownCodeInfo',   { fg = "#9a8cf2" })
            hl('RenderMarkdownCodeBorder', { fg = "#5c6370" })
            hl('RenderMarkdownCodeInline', { fg = "#73c48f" })

            hl('RenderMarkdownTableHead', { fg = "#9a8cf2", bold = true })
            hl('RenderMarkdownTableRow',  { fg = "#d7d7d7" })
            hl('RenderMarkdownTableFill', { fg = "#5c6370" })

            hl('RenderMarkdownLink', { fg = "#f43753" })
        end

        apply_highlights()
        vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_highlights })
    end,
}
