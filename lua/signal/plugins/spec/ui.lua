return {
	{
		-- display keymap hints
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		keys = {
			{ "<Leader>vkk", '<cmd>WhichKey "<cr>', desc = "vim :: view keymaps (all)" },
			{ "<Leader>vkn", "<cmd>WhichKey '' n \"<cr>", desc = "vim :: view keymaps (normal)" },
			{ "<Leader>vki", "<cmd>WhichKey '' i \"<cr>", desc = "vim :: view keymaps (insert)" },
			{ "<Leader>vkc", "<cmd>WhichKey '' c \"<cr>", desc = "vim :: view keymaps (cmdline)" },
			{ "<Leader>vkv", "<cmd>WhichKey '' v \"<cr>", desc = "vim :: view keymaps (visual)" },
			{ "<Leader>vkV", "<cmd>WhichKey '' V \"<cr>", desc = "vim :: view keymaps (visual by line)" },
			{ "<Leader>vks", "<cmd>WhichKey '' s \"<cr>", desc = "vim :: view keymaps (select)" },
			{ "<Leader>vkS", "<cmd>WhichKey '' S \"<cr>", desc = "vim :: view keymaps (select by line)" },
		},
		opts = {},
	},
	{
		"mrjones2014/legendary.nvim",
		version = "^2",
		dependencies = {
			"kkharji/sqlite.lua",
		},
		priority = 10000,
		lazy = false,
		opts = {
			extensions = {
				lazy_nvim = true,
				which_key = { auto_register = true },
				nvim_tree = true,
				diffview = true,
				smart_splits = {
					directions = { "h", "j", "k", "l" },
					mods = {
						move = "<M>",
						resize = "<C>",
						swap = "<M-S>",
					},
				},
			},
		},
	},
	{
		"s1n7ax/nvim-window-picker",
		lazy = true,
		version = "^2",
		opts = {
			hint = "floating-big-letter",
			filter_rules = {
				include_current_win = false,
				autoselect_one = true,
				bo = {
					filetype = { "neo-tree", "neo-tree-popup", "notify", "Trouble", "NvimTree" },
					buftype = { "terminal", "quickfix", "nofile" },
				},
			},
		},
	},
	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	enabled = false,
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	opts = {
	-- 		allow_different_key = true,
	-- 	},
	-- },
	{
		"sindrets/winshift.nvim",
		enabled = false,
		dependencies = {
			"s1n7ax/nvim-window-picker",
		},
		keys = {
			{ "<C-W>X", "<cmd>WinShift swap<cr>", desc = "swap target windows" },
			{ "<M-H>", "<cmd>WinShift left<cr>", desc = "shift window left" },
			{ "<M-J>", "<cmd>WinShift down<cr>", desc = "shift window down" },
			{ "<M-K>", "<cmd>WinShift up<cr>", desc = "shift window up" },
			{ "<M-L>", "<cmd>WinShift right<cr>", desc = "shift window right" },
		},
		opts = {
			window_picker = function()
				require("window-picker").pick_window()
			end,
		},
	},
	{
		"kwkarlwang/bufresize.nvim",
		enabled = false,
		opts = {},
	},
	{
		"mrjones2014/smart-splits.nvim",
		dependencies = {
			"kwkarlwang/bufresize.nvim",
		},
		version = "^1",
		build = "./kitty/install-kittens.bash",
		opts = function()
			return {
				ignored_buftypes = {
					"nofile",
					"quickfix",
					"prompt",
				},
				ignored_filetypes = {
					"NvimTree",
					"Trouble",
				},
				at_edge = "stop",
				cursor_follows_swapped_bufs = true,
				move_cursor_same_row = false,
				-- resize_mode = {
				-- 	hooks = {
				-- 		on_leave = require("bufresize").register,
				-- 	},
				-- },
			}
		end,
	},
	-- {
	-- 	"willothy/flatten.nvim",
	-- 	lazy = false,
	-- 	priority = 1001,
	-- 	opts = {},
	-- }
	{
		"folke/zen-mode.nvim",
		keys = {
			{
				"<Leader>bz",
				function()
					require("zen-mode").toggle()
				end,
				desc = "Toggle zen mode",
			},
		},
		opts = {
			plugins = {
				kitty = {
					enabled = true,
					font = "+4",
				},
			},
			-- on_open = function(_win)
			-- 	vim.cmd.TWEnable()
			-- end,
			-- on_close = function()
			-- 	vim.cmd.TWDisable()
			-- end,
		},
	},
	-- {
	-- 	"joshuadanpeterson/typewriter.nvim",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	cmd = {
	-- 		"TWEnable",
	-- 		"TWDisable",
	-- 		"TWToggle",
	-- 		"TWCenter",
	-- 	},
	-- 	opts = {
	-- 		enable_with_zen_mode = true,
	-- 	},
	-- },
}
