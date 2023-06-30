local M = {}

function M.rust_tools()
    local on_attach = SIGNAL_LSP_ON_ATTACH(true)
    local rt = require'rust-tools'
    rt.setup {
        server = {
            capabilities = {
                workspace = {
                    didChangeWatchedFiles = {
                        -- avoid stutter
                        dynamicRegistration = false
                    }
                }
            },
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                local kopts = { noremap = true, silent = true, buffer = bufnr }
                -- overrides hover.nvim binding
                vim.keymap.set('n', '<Leader>\'', rt.hover_actions.hover_actions, kopts)
                -- vim.keymap.set('n', '<Leader>la', rt.code_action_group.code_action_group, kopts)
                vim.keymap.set('n', '<Leader>lp', rt.parent_module.parent_module, kopts)
            end,
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
        },
        dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(
                "/usr/lib/codelldb/adapter/codelldb",
                "/usr/lib/codelldb/lldb/lib/liblldb.so"
            )
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
                    default_keybinds = false,
                    hook = function(keybinds)
                        local leader = keybinds.leader
                        keybinds.map_event_to_mode("norg", {
                            n = {
                                { leader .. "ntu", "core.qol.todo_items.todo.task_undone" },
                                { leader .. "ntp", "core.qol.todo_items.todo.task_pending" },
                                { leader .. "ntd", "core.qol.todo_items.todo.task_done" },
                                { leader .. "nth", "core.qol.todo_items.todo.task_on_hold" },
                                { leader .. "ntc", "core.qol.todo_items.todo.task_cancelled" },
                                { leader .. "ntr", "core.qol.todo_items.todo.task_recurring" },
                                { leader .. "nti", "core.qol.todo_items.todo.task_important" },
                                { leader .. "nta", "core.qol.todo_items.todo.task_ambiguous" },
                                { leader .. "ntt", "core.qol.todo_items.todo.task_cycle" },

                                { leader .. "nen", "core.dirman.new.note" },

                                { "<CR>", "core.esupports.hop.hop-link" },
                                { "<M-CR>", "core.esupports.hop.hop-link", "vsplit" },

                                { ">.", "core.promo.promote" },
                                { "<,", "core.promo.demote" },
                                { ">>", "core.promo.promote", "nested" },
                                { "<<", "core.promo.demote", "nested" },

                                { leader .. "nlt", "core.pivot.toggle-list-type" },
                                { leader .. "nli", "core.pivot.invert-list-type" },

                                { leader .. "npd", "core.tempus.insert-date" },

                                { leader .. "ncev", "core.looking-glass.magnify-code-block", "vsplit" }
                            },
                            i = {
                                { "<M-CR>", "core.itero.next-iteration" },
                                { "<M-d>", "core.tempus.insert-date-insert-mode" },
                            }
                        }, { silent = true, noremap = true })
                        keybinds.map_to_mode("all", {
                            n = {
                                { leader .. "fnn", ":Neorg mode norg<CR>" },
                                { leader .. "fnh", ":Neorg mode traverse-heading<CR>" },
                                { leader .. "n0", ":Neorg toc split<CR>" },
                            }
                        }, { silent = true, noremap = true })
                    end
                }
            },
            -- extra:
            ['core.concealer'] = {
                config = {
                    icon_preset = "varied",
                    markup_preset = "dimmed"
                }
            },
            ['core.dirman'] = {
                config = {
                    workspaces = {
                        main = "~/notes/main", -- vim.env.XDG_NOTES_DIR,
                        work = "~/notes/work", -- vim.env.XDG_NOTES_DIR,
                    },
                    index = "main.norg"
                }
            },
            ['core.journal'] = {
                workspace = "main"
            },
            ['core.ui.calendar'] = {},
            -- 3rd party
            ['core.integrations.telescope'] = {}
        },
    }
end

function M.org()
    local orgmode = require'orgmode'
    orgmode.setup_ts_grammar()
    orgmode.setup{
        org_agenda_files = { "~/notes" .. '/agenda/*' },
        org_default_notes_file = "~/notes" .. '/scratch.org'
    }
end

function M.tree_sitter_just()
    require'tree-sitter-just'.setup{}
end

function M.telekasten()
    require'telekasten'.setup{
        home = "~/notes"
    }
    local kopts = { noremap = true, silent = true }
    vim.keymap.set('n', '<Leader>fzp', '<cmd>Telekasten panel<cr>', { desc = 'telekasten :: panel', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzf', '<cmd>Telekasten find_notes<cr>', { desc = 'telekasten :: find notes (title)', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzt', '<cmd>Telekasten show_tags<cr>', { desc = 'telekasten :: tag list', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzg', '<cmd>Telekasten search_notes<cr>', { desc = 'telekasten :: search notes', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzc', '<cmd>Telekasten show_calendar<cr>', { desc = 'telekasten :: show calendar', noremap = true, silent = true })

    vim.keymap.set('n', '<Leader>fzee', '<cmd>Telekasten new_note<cr>', { desc = 'telekasten :: edit new note', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzet', '<cmd>Telekasten new_templated_note<cr>', { desc = 'telekasten :: edit new note with template', noremap = true, silent = true })

    vim.keymap.set('n', '<Leader>fzdf', '<cmd>Telekasten find_daily_notes<cr>', { desc = 'telekasten :: find notes (date)', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzdg', '<cmd>Telekasten goto_today<cr>', { desc = 'telekasten :: open current daily note', noremap = true, silent = true })

    vim.keymap.set('n', '<Leader>fzwf', '<cmd>Telekasten find_weekly_notes<cr>', { desc = 'telekasten :: find notes (week)', noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>fzwg', '<cmd>Telekasten goto_thisweek<cr>', { desc = 'telekasten :: open current weekly note', noremap = true, silent = true })
    -- more keymaps in ftplugin/telekasten.lua
end

return M
