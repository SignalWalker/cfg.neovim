local packer_dir = vim.fn.stdpath('data') .. '/site/pack/packer'

local function ensure_packer()
    local fn = vim.fn
    -- check for system packer
    local p_ok, packer = pcall(require, 'packer')
    if not p_ok then
        -- no system packer; install locally
        local install_path = packer_dir .. '/start/packer.nvim'
        if fn.empty(fn.glob(install_path)) > 0 then
            vim.notify("Bootstrapping packer...", "info")
            fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
            vim.cmd [[packadd packer.nvim]]
            return true, require('packer')
        else
            vim.notify("Failed to bootstrap packer: install directory not empty: " .. install_path, "error")
            return true, {}
        end
    end
    return false, packer
end

local bootstrap, packer = ensure_packer()

-- package map
local packages = {
    meta = {
        'wbthomason/packer.nvim',
        'lewis6991/impatient.nvim',
    },
    ui = {
        notify = {
            'rcarriga/nvim-notify',
            after = {
                'telescope.nvim'
            }
        },
        hover = 'lewis6991/hover.nvim',
        leap = { -- cursor jump on s & S
            'ggandor/leap.nvim',
            requires = {
                'tpope/vim-repeat', -- dot repeats
            }
        },
        flit = 'ggandor/flit.nvim', -- better f/t motions
        spooky = 'ggandor/leap-spooky.nvim', -- actions at a distance using leap motions
        indent_guides = 'lukas-reineke/indent-blankline.nvim',
        which_key = 'folke/which-key.nvim',
        -- chadtree = {
        --     'ms-jpq/chadtree',
        --     branch = 'chad',
        --     run = ':CHADdeps'
        -- },
        lualine = {
            'nvim-lualine/lualine.nvim',
            requires = {
                'nvim-tree/nvim-web-devicons'
            }
        },
        hologram = { -- image previews
            'edluffy/hologram.nvim',
            -- only supported in kitty (avoid loading in, for example, neovide)
            cond = function() return vim.env.TERM == "xterm-kitty" end
        },
        -- dashboard = {
        --     'goolord/alpha-nvim',
        --     requires = { 'nvim-tree/nvim-web-devicons' },
        -- },
        project = {
            'ahmedkhalf/project.nvim',
            after = {
                'telescope.nvim'
            }
        },
        window_picker = {
            's1n7ax/nvim-window-picker',
            tag = 'v1.*',
        },
        -- neotree = {
        --     'miversen33/netman.nvim',
        --     tag = "2.*",
        --     requires = {
        --         'nvim-lua/plenary.nvim',
        --         'nvim-tree/nvim-web-devicons',
        --         'MunifTanjim/nui.nvim',
        --         's1n7ax/nvim-window-picker'
        --     },
        -- },
        nvimtree = {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            }
        },
        -- noice = {
        --     'folke/noice.nvim',
        --     requires = {
        --         'MunifTanjim/nui.nvim',
        --         'rcarriga/nvim-notify',
        --         'nvim-treesitter/nvim-treesitter'
        --     },
        --     after = 'telescope.nvim'
        -- },
        trouble = {
            'folke/trouble.nvim',
            requires = {
                'nvim-tree/nvim-web-devicons'
            }
        },
        telescope = {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons',
            }
        },
        telescope_fzf_native = {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            after = 'telescope.nvim',
        },
        telescope_file_browser = {
            'nvim-telescope/telescope-file-browser.nvim',
            after = 'telescope.nvim',
        },
        -- telescope_project = {
        --     'nvim-telescope/telescope-project.nvim',
        --     requires = 'nvim-telescope/telescope.nvim'
        -- },
        gui_font_resize = 'ktunprasert/gui-font-resize.nvim',
        dap_ui = {
            'rcarriga/nvim-dap-ui',
            requires = { 'mfussenegger/nvim-dap' },
            after = { 'nvim-dap' }
        }
    },
    general = {
        'tpope/vim-sleuth',
        { -- strip whitespace while editting
            'lewis6991/spaceless.nvim',
            config = function()
                require 'spaceless'.setup()
            end
        }
    },
    dev = {
        treesitter = {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require 'nvim-treesitter.install'.update({ with_sync = true })
                ts_update()
            end
        },
        lsp = {
            'neovim/nvim-lspconfig',
            requires = {
                'b0o/SchemaStore.nvim',
                'nvim-lua/lsp-status.nvim',
                -- formatting
                'lukas-reineke/lsp-format.nvim'
            },
            after = { 'lsp-format.nvim' }
        },
        coq = { -- completion
            'ms-jpq/coq_nvim',
            branch = 'coq',
            run = ':COQdeps'
        },
        coq_artifacts = {
            'ms-jpq/coq.artifacts',
            branch = 'artifacts',
        },
        coq_thirdparty = {
            'ms-jpq/coq.thirdparty',
            branch = '3p',
            after = { 'orgmode' }
        },
        gitsigns = 'lewis6991/gitsigns.nvim',
        comment = 'numToStr/Comment.nvim',
        neoformat = 'sbdchd/neoformat',
        lsp_format = 'lukas-reineke/lsp-format.nvim',
        dap = 'mfussenegger/nvim-dap',
    },
    lang = {
        rust_tools = {
            'simrat39/rust-tools.nvim',
            requires = {
                'neovim/nvim-lspconfig',
                'nvim-lua/plenary.nvim',
                'mfussenegger/nvim-dap'
            },
            after = { 'nvim-lspconfig' }
        },
        crates = { 'saecki/crates.nvim',
            branch = 'main',
            requires = { 'nvim-lua/plenary.nvim' },
            event = { 'BufRead Cargo.toml' },
        },
        neorg = {
            'nvim-neorg/neorg',
            -- tag = "*", -- latest stable
            run = ':Neorg sync-parsers',
            requires = { 'nvim-lua/plenary.nvim' },
            ft = { "norg" },
            after = { "nvim-treesitter", "telescope.nvim" },
        },
        org = {
            'nvim-orgmode/orgmode',
            requires = { 'nvim-treesitter/nvim-treesitter' },
            after = { 'nvim-treesitter' }
        },
        tree_sitter_just = {
            'IndianBoy42/tree-sitter-just',
            requires = {
                'nvim-treesitter/nvim-treesitter'
            },
        }
    },
    theme = {
        'sainnhe/gruvbox-material',
        everforest = 'sainnhe/everforest',
        'sainnhe/edge',
        'sainnhe/sonokai',
        kanagawa = 'rebelot/kanagawa.nvim',
        catppuccin = {
            'catppuccin/nvim',
            as = 'catppuccin'
        }
    }
}

return packer.startup({
    config = {
        compile_path = vim.fn.stdpath('cache') .. '/plugin/packer_compiled.lua',
        display = {
            open_fn = require('packer.util').float,
        },
        profile = {
            enable = false,
        },
        autoremove = true,
    },
    function(use)
        local pkg_set = {}
        for name, grp in pairs(packages) do
            local s_ok, setup = pcall(require, 'signal.plugins.' .. name)
            if not s_ok then
                vim.notify("Could not load plugin group config module: signal.plugins." .. name, "warn")
                setup = {}
            end
            if type(setup) ~= 'table' then
                vim.notify("Loaded plugin group module is not a table of functions: signal.plugins." .. name, "error")
                setup = {}
            end
            -- for each package in grp, load the package & apply a config function if specified (based on package key & group)
            for key, cfg in pairs(grp) do
                if type(cfg) == 'string' then cfg = { cfg } end
                -- functions that run *before* plugin is loaded
                if cfg['setup'] == nil and setup['setup_' .. key] ~= nil then
                    cfg.setup = setup['setup_' .. key]
                end
                -- functions that run *after* plugin is loaded
                if cfg['config'] == nil and setup[key] ~= nil then
                    cfg.config = setup[key]
                end
                table.insert(pkg_set, cfg)
            end
        end

        use(pkg_set)

        if bootstrap then
            packer.sync()
        end
    end
})


