local M = {}

function M.aniseed()

end

function M.local_fennel()
end

function M.session()
    local Path = require('plenary.path')
    require'session_manager'.setup{
        sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
        autosave_ignore_filetypes = META_FILETYPES,
        autosave_ignore_buftypes = META_BUFTYPES
    }

    -- open nvim-tree after loading a session
    vim.api.nvim_create_autocmd({'User'}, {
        pattern = "SessionLoadPost",
        callback = function()
            require('nvim-tree.api').tree.open()
        end
    })

    vim.keymap.set('n', '<Leader>vsls', '<cmd>SessionManager load_session<cr>', { desc = "load session" })
    vim.keymap.set('n', '<Leader>vsld', '<cmd>SessionManager load_current_dir_session<cr>', { desc = "load last saved session for current directory" })
    vim.keymap.set('n', '<Leader>vss', '<cmd>SessionManager save_current_session<cr>', { desc = "save current session" })
    vim.keymap.set('n', '<Leader>vsd', '<cmd>SessionManager delete_session<cr>', { desc = "delete saved session" })
end

function M.startup_time()
    require'nvim-startup'.setup{
        startup_file = '/tmp/nvim-startuptime'
    }
end

function M.setup_direnv()
    vim.g.direnv_auto = 1
    vim.api.nvim_create_autocmd({'User'}, {
        pattern = "DirenvLoaded",
        callback = function()
            -- vim.notify("Loaded .envrc for " .. vim.fn.getcwd())
        end
    })
end


return M
