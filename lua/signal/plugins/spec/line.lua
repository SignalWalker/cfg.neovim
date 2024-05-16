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

			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
			})

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
					lualine_b = { "hostname", "branch" },
					lualine_c = {
						{ "filename", path = 1 },
						{ symbols.get, cond = symbols.has },
					},
					lualine_x = {
						{ status.message.get_hl, cond = status.message.has },
						{ status.command.get, cond = status.command.has, color = { fg = "#ff9e64" } },
						{ status.mode.get, cond = status.mode.has, color = { fg = "#ff9e64" } },
						{ status.search.get, cond = status.search.has, color = { fg = "#ff9e64" } },
						{ "diagnostics", sources = { "nvim_lsp", "nvim_diagnostic" } },
						"diff",
					},
					lualine_y = {
						"filetype",
						"fileformat",
						"encoding",
					},
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
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "datetime" },
				},
				extensions = {
					"lazy",
					-- "nvim-tree",
					-- "chadtree",
					"nvim-dap-ui",
					"trouble",
					"oil",
					"man",
				},
			}
		end,
		config = function(_, opts)
			vim.opt.showtabline = 0
			local lualine = require("lualine")
			-- workarounds for lualine's obtuse behavior about showtabline
			vim.api.nvim_create_autocmd({ "TabNew", "TabClosed" }, {
				pattern = "*",
				callback = function()
					if vim.fn.tabpagenr("$") > 1 then
						vim.opt.showtabline = 1
						lualine.hide({
							place = { "tabline" },
							unhide = true,
						})
					else
						lualine.hide({
							place = { "tabline" },
							unhide = false,
						})
						vim.opt.showtabline = 0
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					lualine.hide({
						place = { "tabline" },
					})
					vim.opt.showtabline = 0
				end,
			})
			require("lualine").setup(opts)
		end,
	},
}
