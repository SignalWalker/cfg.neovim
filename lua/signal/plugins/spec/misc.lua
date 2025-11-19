return {
	{
		"kazimuth/dwarffortress.vim",
		ft = { "txt" },
		init = function()
			vim.g.dwarffortress_always = 0
			vim.g.dwarffortress_guess = 1
		end,
	},
	{
		"Eandrju/cellular-automaton.nvim",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter",
		},
		cmd = { "CellularAutomaton" },
		keys = {
			{ "<Leader>bcg", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "enable gravity" },
			{ "<Leader>bcl", "<cmd>CellularAutomaton game_of_life<cr>", desc = "enable life" },
		},
	},
	{
		"rktjmp/playtime.nvim",
		cmd = { "Playtime" },
		opts = {},
	},
	{
		"lbrayner/vim-rzip",
	},
	-- {
	-- 	"bxrne/was.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<Leader>pw",
	-- 			"<cmd>Was<cr>",
	-- 			desc = "show last intent for this project",
	-- 		},
	-- 		{
	-- 			"<Leader>pW",
	-- 			function()
	-- 				local intent = vim.fn.input({ prompt = "Intent" })
	-- 				if not intent or intent == "" then
	-- 					return
	-- 				end
	-- 				vim.cmd.Was(intent)
	-- 			end,
	-- 			desc = "set last intent for this project",
	-- 		},
	-- 	},
	-- 	opts = {},
	-- },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function(_, _)
			return {
				bigfile = {
					enabled = true,
				},
				dashboard = {
					enabled = true,
					preset = {
						keys = {
							{
								icon = " ",
								key = "s",
								desc = "Restore Session",
								action = function()
									require("persistence").select()
								end,
							},
							{ icon = "󰏖 ", key = "l", desc = "Lazy", action = "<cmd>Lazy<cr>" },
							{
								icon = " ",
								key = "n",
								desc = "Edit Neovim Config",
								action = function()
									local cfg_dir = vim.fn.stdpath("config")
									vim.cmd.tcd(cfg_dir)
									require("oil").open(cfg_dir)
								end,
							},
							{
								icon = " ",
								key = "q",
								desc = "Quit",
								action = ":qa",
							},
						},
						header = require("signal.lib.theme").choose_header_str(),
					},
					sections = {
						{ section = "header" },
						{ section = "keys", gap = 1, padding = 1 },
						{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
						{ section = "startup" },
					},
				},
				gh = {
					enabled = true,
				},
				gitbrowse = {
					enabled = true,
				},
				image = {
					enabled = true,
				},
				indent = {
					enabled = true,
				},
				input = {
					enabled = true,
				},
				notifier = {
					enabled = true,
					timeout = 2500,
					style = "fancy",
				},
				picker = {
					enabled = true,
				},
				scope = {
					enabled = true,
				},
				scroll = {
					enabled = true,
				},
				statuscolumn = {
					enabled = true,
				},
				words = {
					enabled = true,
				},
			}
		end,
		init = function()
			local Snacks = require("snacks")
			_G.dd = function(...)
				Snacks.debug.inspect(...)
			end
			_G.bt = function()
				Snacks.debug.backtrace()
			end
			vim.print = _G.dd
		end,
		keys = function(_, _)
			local Snacks = require("snacks")
			return {
				-- GITBROWSE
				{
					"<Leader>gpr",
					function()
						Snacks.gitbrowse()
					end,
					desc = "open repo of active file in browser",
				},
				-- PICKERS
				-- PROJECTS
				{
					"<Leader>fpp",
					function()
						Snacks.picker.projects({
							dev = {
								"~/projects",
								"~/projects-terra",
								"~/projects-artemis",
							},
							patterns = { ".jj", ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile" },
						})
					end,
					desc = "find projects",
				},
				{
					"<Leader>fpz",
					function()
						Snacks.picker.zoxide()
					end,
					desc = "find projects (zoxide)",
				},
				-- GIT
				{
					"<Leader>fgb",
					function()
						Snacks.picker.git_branches()
					end,
					desc = "find git branches",
				},
				{
					"<Leader>fgl",
					function()
						Snacks.picker.git_log()
					end,
					desc = "find in git log",
				},
				{
					"<Leader>fgL",
					function()
						Snacks.picker.git_log_line()
					end,
					desc = "find in git log by line",
				},
				{
					"<Leader>fgs",
					function()
						Snacks.picker.git_status()
					end,
					desc = "find in git status",
				},
				{
					"<Leader>fgS",
					function()
						Snacks.picker.git_stash()
					end,
					desc = "find in git stash",
				},
				{
					"<Leader>fgd",
					function()
						Snacks.picker.git_diff()
					end,
					desc = "find in git diff",
				},
				{
					"<Leader>fgf",
					function()
						Snacks.picker.git_files()
					end,
					desc = "find git files",
				},
				{
					"<Leader>fgF",
					function()
						Snacks.picker.git_log_file()
					end,
					desc = "find in git log for current file",
				},
				-- -- GITHUB
				{
					"<Leader>fghi",
					function()
						Snacks.picker.gh_issue()
					end,
					desc = "find in open github issues",
				},
				{
					"<Leader>fghI",
					function()
						Snacks.picker.gh_issue({ state = "all" })
					end,
					desc = "find in all github issues",
				},
				{
					"<Leader>fghp",
					function()
						Snacks.picker.gh_pr()
					end,
					desc = "find in open github pull requests",
				},
				{
					"<Leader>fghP",
					function()
						Snacks.picker.gh_pr({ state = "all" })
					end,
					desc = "find in all github pull requests",
				},
				-- FILES
				{
					"<Leader>fff",
					function()
						Snacks.picker.files()
					end,
					desc = "find files",
				},
				{
					"<Leader>ffs",
					function()
						Snacks.picker.smart()
					end,
					desc = "find files (smart)",
				},
				{
					"<Leader>ff/",
					function()
						Snacks.picker.grep({
							-- this is the `lock` entry from `rg --file-types`
							exclude = { "*.lock", "package-lock.json" },
						})
					end,
					desc = "grep files (ignore lock files)",
				},
				{
					"<Leader>ffr",
					function()
						Snacks.picker.recent()
					end,
					desc = "find files (recent)",
				},
				-- BUFFERS
				{
					"<Leader>fbb",
					function()
						Snacks.picker.buffers()
					end,
					desc = "find buffers",
				},
				{
					"<Leader>fb/",
					function()
						Snacks.picker.grep_buffers()
					end,
					desc = "grep buffers",
				},
				{
					"<Leader>fbd",
					function()
						Snacks.picker.diagnostics_buffer()
					end,
					desc = "find diagnostics in current buffer",
				},
				{
					"<Leader>fbD",
					function()
						Snacks.picker.diagnostics()
					end,
					desc = "find diagnostics in all buffers",
				},
				-- VIM
				{
					"<Leader>fvr",
					function()
						Snacks.picker.registers()
					end,
					desc = "find in vim registers",
				},
				{
					"<Leader>fva",
					function()
						Snacks.picker.autocmds()
					end,
					desc = "find vim autocmd",
				},
				{
					"<Leader>fvh",
					function()
						Snacks.picker.help()
					end,
					desc = "find help file",
				},
				{
					"<Leader>fvc",
					function()
						Snacks.picker.commands()
					end,
					desc = "find command",
				},
				{
					"<Leader>fvC",
					function()
						Snacks.picker.command_history()
					end,
					desc = "find in command history",
				},
				{
					"<Leader>fvu",
					function()
						Snacks.picker.undo()
					end,
					desc = "find in undo history",
				},
				{
					"<Leader>fvs",
					function()
						Snacks.picker.colorschemes()
					end,
					desc = "find colorscheme",
				},
				{
					"<Leader>fvn",
					function()
						Snacks.picker.notifications()
					end,
					desc = "find in notifications",
				},
				{
					"<Leader>fvk",
					function()
						Snacks.picker.keymaps()
					end,
					desc = "find keymap",
				},
				{
					"<Leader>fvj",
					function()
						Snacks.picker.jumps()
					end,
					desc = "find jump",
				},
				-- MISC
				{
					"<Leader>f/",
					function()
						Snacks.picker.grep_buffers()
					end,
					desc = "grep for visual selection or word",
					mode = { "n", "x" },
				},
				{
					"<Leader>fr",
					function()
						Snacks.picker.resume()
					end,
					desc = "resume last picker",
				},
				-- CHARACTER
				{
					"<Leader>fci",
					function()
						Snacks.picker.icons()
					end,
					desc = "find icon",
				},
				-- MAN PAGES
				{
					"<Leader>fmm",
					function()
						-- FIX :: this seems only to search man pages from the extraPackages hm attribute?
						Snacks.picker.man()
					end,
					desc = "find in man page",
				},
			}
		end,
	},
}
