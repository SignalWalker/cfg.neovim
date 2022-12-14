local M = {}

function M.which_key()
    require 'which-key'.setup {}
end

function M.notify()
    local notify = require('notify')
    notify.setup {
        stages = 'static',
        fps = 120,
    }
    vim.notify = notify
    local ts = require('telescope')
    ts.load_extension("notify")
    vim.keymap.set('n', '<Leader>fvn', ts.extensions.notify.notify, { desc = 'telescope :: notifications' })
end

function M.hologram()
    require('hologram').setup{
        auto_display = true
    }
end

function M.gui_font_resize()
    require('gui-font-resize').setup{
        default_size = 9,
        change_by = 1,
        bounds = {
            maximum = 24,
            minimum = 6
        }
    }
    vim.keymap.set("n", '<D-Plus>', '<cmd>:GUIFontSizeUp<cr>', { desc = "increase gui font size" })
    vim.keymap.set("n", '<D-Minus>', '<cmd>:GUIFontSizeDown<cr>', { desc = "decrease gui font size" })
    vim.keymap.set("n", '<D-Equal>', '<cmd>:GUIFontSizeSet<cr>', { desc = "reset gui font size" })
    vim.keymap.set("n", '<D-kPlus>', '<cmd>:GUIFontSizeUp<cr>', { desc = "increase gui font size" })
    vim.keymap.set("n", '<D-kMinus>', '<cmd>:GUIFontSizeDown<cr>', { desc = "decrease gui font size" })
end

function M.hover()
    local hover = require 'hover'
    hover.setup {
        init = function()
            require 'hover.providers.lsp'
            require 'hover.providers.gh'
            require 'hover.providers.gh_user'
            require 'hover.providers.man'
            require 'hover.providers.dictionary'
        end,
        preview_opts = {
            border = nil,
        },
        preview_window = false,
        title = true,
    }
    vim.keymap.set('n', '<Leader>\'', require("hover").hover, { desc = "hover.nvim" })
    vim.keymap.set('n', '<Leader>g\'', require("hover").hover_select, { desc = "hover.nvim (select)" })
end

function M.noice()
    require('noice').setup {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                ["vim.lsp.util.stylize_markdown"] = false,
                ["cmp.entry.get_documentation"] = false,
            }
        }
    }
	local ts = require('telescope')
    ts.load_extension("noice")
    vim.keymap.set('n', '<Leader>fvm', ts.extensions.noice.noice, { desc = 'telescope :: messages' })
end

function M.trouble()
    require('trouble').setup {

    }

    -- keymaps set in lspconfig on_attach()

end

function M.leap()
    -- forward: s
    -- backward: S
    local leap = require'leap'
    leap.add_default_mappings()
end

function M.flit()
    -- forward to: f
    -- backward to: F
    -- forward before: t
    -- backward before: T
    require('flit').setup{}
end

function M.indent_guides()
    require('indent_blankline').setup {
        buftype_exclude = { 'terminal', 'alpha', 'help', 'packer', 'dashboard' },
        show_current_context = true,
    }
end

function M.lualine()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '???', right = '???' },
            section_separators = { left = '???', right = '???' },
            disabled_filetypes = {},
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diagnostics' },
            lualine_c = { 'hostname', { 'filename', path = 1 } },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'hostname', { 'filename', path = 1 } },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = { 'buffers' },
            lualine_b = { 'branch' },
            lualine_c = { 'hostname', { 'filename', path = 2 } },
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'tabs' }
        },
        extensions = {
            'nvim-tree',
        }
    }
end

M.dashboard = require('signal.plugins.ui.dashboard')

function M.window_picker()
    require('window-picker').setup{
        autoselect_one = true,
        include_current = false,
        filter_rules = {
            bo = {
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                buftype = { 'terminal', 'quickfix' }
            }
        },
    }
end

M.neotree = require('signal.plugins.ui.neotree')

function M.dap_ui()
    local dapui = require'dapui'
    dapui.setup{}

    local dap = require'dap'
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
    dap.listeners.after.event_terminated['dapui_config'] = function() dapui.close({}) end
    dap.listeners.after.event_exited['dapui_config'] = function() dapui.close({}) end
end

M.nvimtree = require('signal.plugins.ui.nvimtree')

function M.project()
    require('project_nvim').setup {
        exclude_dirs = { "~/.local/share/cargo/*" },
        scope_chdir = 'win',
        ignore_lsp = { "sumneko_lua" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "flake.nix" },
    }
    local ts = require('telescope')
    ts.load_extension('projects')
    vim.keymap.set('n', '<Leader>ffp', ts.extensions.projects.projects, { desc = 'telescope :: projects' })
end

function M.telescope()
    local ts = require 'telescope'
    ts.setup {
        extensions = {
            file_browser = {
                hijack_netrw = false,
            },
            project = {
                sync_with_nvim_tree = true
            }
        }
    }
    -- keymaps
    local tsb = require 'telescope.builtin'

    -- files
    vim.keymap.set('n', '<Leader>fff', tsb.find_files, { desc = 'tsb.find_files' })
    vim.keymap.set('n', '<Leader>ffi', tsb.git_files, { desc = 'tsb.git_files' })
    -- vim.keymap.set('n', '<Leader>ffb', tsb.file_browser, {desc = 'tsb.file_browser'})
    vim.keymap.set('n', '<Leader>ffr', tsb.oldfiles, { desc = 'tsb.oldfiles' })
    vim.keymap.set('n', '<Leader>ffg', tsb.live_grep, { desc = 'tsb.live_grep' })

    -- buffer
    vim.keymap.set('n', '<Leader>fbf', tsb.current_buffer_fuzzy_find, { desc = 'tsb.current_buffer_fuzzy_find' })

    -- commands
    vim.keymap.set('n', '<Leader>fcc', tsb.commands, { desc = 'tsb.commands' })
    vim.keymap.set('n', '<Leader>fch', tsb.command_history, { desc = 'tsb.command_history' })

    -- help
    vim.keymap.set('n', '<Leader>fhm', tsb.man_pages, { desc = 'tsb.man_pages' })

    -- nvim meta
    vim.keymap.set('n', '<Leader>fvh', tsb.help_tags, { desc = 'tsb.help_tags' })
    vim.keymap.set('n', '<Leader>fvc', tsb.colorscheme, { desc = 'tsb.colorscheme' })
    vim.keymap.set('n', '<Leader>fvb', tsb.buffers, { desc = 'tsb.buffers' })
    vim.keymap.set('n', '<Leader>fvo', tsb.vim_options, { desc = 'tsb.vim_options' })
    vim.keymap.set('n', '<Leader>fvr', tsb.registers, { desc = 'tsb.registers' })
    vim.keymap.set('n', '<Leader>fva', tsb.autocommands, { desc = 'tsb.autocommands' })
    vim.keymap.set('n', '<Leader>fvk', tsb.keymaps, { desc = 'tsb.keymaps' })

    -- lsp
    -- set by on_attach() in lspconfig
    -- vim.keymap.set('n', '<Leader>flo', tsb.lsp_document_diagnostics, {desc = 'tsb.lsp_document_diagnostics'})
    -- vim.keymap.set('n', '<Leader>flw', tsb.lsp_workspace_diagnostics, {desc = 'tsb.lsp_workspace_diagnostics'})

    -- git
    vim.keymap.set('n', '<Leader>fgc', tsb.git_commits, { desc = 'tsb.git_commits' })
    vim.keymap.set('n', '<Leader>fgb', tsb.git_branches, { desc = 'tsb.git_branches' })
    vim.keymap.set('n', '<Leader>fgs', tsb.git_status, { desc = 'tsb.git_status' })

end

function M.telescope_file_browser()
	local ts = require('telescope')
    ts.load_extension('file_browser')
    vim.keymap.set('n', '<Leader>ffb', ts.extensions.file_browser.file_browser, { desc = 'telescope :: file browser' })
end

function M.telescope_fzf_native()
    require 'telescope'.load_extension('fzf')
end

function M.telescope_project()
    require 'telescope'.load_extension('project')
end

return M
