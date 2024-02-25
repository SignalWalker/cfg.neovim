return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			sidebars = { "qf", "help", "NvimTree" },
			transparent = true,
		},
	},
	{
		"folke/drop.nvim",
		event = "VimEnter",
		opts = {},
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			"nvim-telescope/telescope.nvim",
		},
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
		},
		keys = {
			{ "<Leader>fvm", "<cmd>Noice telescope<cr>", desc = "telescope :: message history" },
			{ "<Leader>vns", "<cmd>Noice stats<cr>", desc = "noice :: stats" },
		},
		config = function(plugin, opts)
			local noice = require("noice")
			noice.setup(opts)

			local ts = require("telescope")
			ts.load_extension("noice")
		end,
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
						{
							"buffers",
							filetype_names = {
								TelescopePrompt = "Telescope",
								dashboard = "Dashboard",
								packer = "Packer",
								fzf = "FZF",
								alpha = "Alpha",
								NvimTree = "NvimTree",
							},
						},
					},
					lualine_b = { "hostname", { "filename", path = 2 }, "branch" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = { "datetime" },
					lualine_z = { "tabs" },
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
					"nvim-tree",
					"nvim-dap-ui",
					"lazy",
					"trouble",
				},
			}
		end,
	},
}
