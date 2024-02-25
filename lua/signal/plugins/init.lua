local lazy_dir = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- -> (is_bootstrapped, lazy)
local function ensure_lazy()
	-- check for system packer
	local p_ok, lazy = pcall(require, "lazy")
	local bootstrapped = false
	if not p_ok then
		-- no system lazy; install locally
		if not vim.loop.fs_stat(lazy_dir) then
			vim.fn.system({
				"git",
				"clone",
				"--filter=blob:none",
				"https://github.com/folke/lazy.nvim.git",
				"--branch=stable", -- latest stable release
				lazy_dir,
			})
		end
		bootstrapped = true
	end
	vim.opt.rtp:prepend(lazy_dir)
	if bootstrapped then
		lazy = require("lazy")
	end
	return bootstrapped, lazy
end

local function in_kitty()
	return vim.env.TERM == "xterm-kitty"
end

local function in_neovide()
	return vim.env.TERM == "linux"
end

META_FILETYPES = {
	"lspinfo",
	"packer",
	"checkhealth",
	"help",
	"man",
	"dashboard",
	"NvimTree",
	"gitcommit",
	"alpha",
	-- 'dapui_scopes',
	-- 'dapui_breakpoints',
	-- 'dapui_stacks',
	-- 'dapui_watches',
	-- 'dapui_console',
	-- 'dap-repl',
}
META_BUFTYPES = {
	"terminal",
	"alpha",
	"help",
	"packer",
	"dashboard",
	"NvimTree",
	"nofile",
}

local bootstrapped, lazy = ensure_lazy()

-- package map
local packages = {
	meta = {
		"lewis6991/impatient.nvim",
		aniseed = "Olical/aniseed",
		local_fennel = {
			"Olical/nvim-local-fennel",
			requires = {
				"Olical/aniseed",
			},
		},
	},
	ui = {
		leap = { -- cursor jump on s & S
			"ggandor/leap.nvim",
			requires = {
				"tpope/vim-repeat", -- dot repeats
			},
		},
		flit = "ggandor/flit.nvim", -- better f/t motions
		spooky = "ggandor/leap-spooky.nvim", -- actions at a distance using leap motions
		indent_guides = "lukas-reineke/indent-blankline.nvim",
		lualine = {
			"nvim-lualine/lualine.nvim",
			requires = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		dashboard = {
			"goolord/alpha-nvim",
			requires = { "nvim-tree/nvim-web-devicons" },
		},
		telescope_file_browser = {
			"nvim-telescope/telescope-file-browser.nvim",
			after = "telescope.nvim",
		},
		telescope_ui_select = {
			"nvim-telescope/telescope-ui-select.nvim",
			after = "telescope.nvim",
		},
		telescope_dap = {
			"nvim-telescope/telescope-dap.nvim",
			requires = {
				"nvim-telescope/telescope.nvim",
				"mfussenegger/nvim-dap",
				"nvim-treesitter/nvim-treesitter",
			},
			after = {
				"telescope.nvim",
				"nvim-dap",
			},
		},
		gui_font_resize = "ktunprasert/gui-font-resize.nvim",
		-- kitty_nav = {
		--     'knubie/vim-kitty-navigator',
		--     cond = in_kitty,
		--     run = "ln -st $XDG_CONFIG_HOME/kitty/ ./*.py"
		-- },
	},
	general = {
		"tpope/vim-sleuth",
	},
	dev = {
		diffview = {
			"sindrets/diffview.nvim",
			requires = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		-- octo = {
		--     'pwntester/octo.nvim',
		--     requires = {
		--         'nvim-lua/plenary.nvim',
		--         'nvim-telescope/telescope.nvim',
		--         'nvim-tree/nvim-web-devicons'
		--     },
		--     after = {
		--         'nvim-treesitter',
		--         'telescope.nvim'
		--     }
		-- },
		-- conjure = 'Olical/conjure'
	},
	lang = {
		-- neorg = {
		--     'nvim-neorg/neorg',
		--     -- tag = "*", -- latest stable
		--     run = ':Neorg sync-parsers',
		--     requires = { 'nvim-lua/plenary.nvim', 'nvim-neorg/neorg-telescope' },
		--     ft = { "norg" },
		--     after = { "nvim-treesitter", "telescope.nvim" },
		--     cmd = { "Neorg" }
		-- },
		org = {
			"nvim-orgmode/orgmode",
			requires = { "nvim-treesitter/nvim-treesitter" },
			after = { "nvim-treesitter" },
		},
		tree_sitter_just = {
			"IndianBoy42/tree-sitter-just",
			requires = {
				"nvim-treesitter/nvim-treesitter",
			},
		},
		-- telekasten = {
		--     'renerocksai/telekasten.nvim',
		--     requires = { 'nvim-telescope/telescope.nvim' }
		-- }
	},
}

return lazy.setup("signal.plugins.spec", {
	diff = {
		cmd = "diffview.nvim",
	},
	checker = {
		enabled = true,
	},
})
