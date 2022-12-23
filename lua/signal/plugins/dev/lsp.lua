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
        sumneko_lua = { -- Lua
            cmd = { 'lua-language-server' },
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    },
                    runtime = {
                        version = 'LuaJIT',
                        path = get_lua_runtime_paths(),
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
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
        local kopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, kopts)
        vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, kopts)
        vim.keymap.set('n', '<Leader>li', vim.lsp.buf.implementation, kopts)
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, kopts)
        vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, kopts)
        vim.keymap.set('n', '<Leader>la', vim.lsp.buf.code_action, kopts)
        -- -- telescope
        local tsb = require 'telescope.builtin'
        local tst = require 'telescope.themes'
        vim.keymap.set('n', '<Leader>fla', function() tsb.lsp_code_actions(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>flr', function() tsb.lsp_references(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>fld', function() tsb.lsp_definitions(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>flt', function() tsb.lsp_type_definitions(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>fli', function() tsb.lsp_implementations(tst.get_cursor()) end, kopts)
        -- -- trouble
        vim.keymap.set('n', '<Leader>xt', '<cmd>TroubleToggle<cr>', kopts)
        vim.keymap.set('n', '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', kopts)
        vim.keymap.set('n', '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', kopts)
        vim.keymap.set('n', '<Leader>xl', '<cmd>TroubleToggle loclist<cr>', kopts)
        vim.keymap.set('n', '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>', kopts)
    end

    local on_attach = function(auto_format)
        if auto_format then
            return function(client, bufnr)
                -- formatting
                require('lsp-format').on_attach(client)
                set_keymaps(client, bufnr)
            end
        else
            return set_keymaps
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
