local M = {}

function M.vgit()
    require 'vgit'.setup {

    }
end

function M.gitsigns()
    require 'gitsigns'.setup {}
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

return M
