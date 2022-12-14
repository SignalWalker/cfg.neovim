local M = {}

function M.rust_tools()
    require('rust-tools').setup {
        server = {
            cmd = { "/home/ash/.local/bin/rust-analyzer" }, -- neovide can't find it in $PATH for some reason, so...
            on_attach = SIGNAL_LSP_ON_ATTACH(true),
            imports = {
                granularity = {
                    enforce = true,
                    group = 'crate',
                },
                merge = {
                    glob = false,
                },
                prefix = 'crate',
            },
            cargo = {
                features = 'all',
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = 'clippy',
            },
            diagnostics = {
                experimental = {
                    enable = true,
                },
            },
        }
    }
end

function M.crates()
    require('crates').setup {
        src = {
            coq = {
                enabled = true,
                name = "crates.nvim"
            }
        }
    }
end

function M.neorg()
    require('neorg').setup {
        load = {
            -- defaults:
            ['core.defaults'] = {},
            ['core.keybinds'] = {
                config = {
                    default_keybinds = false
                }
            },
            -- extra:
            ['core.norg.concealer'] = {
                config = {
                    icon_preset = "varied",
                    markup_preset = "dimmed"
                }
            },
            -- ['core.norg.dirman'] = {
            --     config = {
            --         workspaces = {
            --             main = "$XDG_NOTE_DIR",
            --         }
            --     }
            -- },
        },
    }
end

function M.org()
    local orgmode = require'orgmode'
    orgmode.setup_ts_grammar()
    orgmode.setup{
        org_agenda_files = { '~/notes/agenda/*' },
        org_default_notes_file = '~/notes/scratch.org'
    }
end

function M.tree_sitter_just()
    require'tree-sitter-just'.setup{}
end

return M
