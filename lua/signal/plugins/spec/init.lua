-- core plugins
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		opts = {
			ensure_installed = { "vim", "lua", "bash", "c", "rust", "regex", "markdown", "markdown_inline" },
			auto_install = true,
		},
		config = function(plugin, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "flash :: jump" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "flash :: treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "flash :: remote" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "flash :: treesitter search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "flash :: toggle search" }
		},
		opts = {},
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
			scope_chdir = "tab",
			manual_mode = true,
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
			{ "<Leader>vpp", "<cmd>ProjectRoot<cr>", desc = "cd to project root (scope: tab)" },
		},
		config = function(_, opts)
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
