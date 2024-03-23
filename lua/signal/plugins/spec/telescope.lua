-- local keymap = function(keys, action, desc)
-- 	return {
-- 		keys,
-- 		function()
-- 			require("telescope.builtin")[action]()
-- 		end,
-- 		desc = desc,
-- 	}
-- end

return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- enabled = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		opts = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		config = function(_, opts)
			local ts = require("telescope")
			ts.setup({ extensions = { ["fzf"] = opts } })
			require("telescope").load_extension("fzf") -- TODO :: fix cmake
		end,
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<Leader>fbu",
				function()
					require("telescope").extensions.undo.undo({ side_by_side = true })
				end,
				desc = "telescope :: undo tree",
			},
		},
		opts = {
			side_by_side = true,
			layout_strategy = "vertical",
			layout_config = {
				preview_height = 0.8,
			},
		},
		config = function(plugin, opts)
			local ts = require("telescope")
			ts.setup({ extensions = { ["undo"] = opts } })
			ts.load_extension("undo")
		end,
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-telescope/telescope.nvim",
		},
		event = "LspAttach",
		opts = {},
		config = function(plugin, opts)
			local ts = require("telescope")
			ts.setup({ extensions = { ["dap"] = opts } })
			ts.load_extension("dap")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- 'nvim-telescope/telescope-fzf-native.nvim'
		},
		opts = {},
		keys = {
			-- meta
			{
				"<Leader>ffr",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "telescope :: resume last picker",
			},
			-- files & searching
			{
				"<Leader>fff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "telescope :: files",
			},
			{
				"<Leader>ffo",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "telescope :: oldfiles",
			},
			{
				"<Leader>ffg",
				function()
					require("telescope.builtin").live_grep({ additional_args = { "--type-not=lock" } })
				end,
				desc = "telescope :: grep (ignore lock files)",
			},

			-- buffer
			{
				"<Leader>fbf",
				function()
					require("telescope.builtin").current_buffer_fuzzy_find()
				end,
				desc = "telescope :: current_buffer_fuzzy_find",
			},
			{
				"<Leader>fbt",
				function()
					require("telescope.builtin").filetypes()
				end,
				desc = "telescope :: filetypes",
			},

			-- quickfix
			{
				"<Leader>fqq",
				function()
					require("telescope.builtin").quickfix()
				end,
				desc = "telescope :: quickfix",
			},
			{
				"<Leader>fqh",
				function()
					require("telescope.builtin").quickfixhistory()
				end,
				desc = "telescope :: quickfix :: history",
			},

			-- commands
			{
				"<Leader>fcc",
				function()
					require("telescope.builtin").commands()
				end,
				desc = "telescope :: commands",
			},
			{
				"<Leader>fch",
				function()
					require("telescope.builtin").command_history()
				end,
				desc = "telescope :: command history",
			},

			-- help
			{
				"<Leader>fhm",
				function()
					require("telescope.builtin").man_pages()
				end,
				desc = "telescope :: man_pages",
			},

			-- nvim meta
			{
				"<Leader>fvh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "telescope :: help tags",
			},
			{
				"<Leader>fvc",
				function()
					require("telescope.builtin").colorscheme()
				end,
				desc = "telescope :: colorscheme",
			},
			{
				"<Leader>fvb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "telescope :: buffers",
			},
			{
				"<Leader>fvo",
				function()
					require("telescope.builtin").vim_options()
				end,
				desc = "telescope :: vim options",
			},
			{
				"<Leader>fvr",
				function()
					require("telescope.builtin").registers()
				end,
				desc = "telescope :: registers",
			},
			{
				"<Leader>fva",
				function()
					require("telescope.builtin").autocommands()
				end,
				desc = "telescope :: autocommands",
			},
			{
				"<Leader>fvk",
				function()
					require("telescope.builtin").keymaps()
				end,
				desc = "telescope :: keymaps",
			},

			-- git
			{
				"<Leader>fgc",
				function()
					require("telescope.builtin").git_commits()
				end,
				desc = "telescope :: git :: commits",
			},
			{
				"<Leader>fgb",
				function()
					require("telescope.builtin").git_branches()
				end,
				desc = "telescope :: git :: branches",
			},
			{
				"<Leader>fgs",
				function()
					require("telescope.builtin").git_status()
				end,
				desc = "telescope :: git :: status",
			},
			{
				"<Leader>fgf",
				function()
					require("telescope.builtin").git_files()
				end,
				desc = "telescope :: git :: files",
			},
			{
				"<Leader>fgd",
				function()
					require("telescope.builtin").git_bcommits()
				end,
				desc = "telescope :: git :: buffer diff",
			},
			{
				"<Leader>fgt",
				function()
					require("telescope.builtin").git_stash()
				end,
				desc = "telescope :: git :: stash",
			},
		},
	},
}
