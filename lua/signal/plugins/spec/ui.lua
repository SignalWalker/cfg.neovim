return {
	{
		"lukas-reineke/indent-blankline.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		main = "ibl",
		opts = {
			exclude = {
				filetypes = { "dashboard" },
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
					filetype = { "neo-tree", "neo-tree-popup", "notify" },
					buftype = { "terminal", "quickfix" },
				},
			},
		},
	},
	{
		"m4xshen/hardtime.nvim",
		enabled = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			showmode = false,
		},
	},
	{
		"sindrets/winshift.nvim",
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
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"folke/noice.nvim",
		},
		init = function()
			vim.opt.termguicolors = true
		end,
		opts = function(plugin, opts)
			local noice = require("noice")
			local status = noice.api.status
			return {
				options = {
					theme = "auto",
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diagnostics" },
					lualine_c = { "hostname", { "filename", path = 1 }, "diff" },
					lualine_x = {
						{ status.message.get_hl, cond = status.message.has },
						{ status.command.get, cond = status.command.has, color = { fg = "#ff9e64" } },
						{ status.mode.get, cond = status.mode.has, color = { fg = "#ff9e64" } },
						{ status.search.get, cond = status.search.has, color = { fg = "#ff9e64" } },
						"encoding",
						"fileformat",
					},
					lualine_y = { "filetype" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "hostname", { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {
					lualine_a = {
						"tabs",
						-- {
						-- 	"buffers",
						-- 	filetype_names = {
						-- 		TelescopePrompt = "Telescope",
						-- 		dashboard = "Dashboard",
						-- 		packer = "Packer",
						-- 		fzf = "FZF",
						-- 		alpha = "Alpha",
						-- 		NvimTree = "NvimTree",
						-- 	},
						-- },
					},
					lualine_b = { "hostname", { "filename", path = 2 }, "branch" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = { "datetime" },
					lualine_z = {},
				},
				-- winbar = {
				-- 	lualine_a = {},
				-- 	lualine_b = {},
				-- 	lualine_c = { "hostname", { "filename", path = 1 } },
				-- 	lualine_x = {},
				-- 	lualine_y = {},
				-- 	lualine_z = {},
				-- },
				-- inactive_winbar = {
				-- 	lualine_a = {},
				-- 	lualine_b = {},
				-- 	lualine_c = { "hostname", { "filename", path = 1 } },
				-- 	lualine_x = {},
				-- 	lualine_y = {},
				-- 	lualine_z = {},
				-- },
				extensions = {
					"lazy",
					"nvim-tree",
					"nvim-dap-ui",
					"trouble",
				},
			}
		end,
	},
}
