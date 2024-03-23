return {
	{
		"justinhj/battery.nvim",
		enabled = false,
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			update_rate_seconds = 30,
			show_status_when_no_battery = true,
			show_plugged_icon = true,
			show_unplugged_icon = true,
			show_percent = true,
			vertical_icons = true,
			multiple_battery_selection = "minimum",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"folke/noice.nvim",
			-- "justinhj/battery.nvim",
		},
		init = function()
			vim.opt.termguicolors = true
		end,
		opts = function(_, _)
			local noice = require("noice")
			local status = noice.api.status

			-- local battery = {
			-- 	function()
			-- 		return require("battery").get_status_line()
			-- 	end,
			-- 	-- color = { fg = colors.violet, bg = colors.bg },
			-- }
			return {
				options = {
					theme = "auto",
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					always_divide_middle = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", { "diagnostics", sources = { "nvim_lsp", "nvim_diagnostic" } } },
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
					lualine_a = { "tabs" },
					lualine_b = { "hostname", { "filename", path = 3 }, "branch" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "datetime" },
				},
				extensions = {
					"lazy",
					"nvim-tree",
					-- "chadtree",
					"nvim-dap-ui",
					"trouble",
				},
			}
		end,
	},
}
