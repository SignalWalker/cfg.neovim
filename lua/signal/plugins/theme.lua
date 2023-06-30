local M = {}

function M.catppuccin()
    require('catppuccin').setup {
        flavor = 'frappe',
        background = {
            light = "latte",
            dark = "frappe"
        },
        term_colors = true,
        transparent_background = true,
        integrations = {
            notify = true
        }
    }
end

function M.kanagawa()
    require'kanagawa'.setup {}
end

function M.setup_everforest()
    vim.opt.termguicolors = true
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_background = 'soft'
    vim.g.everforest_better_performance = 1
    vim.g.everforest_transparent_background = 1
    vim.g.everforest_ui_contrast = 'low'
end

function M.everforest()
    vim.cmd.colorscheme 'everforest'
end

function M.setup_gruvbox()
    vim.g.gruvbox_material_better_performance = 1
end

function M.gruvbox()
end

return M
