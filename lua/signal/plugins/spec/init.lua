-- core plugins
return {
	{
		-- display keymap hints
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		opts = {
			ensure_installed = { "lua", "c", "rust" },
			auto_install = true,
		},
		config = function(plugin, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"3rd/image.nvim",
		lazy = true,
		opts = {
			backend = "kitty",
		},
	},
	{
		"s1n7ax/nvim-window-picker",
		event = "VeryLazy",
		version = "^2",
		opts = {
			hint = "floating-big-letter",
			filter_rules = {
				include_current_win = false,
				autoselect_one = true,
				bo = {
					filetype = { "neo-tree", "neo-tree-popup", "notify" },
					buftype = { "terminal", "quickfix" },
				},
			},
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			dir = vim.fn.expand(vim.fn.stdpath("cache") .. "/sessions/"),
		},
		keys = {
			{
				"<Leader>vsld",
				function()
					require("persistence").load()
				end,
				desc = "session :: load (current directory)",
			},
			{
				"<Leader>vsll",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "session :: load (last saved)",
			},
			{
				"<Leader>vsq",
				function()
					require("persistence").stop()
				end,
				desc = "session :: don't save on exit",
			},
		},
	},
	{
		"ahmedkhalf/project.nvim",
		lazy = false, -- otherwise, the projects file loads slow enough that entries don't appear in telescope
		opts = {
			manual_mode = false,
			detection_methods = { "lsp", "pattern" },
			patterns = { "flake.nix", ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
			silent_chdir = false,
			exclude_dirs = { "/nix/store/*", "~/.local/share/cargo/*" },
			-- datapath = vim.fn.stdpath("cache") .. "/projects/",
		},
		keys = {
			{
				"<Leader>ffp",
				function()
					require("telescope").extensions.projects.projects({})
				end,
				desc = "telescope :: projects",
			},
		},
		config = function(plugin, opts)
			require("project_nvim").setup(opts)
			require("telescope").load_extension("projects")
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {},
		keys = {
			{
				"<Leader>fvn",
				function()
					require("telescope").extensions.notify.notify()
				end,
				desc = "telescope :: notifications",
			},
		},
		config = function(plugin, opts)
			require("notify").setup(opts)
			require("telescope").load_extension("notify")
		end,
	},
	{
		"epwalsh/pomo.nvim",
		version = "*",
		cmd = { "TimerStart", "TimerRepeat" },
		dependencies = {
			"rcarriga/nvim-notify",
		},
		keys = {
			{ "<Leader>pw", "<cmd>TimerStart 25m Work<cr>", desc = "pomo :: start (work)" },
			{ "<Leader>pb", "<cmd>TimerStart 5m Break<cr>", desc = "pomo :: start (break)" },
			{ "<Leader>pp", "<cmd>TimerPause<cr>", desc = "pomo :: pause" },
			{ "<Leader>pr", "<cmd>TimerResume<cr>", desc = "pomo :: resume" },
		},
		opts = {},
	},
	-- {
	-- 	"lewis6991/hover.nvim",
	-- 	keys = {
	-- 		{
	-- 			"<Leader>'",
	-- 			function()
	-- 				require("hover").hover()
	-- 			end,
	-- 			desc = "hover",
	-- 		},
	-- 		{
	-- 			"<Leader>g'",
	-- 			function()
	-- 				require("hover").hover_select()
	-- 			end,
	-- 			desc = "hover :: select",
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		init = function()
	-- 			require("hover.providers.lsp")
	-- 			require("hover.providers.gh")
	-- 			require("hover.providers.gh_user")
	-- 			require("hover.providers.man")
	-- 			require("hover.providers.dictionary")
	-- 		end,
	-- 		preview_opts = {
	-- 			border = nil,
	-- 		},
	-- 		preview_window = false,
	-- 		title = true,
	-- 	},
	-- },
}
