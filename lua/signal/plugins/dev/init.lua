local M = {}

function M.vgit()
    require 'vgit'.setup {
        keymaps = {
            ['n <Leader>ggj'] = function() require('vgit').hunk_down() end,
            ['n <Leader>ggk'] = function() require('vgit').hunk_up() end,
            ['n <Leader>gpd'] = function() require('vgit').buffer_hunk_preview() end,
            ['n <Leader>gpsd'] = function() require('vgit').buffer_hunk_staged_preview() end,
            ['n <Leader>gph'] = function() require('vgit').buffer_history_preview() end,
            ['n <Leader>gppd'] = function() require('vgit').project_diff_preview() end,
        }
    }
end

function M.neogit()
    local diffview = require'diffview' -- load-bearing for diffview integration
    local neogit = require'neogit'
    neogit.setup{
        integrations = {
            diffview = true
        }
    }
    vim.keymap.set('n', '<Leader>gno', function() neogit.open() end, { desc = "neogit :: open" })
    vim.keymap.set('n', '<Leader>gnc', function() neogit.open({"commit"}) end, { desc = "neogit :: commit" })
end

function M.diffview()
    local actions = require'diffview.actions'
    require'diffview'.setup{
        diff_binaries = false,
        use_icons = true,
        keymaps = {
            -- disable_defaults = true,
            -- view = {
            -- },
        }
    }
end

function M.git_conflict()
    require'git-conflict'.setup{
        default_mappings = {
            ours = '<Leader>gcl', -- 'local'
            theirs = '<Leader>gcr', -- 'remote'
            none = '<Leader>gc0',
            both = '<Leader>gcb',
            next = '<Leader>gcn',
            prev = '<Leader>gcN',
        }
    }
end

function M.gitsigns()
    require 'gitsigns'.setup {}
end

function M.octo()
    require'octo'.setup{

    }

    -- vim.keymap.set('n', '<Leader>gh')

    vim.treesitter.language.register('markdown', 'octo')
end

function M.setup_coq()
    vim.g.coq_settings = { auto_start = 'shut-up' }
    -- require 'coq'.setup {}
end

function M.treesitter()
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { 'c', 'lua', 'rust', 'vim', 'regex', 'bash', 'markdown', 'markdown_inline', 'org' },
        auto_install = true,
        highlight = {
            enable = true,
            -- disable = function(lang, buf) -- disable highlighting for files > 1MiB
            --     local max_filesize = 1024 * 1024 -- 1MiB
            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --     if ok and stats.size > max_filesize then
            --         return true
            --     end
            -- end
        }
    }
end

function M.neoformat()
    local group = vim.api.nvim_create_augroup('fmt', {})
    vim.api.nvim_create_autocmd({'BufWritePre'}, {
        group = group,
        pattern = { '*.nix' },
        command = 'undojoin | Neoformat',
        desc = 'run neoformat on save for matching files'
    })
end

function M.lsp_format()
    require('lsp-format').setup{}
end

function M.comment()
    require 'Comment'.setup {

    }
end

M.lsp = require('signal.plugins.dev.lsp')

function M.conjure()

end

function M.dap()
    local dap = require'dap'
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb"
    }
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = "/usr/lib/codelldb/adapter/codelldb",
            args = { "--port", "${port}" }
        }
    }
    dap.configurations.rust = {
        {
            name = "Launch (codelldb)",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false
        }
    }
    dap.configurations.cpp = dap.configurations.rust
    dap.configurations.c = dap.configurations.rust
end

return M
