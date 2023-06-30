return function()
    local function get_lua_runtime_paths()
        local runtime_paths = vim.split(package.path, ';')
        table.insert(runtime_paths, 'lua/?.lua')
        table.insert(runtime_paths, 'lua/?/init.lua')
        return runtime_paths
    end

    local lsp = require('lspconfig')
    -- local util = require('lspconfig/util')
    local stat = require('lsp-status')
    local schema = require('schemastore')

    local servers = {
        -- shell
        bashls = {}, -- bash
        -- C/C++
        clangd = {
            handlers = stat.extensions.clangd.setup()
        },
        cmake = {},
        -- Misc Programming Languages
        hls = {}, -- Haskell
        pyright = {}, -- Python
        vimls = {}, -- Vimscript
        lua_ls = {},
        -- sumneko_lua = { -- Lua
        --     cmd = { 'lua-language-server' },
        --     settings = {
        --         Lua = {
        --             hint = {
        --                 enable = true,
        --             },
        --             runtime = {
        --                 version = 'LuaJIT',
        --                 path = get_lua_runtime_paths(),
        --             },
        --             diagnostics = {
        --                 globals = { 'vim' },
        --             },
        --             workspace = {
        --                 library = vim.api.nvim_get_runtime_file('', true),
        --             },
        --             telemetry = {
        --                 enable = false,
        --             },
        --         },
        --     },
        -- },
        wgsl_analyzer = {},
        -- Configuration Languages
        dhall_lsp_server = {}, -- Dhall
        rnix = { auto_format = false }, -- Nix
        yamlls = {}, -- YAML
        jsonls = { -- JSON
            settings = {
                json = {
                    schemas = schema.json.schemas()
                }
            }
        },
    }

    local set_keymaps = function(client, bufnr)
        -- keymaps
        local kopts_base = { noremap = true, silent = true, buffer = bufnr }
        local kopts = function(desc)
            if desc == nil then
                return kopts_base
            else
                return {
                    noremap = kopts_base['noremap'],
                    silent = kopts_base['silent'],
                    buffer = kopts_base['buffer'],
                    desc = desc
                }
            end
        end
        vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, kopts("goto declaration"))
        vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, kopts("goto definition"))
        vim.keymap.set('n', '<Leader>li', vim.lsp.buf.implementation, kopts("goto implementation"))
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, kopts("references"))
        vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, kopts("signature help"))
        vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, kopts("actions"))
        -- -- telescope
        local ts = require'telescope'
        local tsb = require 'telescope.builtin'
        local tst = require 'telescope.themes'
        vim.keymap.set('n', '<Leader>fla', function() tsb.lsp_code_actions(tst.get_cursor()) end, kopts("actions"))
        vim.keymap.set('n', '<Leader>flr', function() tsb.lsp_references(tst.get_cursor()) end, kopts("references"))
        vim.keymap.set('n', '<Leader>fld', function() tsb.lsp_definitions(tst.get_cursor()) end, kopts("definitions"))
        vim.keymap.set('n', '<Leader>flt', function() tsb.lsp_type_definitions(tst.get_cursor()) end, kopts("type definitions"))
        vim.keymap.set('n', '<Leader>fli', function() tsb.lsp_implementations(tst.get_cursor()) end, kopts("implementations"))
        -- -- trouble
        vim.keymap.set('n', '<Leader>xt', '<cmd>TroubleToggle<cr>', kopts("toggle issues"))
        vim.keymap.set('n', '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', kopts("workspace diagnostics"))
        vim.keymap.set('n', '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', kopts("document diagnostics"))
        vim.keymap.set('n', '<Leader>xl', '<cmd>TroubleToggle loclist<cr>', kopts("loclist"))
        vim.keymap.set('n', '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>', kopts("quickfix"))
        -- -- dap
        local dap = require'dap'
        local dapui = require'dapui'
        local tsdap = ts.extensions.dap
        vim.keymap.set('n', '<Leader>du', function() dapui.toggle{} end, kopts("toggle dapui"))
        vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, kopts("toggle breakpoint"))
        vim.keymap.set('n', '<F5>', function() dap.continue() end, kopts("dap :: continue"))
        vim.keymap.set('n', '<S-<F5>>', function() dap.restart() end, kopts("dap :: restart"))
        vim.keymap.set('n', '<C-S-<F5>>', function() dap.run_last() end, kopts("dap :: run last"))
        vim.keymap.set('n', '<F10>', function() dap.step_over() end, kopts("dap :: step over"))
        vim.keymap.set('n', '<F11>', function() dap.step_into() end, kopts("dap :: step into"))
        vim.keymap.set('n', '<S-<F11>>', function() dap.step_out() end, kopts("dap :: step out"))
        vim.keymap.set('n', '<Leader>dsi', function() dap.step_into() end, kopts("dap :: step into"))
        vim.keymap.set('n', '<Leader>fdc', function() tsdap.commands{} end, kopts("dap :: commands"))
        vim.keymap.set('n', '<Leader>fdo', function() tsdap.configurations{} end, kopts("dap :: configurations"))
        vim.keymap.set('n', '<Leader>fdb', function() tsdap.list_breakpoints{} end, kopts("dap :: breakpoints"))
        vim.keymap.set('n', '<Leader>fdv', function() tsdap.variables{} end, kopts("dap :: variables"))
        vim.keymap.set('n', '<Leader>fdf', function() tsdap.frames{} end, kopts("dap :: frames"))
    end

    local setup_dap = function(client, bufnr)
        require'dap.ext.vscode'.load_launchjs()
    end

    local __on_attach = function(client, bufnr)
        set_keymaps(client, bufnr)
        setup_dap(client, bufnr)
    end

    local on_attach = function(auto_format)
        if auto_format then
            return function(client, bufnr)
                -- formatting
                require('lsp-format').on_attach(client)
                __on_attach(client, bufnr)
            end
        else
            return __on_attach
        end
    end

    -- set global variable so rust-tools can use it
    SIGNAL_LSP_ON_ATTACH = on_attach

    for srv, cfg in pairs(servers) do
        local auto_format = false
        if cfg['auto_format'] ~= nil then
            auto_format = cfg.auto_format
            cfg.auto_format = nil
        end

        if cfg['on_attach'] == nil then
            cfg.on_attach = on_attach(auto_format)
        end

        lsp[srv].setup(cfg)
    end
end
