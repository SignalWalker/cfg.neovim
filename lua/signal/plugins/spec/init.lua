-- core plugins
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		opts = {
			ensure_installed = { "vim", "lua", "bash", "c", "rust", "regex", "markdown", "markdown_inline", "html" },
			auto_install = true,
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.o.foldenable = false
			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		opts = {
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				-- LazyVim extention to create buffer-local keymaps
				keys = {
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
	},
	{
		"nvim-mini/mini.ai",
		version = false,
		opts = {},
	},
	{
		"nvim-mini/mini.surround",
		version = false,
		opts = {},
	},
	{
		"nvim-mini/mini.pairs",
		version = false,
		opts = {},
	},
	-- {
	-- 	"nvim-mini/mini.operators",
	-- 	version = false,
	-- 	opts = {},
	-- },
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
				"<Leader>vsl",
				function()
					require("persistence").load()
				end,
				desc = "load session for current directory",
			},
			{
				"<Leader>vsL",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "load last saved session",
			},
			{
				"<Leader>vss",
				function()
					require("persistence").select()
				end,
				desc = "select a session to load",
			},
			{
				"<Leader>vsq",
				function()
					require("persistence").stop()
				end,
				desc = "don't save this session on exit",
			},
		},
	},
	-- {
	-- 	'GnikDroy/projections.nvim',
	-- 	opts = {
	-- 	}
	-- },
	-- {
	-- 	"ahmedkhalf/project.nvim",
	-- 	lazy = false, -- otherwise, the projects file loads slow enough that entries don't appear in telescope
	-- 	opts = {
	-- 		scope_chdir = "tab",
	-- 		manual_mode = true,
	-- 		detection_methods = { "lsp", "pattern" },
	-- 		patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
	-- 		silent_chdir = false,
	-- 		exclude_dirs = { "/nix/store/*", "~/.local/share/cargo/*" },
	-- 		-- datapath = vim.fn.stdpath("cache") .. "/projects/",
	-- 	},
	-- 	keys = {
	-- 		-- {
	-- 		-- 	"<Leader>ffp",
	-- 		-- 	function()
	-- 		-- 		require("telescope").extensions.projects.projects({})
	-- 		-- 	end,
	-- 		-- 	desc = "telescope :: projects",
	-- 		-- },
	-- 		{ "<Leader>vpp", "<cmd>ProjectRoot<cr>", desc = "cd to project root (scope: tab)" },
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("project_nvim").setup(opts)
	-- 		require("telescope").load_extension("projects")
	-- 	end,
	-- },
	-- {
	-- 	"rcarriga/nvim-notify",
	-- 	lazy = false,
	-- 	opts = {
	-- 		timeout = 2500,
	-- 		background_colour = "#000000",
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<Leader>fvn",
	-- 			function()
	-- 				require("snacks").picker.notifications()
	-- 			end,
	-- 			desc = "find vim notifications",
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("notify").setup(opts)
	-- 		-- require("telescope").load_extension("notify")
	-- 	end,
	-- },
	{
		"epwalsh/pomo.nvim",
		enabled = false,
		version = "*",
		cmd = { "TimerStart", "TimerRepeat" },
		dependencies = {
			"rcarriga/nvim-notify",
		},
		keys = {
			{ "<Leader>tw", "<cmd>TimerStart 25m Work<cr>", desc = "start pomodoro work timer" },
			{ "<Leader>tb", "<cmd>TimerStart 5m Break<cr>", desc = "start pomodoro break timer" },
			{ "<Leader>tp", "<cmd>TimerPause<cr>", desc = "pause pomodoro timer" },
			{ "<Leader>tr", "<cmd>TimerResume<cr>", desc = "resume pomodoro timer" },
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
