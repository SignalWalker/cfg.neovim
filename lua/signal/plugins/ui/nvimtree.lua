return function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true
    require 'nvim-tree'.setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        open_on_setup_file = false,
        ignore_ft_on_setup = { 'startify', 'alpha' },
        ignore_buf_on_tab_change = {},
        auto_reload_on_write = true,
        create_in_closed_folder = true,
        sort_by = 'extension',
        hijack_cursor = true,
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = true,
        respect_buf_cwd = false,
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_root = true,
            ignore_list = {}
        },
        system_open = {
            cmd = "",
            args = {},
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = false,
        },
        git = {
            enable = true,
            ignore = true,
            show_on_dirs = true,
            show_on_open_dirs = false,
        },
        filesystem_watchers = {
            enable = true
        },
        remove_keymaps = false,
        select_prompts = true,
        view = {
            adaptive_size = false,
            centralize_selection = false,
            hide_root_folder = false,
        },
        renderer = {
            add_trailing = false,
            group_empty = true,
            full_name = true,
            highlight_opened_files = 'name',
            indent_markers = {
                enable = false,
            },
            icons = {
                webdev_colors = true,
                git_placement = 'signcolumn',
            }
        },
        filters = {
            dotfiles = true,
            exclude = { '.gitignore', '.well-known' }
        },
        actions = {
            change_dir = {
                enable = true,
            },
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    enable = true,
                }
            },
            remove_file = {
                close_window = false,
            },
            use_system_clipboard = true,
        },
        log = {
            enable = false,
            truncate = true,
        }
    }
    vim.keymap.set('n', '<Leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = 'nvim-tree toggle' })
    vim.keymap.set('n', '<Leader>tf', '<cmd>NvimTreeFindFile<cr>', { desc = 'nvim-tree find file' })
end
