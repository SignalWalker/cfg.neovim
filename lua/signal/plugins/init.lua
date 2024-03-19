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

local _, lazy = ensure_lazy()

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
	},
	general = {
		"tpope/vim-sleuth",
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
