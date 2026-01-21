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
		"jvgrootveld/telescope-zoxide",
		enabled = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<Leader>ffz",
				function()
					require("telescope").extensions.zoxide.list({})
				end,
				desc = "Find directory (zoxide)",
			},
		},
		opts = function()
			local zx = require("telescope._extensions.zoxide.utils")
			return {
				mappings = {
					default = {
						action = function(selection)
							vim.cmd.tcd(selection.path)
							vim.cmd.edit(selection.path)
						end,
						after_action = function(selection)
							vim.notify(
								selection.path,
								vim.log.levels.INFO,
								{ title = "Zoxide", icon = "", hide_from_history = true }
							)
						end,
					},
				},
			}
		end,
		config = function(_, opts)
			local ts = require("telescope")
			ts.setup({ extensions = { ["zoxide"] = opts } })
			ts.load_extension("zoxide")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		enabled = false,
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
		enabled = false,
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
		config = function(_, opts)
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
		config = function(_, opts)
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
			-- using snacks.nvim for most of the things you can do with telescope
			-- VIM
			{
				"<Leader>fvo",
				function()
					require("telescope.builtin").vim_options()
				end,
				desc = "find vim options",
			},
		},
	},
}
