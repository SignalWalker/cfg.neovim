return {
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		name = "rose-pine",
		opts = {
			dark_variant = "moon",
			enable = {
				legacy_highlights = false,
			},
			styles = {
				transparency = true,
			},
		},
		-- config = function(_, opts)
		-- 	require("rose-pine").setup(opts)
		-- 	-- NOTE :: this is done in theme/init.lua
		-- 	-- vim.cmd([[colorscheme rose-pine]])
		-- end,
	},
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			-- "nvim-telescope/telescope.nvim",
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
				long_message_to_split = false,
				inc_rename = true,
				lsp_doc_border = true,
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
		},
		keys = {
			{ "<Leader>fvm", "<cmd>Noice telescope<cr>", desc = "telescope :: message history" },
			{ "<Leader>vns", "<cmd>Noice stats<cr>", desc = "noice :: stats" },
		},
		config = function(_, opts)
			local noice = require("noice")
			noice.setup(opts)

			local ts = require("telescope")
			ts.load_extension("noice")
		end,
	},
	{
		"3rd/image.nvim",
		-- lazy = true,
		cond = vim.g.theme_enable_terminal_effects,
		opts = {
			backend = "kitty",
			integrations = {
				html = {
					enabled = true,
				},
				css = {
					enabled = true,
				},
			},
		},
	},
}
